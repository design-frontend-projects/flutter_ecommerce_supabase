/// Order model
class OrderModel {
  final int orderId;
  final int customerId;
  final String status;
  final double subtotal;
  final double taxAmount;
  final double discountAmount;
  final double shippingCost;
  final double totalAmount;
  final String? shippingAddressLine1;
  final String? shippingAddressLine2;
  final String? shippingCity;
  final String? shippingStateProvince;
  final String? shippingPostalCode;
  final String? shippingCountry;
  final String? paymentMethod;
  final String? paymentStatus;
  final String? trackingNumber;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<OrderItemModel>? items;

  OrderModel({
    required this.orderId,
    required this.customerId,
    required this.status,
    required this.subtotal,
    required this.taxAmount,
    required this.discountAmount,
    required this.shippingCost,
    required this.totalAmount,
    this.shippingAddressLine1,
    this.shippingAddressLine2,
    this.shippingCity,
    this.shippingStateProvince,
    this.shippingPostalCode,
    this.shippingCountry,
    this.paymentMethod,
    this.paymentStatus,
    this.trackingNumber,
    this.notes,
    this.createdAt,
    this.updatedAt,
    this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    int? parseNullableInt(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value);
      return null;
    }

    int parseInt(dynamic value) {
      return parseNullableInt(value) ?? 0;
    }

    return OrderModel(
      orderId: parseInt(json['order_id']),
      customerId: parseInt(json['customer_id']),
      status: json['status']?.toString() ?? 'pending',
      subtotal: parseDouble(json['subtotal']),
      taxAmount: parseDouble(json['tax_amount']),
      discountAmount: parseDouble(json['discount_amount']),
      shippingCost: parseDouble(json['shipping_cost']),
      totalAmount: parseDouble(json['total_amount']),
      shippingAddressLine1: json['shipping_address_line1']?.toString(),
      shippingAddressLine2: json['shipping_address_line2']?.toString(),
      shippingCity: json['shipping_city']?.toString(),
      shippingStateProvince: json['shipping_state_province']?.toString(),
      shippingPostalCode: json['shipping_postal_code']?.toString(),
      shippingCountry: json['shipping_country']?.toString(),
      paymentMethod: json['payment_method']?.toString(),
      paymentStatus: json['payment_status']?.toString(),
      trackingNumber: json['tracking_number']?.toString(),
      notes: json['notes']?.toString(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
      items: json['order_items'] != null
          ? (json['order_items'] as List)
                .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'customer_id': customerId,
      'status': status,
      'subtotal': subtotal,
      'tax_amount': taxAmount,
      'discount_amount': discountAmount,
      'shipping_cost': shippingCost,
      'total_amount': totalAmount,
      'shipping_address_line1': shippingAddressLine1,
      'shipping_address_line2': shippingAddressLine2,
      'shipping_city': shippingCity,
      'shipping_state_province': shippingStateProvince,
      'shipping_postal_code': shippingPostalCode,
      'shipping_country': shippingCountry,
      'payment_method': paymentMethod,
      'payment_status': paymentStatus,
      'tracking_number': trackingNumber,
      'notes': notes,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  String get formattedDate {
    if (createdAt == null) return '';
    return '${createdAt!.day}/${createdAt!.month}/${createdAt!.year}';
  }

  String get statusDisplay {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'processing':
        return 'Processing';
      case 'shipped':
        return 'Shipped';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }
}

/// Order item model
class OrderItemModel {
  final int orderItemId;
  final int orderId;
  final int productId;
  final int quantity;
  final double unitPrice;
  final double discountAmount;
  final double taxAmount;
  final double totalPrice;
  final String? productName;

  OrderItemModel({
    required this.orderItemId,
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    required this.discountAmount,
    required this.taxAmount,
    required this.totalPrice,
    this.productName,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    int? parseNullableInt(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value);
      return null;
    }

    int parseInt(dynamic value) {
      return parseNullableInt(value) ?? 0;
    }

    return OrderItemModel(
      orderItemId: parseInt(json['order_item_id']),
      orderId: parseInt(json['order_id']),
      productId: parseInt(json['product_id']),
      quantity: parseInt(json['quantity']),
      unitPrice: parseDouble(json['unit_price']),
      discountAmount: parseDouble(json['discount_amount']),
      taxAmount: parseDouble(json['tax_amount']),
      totalPrice: parseDouble(json['total_price']),
      productName: json['products'] != null
          ? (json['products'] as Map<String, dynamic>)['name']?.toString()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_item_id': orderItemId,
      'order_id': orderId,
      'product_id': productId,
      'quantity': quantity,
      'unit_price': unitPrice,
      'discount_amount': discountAmount,
      'tax_amount': taxAmount,
      'total_price': totalPrice,
    };
  }
}
