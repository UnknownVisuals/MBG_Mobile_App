import 'package:flutter/material.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

import 'package:mbg_mobile_app/features/sekolah/models/sekolah_delivery_model.dart';
import 'package:mbg_mobile_app/features/sekolah/screens/sekolah_delivery/widgets/sekolah_delivery_card.dart';

class SekolahDeliveryList extends StatelessWidget {
  const SekolahDeliveryList({
    super.key,
    required this.deliveries,
    required this.onRefresh,
  });

  final List<SekolahDeliveryModel> deliveries;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: MBGSizes.lg),
        itemCount: deliveries.length,
        itemBuilder: (context, index) =>
            SekolahDeliveryCard(delivery: deliveries[index]),
        separatorBuilder: (context, index) =>
            const SizedBox(height: MBGSizes.spaceBtwItems),
      ),
    );
  }
}
