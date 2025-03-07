import "package:flutter/material.dart";
import "package:shopping_list/data/categories.dart";
import "package:shopping_list/models/category.dart";
import "package:shopping_list/models/grocery_item.dart";
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewItem extends StatefulWidget {
  const NewItem({super.key});
  @override
  State<NewItem> createState() {
    return NewItemState();
  }
}

class NewItemState extends State<NewItem> {
  final formKey = GlobalKey<FormState>();
  var enteredName = "";
  var enteredQuantity = 1;
  var _selectedCategory = categories[Categories.vegetables]!;
  var isSending = false;
  void saveItem() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      setState(() {
        isSending = true;
      });
      final url = Uri.https(
          'flutter-demo-fir-default-rtdb.firebaseio.com', 'shopping-list.json');
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'name': enteredName,
            'quantity': enteredQuantity,
            'category': _selectedCategory.title,
          }));
      final Map<String, dynamic> resData =
          json.decode(response.body); //returns a map
      if (!context.mounted) {
        return;
      }
      Navigator.of(context).pop(GroceryItem(
          id: resData['name'],
          name: enteredName,
          quantity: enteredQuantity,
          category: _selectedCategory));
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(label: Text('Name')),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return 'Must be between 1 and 50 characters';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  enteredName = newValue!;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration:
                          const InputDecoration(label: Text("Quantity")),
                      keyboardType: TextInputType.number,
                      initialValue: enteredQuantity.toString(),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! <= 0) {
                          return 'Must be a valid positive number';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        enteredQuantity = int.parse(newValue!);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _selectedCategory,
                      items: [
                        for (final category in categories.entries)
                          DropdownMenuItem(
                            value: category.value,
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  color: category.value.color,
                                ),
                                const SizedBox(width: 6),
                                Text(category.value.title),
                              ],
                            ),
                          )
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: isSending
                          ? null
                          : () {
                              formKey.currentState!.reset();
                            },
                      child: const Text('Reset')),
                  ElevatedButton(
                      onPressed: isSending ? null : saveItem,
                      child: isSending
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(),
                            )
                          : const Text('Add Item'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
