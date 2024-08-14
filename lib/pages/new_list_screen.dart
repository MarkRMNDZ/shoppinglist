import 'package:flutter/material.dart';
import '../models/shopping_list.dart';

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
        children: listSection,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveList,
        child: Icon(Icons.save),
      ),
    );
  }

  List<Widget> get listSection {
    return [
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
    ];
  }
}
