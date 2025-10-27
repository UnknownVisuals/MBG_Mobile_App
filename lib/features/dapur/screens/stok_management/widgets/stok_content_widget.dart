import 'package:flutter/material.dart';
import '../../../models/stok_model.dart';

/// Stok content widget with category filters and list
class StokContentWidget extends StatelessWidget {
  final List<String> categories;
  final String? selectedCategory;
  final List<StokModel> filteredStokList;
  final bool isLoading;
  final Function(String) onCategorySelected;
  final VoidCallback onRefresh;
  final Function(StokModel) onEdit;
  final Function(String, String) onDelete;
  final Color Function(String) getCategoryColor;
  final IconData Function(String) getCategoryIcon;

  const StokContentWidget({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.filteredStokList,
    required this.isLoading,
    required this.onCategorySelected,
    required this.onRefresh,
    required this.onEdit,
    required this.onDelete,
    required this.getCategoryColor,
    required this.getCategoryIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected =
                  selectedCategory == category ||
                  (selectedCategory == null && category == 'Semua');
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (_) => onCategorySelected(category),
                ),
              );
            },
          ),
        ),
        Expanded(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : filteredStokList.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Belum ada stok',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tambahkan stok dengan tombol + di bawah',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async => onRefresh(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredStokList.length,
                    itemBuilder: (context, index) {
                      final stok = filteredStokList[index];
                      final categoryColor = getCategoryColor(stok.kategori);
                      final categoryIcon = getCategoryIcon(stok.kategori);
                      final isLowStock = stok.stokKg < 5;

                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: isLowStock
                              ? const BorderSide(color: Colors.red, width: 2)
                              : BorderSide.none,
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: CircleAvatar(
                            backgroundColor: categoryColor.withOpacity(0.2),
                            child: Icon(categoryIcon, color: categoryColor),
                          ),
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  stok.nama,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              if (isLowStock)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    'STOK RENDAH',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Text(
                                stok.kategori,
                                style: TextStyle(
                                  color: categoryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Stok: ${stok.stokKg} kg',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isLowStock
                                      ? Colors.red
                                      : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                color: Colors.blue,
                                onPressed: () => onEdit(stok),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                color: Colors.red,
                                onPressed: () => onDelete(stok.id, stok.nama),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }
}
