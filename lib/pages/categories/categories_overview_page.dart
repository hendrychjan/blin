import 'package:blin/get/app_controller.dart';
import 'package:blin/get/ui_controller.dart';
import 'package:blin/pages/categories/edit_category_page.dart';
import 'package:blin/pages/categories/new_category_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoriesOverviewPage extends StatefulWidget {
  const CategoriesOverviewPage({Key? key}) : super(key: key);

  @override
  State<CategoriesOverviewPage> createState() => _CategoriesOverviewPageState();
}

class _CategoriesOverviewPageState extends State<CategoriesOverviewPage> {
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
          return Column(
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
          );
        },
      ),
    );
  }
}
