# API Response Mapping Documentation

This document maps the MBG System API responses to the Flutter app models based on the Postman collection.

## Base URL

```
http://localhost:3000
```

## Authentication

All endpoints except login require Bearer token in Authorization header:

```
Authorization: Bearer <token>
```

---

## 1. Authentication & User Management

### POST /api/auth/login

**Request:**

```json
{
  "email": "superadmin@mbg.com",
  "password": "password123"
}
```

**Expected Response:**

```json
{
  "user": {
    "id": "user-id-123",
    "email": "superadmin@mbg.com",
    "name": "Super Admin",
    "phone": "081234567890",
    "role": "SUPERADMIN",
    "nomorKendaraan": null,
    "dapurAsPIC": [],
    "sekolahAsPIC": [],
    "createdAt": "2025-10-20T10:00:00.000Z",
    "updatedAt": "2025-10-20T10:00:00.000Z"
  },
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Flutter Model:** `UserModel` in `lib/features/authentication/models/user_model.dart`

**Mapping:**

- ✅ All fields match perfectly
- ✅ `dapurAsPIC` and `sekolahAsPIC` are arrays
- ✅ Role enum: SUPERADMIN, PIC_DAPUR, PIC_SEKOLAH, DRIVER

---

## 2. Karyawan Management (Employees)

### POST /api/karyawan

**Request (multipart/form-data):**

```
nama: "Nama Karyawan"
posisi: "Chef"
foto: <file>
```

**Expected Response:**

```json
{
  "id": "karyawan-id-123",
  "nama": "Nama Karyawan",
  "posisi": "Chef",
  "foto": "https://s3.amazonaws.com/bucket/karyawan-photo.jpg",
  "dapurId": "dapur-id-456",
  "createdAt": "2025-10-20T10:00:00.000Z",
  "updatedAt": "2025-10-20T10:00:00.000Z"
}
```

**Flutter Model:** `KaryawanModel` in `lib/features/dapur/models/karyawan_model.dart`

**Mapping:**

- ✅ All fields match perfectly
- ✅ `foto` is nullable URL string
- ✅ Uses multipart upload for image

### GET /api/karyawan or GET /api/dapur/:dapurId/karyawan

**Expected Response (Array):**

```json
[
  {
    "id": "karyawan-id-123",
    "nama": "Nama Karyawan",
    "posisi": "Chef",
    "foto": "https://s3.amazonaws.com/bucket/photo.jpg",
    "dapurId": "dapur-id-456",
    "createdAt": "2025-10-20T10:00:00.000Z",
    "updatedAt": "2025-10-20T10:00:00.000Z"
  }
]
```

---

## 3. Stok Management (Inventory)

### POST /api/stok

**Request:**

```json
{
  "nama": "Beras",
  "kategori": "KARBOHIDRAT",
  "stokKg": 50.5
}
```

**Expected Response:**

```json
{
  "id": "stok-id-123",
  "nama": "Beras",
  "kategori": "KARBOHIDRAT",
  "stokKg": 50.5,
  "dapurId": "dapur-id-456",
  "createdAt": "2025-10-20T10:00:00.000Z",
  "updatedAt": "2025-10-20T10:00:00.000Z"
}
```

**Flutter Model:** `StokModel` in `lib/features/dapur/models/stok_model.dart`

**Mapping:**

- ✅ All fields match perfectly
- ✅ `kategori` enum: SAYURAN, BUAH, PROTEIN, KARBOHIDRAT, LAINNYA
- ✅ `stokKg` is double

### PATCH /api/stok/:id/adjust

**Request:**

```json
{
  "adjustment": 5.5
}
```

**Note:** Positive values add stock, negative values subtract

**Expected Response:** Updated StokModel with new `stokKg` value

---

## 4. Pengiriman (Delivery) & QR Code

### POST /api/pengiriman

**Request:**

```json
{
  "sekolahId": "sekolah-id-789",
  "jumlahTray": 10,
  "jumlahKeranjang": 2
}
```

**Expected Response:**

```json
{
  "id": "pengiriman-id-123",
  "qrCodeId": "qr-code-unique-id-xyz",
  "status": "PENDING",
  "waktuDiambil": null,
  "waktuDiterima": null,
  "jumlahTray": 10,
  "jumlahKeranjang": 2,
  "sekolahId": "sekolah-id-789",
  "sekolah": {
    "id": "sekolah-id-789",
    "nama": "SD Negeri 1",
    "alamat": "Jl. Pendidikan No. 1"
  },
  "dapurId": "dapur-id-456",
  "driverId": null,
  "driver": null,
  "createdAt": "2025-10-20T10:00:00.000Z",
  "updatedAt": "2025-10-20T10:00:00.000Z"
}
```

**Flutter Model:** `PengirimanModel` in `lib/features/dapur/models/pengiriman_model.dart`

**Mapping:**

- ✅ All fields match
- ✅ `status` enum: PENDING, DIAMBIL, DITERIMA
- ✅ Nested `sekolah` object mapped to `sekolahNama` and `sekolahAlamat`
- ✅ Nested `driver` object mapped to `driverNama`
- ✅ Use `qrCodeId` for QR code generation

### POST /api/pengiriman/:qrCodeId/scan-driver

**Request:** No body needed

**Expected Response:**

```json
{
  "id": "pengiriman-id-123",
  "qrCodeId": "qr-code-unique-id-xyz",
  "status": "DIAMBIL",
  "waktuDiambil": "2025-10-20T11:00:00.000Z",
  "waktuDiterima": null,
  "jumlahTray": 10,
  "jumlahKeranjang": 2,
  "sekolahId": "sekolah-id-789",
  "sekolah": {...},
  "dapurId": "dapur-id-456",
  "driverId": "driver-user-id",
  "driver": {
    "id": "driver-user-id",
    "name": "Driver Name"
  },
  "createdAt": "2025-10-20T10:00:00.000Z",
  "updatedAt": "2025-10-20T11:00:00.000Z"
}
```

**Status Flow:**

1. Create → `PENDING`
2. Driver scans → `DIAMBIL` (waktuDiambil set)
3. School scans → `DITERIMA` (waktuDiterima set)

---

## 5. Kelas Management (Classes)

### POST /api/sekolah/:sekolahId/kelas

**Request:**

```json
{
  "nama": "Kelas 1A",
  "tingkat": 1
}
```

**Expected Response:**

```json
{
  "id": "kelas-id-123",
  "nama": "Kelas 1A",
  "tingkat": 1,
  "sekolahId": "sekolah-id-789",
  "createdAt": "2025-10-20T10:00:00.000Z",
  "updatedAt": "2025-10-20T10:00:00.000Z"
}
```

**Flutter Model:** `KelasModel` in `lib/features/sekolah/models/kelas_model.dart`

**Mapping:**

- ✅ All fields match perfectly
- ✅ `tingkat` is integer (1-6 for SD)

### GET /api/sekolah/:sekolahId/kelas

**Expected Response (Array):**

```json
[
  {
    "id": "kelas-id-123",
    "nama": "Kelas 1A",
    "tingkat": 1,
    "sekolahId": "sekolah-id-789",
    "createdAt": "2025-10-20T10:00:00.000Z",
    "updatedAt": "2025-10-20T10:00:00.000Z"
  }
]
```

**Note:** API doesn't return `jumlahSiswa` in KelasModel (that's why we removed it from the UI)

---

## 6. Siswa Management (Students)

### POST /api/sekolah/:sekolahId/siswa

**Request (multipart/form-data):**

```
nama: "Nama Siswa"
nis: "12345"
kelasId: "kelas-id-123"
jenisKelamin: "LAKI_LAKI"
umur: 10
tinggiBadan: 140
beratBadan: 35
foto: <file>
```

**Expected Response:**

```json
{
  "id": "siswa-id-123",
  "nama": "Nama Siswa",
  "nis": "12345",
  "jenisKelamin": "LAKI_LAKI",
  "umur": 10,
  "tinggiBadan": 140.0,
  "beratBadan": 35.0,
  "imt": 17.86,
  "statusGizi": "GIZI_BAIK",
  "foto": "https://s3.amazonaws.com/bucket/siswa-photo.jpg",
  "kelasId": "kelas-id-123",
  "kelas": {
    "id": "kelas-id-123",
    "nama": "Kelas 1A"
  },
  "sekolahId": "sekolah-id-789",
  "createdAt": "2025-10-20T10:00:00.000Z",
  "updatedAt": "2025-10-20T10:00:00.000Z"
}
```

**Flutter Model:** `SiswaModel` in `lib/features/sekolah/models/siswa_model.dart`

**Mapping:**

- ✅ All fields match
- ✅ `imt` and `statusGizi` auto-calculated by API
- ✅ `jenisKelamin` enum: LAKI_LAKI, PEREMPUAN
- ✅ `statusGizi` enum: GIZI_BAIK, GIZI_KURANG, GIZI_BURUK, OBESITAS
- ✅ Nested `kelas` object mapped to `kelasNama`

---

## 7. Menu Planning & Daily Menu

### POST /api/menu-planning

**Request:**

```json
{
  "mingguanKe": 1,
  "tanggalMulai": "2025-10-20",
  "tanggalSelesai": "2025-10-25",
  "sekolahId": "sekolah-id-789"
}
```

**Expected Response:**

```json
{
  "id": "planning-id-123",
  "mingguanKe": 1,
  "tanggalMulai": "2025-10-20T00:00:00.000Z",
  "tanggalSelesai": "2025-10-25T00:00:00.000Z",
  "sekolahId": "sekolah-id-789",
  "dapurId": "dapur-id-456",
  "createdAt": "2025-10-20T10:00:00.000Z",
  "updatedAt": "2025-10-20T10:00:00.000Z"
}
```

**Flutter Model:** `MenuPlanningModel` in `lib/features/dapur/models/menu_planning_model.dart`

**Mapping:**

- ✅ All fields match perfectly

### POST /api/menu-planning/:planningId/menu-harian

**Request:**

```json
{
  "tanggal": "2025-10-27",
  "namaMenu": "Nasi Goreng Spesial",
  "biayaPerTray": 15000.0,
  "jamMulaiMasak": "06:00",
  "jamSelesaiMasak": "08:00",
  "kalori": 550.5,
  "protein": 25.5,
  "karbohidrat": 75.0,
  "lemak": 15.0
}
```

**Expected Response:**

```json
{
  "id": "menu-harian-id-123",
  "tanggal": "2025-10-27T00:00:00.000Z",
  "namaMenu": "Nasi Goreng Spesial",
  "biayaPerTray": 15000.0,
  "jamMulaiMasak": "06:00",
  "jamSelesaiMasak": "08:00",
  "kalori": 550.5,
  "protein": 25.5,
  "karbohidrat": 75.0,
  "lemak": 15.0,
  "menuPlanningId": "planning-id-123",
  "createdAt": "2025-10-20T10:00:00.000Z",
  "updatedAt": "2025-10-20T10:00:00.000Z"
}
```

**Flutter Model:** `MenuHarianModel` in `lib/features/dapur/models/menu_harian_model.dart`

**Mapping:**

- ✅ All fields match perfectly
- ✅ Nutrition data: kalori, protein, karbohidrat, lemak (all double)

---

## 8. Checkpoint (Photo Documentation)

### POST /api/menu-harian/:menuHarianId/checkpoint

**Request (multipart/form-data):**

```
tipe: "MULAI_MEMASAK"
foto: <file>
```

**Expected Response:**

```json
{
  "id": "checkpoint-id-123",
  "tipe": "MULAI_MEMASAK",
  "waktu": "2025-10-20T06:00:00.000Z",
  "foto": "https://s3.amazonaws.com/bucket/checkpoint-photo.jpg",
  "menuHarianId": "menu-harian-id-123",
  "createdAt": "2025-10-20T06:00:00.000Z",
  "updatedAt": "2025-10-20T06:00:00.000Z"
}
```

**Flutter Model:** `CheckpointModel` in `lib/features/dapur/models/checkpoint_model.dart`

**Mapping:**

- ✅ All fields match
- ✅ `tipe` enum: MULAI_MEMASAK, SELESAI_MEMASAK

---

## 9. Absensi (Attendance)

### POST /api/kelas/:kelasId/absensi

**Request:**

```json
{
  "tanggal": "2025-10-20",
  "jumlahHadir": 25
}
```

**Expected Response:**

```json
{
  "id": "absensi-id-123",
  "tanggal": "2025-10-20T00:00:00.000Z",
  "jumlahHadir": 25,
  "kelasId": "kelas-id-123",
  "createdAt": "2025-10-20T10:00:00.000Z",
  "updatedAt": "2025-10-20T10:00:00.000Z"
}
```

**Flutter Model:** `AbsensiModel` in `lib/features/sekolah/models/absensi_model.dart`

**Mapping:**

- ✅ All fields match perfectly

### GET /api/sekolah/:sekolahId/absensi/total/:tanggal

**Expected Response:**

```json
{
  "totalHadir": 250,
  "tanggal": "2025-10-20",
  "details": [
    {
      "kelasId": "kelas-id-123",
      "kelasNama": "Kelas 1A",
      "jumlahHadir": 25
    }
  ]
}
```

---

## 10. Sekolah & Dapur

### GET /api/sekolah/:id

**Expected Response:**

```json
{
  "id": "sekolah-id-789",
  "nama": "SD Negeri 1",
  "alamat": "Jl. Pendidikan No. 1",
  "dapurId": "dapur-id-456",
  "dapur": {
    "id": "dapur-id-456",
    "nama": "Dapur Pusat",
    "alamat": "Jl. Dapur No. 1",
    "status": "AKTIF"
  },
  "createdAt": "2025-10-20T10:00:00.000Z",
  "updatedAt": "2025-10-20T10:00:00.000Z"
}
```

**Flutter Model:** `SekolahModel` in `lib/features/sekolah/models/sekolah_model.dart`

### GET /api/dapur/:id

**Expected Response:**

```json
{
  "id": "dapur-id-456",
  "nama": "Dapur Pusat",
  "alamat": "Jl. Dapur No. 1",
  "status": "AKTIF",
  "createdAt": "2025-10-20T10:00:00.000Z",
  "updatedAt": "2025-10-20T10:00:00.000Z"
}
```

**Flutter Model:** `DapurModel` in `lib/features/dapur/models/dapur_model.dart`

---

## Important Notes

### 1. Date/Time Handling

- API returns ISO 8601 format: `"2025-10-20T10:00:00.000Z"`
- Flutter uses `DateTime.parse()` to convert
- Date-only fields like `tanggal` still use full ISO format

### 2. Multipart Uploads

Endpoints requiring image upload:

- POST /api/karyawan (foto)
- POST /api/sekolah/:id/siswa (foto)
- POST /api/menu-harian/:id/checkpoint (foto)

Use `multipart/form-data` with `http` package or `Dio` FormData

### 3. Nested Objects

API often returns nested objects (e.g., `sekolah`, `kelas`, `driver`)
Models flatten these to simple fields:

- `json['sekolah']['nama']` → `sekolahNama`
- `json['kelas']['nama']` → `kelasNama`
- `json['driver']['name']` → `driverNama`

### 4. Auto-Calculated Fields

Don't send in request, received in response:

- Siswa: `imt`, `statusGizi` (calculated by backend)
- Pengiriman: `qrCodeId` (generated by backend)
- Timestamps: `createdAt`, `updatedAt`

### 5. Status Enums

**Pengiriman Status:**

- PENDING → DIAMBIL → DITERIMA

**Status Gizi:**

- GIZI_BAIK
- GIZI_KURANG
- GIZI_BURUK
- OBESITAS

**Checkpoint Tipe:**

- MULAI_MEMASAK
- SELESAI_MEMASAK

**Kategori Stok:**

- SAYURAN
- BUAH
- PROTEIN
- KARBOHIDRAT
- LAINNYA

**Jenis Kelamin:**

- LAKI_LAKI
- PEREMPUAN

**User Role:**

- SUPERADMIN
- PIC_DAPUR
- PIC_SEKOLAH
- DRIVER

**Dapur Status:**

- AKTIF
- TIDAK_AKTIF

---

## Testing Without Backend

For development without backend, use mock data following these response structures. See `lib/utils/http/mbg_http_helper.dart` for API integration.

**Example Mock Response:**

```dart
// Mock Karyawan List
final mockKaryawanList = [
  {
    "id": "karyawan-1",
    "nama": "Chef Ahmad",
    "posisi": "Head Chef",
    "foto": "https://via.placeholder.com/150",
    "dapurId": "dapur-1",
    "createdAt": "2025-10-20T10:00:00.000Z",
    "updatedAt": "2025-10-20T10:00:00.000Z"
  },
  {
    "id": "karyawan-2",
    "nama": "Siti Cooking Assistant",
    "posisi": "Assistant Chef",
    "foto": null,
    "dapurId": "dapur-1",
    "createdAt": "2025-10-20T11:00:00.000Z",
    "updatedAt": "2025-10-20T11:00:00.000Z"
  }
];

// Parse to models
final karyawanList = mockKaryawanList
    .map((json) => KaryawanModel.fromJson(json))
    .toList();
```

---

## Next Steps

1. **Start Backend Server:** Ensure API server is running on `http://localhost:3000`
2. **Test Authentication:** Login with superadmin credentials
3. **Test Each Endpoint:** Use actual API calls to verify response structure
4. **Handle Errors:** Implement proper error handling for failed requests
5. **Add Loading States:** Show loaders during API calls
6. **Cache Data:** Consider local storage for offline support
