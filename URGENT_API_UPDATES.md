# MBG API Integration - Critical Updates Required

## ✅ Completed

1. **Updated Base URL** in `lib/utils/http/http_client.dart` to `http://72.60.79.126:3000`

## ⚠️ CRITICAL - Must Fix Before Testing

### 1. Response Wrapper Issue

**Problem:** All API responses are wrapped in `{success, message, data}` but our models expect direct data.

**Example Current Code (BROKEN):**

```dart
// In sekolah_service.dart
Future<List<KelasModel>> getKelas(String sekolahId) async {
  final response = await _httpClient.getRequest('api/sekolah/$sekolahId/kelas');
  final data = response.body;  // ❌ This is {success, message, data}
  return (data as List).map((e) => KelasModel.fromJson(e)).toList();  // ❌ WILL CRASH
}
```

**Fixed Code:**

```dart
Future<List<KelasModel>> getKelas(String sekolahId) async {
  final response = await _httpClient.getRequest('api/sekolah/$sekolahId/kelas');
  final wrapper = response.body;  // {success, message, data}
  final paginatedData = wrapper['data'];  // {data: [...], pagination: {...}}
  final items = paginatedData['data'];  // The actual array
  return (items as List).map((e) => KelasModel.fromJson(e)).toList();
}
```

### 2. Field Name Mismatch

**Problem:** API uses `fotoUrl` but models use `foto`

**Files to Update:**

- `lib/features/sekolah/models/siswa_model.dart`
- `lib/features/dapur/models/karyawan_model.dart`

**Change:**

```dart
// Before
final String? foto;
fotoModel: json['foto'],

// After
final String? fotoUrl;
fotoUrl: json['fotoUrl'],
```

### 3. Login Response Structure

**Problem:** Login returns `{success, message, data: {user, token}}` not direct `{user, token}`

**Fix AuthService:**

```dart
Future<Map<String, dynamic>> login(String email, String password) async {
  final response = await _httpClient.postRequest('api/auth/login', {
    'email': email,
    'password': password,
  });

  // OLD: return response.body;
  // NEW:
  final wrapper = response.body;
  return wrapper['data'];  // This contains {user, token}
}
```

## 📋 Complete Update Checklist

### Models

- [ ] **siswa_model.dart**: Change `foto` → `fotoUrl`
- [ ] **karyawan_model.dart**: Change `foto` → `fotoUrl`
- [ ] **kelas_model.dart**: Add `jumlahSiswa` field from `_count.siswa`
- [ ] **Create alergi_model.dart**: For student allergies
- [ ] **Create pagination_model.dart**: Reusable pagination handler

### Services - Update ALL methods

#### DapurService

- [ ] `getKaryawan()` - Handle wrapper + pagination
- [ ] `createKaryawan()` - Extract from `response.body.data`
- [ ] `deleteKaryawan()` - Check `response.body.success`
- [ ] `getStok()` - Handle wrapper + pagination
- [ ] `createStok()` - Extract from `response.body.data`
- [ ] `adjustStok()` - Extract from `response.body.data`
- [ ] `deleteStok()` - Check `response.body.success`
- [ ] `createPengiriman()` - Extract from `response.body.data`
- [ ] `getPengiriman()` - Handle wrapper + pagination (if endpoint exists)

#### SekolahService

- [ ] `getKelas()` - Handle wrapper + pagination
- [ ] `createKelas()` - Extract from `response.body.data`
- [ ] `updateKelas()` - Extract from `response.body.data`
- [ ] `deleteKelas()` - Check `response.body.success`
- [ ] `getSiswa()` - Handle wrapper + pagination
- [ ] `createSiswa()` - Extract from `response.body.data`
- [ ] `updateSiswa()` - Extract from `response.body.data`
- [ ] `deleteSiswa()` - Check `response.body.success`

#### AuthService

- [ ] `login()` - Extract `response.body.data` containing {user, token}
- [ ] `getProfile()` - Extract `response.body.data` for user info

### Screens

Files that reference `foto` field:

- [ ] **siswa_management_screen.dart**: Change `siswa.foto` → `siswa.fotoUrl`
- [ ] **karyawan_management_screen.dart**: Change `karyawan.foto` → `karyawan.fotoUrl`
- [ ] **kelas_management_screen.dart**: Display `kelas.jumlahSiswa` (now available!)

