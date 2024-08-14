import 'package:flutter/material.dart';
import '../models/shopping_list.dart';

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
