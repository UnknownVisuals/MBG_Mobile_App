/// Mock API Response Data for Testing
/// Use this file when backend API is not available
/// All data structures match the expected API responses

class ApiMockData {
  // ==================== Authentication ====================

  static Map<String, dynamic> mockLoginResponse = {
    "user": {
      "id": "user-id-123",
      "email": "pic.dapur@mbg.com",
      "name": "PIC Dapur 1",
      "phone": "081234567890",
      "role": "PIC_DAPUR",
      "nomorKendaraan": null,
      "dapurAsPIC": ["dapur-id-456"],
      "sekolahAsPIC": [],
      "createdAt": "2025-10-20T10:00:00.000Z",
      "updatedAt": "2025-10-20T10:00:00.000Z",
    },
    "token": "mock-jwt-token-eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9",
  };

  // ==================== Karyawan (Employees) ====================

  static List<Map<String, dynamic>> mockKaryawanList = [
    {
      "id": "karyawan-1",
      "nama": "Chef Ahmad Santoso",
      "posisi": "Head Chef",
      "foto": "https://i.pravatar.cc/150?img=1",
      "dapurId": "dapur-id-456",
      "createdAt": "2025-10-15T08:00:00.000Z",
      "updatedAt": "2025-10-15T08:00:00.000Z",
    },
    {
      "id": "karyawan-2",
      "nama": "Siti Nurhaliza",
      "posisi": "Assistant Chef",
      "foto": "https://i.pravatar.cc/150?img=5",
      "dapurId": "dapur-id-456",
      "createdAt": "2025-10-16T09:00:00.000Z",
      "updatedAt": "2025-10-16T09:00:00.000Z",
    },
    {
      "id": "karyawan-3",
      "nama": "Budi Prasetyo",
      "posisi": "Kitchen Helper",
      "foto": null,
      "dapurId": "dapur-id-456",
      "createdAt": "2025-10-17T10:00:00.000Z",
      "updatedAt": "2025-10-17T10:00:00.000Z",
    },
    {
      "id": "karyawan-4",
      "nama": "Dewi Kartika",
      "posisi": "Sous Chef",
      "foto": "https://i.pravatar.cc/150?img=9",
      "dapurId": "dapur-id-456",
      "createdAt": "2025-10-18T11:00:00.000Z",
      "updatedAt": "2025-10-18T11:00:00.000Z",
    },
  ];

  static Map<String, dynamic> mockKaryawanCreateResponse = {
    "id": "karyawan-new-${DateTime.now().millisecondsSinceEpoch}",
    "nama": "New Employee",
    "posisi": "Cook",
    "foto": "https://i.pravatar.cc/150?img=12",
    "dapurId": "dapur-id-456",
    "createdAt": DateTime.now().toIso8601String(),
    "updatedAt": DateTime.now().toIso8601String(),
  };

  // ==================== Stok (Inventory) ====================

