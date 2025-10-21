import 'package:flutter/material.dart';
import '../../../controllers/pengiriman_controller.dart';
import '../../../models/pengiriman_model.dart';
import 'empty_pengiriman_widget.dart';
import 'pengiriman_card_widget.dart';

/// List widget displaying pengiriman items
class PengirimanListWidget extends StatelessWidget {
  final PengirimanController controller;
  final List<PengirimanModel> pengirimanList;
  final Function(PengirimanModel) onTapDetails;
  final Function(PengirimanModel) onShowQR;
  final Function(PengirimanModel)? onDelete;

  const PengirimanListWidget({
    super.key,
    required this.controller,
    required this.pengirimanList,
    required this.onTapDetails,
    required this.onShowQR,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (pengirimanList.isEmpty) {
      return const EmptyPengirimanWidget();
    }

    return RefreshIndicator(
      onRefresh: controller.refreshData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: pengirimanList.length,
        itemBuilder: (context, index) {
          final pengiriman = pengirimanList[index];
          return PengirimanCardWidget(
            controller: controller,
            pengiriman: pengiriman,
            onTapDetails: () => onTapDetails(pengiriman),
            onShowQR: () => onShowQR(pengiriman),
            onDelete: onDelete != null ? () => onDelete!(pengiriman) : null,
          );
        },
      ),
    );
  }
}
