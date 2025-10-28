import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/dapur_controller.dart';

/// Widget shown when no dapur is selected
class EmptyDapurKaryawan extends StatelessWidget {
  final String? errorMessage;

  const EmptyDapurKaryawan({super.key, this.errorMessage});

  @override
  Widget build(BuildContext context) {
    final dapurController = Get.find<DapurController>();

    return RefreshIndicator(
      onRefresh: () => dapurController.loadAssignedDapur(forceRefresh: true),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 40),
          Icon(Icons.info_outline, size: 72, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Tidak ada dapur yang aktif untuk akun ini.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          if (errorMessage != null) ...[
            const SizedBox(height: 8),
            Text(
              errorMessage!,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.redAccent),
            ),
          ],
          const SizedBox(height: 12),
          Text(
            'Tarik untuk menyegarkan atau hubungi administrator untuk mendapatkan akses dapur.',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
