import 'package:flutter/material.dart';

void main() {
  runApp(ShoppingListApp());
}

class ShoppingListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<ShoppingList> _shoppingLists = [];

  void _addNewList(String title, List<ShoppingItem> items) {
    setState(() {
      _shoppingLists.add(ShoppingList(title: title, items: items));
    });
  }

  void _deleteList(int index) {
    setState(() {
      _shoppingLists.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Shopping List',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 7, 85, 255),
      ),
      body: ListView.builder(
        itemCount: _shoppingLists.length,
        itemBuilder: (context, index) {
          final list = _shoppingLists[index];
          return ListTile(
            title: Text(list.title),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ShoppingListScreen(
                    shoppingList: list,
                    onDelete: () => _deleteList(index),
                  ),
                ),
              );
            },
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deleteList(index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => NewListScreen(onSave: _addNewList),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class NewListScreen extends StatefulWidget {
  final Function(String, List<ShoppingItem>) onSave;

  NewListScreen({required this.onSave});

  @override
  _NewListScreenState createState() => _NewListScreenState();
}

class _NewListScreenState extends State<NewListScreen> {
  final TextEditingController _titleController = TextEditingController();
  final List<ShoppingItem> _items = [];
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  void _addItem() {
    if (_itemController.text.isNotEmpty &&
        _quantityController.text.isNotEmpty) {
      setState(() {
        _items.add(
          ShoppingItem(
            name: _itemController.text,
            quantity: int.parse(_quantityController.text),
            checked: false,
          ),
        );
        _itemController.clear();
        _quantityController.clear();
      });
    }
  }

  void _deleteItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  void _saveList() {
    if (_titleController.text.isNotEmpty) {
      widget.onSave(_titleController.text, _items);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Shopping List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _itemController,
                    decoration: InputDecoration(labelText: 'Item'),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _quantityController,
                    decoration: InputDecoration(labelText: 'Quantity'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addItem,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return ListTile(
                  title: Text('${item.name} x ${item.quantity}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteItem(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveList,
        child: Icon(Icons.save),
      ),
    );
  }
}

class ShoppingListScreen extends StatefulWidget {
  final ShoppingList shoppingList;
  final VoidCallback onDelete;

  ShoppingListScreen({required this.shoppingList, required this.onDelete});

  @override
  _ShoppingListScreenState createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _editItemController = TextEditingController();
  final TextEditingController _editQuantityController = TextEditingController();

  void _addItem() {
    if (_itemController.text.isNotEmpty &&
        _quantityController.text.isNotEmpty) {
      setState(() {
        widget.shoppingList.items.add(
          ShoppingItem(
            name: _itemController.text,
            quantity: int.parse(_quantityController.text),
            checked: false,
          ),
        );
        _itemController.clear();
        _quantityController.clear();
      });
    }
  }

  void _deleteItem(int index) {
    setState(() {
      widget.shoppingList.items.removeAt(index);
    });
  }

  void _toggleItemChecked(int index) {
    setState(() {
      widget.shoppingList.items[index].checked =
          !widget.shoppingList.items[index].checked;
    });
  }

  void _editItem(int index) {
    _editItemController.text = widget.shoppingList.items[index].name;
    _editQuantityController.text =
        widget.shoppingList.items[index].quantity.toString();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _editItemController,
                decoration: InputDecoration(labelText: 'Item'),
              ),
              TextField(
                controller: _editQuantityController,
                decoration: InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  widget.shoppingList.items[index].name =
                      _editItemController.text;
                  widget.shoppingList.items[index].quantity =
                      int.parse(_editQuantityController.text);
                });
                _editItemController.clear();
                _editQuantityController.clear();
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.shoppingList.title),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              widget.onDelete();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _itemController,
                    decoration: InputDecoration(labelText: 'Item'),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _quantityController,
                    decoration: InputDecoration(labelText: 'Quantity'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addItem,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.shoppingList.items.length,
              itemBuilder: (context, index) {
                final item = widget.shoppingList.items[index];
                return ListTile(
                  leading: Checkbox(
                    value: item.checked,
                    onChanged: (bool? value) {
                      _toggleItemChecked(index);
                    },
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          'x ${item.quantity}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _editItem(index),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteItem(index),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ShoppingItem {
  String name;
  int quantity;
  bool checked;

  ShoppingItem({
    required this.name,
    required this.quantity,
    required this.checked,
  });
}

class ShoppingList {
  String title;
  List<ShoppingItem> items;

  ShoppingList({
    required this.title,
    required this.items,
  });
}
