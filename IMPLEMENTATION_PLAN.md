# Role-Based Implementation Summary

## ✅ What Has Been Completed

### 1. Role-Based Drawer Navigation

- ✅ Created `MBGDrawerPicDapur` for Kitchen Manager
- ✅ Created `MBGDrawerDriver` for Delivery Driver
- ✅ Created `MBGDrawerPicSekolah` for School Manager
- ✅ Each drawer has role-specific menu items

### 2. Controllers

- ✅ `DapurController` - Manages PIC_DAPUR state
- ✅ `DriverController` - Manages DRIVER state
- ✅ `SekolahController` - Manages PIC_SEKOLAH state

### 3. Screen Structure

All main screens updated with IndexedStack for drawer navigation:

- ✅ `DapurScreen` - 8 menu items
- ✅ `DriverScreen` - 5 menu items
- ✅ `SekolahScreen` - 9 menu items

### 4. Placeholder Screens Created

**PIC_DAPUR:**

- ✅ Dashboard (existing timeline)
- ✅ Dapur Management
- ✅ Karyawan Management
- ✅ Stok Management
- ✅ Menu Planning
- ✅ Checkpoint
- ✅ Pengiriman

**DRIVER:**

- ✅ Dashboard
- ✅ My Deliveries
- ✅ QR Scanner
- ✅ Delivery History

**PIC_SEKOLAH:**

- ✅ Dashboard
- ✅ Sekolah Management
- ✅ Kelas Management
- ✅ Siswa Management
- ✅ Absensi
- ✅ Nutrition Monitor
- ✅ Receive Delivery
- ✅ Menu View

---

## 📋 Next Steps to Build the App

### Phase 1: Setup & Infrastructure

1. **Install Required Packages**

```bash
flutter pub add qr_code_scanner qr_flutter fl_chart intl
```

2. **Create API Service Layer**
   Create these files:

- `lib/utils/http/dapur_service.dart`
- `lib/utils/http/driver_service.dart`
- `lib/utils/http/sekolah_service.dart`

Each service should handle HTTP requests for their respective domain.

### Phase 2: PIC_DAPUR Implementation

**Priority Order:**

1. **Dapur Management** ⭐

   - List view of kitchens
   - Create/Edit form
   - API: `GET /api/dapur`, `POST /api/dapur`, `PUT /api/dapur/:id`

2. **Karyawan Management** ⭐

   - List with photos
   - Add form with image picker
   - API: `GET /api/dapur/:dapurId/karyawan`, `POST /api/karyawan` (multipart)

3. **Stok Management** ⭐

   - Inventory list
   - Add/Edit stock
   - Adjust stock levels
   - API: `GET /api/stok`, `POST /api/stok`, `PATCH /api/stok/:id/adjust`

4. **Menu Planning** ⭐⭐

   - Weekly menu calendar
   - Create menu planning
   - Add daily menus with nutrition info
   - API: `POST /api/menu-planning`, `POST /api/menu-planning/:planningId/menu-harian`

5. **Checkpoint** ⭐⭐

   - Photo upload for cooking checkpoints
   - Types: MULAI_MEMASAK, SELESAI_MEMASAK
   - API: `POST /api/menu-harian/:menuHarianId/checkpoint` (multipart)

6. **Pengiriman** ⭐⭐⭐
   - Create delivery
   - Generate QR code
   - Track status
   - API: `POST /api/pengiriman`, `GET /api/pengiriman/:id`

### Phase 3: DRIVER Implementation

1. **My Deliveries** ⭐

   - List of assigned deliveries
   - API: `GET /api/driver/pengiriman`

2. **QR Scanner** ⭐⭐⭐

   - Scan QR code at kitchen
   - Confirm pickup
   - API: `POST /api/pengiriman/:qrCodeId/scan-driver`

3. **Delivery History** ⭐
   - Past deliveries
   - Status tracking

### Phase 4: PIC_SEKOLAH Implementation

