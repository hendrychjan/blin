import 'package:blin/get/app_controller.dart';
import 'package:blin/pages/settings_page.dart';
import 'package:blin/theme/blin_ui_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: UniqueKey(),
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Get.to(() => const SettinsPage());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const Text('Home Page'),
        ],
      ),
    );
  }
}
