import 'package:flutter/material.dart';
import '../../widgets/kpi_card.dart';
import '../../widgets/inventory/equipment_table.dart';
import '../../widgets/inventory/consumables_management.dart';
import '../../models/inventory.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  bool _loading = true;
  List<Equipment> _equipment = [];
  List<Consumable> _consumables = [];

  @override
  void initState() {
    super.initState();
    _fetchInventory();
  }

  Future<void> _fetchInventory() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _equipment = [
          Equipment(id: 'E1', name: 'Training Cones (Set of 20)', category: 'Field', status: 'In Use', location: 'Field A', assignedTo: 'Coach Mike'),
          Equipment(id: 'E2', name: 'Standard Footballs (x10)', category: 'Ball', status: 'In Storage', location: 'Locker 1'),
          Equipment(id: 'E3', name: 'Goalkeeper Gloves (Size L)', category: 'Gear', status: 'Maintenance', location: 'Repair Shop', maintenanceDue: DateTime.now().add(const Duration(days: 3))),
        ];
        _consumables = [
          Consumable(id: 1, name: 'Mineral Water (500ml)', category: 'Beverage', unit: 'bottles', currentStock: 45, lowStockThreshold: 100, minOrderQuantity: 50, pricePerUnit: 50, location: 'Storage A', stockStatus: 'Low Stock', needsRestock: true, progress: 45),
          Consumable(id: 2, name: 'First Aid Kit Refills', category: 'Medical', unit: 'kits', currentStock: 12, lowStockThreshold: 5, minOrderQuantity: 5, pricePerUnit: 1200, location: 'Clinic', stockStatus: 'In Stock', needsRestock: false, progress: 85),
        ];
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Inventory & Logistics', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Text('Track equipment and manage consumables.', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            _buildKPIs(),
            const SizedBox(height: 32),
            EquipmentTable(equipment: _equipment),
            const SizedBox(height: 32),
            ConsumablesManagement(consumables: _consumables),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildKPIs() {
    return GridView.count(
      crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 1,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 2.5,
      children: [
        KpiCard(title: 'Total Assets', value: _equipment.length.toString(), icon: Icons.inventory_2_outlined, description: 'Tracked items'),
        KpiCard(title: 'Maintenance', value: _equipment.where((e) => e.status == 'Maintenance').length.toString(), icon: Icons.build_circle_outlined, description: 'Needs repair'),
        KpiCard(title: 'Restock Needed', value: _consumables.where((c) => c.needsRestock).length.toString(), icon: Icons.shopping_cart_outlined, description: 'Low stock alerts'),
      ],
    );
  }
}