## 🔧 Helper Method Template

Add this to `MBGHttpHelper` for easier response handling:

```dart
// Add to lib/utils/http/http_client.dart
class MBGHttpHelper extends GetConnect {
  // ... existing code ...

  /// Extract data from standardized API response
  /// Returns the actual data from {success, message, data} wrapper
  static dynamic extractResponseData(Response response) {
    if (response.body == null) {
      throw Exception('Response body is null');
    }

    final wrapper = response.body as Map<String, dynamic>;

    if (wrapper['success'] != true) {
      throw Exception(wrapper['message'] ?? 'Request failed');
    }

    return wrapper['data'];
  }

  /// Extract paginated list from API response
  /// Returns the items array from {success, message, data: {data: [...], pagination: {...}}}
  static List<dynamic> extractPaginatedList(Response response) {
    final data = extractResponseData(response);

    if (data is! Map<String, dynamic>) {
      throw Exception('Expected paginated response structure');
    }

    final items = data['data'];
    if (items is! List) {
      throw Exception('Expected array of items in data.data');
    }

    return items;
  }

  /// Extract pagination info
  static Map<String, dynamic> extractPagination(Response response) {
    final data = extractResponseData(response);
    return data['pagination'] as Map<String, dynamic>;
  }
}
```

Then update services to use these helpers:

```dart
// Example updated service method
Future<List<KelasModel>> getKelas(String sekolahId) async {
  final response = await _httpClient.getRequest('api/sekolah/$sekolahId/kelas');
  final items = MBGHttpHelper.extractPaginatedList(response);
  return items.map((e) => KelasModel.fromJson(e)).toList();
}
```

## 🧪 Quick Test Script

After making changes, test with this in a screen:

```dart
void _testAPI() async {
  try {
    // Test login
    final authService = Get.find<AuthService>();
    final loginData = await authService.login('picsekolah1@mbg.com', 'password123');
    print('Token: ${loginData['token']}');
    print('User: ${loginData['user']['name']}');

    // Test get kelas
    final sekolahService = Get.find<SekolahService>();
    final kelas = await sekolahService.getKelas('4301290c-0fa8-465f-b7a8-82db3535d878');
    print('Kelas count: ${kelas.length}');
    print('First kelas: ${kelas.first.nama}, Students: ${kelas.first.jumlahSiswa}');

    // Test get siswa
    final siswa = await sekolahService.getSiswa('4301290c-0fa8-465f-b7a8-82db3535d878');
    print('Siswa count: ${siswa.length}');
    print('First siswa: ${siswa.first.nama}, Photo: ${siswa.first.fotoUrl}');

  } catch (e) {
    print('Error: $e');
  }
}
```

## 🎯 Priority Order

1. **HIGHEST**: Update AuthService login (blocks everything)
2. **HIGH**: Add helper methods to MBGHttpHelper
3. **HIGH**: Update all GET methods in services (pagination)
4. **MEDIUM**: Update models (foto → fotoUrl)
5. **MEDIUM**: Update screens (display changes)
6. **LOW**: Add jumlahSiswa, alergi features

## 📝 Test Accounts

Use these for testing:

```
PIC Dapur 1:    picdapur1@mbg.com / password123
  Dapur: "Dapur Pusat Jakarta Selatan" (ID: 1ceb329e-a624-47ca-9975-33e3223713b7)

PIC Sekolah 1:  picsekolah1@mbg.com / password123
  Sekolah: "SDN 01 Kebayoran Baru" (ID: 4301290c-0fa8-465f-b7a8-82db3535d878)
  - Has 2 kelas
  - Has 4 siswa

All passwords: password123
```

## ⚡ Quick Start

**Fastest path to working app:**

1. Add helper methods to MBGHttpHelper (5 min)
2. Update AuthService.login() (2 min)
3. Update SekolahService.getKelas() (3 min)
4. Update SekolahService.getSiswa() (3 min)
5. Change `foto` to `fotoUrl` in siswa_model.dart (1 min)
6. Test login → kelas list → siswa list (2 min)

**Total: ~15 minutes to basic functionality**

---

The API is live and working! All the data structures match our models except for the response wrapper. Once we handle that, everything will work smoothly.