  static List<Map<String, dynamic>> mockStokList = [
    {
      "id": "stok-1",
      "nama": "Beras Organik",
      "kategori": "KARBOHIDRAT",
      "stokKg": 150.5,
      "dapurId": "dapur-id-456",
      "createdAt": "2025-10-15T08:00:00.000Z",
      "updatedAt": "2025-10-20T14:30:00.000Z",
    },
    {
      "id": "stok-2",
      "nama": "Ayam Fillet",
      "kategori": "PROTEIN",
      "stokKg": 45.0,
      "dapurId": "dapur-id-456",
      "createdAt": "2025-10-16T08:00:00.000Z",
      "updatedAt": "2025-10-20T14:30:00.000Z",
    },
    {
      "id": "stok-3",
      "nama": "Bayam Segar",
      "kategori": "SAYURAN",
      "stokKg": 3.5,
      "dapurId": "dapur-id-456",
      "createdAt": "2025-10-17T08:00:00.000Z",
      "updatedAt": "2025-10-20T14:30:00.000Z",
    },
    {
      "id": "stok-4",
      "nama": "Wortel",
      "kategori": "SAYURAN",
      "stokKg": 25.0,
      "dapurId": "dapur-id-456",
      "createdAt": "2025-10-17T08:00:00.000Z",
      "updatedAt": "2025-10-20T14:30:00.000Z",
    },
    {
      "id": "stok-5",
      "nama": "Pisang Cavendish",
      "kategori": "BUAH",
      "stokKg": 12.5,
      "dapurId": "dapur-id-456",
      "createdAt": "2025-10-18T08:00:00.000Z",
      "updatedAt": "2025-10-20T14:30:00.000Z",
    },
    {
      "id": "stok-6",
      "nama": "Apel Fuji",
      "kategori": "BUAH",
      "stokKg": 8.0,
      "dapurId": "dapur-id-456",
      "createdAt": "2025-10-18T08:00:00.000Z",
      "updatedAt": "2025-10-20T14:30:00.000Z",
    },
    {
      "id": "stok-7",
      "nama": "Telur Ayam",
      "kategori": "PROTEIN",
      "stokKg": 20.0,
      "dapurId": "dapur-id-456",
      "createdAt": "2025-10-19T08:00:00.000Z",
      "updatedAt": "2025-10-20T14:30:00.000Z",
    },
    {
      "id": "stok-8",
      "nama": "Minyak Goreng",
      "kategori": "LAINNYA",
      "stokKg": 35.0,
      "dapurId": "dapur-id-456",
      "createdAt": "2025-10-19T08:00:00.000Z",
      "updatedAt": "2025-10-20T14:30:00.000Z",
    },
    {
      "id": "stok-9",
      "nama": "Garam",
      "kategori": "LAINNYA",
      "stokKg": 2.0,
      "dapurId": "dapur-id-456",
      "createdAt": "2025-10-20T08:00:00.000Z",
      "updatedAt": "2025-10-20T14:30:00.000Z",
    },
  ];

  // ==================== Pengiriman (Delivery) ====================

  static List<Map<String, dynamic>> mockPengirimanList = [
    {
      "id": "pengiriman-1",
      "qrCodeId": "QR-MBG-2025-001",
      "status": "DITERIMA",
      "waktuDiambil": "2025-10-20T08:30:00.000Z",
      "waktuDiterima": "2025-10-20T09:15:00.000Z",
      "jumlahTray": 15,
      "jumlahKeranjang": 3,
      "sekolahId": "sekolah-1",
      "sekolah": {
        "id": "sekolah-1",
        "nama": "SD Negeri 1 Bandung",
        "alamat": "Jl. Pendidikan No. 1, Bandung",
      },
      "dapurId": "dapur-id-456",
      "driverId": "driver-1",
      "driver": {"id": "driver-1", "name": "Agus Supratman"},
      "createdAt": "2025-10-20T07:00:00.000Z",
      "updatedAt": "2025-10-20T09:15:00.000Z",
    },
    {
      "id": "pengiriman-2",
      "qrCodeId": "QR-MBG-2025-002",
      "status": "DIAMBIL",
      "waktuDiambil": "2025-10-21T08:00:00.000Z",
      "waktuDiterima": null,
      "jumlahTray": 20,
      "jumlahKeranjang": 4,
      "sekolahId": "sekolah-2",
      "sekolah": {
        "id": "sekolah-2",
        "nama": "SD Negeri 5 Bandung",
        "alamat": "Jl. Merdeka No. 5, Bandung",
      },
      "dapurId": "dapur-id-456",
      "driverId": "driver-1",
      "driver": {"id": "driver-1", "name": "Agus Supratman"},
      "createdAt": "2025-10-21T07:00:00.000Z",
      "updatedAt": "2025-10-21T08:00:00.000Z",
    },
    {
      "id": "pengiriman-3",
      "qrCodeId": "QR-MBG-2025-003",
      "status": "PENDING",
      "waktuDiambil": null,
      "waktuDiterima": null,
      "jumlahTray": 12,
      "jumlahKeranjang": 2,
      "sekolahId": "sekolah-3",
      "sekolah": {
        "id": "sekolah-3",
        "nama": "SD Muhammadiyah 3",
        "alamat": "Jl. Ahmad Yani No. 15, Bandung",
      },
      "dapurId": "dapur-id-456",
      "driverId": null,
      "driver": null,
      "createdAt": "2025-10-21T07:30:00.000Z",
      "updatedAt": "2025-10-21T07:30:00.000Z",
    },
  ];

