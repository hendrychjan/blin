import 'package:blin/get/app_controller.dart';
import 'package:blin/get/ui_controller.dart';
import 'package:blin/models/category.dart';
import 'package:blin/pages/categories/edit_category_page.dart';
import 'package:blin/pages/categories/new_category_page.dart';
import 'package:blin/services/blin_api/blin_categories_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoriesOverviewPage extends StatefulWidget {
  const CategoriesOverviewPage({Key? key}) : super(key: key);

  @override
  State<CategoriesOverviewPage> createState() => _CategoriesOverviewPageState();
}

class _CategoriesOverviewPageState extends State<CategoriesOverviewPage> {
  Future<void> _handleRefresh() async {
    // Download the fresh data from API
    List<Category> updated = await BlinCategoriesService.getAllCategories();

    // Update the categories in the app controller
    AppController.to.categories.value = updated;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: UniqueKey(),
        title: const Text('Categories'),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: UniqueKey(),
        key: UniqueKey(),
        onPressed: () {
          Get.to(() => const NewCategoryPage());
        },
        child: const Icon(Icons.add),
      ),
      body: Obx(
        () {
          // If there are no categories, show a message
          if (AppController.to.categories.isEmpty) {
            return const Center(
              child: Text('No categories yet'),
            );
          }

          // Otherwise, show the categories
          return RefreshIndicator(
            key: UniqueKey(),
            onRefresh: () async => await _handleRefresh(),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: AppController.to.categories.length,
                    itemBuilder: (context, index) {
                      final category = AppController.to.categories[index];
                      return GestureDetector(
                        key: UniqueKey(),
                        onTap: () => Get.to(
                          () => EditCategoryPage(category: category),
                        ),
                        child: Card(
                          child: ListTile(
                            title: Text(category.title),
                            subtitle: Text(category.description ?? ''),
                            tileColor: Colors.grey[50],
                            textColor:
                                UiController.hexStringToColor(category.color),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
