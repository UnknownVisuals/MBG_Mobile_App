# API Role Endpoint Matrix

**Date:** 2025-10-21

This matrix links the MBG System API endpoints (per Postman collection) with the Flutter implementation by role. Use it to track coverage and identify outstanding integration work.

## Legend

- **Status**: `✅` implemented and verified, `🟡` partially implemented or pending validation, `🔴` missing.
- **Module** references the primary screen/controller/service in `lib/`.

## PIC_DAPUR (Kitchen Manager)

| Flow                   | Endpoint                             | Method | Request Highlights                              | Response Highlights           | Module(s)                                                              | Status | Notes                                                                   |
| ---------------------- | ------------------------------------ | ------ | ----------------------------------------------- | ----------------------------- | ---------------------------------------------------------------------- | ------ | ----------------------------------------------------------------------- |
| Authentication context | `/api/auth/login`                    | POST   | email, password                                 | user payload with role, token | `features/authentication`                                              | ✅     | Shared across roles.                                                    |
| Assigned kitchens      | `/api/dapur/me` (TODO verify)        | GET    | bearer token                                    | kitchens assigned to PIC      | `features/dapur/controllers/dapur_controller.dart`                     | 🟡     | Controller loads assigned dapur; confirm endpoint path matches backend. |
| Karyawan list          | `/api/dapur/:dapurId/karyawan`       | GET    | selected dapur id                               | paginated karyawan array      | `.../karyawan_management_screen.dart`, `utils/http/dapur_service.dart` | 🟡     | List rendering wired; ensure pagination + error states.                 |
| Create karyawan        | `/api/dapur/:dapurId/karyawan`       | POST   | nama, posisi, foto multipart                    | KaryawanModel                 | same as above                                                          | 🟡     | Service updated to send dapurId; requires backend validation.           |
| Delete karyawan        | `/api/karyawan/:id`                  | DELETE | id path                                         | success bool                  | same                                                                   | 🟡     | Works; confirm success state from API.                                  |
| Stok list              | `/api/dapur/:dapurId/stok`           | GET    | dapur id                                        | stok array                    | `stok_management_screen.dart`, `utils/http/dapur_service.dart`         | �      | Screen now scopes by selected dapur; ensure pagination/error states.    |
| Create stok            | `/api/stok`                          | POST   | nama, kategori, stokKg, `dapurId` body          | StokModel                     | same                                                                   | 🟡     | UI wired; confirm backend accepts `dapurId` payload from PIC flow.      |
| Adjust stok            | `/api/stok/:id/adjust`               | PATCH  | adjustment double                               | updated StokModel             | same                                                                   | 🟡     | Adjustment dialog active; validate concurrency handling.                |
| Menu planning list     | `/api/menu-planning`                 | GET    | optional filters                                | planning array                | `menu_planning_controller.dart`                                        | ✅     | Screen functional; ensure filtering by dapur/sekolah.                   |
| Create menu planning   | `/api/menu-planning`                 | POST   | mingguanKe, tanggal, sekolahId                  | MenuPlanningModel             | same                                                                   | ✅     | Completed.                                                              |
| Menu harian list       | `/api/menu-planning/:id/menu-harian` | GET    | planning id                                     | menu harian array             | same                                                                   | ✅     | Completed.                                                              |
| Create menu harian     | `/api/menu-planning/:id/menu-harian` | POST   | nutrition data                                  | MenuHarianModel               | same                                                                   | ✅     | Completed.                                                              |
| Checkpoints list       | `/api/menu-harian/:id/checkpoint`    | GET    | menu harian id                                  | checkpoint list               | `checkpoint_screen.dart`                                               | ✅     | Completed.                                                              |
| Create checkpoint      | `/api/menu-harian/:id/checkpoint`    | POST   | tipe, foto                                      | CheckpointModel               | same                                                                   | ✅     | Completed.                                                              |
| Pengiriman list        | `/api/pengiriman`                    | GET    | optional filters (dapurId, status)              | delivery array                | `pengiriman_screen.dart`                                               | �      | Scoped by dapur, needs backend validation.                              |
| Create pengiriman      | `/api/pengiriman`                    | POST   | dapurId, sekolahId, jumlahTray, jumlahKeranjang | PengirimanModel (+qrCodeId)   | same                                                                   | �      | UI complete with QR display, test backend dapurId acceptance.           |
| Get pengiriman detail  | `/api/pengiriman/:id`                | GET    | id                                              | detail                        | same                                                                   | ✅     | Working, used in detail dialog.                                         |
| Delete pengiriman      | `/api/pengiriman/:id`                | DELETE | id                                              | success bool                  | same                                                                   | ✅     | Implemented with confirmation dialog (PENDING status only).             |

