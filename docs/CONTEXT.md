# AgroTrack v4.0 — Progress & Context

## Repo
GitHub: https://github.com/rgcrew0/agrotrack.git
Blueprint: docs/agrotrack_blueprint_v4.md
Rules: .devin/rules.md

## Cara Melanjutkan (untuk AI baru)
1. Baca docs/agrotrack_blueprint_v4.md
2. Baca .devin/rules.md
3. Cek checklist di bawah — lanjutkan halaman yang belum [x]
4. Setiap halaman selesai, update checklist ini
5. Stack: Flutter, Drift, Riverpod, go_router, fl_chart, Supabase
6. Dark mode default, semua halaman wajib ada Info Bar + Floating Alarm Banner

## Tahap Sekarang: TAHAP 1 (Visual Mock Data)
Belum ada koneksi database atau API. Semua data hardcoded.

## Checklist Halaman

### SELESAI
- [x] Beranda — lib/features/beranda/beranda_screen.dart (Section 11)
- [x] Daftar Lahan — lib/features/daftar_lahan/daftar_lahan_screen.dart (Section 12)
- [x] Stok & Notif Produk — lib/features/stok_produk/stok_produk_screen.dart (Section 13)
- [x] Semprot — lib/features/semprot/semprot_screen.dart (Section 14)
- [x] Pemupukan — lib/features/pemupukan/pemupukan_screen.dart (Section 15)
- [x] Panen — lib/features/panen/panen_screen.dart (Section 16)
- [x] Perawatan — lib/features/perawatan/perawatan_screen.dart (Section 17)
- [x] Catatan Lapangan — lib/features/catatan_lapangan/catatan_lapangan_screen.dart (Section 18)
- [x] Laporan — lib/features/laporan/laporan_screen.dart (Section 19)
- [x] Pengaturan — lib/features/pengaturan/pengaturan_screen.dart (Section 21)
- [x] Aktivasi Lisensi — lib/features/lisensi/lisensi_screen.dart (Section 22)

### BELUM

## Perintah Task Siap Pakai

### Stok & Notif Produk
Baca docs/agrotrack_blueprint_v4.md dan .devin/rules.md sebelum mulai.
Task: Buat halaman Stok & Notif Produk (lib/features/stok_produk/stok_produk_screen.dart)
Ikuti Section 15 blueprint. Mock data hardcoded, belum perlu database.
Pastikan ada Info Bar dan Floating Alarm Banner. Dark mode default.
Setelah selesai update docs/CONTEXT.md tandai halaman ini sebagai [x].

### Semprot
Baca docs/agrotrack_blueprint_v4.md dan .devin/rules.md sebelum mulai.
Task: Buat halaman Semprot (lib/features/semprot/semprot_screen.dart)
Ikuti Section 13 blueprint. Mock data hardcoded, belum perlu database.
Pastikan ada Info Bar, Floating Alarm Banner, dan peringatan FRAC/IRAC. Dark mode default.
Setelah selesai update docs/CONTEXT.md tandai halaman ini sebagai [x].

### Pemupukan
Baca docs/agrotrack_blueprint_v4.md dan .devin/rules.md sebelum mulai.
Task: Buat halaman Pemupukan (lib/features/pemupukan/pemupukan_screen.dart)
Ikuti Section 14 blueprint. Mock data hardcoded, belum perlu database.
Pastikan ada Info Bar dan Floating Alarm Banner. Dark mode default.
Setelah selesai update docs/CONTEXT.md tandai halaman ini sebagai [x].

### Panen
Baca docs/agrotrack_blueprint_v4.md dan .devin/rules.md sebelum mulai.
Task: Buat halaman Panen (lib/features/panen/panen_screen.dart)
Ikuti Section 16 blueprint. Mock data hardcoded, belum perlu database.
Pastikan ada Info Bar dan Floating Alarm Banner. Dark mode default.
Setelah selesai update docs/CONTEXT.md tandai halaman ini sebagai [x].

### Perawatan
Baca docs/agrotrack_blueprint_v4.md dan .devin/rules.md sebelum mulai.
Task: Buat halaman Perawatan (lib/features/perawatan/perawatan_screen.dart)
Ikuti Section 17 blueprint. Mock data hardcoded, belum perlu database.
Pastikan ada Info Bar dan Floating Alarm Banner. Dark mode default.
Setelah selesai update docs/CONTEXT.md tandai halaman ini sebagai [x].

