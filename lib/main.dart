import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/shopping_list.dart';
import 'pages/new_list_screen.dart';
import 'pages/shopping_list_screen.dart';

void main() {
  runApp(ShoppingListApp());
}

class ShoppingListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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

  @override
  void initState() {
    super.initState();
    _loadShoppingLists();
  }

  Future<void> _loadShoppingLists() async {
    final prefs = await SharedPreferences.getInstance();
    final String? shoppingListsString = prefs.getString('shoppingLists');
    if (shoppingListsString != null) {
      final List<dynamic> shoppingListJson = jsonDecode(shoppingListsString);
      setState(() {
        _shoppingLists.addAll(shoppingListJson
            .map((json) => ShoppingList.fromJson(json))
            .toList());
      });
    }
  }

  Future<void> _saveShoppingLists() async {
    final prefs = await SharedPreferences.getInstance();
    final String shoppingListsString =
        jsonEncode(_shoppingLists.map((list) => list.toJson()).toList());
    await prefs.setString('shoppingLists', shoppingListsString);
  }

  void _addNewList(String title, List<ShoppingItem> items) {
    setState(() {
      _shoppingLists.add(ShoppingList(title: title, items: items));
      _saveShoppingLists();
    });
  }

  void _deleteList(int index) {
    setState(() {
      _shoppingLists.removeAt(index);
      _saveShoppingLists();
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
