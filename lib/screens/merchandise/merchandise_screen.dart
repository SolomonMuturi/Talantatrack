import 'package:flutter/material.dart';
import '../../widgets/kpi_card.dart';
import '../../widgets/merchandise/merchandise_store.dart';
import '../../models/merchandise.dart';

class MerchandiseScreen extends StatefulWidget {
  const MerchandiseScreen({super.key});

  @override
  State<MerchandiseScreen> createState() => _MerchandiseScreenState();
}

class _MerchandiseScreenState extends State<MerchandiseScreen> {
  bool _loading = true;
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _products = [
          Product(id: '1', name: 'Official Academy Jersey', price: 2500, cost: 1200, sales: 45, stock: 12, lowStockThreshold: 5, category: 'Apparel', sizes: ['S', 'M', 'L', 'XL'], image: 'https://picsum.photos/seed/jersey/400/300'),
          Product(id: '2', name: 'Academy Training Kit', price: 1800, cost: 900, sales: 30, stock: 8, lowStockThreshold: 5, category: 'Apparel', sizes: ['S', 'M', 'L'], image: 'https://picsum.photos/seed/training/400/300'),
          Product(id: '3', name: 'Sports Water Bottle', price: 500, cost: 200, sales: 60, stock: 20, lowStockThreshold: 5, category: 'Accessories', sizes: [], image: 'https://picsum.photos/seed/bottle/400/300'),
          Product(id: '4', name: 'Official Team Scarf', price: 800, cost: 350, sales: 25, stock: 15, lowStockThreshold: 5, category: 'Accessories', sizes: [], image: 'https://picsum.photos/seed/scarf/400/300'),
        ];
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());

    final totalRevenue = _products.fold(0.0, (sum, p) => sum + (p.price * p.sales));
    final bestSelling = _products.isNotEmpty ? _products.reduce((a, b) => a.sales > b.sales ? a : b) : null;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 16,
              runSpacing: 16,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Merchandise Store', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    Text('Browse and purchase official academy gear.', style: TextStyle(color: Colors.grey)),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.settings_outlined),
                  label: const Text('Manage Store'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(150, 40),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            GridView.count(
              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 1,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.5,
              children: [
                KpiCard(title: 'Total Revenue', value: 'KES ${_formatNum(totalRevenue)}', icon: Icons.attach_money, description: 'All-time sales'),
                KpiCard(title: 'Best Seller', value: bestSelling?.name ?? 'N/A', icon: Icons.trending_up, description: '${bestSelling?.sales ?? 0} units sold'),
                KpiCard(title: 'Low Stock', value: _products.where((p) => p.stock < p.lowStockThreshold).length.toString(), icon: Icons.inventory_2_outlined, description: 'Items to restock'),
              ],
            ),
            const SizedBox(height: 32),
            MerchandiseStore(products: _products),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  String _formatNum(double num) => num.toInt().toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (Match m) => "${m[1]},");
}
