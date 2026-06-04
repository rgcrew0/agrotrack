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

### BELUM
- [ ] Stok & Notif Produk — lib/features/stok_produk/stok_produk_screen.dart (Section 15)
- [ ] Semprot — lib/features/semprot/semprot_screen.dart (Section 13)
- [ ] Pemupukan — lib/features/pemupukan/pemupukan_screen.dart (Section 14)
- [ ] Panen — lib/features/panen/panen_screen.dart (Section 16)
- [ ] Perawatan — lib/features/perawatan/perawatan_screen.dart (Section 17)
- [ ] Catatan Lapangan — lib/features/catatan_lapangan/catatan_lapangan_screen.dart (Section 18)
- [ ] Laporan — lib/features/laporan/laporan_screen.dart (Section 19)
- [ ] Pengaturan — lib/features/pengaturan/pengaturan_screen.dart (Section 21)
- [ ] Aktivasi Lisensi — lib/features/lisensi/lisensi_screen.dart (Section 22)

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