  // ==================== Sekolah (Schools) ====================

  static List<Map<String, dynamic>> mockSekolahList = [
    {
      "id": "sekolah-1",
      "nama": "SD Negeri 1 Bandung",
      "alamat": "Jl. Pendidikan No. 1, Bandung",
      "dapurId": "dapur-id-456",
      "createdAt": "2025-01-15T08:00:00.000Z",
      "updatedAt": "2025-01-15T08:00:00.000Z",
    },
    {
      "id": "sekolah-2",
      "nama": "SD Negeri 5 Bandung",
      "alamat": "Jl. Merdeka No. 5, Bandung",
      "dapurId": "dapur-id-456",
      "createdAt": "2025-01-16T08:00:00.000Z",
      "updatedAt": "2025-01-16T08:00:00.000Z",
    },
    {
      "id": "sekolah-3",
      "nama": "SD Muhammadiyah 3",
      "alamat": "Jl. Ahmad Yani No. 15, Bandung",
      "dapurId": "dapur-id-456",
      "createdAt": "2025-01-17T08:00:00.000Z",
      "updatedAt": "2025-01-17T08:00:00.000Z",
    },
  ];

  // ==================== Kelas (Classes) ====================

  static List<Map<String, dynamic>> mockKelasList = [
    {
      "id": "kelas-1",
      "nama": "Kelas 1A",
      "tingkat": 1,
      "sekolahId": "sekolah-1",
      "createdAt": "2025-09-01T08:00:00.000Z",
      "updatedAt": "2025-09-01T08:00:00.000Z",
    },
    {
      "id": "kelas-2",
      "nama": "Kelas 1B",
      "tingkat": 1,
      "sekolahId": "sekolah-1",
      "createdAt": "2025-09-01T08:00:00.000Z",
      "updatedAt": "2025-09-01T08:00:00.000Z",
    },
    {
      "id": "kelas-3",
      "nama": "Kelas 2A",
      "tingkat": 2,
      "sekolahId": "sekolah-1",
      "createdAt": "2025-09-01T08:00:00.000Z",
      "updatedAt": "2025-09-01T08:00:00.000Z",
    },
    {
      "id": "kelas-4",
      "nama": "Kelas 3A",
      "tingkat": 3,
      "sekolahId": "sekolah-1",
      "createdAt": "2025-09-01T08:00:00.000Z",
      "updatedAt": "2025-09-01T08:00:00.000Z",
    },
    {
      "id": "kelas-5",
      "nama": "Kelas 4A",
      "tingkat": 4,
      "sekolahId": "sekolah-1",
      "createdAt": "2025-09-01T08:00:00.000Z",
      "updatedAt": "2025-09-01T08:00:00.000Z",
    },
    {
      "id": "kelas-6",
      "nama": "Kelas 5A",
      "tingkat": 5,
      "sekolahId": "sekolah-1",
      "createdAt": "2025-09-01T08:00:00.000Z",
      "updatedAt": "2025-09-01T08:00:00.000Z",
    },
    {
      "id": "kelas-7",
      "nama": "Kelas 6A",
      "tingkat": 6,
      "sekolahId": "sekolah-1",
      "createdAt": "2025-09-01T08:00:00.000Z",
      "updatedAt": "2025-09-01T08:00:00.000Z",
    },
  ];

  // ==================== Siswa (Students) ====================

