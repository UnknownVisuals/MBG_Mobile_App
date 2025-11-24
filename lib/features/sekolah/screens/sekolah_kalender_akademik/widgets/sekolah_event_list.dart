import 'package:flutter/material.dart';

import 'package:mbg_mobile_app/features/sekolah/models/sekolah_kalender_akademik_model.dart';
import 'package:mbg_mobile_app/features/sekolah/screens/sekolah_kalender_akademik/widgets/sekolah_event_card.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class SekolahEventList extends StatelessWidget {
  const SekolahEventList({super.key, required this.events});

  final List<SekolahKalenderAkademikModel> events;

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return Center(
        child: Text(
          'Belum ada event kalender',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: MBGColors.textSecondary),
        ),
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: MBGSizes.spaceBtwItems),
      itemCount: events.length,
      separatorBuilder: (_, __) =>
          const SizedBox(height: MBGSizes.spaceBtwItems),
      itemBuilder: (context, index) {
        final event = events[index];
        return SekolahEventCard(event: event);
      },
    );
  }
}
