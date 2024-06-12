import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '/main.dart';

class SignInController extends GetxController {
  TextEditingController loginController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  FocusNode passwordFocusNode = FocusNode();

  RxBool isValid = RxBool(false);

  RxBool signingIn = RxBool(false);

  @override
  void onInit() {
    loginController.addListener(_listener);
    passwordController.addListener(_listener);

    super.onInit();
  }

  @override
  void dispose() {
    loginController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> signIn(BuildContext context) async {
    if (isValid.isTrue) {
      signingIn.value = true;
      await Future.delayed(1.seconds);

      if (context.mounted) {
        Navigator.of(context).pushNamed(Routes.tasks);
      }

      signingIn.value = false;
    }
  }

  void _listener() {
    isValid.value =
        loginController.text.isNotEmpty && passwordController.text.isNotEmpty;
  }
}
