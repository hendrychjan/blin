import 'package:blin/forms/category_form.dart';
import 'package:blin/models/category.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditCategoryPage extends StatefulWidget {
  final Category category;
  const EditCategoryPage({Key? key, required this.category}) : super(key: key);

  @override
  State<EditCategoryPage> createState() => _EditCategoryPageState();
}

class _EditCategoryPageState extends State<EditCategoryPage> {
  late bool isDefaultCatgory;

  @override
  void initState() {
    super.initState();
    isDefaultCatgory = widget.category.id == "0";
  }

  Future<void> _handleRemove() async {
    try {
      await widget.category.remove();
      Get.back();
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _handleUpdate(Category updatedCategory) async {
    await updatedCategory.update();
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: UniqueKey(),
        title: const Text('Edit category'),
        actions: [
          if (!isDefaultCatgory)
            IconButton(
              key: UniqueKey(),
              icon: const Icon(Icons.delete),
              onPressed: _handleRemove,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: CategoryForm(
          handleSubmit: _handleUpdate,
          initialState: widget.category,
          submitButtonText: "Update",
        ),
      ),
    );
  }
}
