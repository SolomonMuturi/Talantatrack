class Equipment {
  final String id;
  final String name;
  final String category;
  final String? assignedTo;
  final String location;
  final String status; // In Use, In Storage, Maintenance, Damaged
  final DateTime? maintenanceDue;
  final String? description;

  Equipment({
    required this.id,
    required this.name,
    required this.category,
    this.assignedTo,
    required this.location,
    required this.status,
    this.maintenanceDue,
    this.description,
  });
}

class Consumable {
  final int id;
  final String name;
  final String category;
  final String unit;
  final int currentStock;
  final int lowStockThreshold;
  final int minOrderQuantity;
  final double pricePerUnit;
  final String location;
  final String stockStatus; // In Stock, Low Stock, Out of Stock
  final bool needsRestock;
  final double progress;
  final String? notes;

  Consumable({
    required this.id,
    required this.name,
    required this.category,
    required this.unit,
    required this.currentStock,
    required this.lowStockThreshold,
    required this.minOrderQuantity,
    required this.pricePerUnit,
    required this.location,
    required this.stockStatus,
    required this.needsRestock,
    required this.progress,
    this.notes,
  });
}
