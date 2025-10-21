import 'package:flutter/material.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class MBGInfoRow extends StatelessWidget {
  const MBGInfoRow({super.key, required this.title, required this.value});

  final String title, value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: MBGSizes.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge,
              // overflow: TextOverflow.ellipsis,
              // maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}
