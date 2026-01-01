class Order {
  final int id;
  final String userId;
  final double total;
  final String status;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.userId,
    required this.total,
    required this.status,
    required this.createdAt,
  });

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'] as int,
      userId: map['user_id'] as String,
      total: (map['total'] as num).toDouble(),
      status: map['status'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'total': total,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
