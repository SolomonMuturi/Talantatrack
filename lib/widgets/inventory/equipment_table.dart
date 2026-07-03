import 'package:flutter/material.dart';
import '../../models/inventory.dart';
import 'package:intl/intl.dart';

class EquipmentTable extends StatelessWidget {
  final List<Equipment> equipment;

  const EquipmentTable({super.key, required this.equipment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Equipment Inventory', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Track all high-value academy assets.', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Item Name')),
                DataColumn(label: Text('Category')),
                DataColumn(label: Text('Assigned To')),
                DataColumn(label: Text('Status')),
                DataColumn(label: Text('Next Maint.')),
              ],
              rows: equipment.map((item) => DataRow(cells: [
                DataCell(Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold))),
                DataCell(Text(item.category)),
                DataCell(Text(item.assignedTo ?? 'N/A')),
                DataCell(_buildStatusBadge(item.status)),
                DataCell(Text(item.maintenanceDue != null ? DateFormat('MMM dd').format(item.maintenanceDue!) : 'N/A')),
              ])).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'in use': color = Colors.blueAccent; break;
      case 'in storage': color = Colors.greenAccent; break;
      case 'maintenance': color = Colors.orangeAccent; break;
      case 'damaged': color = Colors.redAccent; break;
      default: color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color, width: 0.5),
      ),
      child: Text(status, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}
