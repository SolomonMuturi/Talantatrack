import 'package:flutter/material.dart';
import '../../models/inventory.dart';

class ConsumablesManagement extends StatelessWidget {
  final List<Consumable> consumables;

  const ConsumablesManagement({super.key, required this.consumables});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Consumables', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('Track stock levels of academy supplies.', style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: consumables.length,
          itemBuilder: (context, index) {
            final item = consumables[index];
            return _buildConsumableCard(context, item);
          },
        ),
      ],
    );
  }

  Widget _buildConsumableCard(BuildContext context, Consumable item) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), overflow: TextOverflow.ellipsis)),
                _buildStatusBadge(item.stockStatus),
              ],
            ),
            const SizedBox(height: 8),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${item.currentStock} ${item.unit} left', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    Text('Limit: ${item.lowStockThreshold}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: item.progress / 100,
                  backgroundColor: Colors.grey.shade900,
                  color: item.needsRestock ? Colors.redAccent : Theme.of(context).colorScheme.primary,
                  minHeight: 4,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(item.location, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: const Size(0, 24),
                    textStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                  child: const Text('Restock'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'in stock': color = Colors.greenAccent; break;
      case 'low stock': color = Colors.orangeAccent; break;
      case 'out of stock': color = Colors.redAccent; break;
      default: color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(status, style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold)),
    );
  }
}