  static List<Map<String, dynamic>> mockSiswaList = [
    {
      "id": "siswa-1",
      "nama": "Ahmad Fauzi",
      "nis": "20250001",
      "jenisKelamin": "LAKI_LAKI",
      "umur": 7,
      "tinggiBadan": 120.0,
      "beratBadan": 22.0,
      "imt": 15.28,
      "statusGizi": "GIZI_BAIK",
      "foto": "https://i.pravatar.cc/150?img=11",
      "kelasId": "kelas-1",
      "kelas": {"id": "kelas-1", "nama": "Kelas 1A"},
      "sekolahId": "sekolah-1",
      "createdAt": "2025-09-15T08:00:00.000Z",
      "updatedAt": "2025-09-15T08:00:00.000Z",
    },
    {
      "id": "siswa-2",
      "nama": "Siti Aisyah",
      "nis": "20250002",
      "jenisKelamin": "PEREMPUAN",
      "umur": 7,
      "tinggiBadan": 118.0,
      "beratBadan": 20.0,
      "imt": 14.36,
      "statusGizi": "GIZI_KURANG",
      "foto": "https://i.pravatar.cc/150?img=20",
      "kelasId": "kelas-1",
      "kelas": {"id": "kelas-1", "nama": "Kelas 1A"},
      "sekolahId": "sekolah-1",
      "createdAt": "2025-09-15T08:00:00.000Z",
      "updatedAt": "2025-09-15T08:00:00.000Z",
    },
    {
      "id": "siswa-3",
      "nama": "Budi Santoso",
      "nis": "20250003",
      "jenisKelamin": "LAKI_LAKI",
      "umur": 8,
      "tinggiBadan": 130.0,
      "beratBadan": 35.0,
      "imt": 20.71,
      "statusGizi": "OBESITAS",
      "foto": null,
      "kelasId": "kelas-3",
      "kelas": {"id": "kelas-3", "nama": "Kelas 2A"},
      "sekolahId": "sekolah-1",
      "createdAt": "2025-09-15T08:00:00.000Z",
      "updatedAt": "2025-09-15T08:00:00.000Z",
    },
  ];

  // ==================== Menu Planning ====================

  static List<Map<String, dynamic>> mockMenuPlanningList = [
    {
      "id": "planning-1",
      "mingguanKe": 1,
      "tanggalMulai": "2025-10-20T00:00:00.000Z",
      "tanggalSelesai": "2025-10-26T00:00:00.000Z",
      "sekolahId": "sekolah-1",
      "dapurId": "dapur-id-456",
      "createdAt": "2025-10-15T08:00:00.000Z",
      "updatedAt": "2025-10-15T08:00:00.000Z",
    },
  ];

  static List<Map<String, dynamic>> mockMenuHarianList = [
    {
      "id": "menu-1",
      "tanggal": "2025-10-21T00:00:00.000Z",
      "namaMenu": "Nasi Goreng Sayuran",
      "biayaPerTray": 12000.0,
      "jamMulaiMasak": "06:00",
      "jamSelesaiMasak": "08:00",
      "kalori": 550.5,
      "protein": 25.5,
      "karbohidrat": 75.0,
      "lemak": 15.0,
      "menuPlanningId": "planning-1",
      "createdAt": "2025-10-15T08:00:00.000Z",
      "updatedAt": "2025-10-15T08:00:00.000Z",
    },
    {
      "id": "menu-2",
      "tanggal": "2025-10-22T00:00:00.000Z",
      "namaMenu": "Ayam Bakar + Nasi + Sayur",
      "biayaPerTray": 15000.0,
      "jamMulaiMasak": "06:00",
      "jamSelesaiMasak": "08:30",
      "kalori": 650.0,
      "protein": 35.0,
      "karbohidrat": 80.0,
      "lemak": 20.0,
      "menuPlanningId": "planning-1",
      "createdAt": "2025-10-15T08:00:00.000Z",
      "updatedAt": "2025-10-15T08:00:00.000Z",
    },
  ];

  // ==================== Checkpoint ====================

