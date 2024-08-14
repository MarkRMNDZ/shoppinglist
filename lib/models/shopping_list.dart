class ShoppingItem {
  String name;
  int quantity;
  bool checked;

  ShoppingItem({
    required this.name,
    required this.quantity,
    required this.checked,
  });

  // Convert ShoppingItem to JSON
  Map<String, dynamic> toJson() => {
        'name': name,
        'quantity': quantity,
        'checked': checked,
      };

  // Convert JSON to ShoppingItem
  factory ShoppingItem.fromJson(Map<String, dynamic> json) {
    return ShoppingItem(
      name: json['name'],
      quantity: json['quantity'],
      checked: json['checked'],
    );
  }
}

class ShoppingList {
  String title;
  List<ShoppingItem> items;

  ShoppingList({
    required this.title,
    required this.items,
  });

  // Convert ShoppingList to JSON
  Map<String, dynamic> toJson() => {
        'title': title,
        'items': items.map((item) => item.toJson()).toList(),
      };

  // Convert JSON to ShoppingList
  factory ShoppingList.fromJson(Map<String, dynamic> json) {
    return ShoppingList(
      title: json['title'],
      items: (json['items'] as List)
          .map((item) => ShoppingItem.fromJson(item))
          .toList(),
    );
  }
}
