import 'package:blin/forms/category_form.dart';
import 'package:blin/get/app_controller.dart';
import 'package:blin/models/category.dart';
import 'package:blin/services/blin_api/blin_categories_service.dart';
import 'package:blin/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewCategoryPage extends StatefulWidget {
  const NewCategoryPage({Key? key}) : super(key: key);

  @override
  State<NewCategoryPage> createState() => _NewCategoryPageState();
}

class _NewCategoryPageState extends State<NewCategoryPage> {
  Future<void> _handleSubmit(Map formValues) async {
    // Check if the internet connection is available
    bool connected = await HttpService.checkInternetConnection();

    // If yes, try to create the category
    if (connected) {
      Category newCategory = Category(
        id: null,
        name: formValues['name'],
        description: formValues['description'],
        color: formValues['color'],
      );
      // Create the category
      Category created =
          await BlinCategoriesService.createNewCategory(newCategory);

      // Save the category to the local storage
      AppController.to.categories.add(created);

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
        title: const Text('New Category'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: CategoryForm(handleSubmit: _handleSubmit),
      ),
    );
  }
}
