import 'package:flutter/material.dart';

void main() {
  runApp(GroceryListApp());
}

class GroceryListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grocery List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GroceryListHome(),
    );
  }
}

class GroceryList {
  String name;
  List<GroceryItem> items;

  GroceryList({required this.name, required this.items});
}

class GroceryItem {
  String name;
  bool isBought;

  GroceryItem({required this.name, required this.isBought});
}

class GroceryListHome extends StatefulWidget {
  @override
  _GroceryListHomeState createState() => _GroceryListHomeState();
}

class _GroceryListHomeState extends State<GroceryListHome> {
  List<GroceryList> _groceryLists = [];

  void _addGroceryList(String name) {
    setState(() {
      _groceryLists.add(GroceryList(name: name, items: []));
    });
  }

  void _deleteGroceryList(int index) {
    setState(() {
      _groceryLists.removeAt(index);
    });
  }

  void _addItemToList(int listIndex, String itemName) {
    setState(() {
      _groceryLists[listIndex].items.add(GroceryItem(name: itemName, isBought: false));
    });
  }

  void _toggleItemBoughtStatus(int listIndex, int itemIndex, bool? value) {
    setState(() {
      _groceryLists[listIndex].items[itemIndex].isBought = value ?? false;
    });
  }

  void _shareList(int listIndex) {
    final list = _groceryLists[listIndex];
    final items = list.items.map((item) => item.name).join(', ');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing list: ${list.name}\nItems: $items'),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Grocery List',
          style: TextStyle(color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.red, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.purple.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: _groceryLists.isEmpty
            ? Center(
                child: Text(
                  'No grocery lists yet!\nTap the + button to create one.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
                ),
              )
            : ListView.builder(
                itemCount: _groceryLists.length,
                itemBuilder: (context, index) {
                  final list = _groceryLists[index];
                  return Card(
                    margin: EdgeInsets.all(8),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ExpansionTile(
                      title: Text(
                        list.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteGroceryList(index),
                      ),
                      children: [
                        ...list.items.asMap().entries.map((entry) {
                          int itemIndex = entry.key;
                          GroceryItem item = entry.value;
                          return ListTile(
                            title: Text(
                              item.name,
                              style: TextStyle(
                                color: item.isBought ? Colors.grey : Colors.black,
                                decoration: item.isBought
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            trailing: Checkbox(
                              value: item.isBought,
                              onChanged: (value) =>
                                  _toggleItemBoughtStatus(index, itemIndex, value),
                              activeColor: Colors.deepPurple,
                            ),
                          );
                        }).toList(),
                        ListTile(
                          leading: Icon(Icons.add, color: Colors.blue),
                          title: Text(
                            'Add Item',
                            style: TextStyle(color: Colors.blue),
                          ),
                          onTap: () => _showAddItemDialog(index),
                        ),
                        ListTile(
                          leading: Icon(Icons.share, color: Colors.purple),
                          title: Text(
                            'Share List',
                            style: TextStyle(color: Colors.purple),
                          ),
                          onTap: () => _shareList(index),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateListDialog,
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  void _showCreateListDialog() {
    String newListName = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Create New List',
            style: TextStyle(color: Colors.deepPurple),
          ),
          content: TextField(
            onChanged: (value) => newListName = value,
            decoration: InputDecoration(
              hintText: 'List name',
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (newListName.isNotEmpty) {
                  _addGroceryList(newListName);
                  Navigator.pop(context);
                }
              },
              child: Text(
                'Create',
                style: TextStyle(color: Colors.deepPurple),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAddItemDialog(int listIndex) {
    String newItem = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Add Item',
            style: TextStyle(color: Colors.deepPurple),
          ),
          content: TextField(
            onChanged: (value) => newItem = value,
            decoration: InputDecoration(
              hintText: 'Item name',
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (newItem.isNotEmpty) {
                  _addItemToList(listIndex, newItem);
                  Navigator.pop(context);
                }
              },
              child: Text(
                'Add',
                style: TextStyle(color: Colors.deepPurple),
              ),
            ),
          ],
        );
      },
    );
  }
}