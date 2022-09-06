import 'package:blin/forms/category_form.dart';
import 'package:blin/models/category.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewCategoryPage extends StatefulWidget {
  const NewCategoryPage({Key? key}) : super(key: key);

  @override
  State<NewCategoryPage> createState() => _NewCategoryPageState();
}

class _NewCategoryPageState extends State<NewCategoryPage> {
  Future<void> _handleSubmit(Category newCategory) async {
    await newCategory.create();
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: UniqueKey(),
        title: const Text('New Category'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: CategoryForm(handleSubmit: _handleSubmit),
      ),
    );
  }
}
