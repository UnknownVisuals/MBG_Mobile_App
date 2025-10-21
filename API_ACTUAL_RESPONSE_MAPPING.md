# MBG API - Actual Response Mapping (Live API)

## Base URL

```
http://72.60.79.126:3000
```

## Critical Findings

### 1. **Response Wrapper Structure**

All API responses are wrapped in a standardized format:

```json
{
  "success": true,
  "message": "Operation successful",
  "data": { ... }
}
```

**Impact**: All service methods must extract `response.data` instead of using `response` directly.

### 2. **Pagination Structure**

List endpoints return paginated data:

```json
{
  "success": true,
  "message": "Items fetched successfully",
  "data": {
    "data": [...items...],
    "pagination": {
      "total": 100,
      "page": 1,
      "limit": 10,
      "totalPages": 10
    }
  }
}
```

**Impact**: Access items via `response.data.data`, not `response.data`

### 3. **Field Name Differences**

| Expected (Model) | Actual (API) | Field                   |
| ---------------- | ------------ | ----------------------- |
| `foto`           | `fotoUrl`    | Student/Employee photos |

### 4. **Additional Fields**

API returns extra fields not in our models:

- Kelas has `_count.siswa` (student count)
- Siswa has `alergi` array (allergies)
- Nested objects include more detail

---

## Authentication

### POST /api/auth/login

**Request:**

```json
{
  "email": "picdapur1@mbg.com",
  "password": "password123"
}
```

**Actual Response:**

```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "user": {
      "id": "a7359b03-4435-4c37-b549-74c6c1fa9eea",
      "email": "picdapur1@mbg.com",
      "name": "Siti Nurhaliza",
      "phone": "081234567891",
      "role": "PIC_DAPUR",
      "nomorKendaraan": null
    },
    "token": "eyJhbGci..."
  }
}
```

**Access Token:** `response.data.token`
**User Data:** `response.data.user`

⚠️ **Missing in Response:** `dapurAsPIC`, `sekolahAsPIC`, `createdAt`, `updatedAt`
(These are available in `/api/auth/me`)

### GET /api/auth/me

**Actual Response:**

```json
{
  "success": true,
  "message": "Profile fetched successfully",
  "data": {
    "id": "a7359b03-4435-4c37-b549-74c6c1fa9eea",
    "email": "picdapur1@mbg.com",
    "name": "Siti Nurhaliza",
    "phone": "081234567891",
    "role": "PIC_DAPUR",
    "nomorKendaraan": null,
    "dapurAsPIC": [
      {
        "id": "1ceb329e-a624-47ca-9975-33e3223713b7",
        "nama": "Dapur Pusat Jakarta Selatan",
        "alamat": "Jl. TB Simatupang No. 123, Jakarta Selatan",
        "status": "AKTIF"
      }
    ],
    "sekolahAsPIC": [],
    "createdAt": "2025-10-19T17:16:31.687Z",
    "updatedAt": "2025-10-19T17:16:31.687Z"
  }
}
```

---

## Kelas Management

### GET /api/sekolah/:sekolahId/kelas

**Actual Response:**

```json
{
  "success": true,
  "message": "Kelas fetched successfully",
  "data": {
    "data": [
      {
        "id": "60699c4a-56c3-462f-a31a-d282487c31e2",
        "nama": "1A",
        "tingkat": 1,
        "createdAt": "2025-10-19T17:16:50.643Z",
        "updatedAt": "2025-10-19T17:16:50.643Z",
        "sekolahId": "4301290c-0fa8-465f-b7a8-82db3535d878",
        "sekolah": {
          "id": "4301290c-0fa8-465f-b7a8-82db3535d878",
          "nama": "SDN 01 Kebayoran Baru"
        },
        "_count": {
          "siswa": 2
        }
      }
    ],
    "pagination": {
      "total": 2,
      "page": 1,
      "limit": 10,
      "totalPages": 1
    }
  }
}
```

**New Field:** `_count.siswa` - Now available! Can display student count.

**Access Items:** `response.data.data`
**Access Pagination:** `response.data.pagination`

---

## Siswa Management

### GET /api/sekolah/:sekolahId/siswa

**Actual Response:**

```json
{
  "success": true,
  "message": "Siswa fetched successfully",
  "data": {
    "data": [
      {
        "id": "b7070992-f337-4545-9da9-30fa38487b6c",
        "nama": "Ahmad Rizki",
        "nis": "NIS001",
        "jenisKelamin": "LAKI_LAKI",
        "umur": 7,
        "tinggiBadan": 115,
        "beratBadan": 20,
        "imt": 15.12,
        "statusGizi": "GIZI_BURUK",
        "fotoUrl": null,
        "createdAt": "2025-10-19T17:16:51.913Z",
        "updatedAt": "2025-10-19T17:16:51.913Z",
        "sekolahId": "4301290c-0fa8-465f-b7a8-82db3535d878",
        "kelasId": "60699c4a-56c3-462f-a31a-d282487c31e2",
        "sekolah": {
          "id": "4301290c-0fa8-465f-b7a8-82db3535d878",
          "nama": "SDN 01 Kebayoran Baru"
        },
        "kelas": {
          "id": "60699c4a-56c3-462f-a31a-d282487c31e2",
          "nama": "1A",
          "tingkat": 1
        },
        "alergi": [
          {
            "id": "023ab66b-b8ef-4756-abdd-7d4db2f891d9",
            "namaAlergi": "Kacang dan produk olahannya"
          }
        ]
      }
    ],
    "pagination": {...}
  }
}
```

**Field Differences:**

- API uses `fotoUrl` instead of `foto`
- API includes `alergi` array (not in model)
- Nested `sekolah` and `kelas` objects

---