## DRIVER

| Flow                | Endpoint                                    | Method | Request Highlights | Response Highlights      | Module(s)                                                                             | Status | Notes                                            |
| ------------------- | ------------------------------------------- | ------ | ------------------ | ------------------------ | ------------------------------------------------------------------------------------- | ------ | ------------------------------------------------ |
| Assigned deliveries | `/api/driver/pengiriman`                    | GET    | bearer token       | deliveries array         | `features/driver/screens/my_deliveries_screen.dart`, `utils/http/driver_service.dart` | ✅     | Already used in list.                            |
| Delivery detail     | `/api/pengiriman/:id`                       | GET    | id                 | delivery detail          | same modules                                                                          | 🟡     | Ensure detail view uses API instead of mock.     |
| Scan at pickup      | `/api/pengiriman/:qrCodeId/scan-driver`     | POST   | qrCodeId           | updated status `DIAMBIL` | `driver_service.dart`, `qr_scanner_screen.dart`                                       | 🟡     | Endpoint hooked; add robust feedback + cooldown. |
| Delivery history    | `/api/pengiriman` with driver filter (TODO) | GET    | query params?      | historical deliveries    | `delivery_history_screen.dart`                                                        | 🔴     | Need confirm backend filter; implement list.     |

## PIC_SEKOLAH (School Manager)

