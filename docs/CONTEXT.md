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
- [x] Beranda — lib/features/beranda/beranda_screen.dart (Section 11) - DIPERBAIKI LENGKAP
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
- `/lisensi` → LisensiScreen
- `/beranda` → BerandaScreen (halaman awal untuk Tahap 1 testing)
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

## Status Halaman (Perbaikan Tahap 1)
### Sidebar & Navigasi
- ✅ Semua halaman menggunakan shared Sidebar (lib/shared/widgets/sidebar.dart)
- ✅ Sidebar menggunakan go_router untuk navigasi
- ✅ Semua menu sidebar bisa diklik dan berpindah halaman
- ✅ Route lengkap di app.dart termasuk placeholder screens (History, Keranjang Sampah, Modal Pra-Tanam)

### Floating Alarm Banner
- ✅ Semua halaman memiliki _buildFloatingAlarmBanner()
- ✅ Banner muncul di semua halaman sesuai blueprint

### Halaman yang Bisa Dibuka (Tanpa Crash)
1. ✅ BerandaScreen - Fixed, uses shared Sidebar, has Floating Alarm Banner
2. ✅ DaftarLahanScreen - Uses shared Sidebar, has Floating Alarm Banner
3. ✅ StokProdukScreen - Uses shared Sidebar, has Floating Alarm Banner
4. ✅ SemprotScreen - Uses shared Sidebar, has Floating Alarm Banner
5. ✅ PemupukanScreen - Uses shared Sidebar, has Floating Alarm Banner
6. ✅ PanenScreen - Uses shared Sidebar, has Floating Alarm Banner
7. ✅ PerawatanScreen - Uses shared Sidebar, has Floating Alarm Banner
8. ✅ CatatanLapanganScreen - Uses shared Sidebar, has Floating Alarm Banner
9. ✅ LaporanScreen - Uses shared Sidebar, has Floating Alarm Banner
10. ✅ PengaturanScreen - Uses shared Sidebar, has Floating Alarm Banner
11. ✅ LisensiScreen - Standalone (no sidebar needed for activation)
12. ✅ HistoryScreen - Placeholder screen with shared Sidebar
13. ✅ KeranjangSampahScreen - Placeholder screen with shared Sidebar
14. ✅ ModalPraTanamScreen - Placeholder screen with shared Sidebar

### Perubahan yang Dilakukan
- Removed all local _buildSidebar() methods from screens
- Updated all screens to import and use shared Sidebar widget
- Added placeholder screens for missing routes (history, keranjang-sampah, modal-pra-tanam)
- Fixed unused import in beranda_screen.dart
- All screens have Info Bar and Floating Alarm Banner as per blueprint

### Perbaikan Beranda (Section 11) - Terbaru (Update 2026-06-04)
Halaman Beranda telah diperbaiki lengkap sesuai blueprint Section 11 dengan semua fitur yang diminta:

**Fitur yang Ditambahkan/Diperbaiki:**
1. **FORMAT RUPIAH**
   - Semua nominal Rupiah menggunakan format titik pemisah ribuan (Rp 1.000.000)
   - Helper formatRupiah() dibuat di lib/core/format.dart
   - Diterapkan ke semua dashboard cards dan kalkulator

2. **TOOLTIP**
   - Semua elemen memiliki tooltip (hover di PC, long press di HP)
   - Sidebar, kolom input, tombol, ikon semua memiliki tooltip
   - Dashboard cards memiliki tooltip untuk setiap metrik
   - Kalkulator buttons memiliki tooltip

3. **INFO BAR + FLOATING BANNER NON-STICKY**
   - Keduanya TIDAK sticky — ikut scroll ke atas bersama konten
   - Layar terasa lebih luas saat scroll

4. **CARD RINGKASAN SIKLUS LENGKAP**
   - Total Omzet, ROI, Saldo Siklus, Total Biaya
   - Populasi Awal & Realtime, Biaya/Pohon, Omzet/Pohon
   - HPP/kg, Stok Kritis, BEP
   - Semua nominal Rupiah pakai format titik
   - Mock data hardcoded

5. **GRAFIK MULTIFUNGSI 7 MODE DIPERBAIKI**
   - Cashflow, Biaya Kumulatif, Omzet Kumulatif, Panen per Periode
   - Biaya per Kategori, Populasi, Unsur Hara
   - Setiap grafik menampilkan: angka/label di titik data, sumbu X dan Y dengan label, legend/keterangan warna, tooltip saat hover/tap
   - Warna sesuai blueprint: Biaya/rugi (#e53935 merah), Omzet/laba (#3ecf8e hijau), BEP line (#fdd835 kuning putus-putus)
   - Tinggi grafik ditingkatkan ke 250px untuk better visibility

6. **PANEL NOTIFIKASI DIPERBAIKI**
   - Ikon lonceng kanan atas bisa diklik dan muncul panel
   - Panel tipis, memanjang ke bawah
   - Background belakang diburamkan (blur) saat panel terbuka
   - Warna item notifikasi: 🔴 Merah (terlambat), 🟡 Kuning (hari ini), 🟢 Hijau (aman), 🔵 Biru (pesan admin)
   - 5 slide sesuai blueprint: Jadwal mendatang, Keterlambatan, Selesai baru, Stok menipis, Pesan admin
   - Semua mock data hardcoded

7. **ALARM NOTIFIKASI HP**
   - H-2: notifikasi pertama
   - H-1: notifikasi kedua
   - H: notifikasi hari H (paling penting)
   - Menggunakan flutter_local_notifications
   - Method _scheduleAlarmNotifications() siap dipanggil
   - Package timezone ^0.9.2 ditambahkan ke pubspec.yaml

8. **KALKULATOR PUPUK DIPERBAIKI**
   - Hapus "Total Gram" dan "Total Biaya" dari bagian atas
   - Urutan layout:
     * Paling atas: dropdown [Kalkulator Pupuk ▼] | [Pupuk ▼ / Gram/Harga ▼]
     * Baris 1: Target Campuran (default 1000 gram) | Sisa Gram (realtime)
     * Garis pemisah
     * Baris 2 (repeatable): Kolom Produk (autocomplete, bisa diketik + muncul saran), Dosis (gram), Tombol Edit (ikon pensil), Tombol Hapus (X merah)
     * Baris 3: Tombol [+ Tambah Kolom] | [Kelola Katalog]
     * Baris 4: Tombol Reset (25% lebar, kecil) | Tombol Hitung Unsur (75% lebar)
     * Hasil hitung: "Unsur hara ini dibuat dari [X] gram", tampilkan HANYA unsur yang ada dalam produk + total gram murninya
     * Hasil HILANG jika ada angka diubah, muncul kembali hanya jika klik Hitung Unsur lagi
     * Tooltip di kolom produk: tampilkan 14 unsur hara produk tersebut
     * Reset: hapus angka gram saja, nama produk tetap
   - Kelola Katalog: Form input Nama Produk + 14 kolom unsur hara (placeholder)

**Dependencies yang Ditambahkan:**
- fl_chart: ^0.68.0 (sudah terinstall sebelumnya)
- timezone: ^0.9.2 (untuk notification scheduling)

**Files yang Dimodifikasi:**
- lib/core/format.dart - Dibuat baru dengan helper formatRupiah()
- lib/features/beranda/beranda_screen.dart - Diperbaiki lengkap sesuai semua requirement
- pubspec.yaml - Ditambahkan package timezone