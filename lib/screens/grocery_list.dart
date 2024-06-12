import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop/data/categories.dart';
import 'package:shop/models/category.dart';
import 'package:shop/models/grocery_item.dart';
import 'package:shop/widgets/new_item.dart';
import 'package:http/http.dart' as http;

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> groceryItems = [];

  /// same as post but here we just get the data from firebase
  void _loadDate() async {
    final url = Uri.https(
        "flutter-test-ef152-default-rtdb.firebaseio.com", "shopping-list.json");
    final http.Response res = await http.get(url);
    final Map<String, dynamic> loadedData = json.decode(res.body);

    /// [json.decode] convert string to map
    /// for dart it's hard to give this [loadedData] type so we give it manually to understand more what is this type just use log(res.body.toString());
    /// but dart will not accept that type so we have to just write dynamic

    List<GroceryItem> loadedItems = [];
    for (var item in loadedData.entries) {
      final Category category = categories.entries.firstWhere(
        (element) {
          return element.value.title == item.value["category"];
        },
      ).value;
      loadedItems.add(
        GroceryItem(
          id: item.key,
          name: item.value["name"],
          quantity: item.value["quantity"],
          category: category,
        ),
      );
    }
    setState(() {
      groceryItems = loadedItems;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadDate();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text("No item added yet."),
    );
    if (groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: groceryItems.length,
        itemBuilder: (ctx, int index) => Dismissible(
          key: ValueKey(groceryItems[index].id),
          onDismissed: (_) {
            setState(() {
              groceryItems.remove(groceryItems[index]);
            });
          },
          child: ListTile(
            ///you can't just writ [GroceryItem.name] no [GroceryItem] is an index in the [_groceryItems] and it's List,
            /// so we give it an index like 1,2,3 than write .name
            title: Text(groceryItems[index].name),

            /// Like the previous one here we travels to [_groceryItems] and go to each element using the index,
            /// and then go to [category] this category have value about every thing you may need to know about certain element,
            /// here we used it for color
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: groceryItems[index].category.color,
              ),
            ),
            trailing: Text(
              groceryItems[index].quantity.toString(),
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Grocery List"),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: content,
    );
  }

  _addItem() async {
    final newValue = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );
    if (newValue != null) {
      setState(() {
        groceryItems.add(newValue);
      });
    } else {
      return;
    }
  }
}
