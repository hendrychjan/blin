import 'package:blin/get/app_controller.dart';
import 'package:blin/get/ui_controller.dart';
import 'package:blin/models/user.dart';
import 'package:blin/pages/home_page.dart';
import 'package:blin/pages/login_page.dart';
import 'package:blin/services/blin_api/blin_users_service.dart';
import 'package:blin/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _serverUrlControler = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  String _registerError = "";

  Future<void> _handleSignUp() async {
    // Validate the form
    if (!_formKey.currentState!.validate()) return;

    // Check if internet connection is available
    bool connected = await HttpService.checkInternetConnection();

    // If yes, try to login
    if (connected) {
      try {
        // Register
        String token = await BlinUsersService.registerNewUser(
            _nameController.text, _passwordController.text);

        // Run the local login procedure
        User.loginLocallyFromJWT(token, _serverUrlControler.text);

        // Go to the home page
        Get.off(() => const HomePage());
      } catch (e) {
        setState(() {
          _registerError = e as String;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _serverUrlControler.text = AppController.to.serverUrl.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: UniqueKey(),
        title: const Text('Sign up'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  UiController.renderTextInput(
                    hint: "Server URL",
                    controller: _serverUrlControler,
                    validationRules: ["required"],
                  ),
                  UiController.renderTextInput(
                    hint: "Username",
                    controller: _nameController,
                    validationRules: ["required"],
                  ),
                  UiController.renderTextInput(
                    hint: "Password",
                    controller: _passwordController,
                    validationRules: ["required"],
                    obscureText: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: ElevatedButton(
                      onPressed: _handleSignUp,
                      child: const Text("Sign up"),
                    ),
                  ),
                  Text(
                    _registerError,
                    style: const TextStyle(color: Colors.red),
                  ),
                  TextButton(
                    onPressed: () => Get.off(() => const LoginPage()),
                    child: const Text("Already registered? Log in!"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
