import 'package:flutter/material.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widgets/new_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shopping_list/data/categories.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];
  var isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadItems();
  }

  void loadItems() async {
    final url = Uri.https(
        'flutter-demo-fir-default-rtdb.firebaseio.com', 'shopping-list.json');
    try {
      final response = await http.get(
        url,
      );
      if (response.statusCode >= 400) {
        setState(() {
          error = "Failed to fecth data, please try again later";
        });
      }
      if (response.body == 'null') {
        setState(() {
          isLoading = false;
        });
        return;
      }
      final Map<String, dynamic> listdata =
          json.decode(response.body); //returns a dynamic value
      final List<GroceryItem> loadedItems = [];
      for (final item in listdata.entries) {
        final categoryEntry = categories.entries.firstWhere(
          (element) => element.value.title == item.value['category'],
        );
        final category = categoryEntry.value; // Extract the Category value
        loadedItems.add(GroceryItem(
            id: item.key,
            name: item.value['name'],
            quantity: item.value['quantity'],
            category: category));
      }
      setState(() {
        _groceryItems = loadedItems;
        isLoading = false;
      });
    } catch (erro) {
      setState(() {
        error = "Something went wrong, please try again later";
      });
    }
  }

  void addItem() async {
    final newitem = await Navigator.of(context)
        .push<GroceryItem>(//need to wait to add a new item
            MaterialPageRoute(builder: (ctx) => const NewItem()));
    loadItems();
    if (newitem == null) {
      return;
    }
    setState(() {
      _groceryItems.add(newitem);
    });
  }

  void removeItem(GroceryItem item) async {
    final index = _groceryItems.indexOf(item);
    setState(() {
      _groceryItems.remove(item);
    });
    final url = Uri.https('flutter-demo-fir-default-rtdb.firebaseio.com',
        'shopping-list/${item.id}.json');
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      setState(() {
        _groceryItems.insert(index, item);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text("No items added yet!"),
    );
    if (isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
          itemCount: _groceryItems.length,
          itemBuilder: (ctx, index) => Dismissible(
                key: ValueKey(_groceryItems[index].id),
                onDismissed: (direction) {
                  removeItem(_groceryItems[index]);
                },
                child: ListTile(
                  title: Text(_groceryItems[index].name),
                  leading: Container(
                    width: 24,
                    height: 24,
                    color: _groceryItems[index].category.color,
                  ),
                  trailing: Text(_groceryItems[index].quantity.toString()),
                ),
              ));
    }
    if (error != null) {
      content = Center(
        child: Text(error!),
      );
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Groceries'),
          actions: [
            IconButton(onPressed: addItem, icon: const Icon(Icons.add))
          ],
        ),
        body: content);
  }
}
