import 'package:blin/forms/category_form.dart';
import 'package:blin/get/app_controller.dart';
import 'package:blin/models/category.dart';
import 'package:blin/services/blin_api/blin_categories_service.dart';
import 'package:blin/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditCategoryPage extends StatefulWidget {
  final Category category;
  const EditCategoryPage({Key? key, required this.category}) : super(key: key);

  @override
  State<EditCategoryPage> createState() => _EditCategoryPageState();
}

class _EditCategoryPageState extends State<EditCategoryPage> {
  Future<void> _handleDelete() async {
    // Check if the internet connection is available
    bool connected = await HttpService.checkInternetConnection();

    // If yes, try to delete the category
    if (connected) {
      // Delete the category
      await BlinCategoriesService.deleteCategory(widget.category);

      // Remove the category from the local storage
      AppController.to.categories.remove(widget.category);

      // Go to the categories overview page
      Get.back();
    } else {
      throw "No internet.";
    }
  }

  Future<void> _handleUpdate(Map form) async {
    // Check if the internet connection is available
    bool connected = await HttpService.checkInternetConnection();

    // If yes, try to update the category
    if (connected) {
      Category newCategory = Category(
        id: widget.category.id,
        name: form['name'],
        description: form['description'],
        color: form['color'],
      );

      // Update the category
      Category updated =
          await BlinCategoriesService.updateCategory(newCategory);

      // Update the category in AppController list of categories
      AppController.to.categories
          .removeWhere((category) => category.id == updated.id);
      AppController.to.categories.add(updated);

      // Go to the categories overview page
      Get.back();
    } else {
      throw "No internet.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: UniqueKey(),
        title: const Text('Edit category'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _handleDelete,
          )
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