## Karyawan Management

### GET /api/karyawan

**Actual Response:**

```json
{
  "success": true,
  "message": "Karyawan fetched successfully",
  "data": {
    "data": [],
    "pagination": {
      "total": 0,
      "page": 1,
      "limit": 10,
      "totalPages": 0
    }
  }
}
```

**Expected Field:** `fotoUrl` (likely similar to siswa)

---

## Stok Management

### GET /api/stok

**Actual Response:**

```json
{
  "success": true,
  "message": "Stok fetched successfully",
  "data": {
    "data": [],
    "pagination": {
      "total": 0,
      "page": 1,
      "limit": 10,
      "totalPages": 0
    }
  }
}
```

---

## Required Model Updates

### 1. **Update SiswaModel**

Change field name from `foto` to `fotoUrl`:

```dart
class SiswaModel {
  final String? fotoUrl;  // Changed from 'foto'

  factory SiswaModel.fromJson(Map<String, dynamic> json) {
    return SiswaModel(
      // ...
      fotoUrl: json['fotoUrl'],  // Changed from json['foto']
      // ...
    );
  }
}
```

### 2. **Update KaryawanModel**

Likely needs same change:

```dart
class KaryawanModel {
  final String? fotoUrl;  // Changed from 'foto'

  factory KaryawanModel.fromJson(Map<String, dynamic> json) {
    return KaryawanModel(
      // ...
      fotoUrl: json['fotoUrl'],
      // ...
    );
  }
}
```

### 3. **Add Student Count to KelasModel**

```dart
class KelasModel {
  final int? jumlahSiswa;  // Add this field

  factory KelasModel.fromJson(Map<String, dynamic> json) {
    return KelasModel(
      // ...
      jumlahSiswa: json['_count']?['siswa'],  // Extract from _count
      // ...
    );
  }
}
```

### 4. **Create AlergiModel**

```dart
class AlergiModel {
  final String id;
  final String namaAlergi;

  AlergiModel({
    required this.id,
    required this.namaAlergi,
  });

  factory AlergiModel.fromJson(Map<String, dynamic> json) {
    return AlergiModel(
      id: json['id'],
      namaAlergi: json['namaAlergi'],
    );
  }
}
```

Then add to SiswaModel:

```dart
class SiswaModel {
  final List<AlergiModel>? alergi;  // Add allergies

  factory SiswaModel.fromJson(Map<String, dynamic> json) {
    return SiswaModel(
      // ...
      alergi: json['alergi'] != null
          ? (json['alergi'] as List)
              .map((a) => AlergiModel.fromJson(a))
              .toList()
          : null,
    );
  }
}
```

---

## Required Service Updates

### All Service Methods Must Handle Response Wrapper

**Before:**

```dart
Future<List<KelasModel>> getKelas(String sekolahId) async {
  final response = await MBGHttpHelper.get('/api/sekolah/$sekolahId/kelas');
  return (response as List).map((e) => KelasModel.fromJson(e)).toList();
}
```

**After:**

```dart
Future<List<KelasModel>> getKelas(String sekolahId) async {
  final response = await MBGHttpHelper.get('/api/sekolah/$sekolahId/kelas');
  final data = response['data']['data'];  // Navigate through wrapper
  return (data as List).map((e) => KelasModel.fromJson(e)).toList();
}
```

### Access Pagination Data

```dart
class PaginationModel {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      total: json['total'],
      page: json['page'],
      limit: json['limit'],
      totalPages: json['totalPages'],
    );
  }
}
```

---

## Configuration Update

Update `lib/utils/constants/api_constants.dart`:

```dart
class MBGAPIConstants {
  static const String baseUrl = 'http://72.60.79.126:3000';

  // Test accounts
  static const String testSuperAdmin = 'superadmin@mbg.com';
  static const String testPICDapur1 = 'picdapur1@mbg.com';
  static const String testPICDapur2 = 'picdapur2@mbg.com';
  static const String testPICSekolah1 = 'picsekolah1@mbg.com';
  static const String testPICSekolah2 = 'picsekolah2@mbg.com';
  static const String testDriver1 = 'driver1@mbg.com';
  static const String testDriver2 = 'driver2@mbg.com';
  static const String testPassword = 'password123';
}
```

---

## Action Items Summary

1. ✅ **Update Base URL** to `http://72.60.79.126:3000`
2. ⚠️ **Update All Service Methods** to handle `{success, message, data}` wrapper
3. ⚠️ **Update All Service Methods** to handle pagination: `data.data` and `data.pagination`
4. ⚠️ **Rename Field** `foto` → `fotoUrl` in SiswaModel and KaryawanModel
5. ✅ **Add Field** `jumlahSiswa` to KelasModel from `_count.siswa`
6. ⏳ **Create AlergiModel** and add to SiswaModel
7. ⏳ **Create PaginationModel** for reusable pagination handling
8. ⚠️ **Update Login Flow** to extract token from `response.data.token`
9. ⚠️ **Update Profile Fetch** to use `/api/auth/me` for full user data

---

## Testing Checklist

After updates:

- [ ] Login with all test accounts
- [ ] Fetch kelas list - verify pagination
- [ ] Display student count on kelas cards
- [ ] Fetch siswa list - verify fotoUrl field
- [ ] Display allergies if present
- [ ] Create new karyawan with photo
- [ ] Create new siswa with photo
- [ ] Adjust stok quantities
- [ ] Create pengiriman with QR code
- [ ] Test all CRUD operations

---

## Notes

- API is live and working correctly
- Main difference: response wrapper and pagination
- Field naming: `fotoUrl` instead of `foto`
- Extra data available: `_count`, `alergi`, nested objects
- Pagination must be handled for all list endpoints
