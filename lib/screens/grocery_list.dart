import 'package:flutter/material.dart';
import 'package:shop/models/grocery_item.dart';
import 'package:shop/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final List<GroceryItem> _groceryItems = [];

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text("No item added yet."),
    );
    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (ctx, int index) => Dismissible(
          key: ValueKey(_groceryItems[index].id),
          onDismissed: (_) {
            setState(() {
              _groceryItems.remove(_groceryItems[index]);
            });
          },
          child: ListTile(
            ///you can't just writ [GroceryItem.name] no [GroceryItem] is an index in the [_groceryItems] and it's List,
            /// so we give it an index like 1,2,3 than write .name
            title: Text(_groceryItems[index].name),

            /// Like the previous one here we travels to [_groceryItems] and go to each element using the index,
            /// and then go to [category] this category have value about every thing you may need to know about certain element,
            /// here we used it for color
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: _groceryItems[index].category.color,
              ),
            ),
            trailing: Text(
              _groceryItems[index].quantity.toString(),
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
            onPressed: () {
              Navigator.of(context)
                  .push<GroceryItem>(
                MaterialPageRoute(
                  builder: (ctx) => const NewItem(),
                ),
              )
                  .then((onValue) {
                if (onValue == null) {
                  return;
                }
                setState(() {
                  _groceryItems.add(onValue);
                });
              });
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: content,
    );
  }
}
