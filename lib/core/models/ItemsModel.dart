
class ItemsModel {
  final int product_id;
  final String name;
  final double base_price;

  ItemsModel({
    required this.product_id,
    required this.name,
    required this.base_price,
  });

  factory ItemsModel.fromJson(Map<String, dynamic> json) {
    return ItemsModel(
      product_id: json['product_id'],
      name: json['name'] as String,
      base_price: json['base_price'] is double ? json['base_price'] : json['base_price'] is int ? json['base_price'].toDouble() : double.parse(json['base_price'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': product_id,
      'name': name,
      'base_price': base_price,
    };
  }
}
