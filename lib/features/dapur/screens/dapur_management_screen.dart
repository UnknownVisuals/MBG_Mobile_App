import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_model.dart';
import 'package:mbg_mobile_app/utils/http/dapur_service.dart';

class DapurManagementScreen extends StatefulWidget {
  const DapurManagementScreen({super.key});

  @override
  State<DapurManagementScreen> createState() => _DapurManagementScreenState();
}

class _DapurManagementScreenState extends State<DapurManagementScreen> {
  final DapurService _dapurService = Get.find<DapurService>();
  List<DapurModel> _dapurList = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadDapur();
  }

  Future<void> _loadDapur() async {
    setState(() => _isLoading = true);
    try {
      final data = await _dapurService.getAllDapur();
      setState(() => _dapurList = data);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load dapur: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showCreateDialog() {
    final nameController = TextEditingController();
    final addressController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Create Dapur'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Dapur',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: 'Alamat',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isEmpty ||
                  addressController.text.isEmpty) {
                Get.snackbar('Error', 'Please fill all fields');
                return;
              }

              try {
                await _dapurService.createDapur({
                  'nama': nameController.text,
                  'alamat': addressController.text,
                });
                Get.back();
                Get.snackbar('Success', 'Dapur created successfully');
                _loadDapur();
              } catch (e) {
                Get.snackbar('Error', 'Failed to create dapur: $e');
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showUpdateStatusDialog(DapurModel dapur) {
    final newStatus = dapur.status == 'AKTIF' ? 'NONAKTIF' : 'AKTIF';

    Get.dialog(
      AlertDialog(
        title: const Text('Update Status'),
        content: Text('Change status to $newStatus?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              try {
                await _dapurService.updateDapur(dapur.id, {
                  'status': newStatus,
                });
                Get.back();
                Get.snackbar('Success', 'Status updated successfully');
                _loadDapur();
              } catch (e) {
                Get.snackbar('Error', 'Failed to update status: $e');
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dapur Management'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadDapur),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _dapurList.isEmpty
          ? const Center(child: Text('No dapur found'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _dapurList.length,
              itemBuilder: (context, index) {
                final dapur = _dapurList[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: dapur.status == 'AKTIF'
                          ? Colors.green
                          : Colors.grey,
                      child: const Icon(Icons.restaurant, color: Colors.white),
                    ),
                    title: Text(
                      dapur.nama,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(dapur.alamat),
                        const SizedBox(height: 4),
                        Chip(
                          label: Text(
                            dapur.status,
                            style: const TextStyle(fontSize: 12),
                          ),
                          backgroundColor: dapur.status == 'AKTIF'
                              ? Colors.green.shade100
                              : Colors.grey.shade300,
                        ),
                      ],
                    ),
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: const Icon(Icons.settings),
                      onPressed: () => _showUpdateStatusDialog(dapur),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
