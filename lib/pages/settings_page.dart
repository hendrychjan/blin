import 'package:blin/get/app_controller.dart';
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
            Column(
              children: const [],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(
                    Icons.warning,
                    color: Colors.red,
                  ),
                  const Text(
                    "You are using a pre-release version of Blin!",
                    style: TextStyle(color: Colors.red),
                  ),
                  Obx(
                    () => Text(
                      AppController.to.appVersion.string,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Text(
                      "With ❤️ by Jan Hendrych",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
