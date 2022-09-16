import 'package:blin/services/local_data_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DataSettingsSection extends StatefulWidget {
  const DataSettingsSection({super.key});

  @override
  State<DataSettingsSection> createState() => _DataSettingsSectionState();
}

class _DataSettingsSectionState extends State<DataSettingsSection> {
  bool _backupInProgress = false;
  bool _restoreInProgress = false;

  void _handleBackupData() async {
    setState(() {
      _backupInProgress = true;
    });

    await LocalDataService.backupData();
    Get.snackbar(
      "Success",
      "Backup file created successfully!",
      snackPosition: SnackPosition.BOTTOM,
    );

    setState(() {
      _backupInProgress = false;
    });
  }

  void _handleRestoreData() async {
    setState(() {
      _restoreInProgress = true;
    });

    try {
      await LocalDataService.restoreData();
      Get.snackbar(
        "Success",
        "Synchronized with the backup file!",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    setState(() {
      _restoreInProgress = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 30, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              "Import and export",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Get.theme.primaryColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 8,
            ),
            child: (!_backupInProgress)
                ? ElevatedButton(
                    onPressed: _handleBackupData,
                    child: const Text("Backup data"),
                  )
                : const CircularProgressIndicator(),
          ),
          Padding(
            padding: const EdgeInsets.only(),
            child: (!_restoreInProgress)
                ? ElevatedButton(
                    onPressed: _handleRestoreData,
                    child: const Text("Restore data"),
                  )
                : const CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}
