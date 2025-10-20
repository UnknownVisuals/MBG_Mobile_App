import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbg_mobile_app/common/widgets/appbar.dart';
import 'package:mbg_mobile_app/features/authentication/controllers/user_controller.dart';
import 'package:mbg_mobile_app/features/dapur/screens/widgets/progress_summary_card.dart';
import 'package:mbg_mobile_app/features/dapur/screens/widgets/timeline_event_card.dart';
import 'package:mbg_mobile_app/features/dapur/screens/widgets/timeline_indicator.dart';
import 'package:mbg_mobile_app/features/dapur/screens/widgets/timeline_section_header.dart';
import 'package:mbg_mobile_app/features/dapur/screens/widgets/timeline_utils.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:timelines_plus/timelines_plus.dart';

class DapurScreen extends StatelessWidget {
  const DapurScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(UserController());
    final events = TimelineUtils.getSampleEvents();
    final completedCount = events.where((e) => e.isCompleted).length;
    final totalCount = events.length;

    return Scaffold(
      backgroundColor: MBGColors.softGrey,
      appBar: MBGAppBar(
        showDrawerIcon: true,
        title: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Selamat Datang Kembali,",
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(color: MBGColors.darkGrey),
              ),
              Text(
                "Halo, ${userController.user.value?.name ?? ''}!",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: SidebarX(
          controller: SidebarXController(selectedIndex: 0, extended: true),
          headerBuilder: (context, extended) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(MBGSizes.lg),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    MBGColors.primary,
                    MBGColors.primary.withValues(alpha: 0.8),
                  ],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: MBGColors.primary.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, MBGSizes.xs),
                  ),
                ],
              ),
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: MBGColors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: MBGColors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: MBGColors.black.withValues(alpha: 0.15),
                            blurRadius: 10,
                            offset: const Offset(0, MBGSizes.xs),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          userController.user.value != null &&
                                  userController.user.value!.name.isNotEmpty
                              ? userController.user.value!.name
                                    .substring(0, 1)
                                    .toUpperCase()
                              : 'U',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                color: MBGColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                    const SizedBox(height: MBGSizes.md),
                    // Name
                    Text(
                      userController.user.value?.name ?? 'User',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: MBGColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: MBGSizes.xs),
                    // Email
                    Text(
                      userController.user.value?.email ?? '',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: MBGColors.white.withValues(alpha: 0.9),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: MBGSizes.sm),
                    // Role Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: MBGSizes.sm,
                        vertical: MBGSizes.xs,
                      ),
                      decoration: BoxDecoration(
                        color: MBGColors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(
                          MBGSizes.borderRadiusSm,
                        ),
                        border: Border.all(
                          color: MBGColors.white.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        userController.user.value != null &&
                                userController.user.value!.role.isNotEmpty
                            ? userController.user.value!.role.toUpperCase()
                            : 'USER',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: MBGColors.white,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          // Main menu items
          items: [
            SidebarXItem(icon: Icons.home_rounded, label: 'Home'),
            SidebarXItem(icon: Icons.kitchen_rounded, label: 'Dapur'),
            SidebarXItem(icon: Icons.school_rounded, label: 'Sekolah'),
            SidebarXItem(icon: Icons.local_shipping_rounded, label: 'Driver'),
            SidebarXItem(icon: Icons.person_rounded, label: 'Profile'),
            SidebarXItem(icon: Icons.settings_rounded, label: 'Settings'),
          ],
          // Footer items for logout
          footerItems: [
            SidebarXItem(
              icon: Icons.logout_rounded,
              label: 'Logout',
              onTap: () {},
            ),
          ],
          // Divider between footer and main content
          footerDivider: Divider(
            color: MBGColors.borderPrimary.withValues(alpha: 0.5),
            thickness: MBGSizes.dividerHeight,
            height: MBGSizes.dividerHeight,
          ),
          theme: SidebarXTheme(
            decoration: const BoxDecoration(color: MBGColors.white),
            padding: const EdgeInsets.symmetric(
              horizontal: MBGSizes.md,
              vertical: MBGSizes.sm,
            ),
            margin: const EdgeInsets.symmetric(
              vertical: MBGSizes.xs,
              horizontal: MBGSizes.sm,
            ),
            textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: MBGColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
            selectedTextStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: MBGColors.primary,
              fontWeight: FontWeight.bold,
            ),
            itemTextPadding: const EdgeInsets.only(left: MBGSizes.md),
            selectedItemTextPadding: const EdgeInsets.only(left: MBGSizes.md),
            itemDecoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(MBGSizes.cardRadiusMd),
            ),
            selectedItemDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(MBGSizes.cardRadiusMd),
              gradient: LinearGradient(
                colors: [
                  MBGColors.white,
                  MBGColors.primary.withValues(alpha: 0.08),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: MBGColors.primary.withValues(alpha: 0.4),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: MBGColors.primary.withValues(alpha: 0.15),
                  blurRadius: 8,
                  offset: const Offset(0, MBGSizes.xs),
                ),
              ],
            ),
            iconTheme: const IconThemeData(
              color: MBGColors.darkGrey,
              size: MBGSizes.iconMd,
            ),
            selectedIconTheme: const IconThemeData(color: MBGColors.primary),
          ),
          // Extended theme for footer items (logout styling)
          extendedTheme: SidebarXTheme(
            decoration: const BoxDecoration(color: MBGColors.lightGrey),
            textStyle: Theme.of(context).textTheme.bodyLarge,
            selectedTextStyle: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: MBGColors.primary),

            selectedIconTheme: const IconThemeData(color: MBGColors.primary),
          ),
        ),
      ),
      body: Column(
        children: [
          // Progress Summary Card
          ProgressSummaryCard(
            completedCount: completedCount,
            totalCount: totalCount,
          ),

          // Timeline Section Header
          const TimelineSectionHeader(),
          const SizedBox(height: MBGSizes.md),

          // Timeline
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: MBGSizes.md),
              child: Timeline.tileBuilder(
                theme: TimelineThemeData(
                  nodePosition: 0,
                  connectorTheme: const ConnectorThemeData(thickness: 3.0),
                ),
                builder: TimelineTileBuilder.connected(
                  itemCount: events.length,
                  contentsBuilder: (context, index) {
                    final event = events[index];
                    return Padding(
                      padding: const EdgeInsets.only(
                        left: MBGSizes.md,
                        bottom: MBGSizes.lg - 4,
                      ),
                      child: TimelineEventCard(event: event),
                    );
                  },
                  connectorBuilder: (context, index, connectorType) {
                    final event = events[index];
                    if (event.isCompleted && index < events.length - 1) {
                      final nextEvent = events[index + 1];
                      return nextEvent.isCompleted
                          ? SolidLineConnector(
                              color: TimelineUtils.getEventColor(
                                event.type,
                                true,
                              ),
                              thickness: 3,
                            )
                          : DashedLineConnector(
                              color: MBGColors.borderSecondary,
                              thickness: 3,
                            );
                    }
                    return DashedLineConnector(
                      color: MBGColors.borderSecondary,
                      thickness: 3,
                    );
                  },
                  indicatorBuilder: (context, index) {
                    final event = events[index];
                    return CustomTimelineIndicator(event: event);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
