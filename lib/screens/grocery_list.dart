import 'package:flutter/material.dart';
import 'package:shop/data/dummy_items.dart';


class GroceryList extends StatelessWidget {
  const GroceryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Grocery List"),
      ),
      body: ListView.builder(
        itemCount: groceryItems.length,
        itemBuilder: (ctx, int index) => ListTile(
          ///you can't just writ [GroceryItem.name] no [GroceryItem] is an index in the [groceryItems] and it's List,
          /// so we give it an index like 1,2,3 than write .name
          title: Text(groceryItems[index].name),

          /// Like the previous one here we travels to [groceryItems] and go to each element using the index,
          /// and then go to [category] this category have value about every thing you may need to know about certain element,
          /// here we used it for color
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: groceryItems[index].category.color,
            ),
          ),
          trailing: Text(groceryItems[index].quantity.toString(),),
        ),
      ),
    );
  }
}
