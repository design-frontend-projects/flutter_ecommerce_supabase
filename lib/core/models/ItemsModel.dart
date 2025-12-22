
class ItemsModel {
  final int itemId;
  final String name;
  final double price;

  ItemsModel({
    required this.itemId,
    required this.name,
    required this.price,
  });

  factory ItemsModel.fromJson(Map<String, dynamic> json) {
    return ItemsModel(
      itemId: json['item_id'],
      name: json['name'] as String,
      price: json['price'] is double ? json['price'] : json['price'] is int ? json['price'].toDouble() : double.parse(json['price'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item_id': itemId,
      'name': name,
      'price': price,
    };
  }
}