### Catatan Lapangan
Baca docs/agrotrack_blueprint_v4.md dan .devin/rules.md sebelum mulai.
Task: Buat halaman Catatan Lapangan (lib/features/catatan_lapangan/catatan_lapangan_screen.dart)
Ikuti Section 18 blueprint. Mock data hardcoded, belum perlu database.
Pastikan ada Info Bar dan Floating Alarm Banner. Dark mode default.
Setelah selesai update docs/CONTEXT.md tandai halaman ini sebagai [x].

### Laporan
Baca docs/agrotrack_blueprint_v4.md dan .devin/rules.md sebelum mulai.
Task: Buat halaman Laporan (lib/features/laporan/laporan_screen.dart)
Ikuti Section 19 blueprint. Mock data hardcoded, belum perlu database.
Pastikan ada Info Bar dan Floating Alarm Banner. Dark mode default.
Setelah selesai update docs/CONTEXT.md tandai halaman ini sebagai [x].

### Pengaturan
Baca docs/agrotrack_blueprint_v4.md dan .devin/rules.md sebelum mulai.
Task: Buat halaman Pengaturan (lib/features/pengaturan/pengaturan_screen.dart)
Ikuti Section 21 blueprint. Mock data hardcoded, belum perlu database.
Pastikan ada Info Bar dan Floating Alarm Banner. Dark mode default.
Setelah selesai update docs/CONTEXT.md tandai halaman ini sebagai [x].

### Aktivasi Lisensi
Baca docs/agrotrack_blueprint_v4.md dan .devin/rules.md sebelum mulai.
Task: Buat halaman Aktivasi Lisensi (lib/features/lisensi/lisensi_screen.dart)
Ikuti Section 22 blueprint. Tampilan saja tanpa koneksi Supabase.
Form: Nama + Kota + Key (TSM-XXXX). Dark mode default.
Setelah selesai update docs/CONTEXT.md tandai halaman ini sebagai [x].

## Catatan Penting
- Timestamp SELALU dalam detik (BUG 2)
- Guard divide-by-zero sebelum semua operasi bagi (BUG 6)
- Flutter TIDAK BOLEH akses tabel licenses langsung
- Lisensi via Supabase RPC activate_license() — format key TSM-0001

## Routing & Navigasi
### Setup Selesai
- **lib/main.dart**: Entry point dengan ProviderScope (Riverpod)
- **lib/app.dart**: MaterialApp.router dengan go_router configuration
- **lib/shared/widgets/sidebar.dart**: Sidebar navigasi dengan menu ke semua halaman

### Route Configuration (go_router)
- `/lisensi` → LisensiScreen (halaman awal)
- `/beranda` → BerandaScreen
- `/daftar-lahan` → DaftarLahanScreen
- `/stok-produk` → StokProdukScreen
- `/semprot` → SemprotScreen
- `/pemupukan` → PemupukanScreen
- `/panen` → PanenScreen
- `/perawatan` → PerawatanScreen
- `/catatan-lapangan` → CatatanLapanganScreen
- `/laporan` → LaporanScreen
- `/pengaturan` → PengaturanScreen

### Dependencies Terinstall
- flutter_riverpod: ^2.4.9 (State management)
- go_router: ^13.0.0 (Routing)
- supabase_flutter: ^2.3.4 (Supabase integration)
- flutter_secure_storage: ^9.0.0 (Secure storage)
- device_info_plus: ^10.0.1 (Device info)
- flutter_local_notifications: ^17.0.0 (Local notifications)
- local_auth: ^2.1.8 (Biometrics)
- dio: ^5.4.0 (HTTP client)
- fl_chart: ^0.68.0 (Charts)
- excel: ^4.0.3 (Excel export)
- pdf: ^3.10.7 (PDF generation)
- printing: ^5.11.1 (PDF printing)
- share_plus: ^9.0.0 (Share functionality)
- file_picker: ^8.0.0 (File picker)
- path_provider: ^2.1.1 (Path provider)
- url_launcher: ^6.2.2 (URL launcher)
- intl: ^0.19.0 (Internationalization)
- screenshot: ^2.1.0 (Screenshot)

### Catatan Run
- Flutter analyze: No errors (hanya lint warnings)
- Flutter run: Memerlukan Developer Mode di Windows (system requirement)
- Code sudah siap untuk dijalankan setelah enable Developer Mode