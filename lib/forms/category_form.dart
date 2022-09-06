import 'package:blin/get/ui_controller.dart';
import 'package:blin/models/category.dart';
import 'package:flutter/material.dart';

class CategoryForm extends StatefulWidget {
  final Function handleSubmit;
  final Category? initialState;
  final String? submitButtonText;
  const CategoryForm({
    Key? key,
    required this.handleSubmit,
    this.initialState,
    this.submitButtonText,
  }) : super(key: key);

  @override
  State<CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  Color colorController = const Color(0xFF194466);
  Color colorSelected = const Color(0xFF194466);

  @override
  void initState() {
    super.initState();
    if (widget.initialState != null) {
      titleController.text = widget.initialState!.title;
      descriptionController.text = widget.initialState!.description ?? "";
      colorController =
          UiController.hexStringToColor(widget.initialState!.color);
      colorSelected = UiController.hexStringToColor(widget.initialState!.color);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          UiController.renderTextInput(
            hint: "Title",
            controller: titleController,
            validationRules: ["required"],
          ),
          UiController.renderTextInput(
            hint: "Description",
            controller: descriptionController,
            validationRules: [""],
          ),
          UiController.renderColorSelect(
            hint: "Theme color",
            controller: colorController,
            selected: colorSelected,
            onChanged: (color) {
              setState(() {
                colorController = color;
              });
            },
            onSelected: () {
              setState(() {
                colorSelected = colorController;
              });
            },
          ),
          ElevatedButton(
            onPressed: () async {
              // Validate the form
              if (!formKey.currentState!.validate()) return;

              // Submit the form
              await widget.handleSubmit(Category(
                id: widget.initialState?.id ?? "0",
                title: titleController.text,
                description: descriptionController.text,
                color: UiController.colorToHexString(colorSelected),
              ));
            },
            child: Text(widget.submitButtonText ?? "Submit"),
          ),
        ],
      ),
    );
  }
}