| Flow                  | Endpoint                                  | Method | Request Highlights   | Response Highlights  | Module(s)                        | Status | Notes                                         |
| --------------------- | ----------------------------------------- | ------ | -------------------- | -------------------- | -------------------------------- | ------ | --------------------------------------------- |
| School profile        | `/api/sekolah/:id`                        | GET    | sekolahId            | SekolahModel         | `sekolah_controller.dart`        | 🟡     | Ensure controller caches data.                |
| Update school         | `/api/sekolah/:id`                        | PUT    | name, address        | updated school       | `sekolah_management_screen.dart` | 🔴     | UI pending.                                   |
| Class list            | `/api/sekolah/:id/kelas`                  | GET    | sekolahId            | kelas array          | `kelas_management_screen.dart`   | ✅     | Implemented with UserController sekolahId.    |
| Create class          | `/api/sekolah/:id/kelas`                  | POST   | nama, tingkat        | KelasModel           | same                             | ✅     | Fully functional CRUD.                        |
| Update class          | `/api/kelas/:id`                          | PUT    | nama, tingkat        | KelasModel           | same                             | ✅     | Edit dialog working.                          |
| Delete class          | `/api/kelas/:id`                          | DELETE | id                   | success              | same                             | ✅     | Confirmation dialog implemented.              |
| Student list (school) | `/api/sekolah/:id/siswa`                  | GET    | sekolahId            | siswa array          | `siswa_management_screen.dart`   | ✅     | Implemented.                                  |
| Student list (class)  | `/api/kelas/:id/siswa`                    | GET    | kelasId              | filtered list        | same                             | 🟡     | Ensure selection wiring.                      |
| Create siswa          | `/api/sekolah/:id/siswa`                  | POST   | form-data + foto     | SiswaModel           | same                             | ✅     | Done.                                         |
| Delete siswa          | `/api/siswa/:id`                          | DELETE | id                   | success              | same                             | ✅     | Works.                                        |
| Add alergi            | `/api/siswa/:id/alergi`                   | POST   | namaAlergi           | AlergiModel          | allergies UI                     | 🔴     | Methods exist, need UI integration.           |
| Get alergi list       | `/api/siswa/:id/alergi`                   | GET    | siswaId              | alergi array         | same                             | 🔴     | ...                                           |
| Delete alergi         | `/api/alergi/:id`                         | DELETE | id                   | success              | same                             | 🔴     | Service uses flat route.                      |
| Attendance list       | `/api/kelas/:id/absensi`                  | GET    | class id             | records              | `absensi_screen.dart`            | ✅     | Completed.                                    |
| Create attendance     | `/api/kelas/:id/absensi`                  | POST   | tanggal, jumlahHadir | AbsensiModel         | same                             | ✅     | Completed.                                    |
| Total attendance      | `/api/sekolah/:id/absensi/total/:tanggal` | GET    | path date            | summary              | same                             | ✅     | Completed.                                    |
| Menu view             | `/api/sekolah/:id/menu-planning`          | GET    | sekolahId            | menus                | `menu_view_screen.dart`          | ✅     | Read-only list view complete.                 |
| Receive delivery      | `/api/pengiriman/:qrCodeId/scan-sekolah`  | POST   | qrCodeId             | status -> `DITERIMA` | `receive_delivery_screen.dart`   | ✅     | Scanner implemented; add detail view.         |
| Delivery history      | `/api/sekolah/:id/pengiriman`             | GET    | sekolahId            | deliveries           | `delivery_history_screen.dart`   | ✅     | List with filters and detail dialog complete. |
| Calendar list         | `/api/kalender-akademik`                  | GET    | optional filters     | calendar events      | `kalender_akademik_screen.dart`  | ✅     | Shared from dapur folder, full CRUD exists.   |
| Add calendar entry    | `/api/kalender-akademik`                  | POST   | tanggal, keterangan  | event                | same                             | ✅     | ...                                           |
| Update calendar       | `/api/kalender-akademik/:id`              | PUT    | tanggal, keterangan  | event                | same                             | ✅     | ...                                           |
| Delete calendar       | `/api/kalender-akademik/:id`              | DELETE | id                   | success              | same                             | ✅     | ...                                           |

## Shared Infrastructure

| Concern             | Endpoint(s)                                               | Module(s)                                                   | Status | Notes                                                 |
| ------------------- | --------------------------------------------------------- | ----------------------------------------------------------- | ------ | ----------------------------------------------------- |
| Image upload        | `/api/upload/image`                                       | `utils/http/dapur_service.dart`, `.../sekolah_service.dart` | ✅     | Helper uses multipart + bearer auth.                  |
| Ticketing           | `/api/tickets` etc.                                       | (none)                                                      | 🔴     | No UI yet; low priority for role apps.                |
| Pagination metadata | Most list endpoints wrap `{data: {data: [], pagination}}` | Services parse inner `data`                                 | 🟡     | Ensure controllers handle pagination for large lists. |

## Immediate Action Items

1. ✅ ~~Confirm endpoint for assigned kitchens and align `DapurController.loadAssignedDapur`~~ - Working with user.dapurAsPIC
2. ✅ ~~Build Pengiriman management UI: creation form, list, QR render~~ - Completed with dapur-scoped filtering
3. ✅ ~~Complete school-side management screens~~ - Kelas CRUD, Menu view, Delivery history all implemented
4. 🔄 **Validate backend**: Confirm `/api/pengiriman` accepts `dapurId` query param and POST body
5. 🔄 **Test stok adjustments**: Verify backend accepts `dapurId` in createStok payload
6. � **Add alergi UI**: Integrate existing allergy API methods into siswa management screen (detail dialog with chips)
7. 🔴 **Build delivery history for DRIVER**: Show completed deliveries with date filters
8. 🔴 **Add delivery history tab for PIC_DAPUR**: Historical view in pengiriman screen
9. 🔴 **Ensure drawer navigation**: Verify all role screens accessible via drawer (not just nav bar for SUPERADMIN)

Update this matrix as endpoints are integrated and validated.
