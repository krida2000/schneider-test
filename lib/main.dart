import 'package:context_menus/context_menus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'store/hive/task.dart';
import 'store/task.dart';
import 'ui/page/task/view.dart';
import 'ui/page/sign_in/view.dart';

Future<void> main() async {
  await Hive.initFlutter('hive');
  await Get.put(HiveTaskProvider()).init();

  Get.put(TaskRepository(Get.find())).init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ContextMenuOverlay(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: const ColorScheme.light(
            primary: Colors.blue,
            onPrimary: Colors.white,
          ),
          buttonTheme: const ButtonThemeData(
            buttonColor: Colors.blue,
            disabledColor: Colors.grey,
            textTheme: ButtonTextTheme.primary,
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.disabled)) {
                  return Colors.black12;
                }

                return Colors.blue;
              }),
              foregroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.disabled)) {
                  return Colors.black26;
                }

                return Colors.white;
              }),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
              side: WidgetStateProperty.all(BorderSide.none),
            ),
          ),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        routes: {
          Routes.signIn: (context) => const SignInView(),
          Routes.tasks: (context) => const TasksView(),
        },
        initialRoute: '/signIn',
      ),
    );
  }
}

class Routes {
  static const signIn = '/signIn';
  static const tasks = '/markup';
}
