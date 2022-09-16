import 'package:blin/services/local_data_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DataSettingsSection extends StatefulWidget {
  const DataSettingsSection({super.key});

  @override
  State<DataSettingsSection> createState() => _DataSettingsSectionState();
}

class _DataSettingsSectionState extends State<DataSettingsSection> {
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
          const Padding(
            padding: EdgeInsets.only(
              bottom: 8,
            ),
            child: ElevatedButton(
              onPressed: LocalDataService.exportData,
              child: Text("Backup data (export)"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(),
            child: ElevatedButton(
              onPressed: () {},
              child: const Text("Restore data (import)"),
            ),
          ),
        ],
      ),
    );
  }
}
