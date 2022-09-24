import 'package:blin/components/settings/appearance_settings_section.dart';
import 'package:blin/components/settings/data_settings_section.dart';
import 'package:blin/get/app_controller.dart';
import 'package:blin/services/local_data_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettinsPage extends StatefulWidget {
  const SettinsPage({Key? key}) : super(key: key);

  @override
  State<SettinsPage> createState() => _SettinsPageState();
}

class _SettinsPageState extends State<SettinsPage> {
  bool _mockDataLoading = false;

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
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: GestureDetector(
                    onLongPress: () {
                      Get.dialog(
                        AlertDialog(
                          title: const Text("Load mock data"),
                          content: const Text(
                            "Do you wish to load mock data? This serves for development purposes only.",
                          ),
                          actions: [
                            ElevatedButton(
                                onPressed: Get.back,
                                child: const Text("Cancel")),
                            ElevatedButton(
                                onPressed: () async {
                                  Future.delayed(Duration.zero, () async {
                                    setState(() {
                                      _mockDataLoading = true;
                                    });
                                    await LocalDataService.loadMockData();
                                    setState(() {
                                      _mockDataLoading = false;
                                    });
                                  });
                                  Get.back();
                                },
                                child: const Text("Load")),
                          ],
                        ),
                      );
                    },
                    child: (!_mockDataLoading)
                        ? const Text(
                            "OSS with ❤️ by Jan Hendrych",
                            style: TextStyle(color: Colors.grey),
                          )
                        : const CircularProgressIndicator(),
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
