import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/grocery_item.dart';
import '../data/categories.dart';
import '../models/category.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  String _enteredName = "";
  int _enteredQuantity = 0;
  Category _selectedCategory = categories[Categories.dairy]!;
  bool _isLoading = false;

  _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
    }

    /// instead of using parse you can use https as follow in this case you don't have to write [https://]
    final url = Uri.https(
        "flutter-test-ef152-default-rtdb.firebaseio.com", "shopping-list.json");
    final http.Response res = await http.post(
      /// we wanted to post our data on firebase so we used http then [post] but the url want it to be type of uri,
      /// so we create the [url] var to do this then give it other information he need to post our data
      url,
      headers: {"Conten-Type": "application/json"},
      body: json.encode(
        /// [json.encode] convert object(map) to string
        {
          "name": _enteredName,
          "quantity": _enteredQuantity,
          "category": _selectedCategory.title,
        },
      ),
    );
    if (res.statusCode == 200) {
      final Map<String, dynamic> id = json.decode(res.body);
      Navigator.of(context).pop(GroceryItem(
        id: id["name"],
        name: _enteredName,
        quantity: _enteredQuantity,
        category: _selectedCategory,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add new item"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          /// [Form] is very useful when you are dealing with forms or many input, it's have a [key]
          /// this can make your life easier
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                minLines: 1,
                onSaved: (newValue) {
                  _enteredName = newValue!;
                },
                decoration: const InputDecoration(labelText: "Name"),
                validator: (value) {
                  /// [value] what the user will enter
                  if (value == null ||
                      value.trim().length <= 1 ||
                      value.trim().length > 51) {
                    return "Must be between 1 and 50 characters. ";
                  }
                  return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: "1",
                      keyboardType: TextInputType.number,
                      onSaved: (newValue) {
                        _enteredQuantity = int.parse(newValue!);
                      },
                      decoration: const InputDecoration(labelText: "Quantity"),
                      validator: (value) {
                        /// [value] what the user will enter
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! <= 0) {
                          return "Must be valid, Positive number. ";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                      items: [
                        for (final category in categories.entries)

                          /// [entries] allow us to take the values inside the map
                          DropdownMenuItem(
                            value: category.value,
                            child: Row(
                              children: [
                                Container(
                                  height: 16,
                                  width: 16,
                                  color: category.value.color,
                                ),
                                const SizedBox(width: 6),
                                Text(category.value.title),
                              ],
                            ),
                          ),
                      ],
                      value: _selectedCategory,
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
                    onPressed: _isLoading
                        ? null
                        : () {
                            _formKey.currentState!.reset();
                          },
                    child: const Text("Reset"),
                  ),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _saveItem,
                    child: _isLoading
                        ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator())
                        : const Text("Add item"),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
