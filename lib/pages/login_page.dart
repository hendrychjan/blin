import 'package:blin/get/app_controller.dart';
import 'package:blin/get/ui_controller.dart';
import 'package:blin/models/user.dart';
import 'package:blin/pages/home_page.dart';
import 'package:blin/pages/register_page.dart';
import 'package:blin/services/blin_api/blin_auth_service.dart';
import 'package:blin/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _serverUrlControler = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  String _loginError = "";

  Future<void> _handleLogin() async {
    // Validate the form
    if (!_formKey.currentState!.validate()) return;

    // Check if internet connection is available
    bool connected = await HttpService.checkInternetConnection();

    // If yes, try to login
    if (connected) {
      try {
        // Login
        String token = await BlinAuthService.auth(
            _nameController.text, _passwordController.text);

        // Run the local login procedure
        User.loginLocallyFromJWT(token, _serverUrlControler.text);

        // Go to the home page
        Get.off(() => const HomePage());
      } catch (e) {
        setState(() {
          _loginError = e as String;
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
        title: const Text('Login'),
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
                      onPressed: _handleLogin,
                      child: const Text("Log in"),
                    ),
                  ),
                  Text(
                    _loginError,
                    style: const TextStyle(color: Colors.red),
                  ),
                  TextButton(
                    onPressed: () => Get.off(() => const RegisterPage()),
                    child: const Text("Not registered? Sign up!"),
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