1. **Sekolah Management** ⭐

   - School info
   - API: `GET /api/sekolah/:id`, `PUT /api/sekolah/:id`

2. **Kelas Management** ⭐

   - List classes
   - Create/Edit class
   - API: `GET /api/sekolah/:sekolahId/kelas`, `POST /api/sekolah/:sekolahId/kelas`

3. **Siswa Management** ⭐⭐

   - Student list with photos
   - Add student (auto-calculate IMT & Status Gizi)
   - Manage allergies
   - API: `POST /api/sekolah/:sekolahId/siswa`, `POST /api/siswa/:siswaId/alergi`

4. **Absensi** ⭐⭐

   - Record daily attendance per class
   - View total attendance
   - API: `POST /api/kelas/:kelasId/absensi`, `GET /api/sekolah/:sekolahId/absensi/total/:tanggal`

5. **Nutrition Monitor** ⭐⭐

   - View student nutrition status
   - Charts for IMT trends
   - Use `fl_chart` package

6. **Receive Delivery** ⭐⭐⭐

   - QR scanner
   - Receive food delivery
   - API: `POST /api/pengiriman/:qrCodeId/scan-sekolah`

7. **Menu View** ⭐
   - View weekly menu from kitchen
   - API: `GET /api/sekolah/:sekolahId/menu-planning`

---

## 🔑 Key Features to Implement

### Image Upload (All Roles)

Use `image_picker` package:

```dart
final ImagePicker picker = ImagePicker();
final XFile? image = await picker.pickImage(source: ImageSource.gallery);
// Upload to: POST /api/upload/image
```

### QR Code Generation (PIC_DAPUR)

Use `qr_flutter` package:

```dart
QrImageView(
  data: qrCodeId,
  version: QrVersions.auto,
  size: 200.0,
)
```

### QR Code Scanning (DRIVER & PIC_SEKOLAH)

Use `qr_code_scanner` package:

```dart
QRView(
  key: qrKey,
  onQRViewCreated: _onQRViewCreated,
)
```

---

## 📊 Data Models to Create

Create these model files:

```
lib/features/dapur/models/
  ├── dapur_model.dart
  ├── karyawan_model.dart
  ├── stok_model.dart
  ├── menu_planning_model.dart
  ├── menu_harian_model.dart
  ├── checkpoint_model.dart
  └── pengiriman_model.dart

lib/features/driver/models/
  └── delivery_model.dart

lib/features/sekolah/models/
  ├── sekolah_model.dart
  ├── kelas_model.dart
  ├── siswa_model.dart
  ├── alergi_model.dart
  └── absensi_model.dart
```

---

## 🎯 Suggested Implementation Order

### Week 1: Core Infrastructure

- [ ] Install packages
- [ ] Create API service classes
- [ ] Create data models
- [ ] Test API connections

### Week 2: PIC_DAPUR Basic Features

- [ ] Dapur management (CRUD)
- [ ] Karyawan management with photos
- [ ] Stok management

### Week 3: PIC_DAPUR Advanced

- [ ] Menu planning
- [ ] Checkpoint with photos
- [ ] Pengiriman with QR generation

### Week 4: DRIVER Features

- [ ] Deliveries list
- [ ] QR Scanner implementation
- [ ] Delivery tracking

### Week 5: PIC_SEKOLAH Basic

- [ ] Sekolah & Kelas management
- [ ] Siswa management with photos

### Week 6: PIC_SEKOLAH Advanced

- [ ] Absensi system
- [ ] Nutrition monitoring
- [ ] Receive delivery QR scanner
- [ ] Menu viewing

### Week 7: Polish & Testing

- [ ] Error handling
- [ ] Loading states
- [ ] UI/UX improvements
- [ ] Testing all flows

---

## 📖 Reference

See `ROLE_BASED_NAVIGATION.md` for:

- Complete API flow diagrams
- Detailed endpoint documentation
- Architecture explanation
- Code examples

See `MBG System API - Updated.postman_collection.json` for:

- All API endpoints
- Request/response formats
- Authentication requirements