  static List<Map<String, dynamic>> mockCheckpointList = [
    {
      "id": "checkpoint-1",
      "tipe": "MULAI_MEMASAK",
      "waktu": "2025-10-21T06:00:00.000Z",
      "foto": "https://picsum.photos/400/300?random=1",
      "menuHarianId": "menu-1",
      "createdAt": "2025-10-21T06:00:00.000Z",
      "updatedAt": "2025-10-21T06:00:00.000Z",
    },
    {
      "id": "checkpoint-2",
      "tipe": "SELESAI_MEMASAK",
      "waktu": "2025-10-21T08:00:00.000Z",
      "foto": "https://picsum.photos/400/300?random=2",
      "menuHarianId": "menu-1",
      "createdAt": "2025-10-21T08:00:00.000Z",
      "updatedAt": "2025-10-21T08:00:00.000Z",
    },
  ];

  // ==================== Absensi (Attendance) ====================

  static List<Map<String, dynamic>> mockAbsensiList = [
    {
      "id": "absensi-1",
      "tanggal": "2025-10-21T00:00:00.000Z",
      "jumlahHadir": 28,
      "kelasId": "kelas-1",
      "createdAt": "2025-10-21T08:00:00.000Z",
      "updatedAt": "2025-10-21T08:00:00.000Z",
    },
    {
      "id": "absensi-2",
      "tanggal": "2025-10-21T00:00:00.000Z",
      "jumlahHadir": 25,
      "kelasId": "kelas-2",
      "createdAt": "2025-10-21T08:00:00.000Z",
      "updatedAt": "2025-10-21T08:00:00.000Z",
    },
  ];

  static Map<String, dynamic> mockAbsensiTotal = {
    "totalHadir": 250,
    "tanggal": "2025-10-21",
    "details": [
      {"kelasId": "kelas-1", "kelasNama": "Kelas 1A", "jumlahHadir": 28},
      {"kelasId": "kelas-2", "kelasNama": "Kelas 1B", "jumlahHadir": 25},
      {"kelasId": "kelas-3", "kelasNama": "Kelas 2A", "jumlahHadir": 30},
      {"kelasId": "kelas-4", "kelasNama": "Kelas 3A", "jumlahHadir": 27},
      {"kelasId": "kelas-5", "kelasNama": "Kelas 4A", "jumlahHadir": 32},
      {"kelasId": "kelas-6", "kelasNama": "Kelas 5A", "jumlahHadir": 29},
      {"kelasId": "kelas-7", "kelasNama": "Kelas 6A", "jumlahHadir": 79},
    ],
  };

  // ==================== Helper Methods ====================

  /// Simulate network delay
  static Future<void> simulateNetworkDelay() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  /// Get mock response for an endpoint
  static Future<Map<String, dynamic>> getMockResponse(String endpoint) async {
    await simulateNetworkDelay();

    if (endpoint.contains('/auth/login')) {
      return mockLoginResponse;
    }

    throw Exception('Mock endpoint not found: $endpoint');
  }

  /// Get mock list response
  static Future<List<Map<String, dynamic>>> getMockListResponse(
    String endpoint,
  ) async {
    await simulateNetworkDelay();

    if (endpoint.contains('/karyawan')) {
      return mockKaryawanList;
    } else if (endpoint.contains('/stok')) {
      return mockStokList;
    } else if (endpoint.contains('/pengiriman')) {
      return mockPengirimanList;
    } else if (endpoint.contains('/kelas')) {
      return mockKelasList;
    } else if (endpoint.contains('/siswa')) {
      return mockSiswaList;
    } else if (endpoint.contains('/menu-planning')) {
      return mockMenuPlanningList;
    } else if (endpoint.contains('/menu-harian')) {
      return mockMenuHarianList;
    } else if (endpoint.contains('/checkpoint')) {
      return mockCheckpointList;
    } else if (endpoint.contains('/absensi')) {
      return mockAbsensiList;
    } else if (endpoint.contains('/sekolah')) {
      return mockSekolahList;
    }

    throw Exception('Mock endpoint not found: $endpoint');
  }
}
