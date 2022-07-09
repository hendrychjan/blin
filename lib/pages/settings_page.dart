import 'package:blin/get/app_controller.dart';
import 'package:blin/models/user.dart';
import 'package:blin/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettinsPage extends StatefulWidget {
  const SettinsPage({Key? key}) : super(key: key);

  @override
  State<SettinsPage> createState() => _SettinsPageState();
}

class _SettinsPageState extends State<SettinsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: UniqueKey(),
        title: const Text("Settings"),
      ),
      body: Center(
        child: Column(
          children: [
            Text(AppController.to.user!.name + AppController.to.user!.id),
            ElevatedButton(
              onPressed: () async {
                // Logout the user locally
                await User.logoutLocally();

                // Go back to login page
                Get.off(() => const LoginPage());
              },
              child: const Text("Log out"),
            ),
          ],
        ),
      ),
    );
  }
}
