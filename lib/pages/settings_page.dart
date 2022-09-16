import 'package:blin/components/appearance_settings_section.dart';
import 'package:blin/components/data_settings_section.dart';
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        key: UniqueKey(),
        title: const Text("Settings"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              AppearanceSettingsSection(),
              DataSettingsSection(),
            ],
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Obx(
                  () => Text(
                    AppController.to.appVersion.string,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    "OSS with ❤️ by Jan Hendrych",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
