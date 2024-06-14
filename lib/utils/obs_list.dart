import 'dart:async';

import 'package:collection/collection.dart';

class ObsList<E> extends DelegatingList<E> implements List<E> {
  ObsList([List<E>? initial]) : super(initial ?? []);

  factory ObsList.filled(int length, E fill, {bool growable = false}) =>
      ObsList(List<E>.filled(length, fill, growable: growable));

  factory ObsList.from(Iterable<E> elements, {bool growable = true}) =>
      ObsList(List<E>.from(elements, growable: growable));

  factory ObsList.of(Iterable<E> elements, {bool growable = true}) =>
      ObsList(List<E>.of(elements, growable: growable));

  factory ObsList.generate(
    int length,
    E Function(int index) generator, {
    bool growable = true,
  }) =>
      ObsList(List<E>.generate(length, generator, growable: growable));

  factory ObsList.unmodifiable(Iterable elements) =>
      ObsList(List<E>.unmodifiable(elements));

  final _changes =
      StreamController<ListChangeNotification<E>>.broadcast(sync: true);

  Stream<ListChangeNotification<E>> get changes => _changes.stream;

  void emit(ListChangeNotification<E> event) => _changes.add(event);

  @override
  operator []=(int index, E value) {
    super[index] = value;
    _changes.add(ListChangeNotification<E>.updated(value, index));
  }

  @override
  void add(E value) {
    super.add(value);
    _changes.add(ListChangeNotification<E>.added(value, length - 1));
  }

  @override
  void addAll(Iterable<E> iterable) {
    super.addAll(iterable);
    for (var element in iterable) {
      _changes.add(ListChangeNotification<E>.added(element, length - 1));
    }
  }

  @override
  void insert(int index, E element) {
    super.insert(index, element);
    _changes.add(ListChangeNotification<E>.added(element, index));
  }

  @override
  bool remove(Object? value) {
    int pos = indexOf(value as E);
    bool hasRemoved = super.remove(value);
    if (hasRemoved) {
      _changes.add(ListChangeNotification<E>.removed(value, pos));
    }
    return hasRemoved;
  }

  @override
  E removeAt(int index) {
    E removed = super.removeAt(index);
    _changes.add(ListChangeNotification<E>.removed(removed, index));
    return removed;
  }

  @override
  void removeWhere(bool Function(E p1) test) {
    List<E> stored = List.from(this, growable: false);
    super.removeWhere(test);

    for (int i = 0; i < stored.length; ++i) {
      if (!contains(stored[i])) {
        _changes.add(ListChangeNotification<E>.removed(stored[i], i));
      }
    }
  }

  @override
  void clear() {
    for (int i = 0; i < length; ++i) {
      _changes.add(ListChangeNotification<E>.removed(this[i], length));
    }
    super.clear();
  }

  @override
  void removeRange(int start, int end) {
    List<E> stored = List.from(this, growable: false);
    super.removeRange(start, end);

    for (int i = start; i < end; ++i) {
      if (!contains(stored[i])) {
        _changes.add(ListChangeNotification<E>.removed(stored[i], i));
      }
    }
  }

  @override
  void insertAll(int index, Iterable<E> iterable) {
    super.insertAll(index, iterable);
    for (int i = 0; i < iterable.length; i++) {
      _changes.add(
        ListChangeNotification<E>.added(iterable.elementAt(i), i + index),
      );
    }
  }
}

class ListChangeNotification<E> {
  ListChangeNotification(this.element, this.op, this.pos);

  ListChangeNotification.added(this.element, this.pos)
      : op = OperationKind.added;

  ListChangeNotification.updated(this.element, this.pos)
      : op = OperationKind.updated;

  ListChangeNotification.removed(this.element, this.pos)
      : op = OperationKind.removed;

  final E element;

  final OperationKind op;

  final int pos;
}

enum OperationKind { added, removed, updated }
