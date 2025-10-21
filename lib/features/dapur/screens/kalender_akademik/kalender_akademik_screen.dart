import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../../../common/widgets/appbar.dart';
import '../../controllers/kalender_akademik_controller.dart';
import '../../models/kalender_akademik_model.dart';
import 'widgets/calendar_legend_item_widget.dart';
import 'widgets/calendar_event_card_widget.dart';
import 'widgets/event_detail_row_widget.dart';

class KalenderAkademikScreen extends StatelessWidget {
  const KalenderAkademikScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(KalenderAkademikController());

    return Scaffold(
      appBar: const MBGAppBar(
        title: Text('Kalender Akademik'),
        showBackArrow: false,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  // Calendar Widget
                  Card(
                    margin: const EdgeInsets.all(16),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Obx(
                        () => TableCalendar(
                          firstDay: DateTime(2020),
                          lastDay: DateTime(2030),
                          focusedDay: controller.focusedDate.value,
                          selectedDayPredicate: (day) =>
                              isSameDay(controller.selectedDate.value, day),
                          onDaySelected: (selectedDay, focusedDay) {
                            controller.selectedDate.value = selectedDay;
                            controller.focusedDate.value = focusedDay;
                          },
                          calendarFormat: CalendarFormat.month,
                          eventLoader: (day) =>
                              controller.getEventsForDate(day),
                          calendarStyle: CalendarStyle(
                            todayDecoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            selectedDecoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            markerDecoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                          headerStyle: HeaderStyle(
                            formatButtonVisible: false,
                            titleCentered: true,
                            titleTextFormatter: (date, locale) {
                              return DateFormat.yMMMM(locale).format(date);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Legend
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CalendarLegendItemWidget(
                          icon: Icons.beach_access,
                          label: 'Libur',
                          color: Colors.red,
                        ),
                        CalendarLegendItemWidget(
                          icon: Icons.event,
                          label: 'Kegiatan',
                          color: Colors.blue,
                        ),
                        CalendarLegendItemWidget(
                          icon: Icons.priority_high,
                          label: 'Penting',
                          color: Colors.orange,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Events list for selected date
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        const Icon(Iconsax.calendar_1, size: 20),
                        const SizedBox(width: 8),
                        Obx(
                          () => Text(
                            'Event pada ${DateFormat('dd MMMM yyyy').format(controller.selectedDate.value)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 24),
                  Expanded(
                    child: Obx(() {
                      final events = controller.getEventsForDate(
                        controller.selectedDate.value,
                      );
                      if (events.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Iconsax.calendar_remove,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Tidak ada event',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          final event = events[index];
                          return CalendarEventCardWidget(
                            event: event,
                            controller: controller,
                            onTap: () => _showEventDetailsDialog(
                              context,
                              controller,
                              event,
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateEventDialog(context, controller),
        icon: const Icon(Iconsax.add),
        label: const Text('Tambah Event'),
      ),
    );
  }

  void _showEventDetailsDialog(
    BuildContext context,
    KalenderAkademikController controller,
    KalenderAkademikModel event,
  ) {
    final color = controller.getEventColor(event.jenis);
    final icon = controller.getEventIcon(event.jenis);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: color, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      event.nama,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const Divider(height: 24),
              EventDetailRowWidget(
                icon: Icons.calendar_today,
                label: 'Tanggal',
                value: DateFormat('dd MMMM yyyy').format(event.tanggal),
              ),
              EventDetailRowWidget(
                icon: Icons.category,
                label: 'Jenis',
                value: controller.getEventLabel(event.jenis),
              ),
              if (event.deskripsi.isNotEmpty)
                EventDetailRowWidget(
                  icon: Icons.description,
                  label: 'Deskripsi',
                  value: event.deskripsi,
                ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _showEditEventDialog(context, controller, event);
                      },
                      icon: const Icon(Iconsax.edit),
                      label: const Text('Edit'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _confirmDeleteEvent(context, controller, event);
                      },
                      icon: const Icon(Iconsax.trash),
                      label: const Text('Hapus'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCreateEventDialog(
    BuildContext context,
    KalenderAkademikController controller,
  ) {
    _showEventFormDialog(context, controller, null);
  }

  void _showEditEventDialog(
    BuildContext context,
    KalenderAkademikController controller,
    KalenderAkademikModel event,
  ) {
    _showEventFormDialog(context, controller, event);
  }

  void _showEventFormDialog(
    BuildContext context,
    KalenderAkademikController controller,
    KalenderAkademikModel? event,
  ) {
    final formKey = GlobalKey<FormState>();
    final namaController = TextEditingController(text: event?.nama ?? '');
    final deskripsiController = TextEditingController(
      text: event?.deskripsi ?? '',
    );
    DateTime selectedDate = event?.tanggal ?? controller.selectedDate.value;
    String selectedJenis = event?.jenis ?? 'KEGIATAN';

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(event == null ? 'Tambah Event' : 'Edit Event'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: namaController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Event',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Iconsax.edit),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama event harus diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: deskripsiController,
                    decoration: const InputDecoration(
                      labelText: 'Deskripsi',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Iconsax.document_text),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null) {
                        setState(() {
                          selectedDate = picked;
                        });
                      }
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Tanggal',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Iconsax.calendar_1),
                      ),
                      child: Text(
                        DateFormat('dd MMMM yyyy').format(selectedDate),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: selectedJenis,
                    decoration: const InputDecoration(
                      labelText: 'Jenis Event',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Iconsax.category),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'LIBUR', child: Text('Libur')),
                      DropdownMenuItem(
                        value: 'KEGIATAN',
                        child: Text('Kegiatan'),
                      ),
                      DropdownMenuItem(
                        value: 'PENTING',
                        child: Text('Penting'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedJenis = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(dialogContext);
                  if (event == null) {
                    await controller.createKalender(
                      nama: namaController.text,
                      deskripsi: deskripsiController.text,
                      tanggal: selectedDate,
                      jenis: selectedJenis,
                    );
                  } else {
                    await controller.updateKalender(
                      id: event.id,
                      nama: namaController.text,
                      deskripsi: deskripsiController.text,
                      tanggal: selectedDate,
                      jenis: selectedJenis,
                    );
                  }
                }
              },
              child: Text(event == null ? 'Tambah' : 'Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteEvent(
    BuildContext context,
    KalenderAkademikController controller,
    KalenderAkademikModel event,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Event'),
        content: Text(
          'Apakah Anda yakin ingin menghapus event "${event.nama}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await controller.deleteKalender(event);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
