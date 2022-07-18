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
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  Color colorController = const Color(0xFF194466);
  Color colorSelected = const Color(0xFF194466);
  String _error = "";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialState != null) {
      nameController.text = widget.initialState!.name;
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
            hint: "Name",
            controller: nameController,
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
          (!_isLoading)
              ? ElevatedButton(
                  onPressed: () async {
                    // Validate the form
                    if (!formKey.currentState!.validate()) return;

                    setState(() {
                      _isLoading = true;
                    });

                    try {
                      await widget.handleSubmit({
                        "name": nameController.text,
                        "description": descriptionController.text,
                        "color": UiController.colorToHexString(colorSelected),
                      });
                    } catch (e) {
                      setState(() {
                        _error = e as String;
                        _isLoading = false;
                      });
                    }
                  },
                  child: Text(widget.submitButtonText ?? "Submit"),
                )
              : const CircularProgressIndicator(),
          Text(
            _error,
            style: const TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }
}
