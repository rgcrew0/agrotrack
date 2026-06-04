==============================================================================
BLUEPRINT AGROTRACK v4.0 — FLUTTER EDITION
Sistem Cerdas Siklus Tani | Versi Aplikasi 1.0
Panduan otoritatif untuk AI developer (Flutter/Dart).
Ikuti setiap aturan. Jika ada konflik antar section, RULE 0 yang menang.
Dibuat untuk: Cursor AI, Claude, GPT, Gemini, atau AI apapun.
==============================================================================
CHANGELOG v4.0 (dari blueprint v3.0):
  LISENSI — DIGANTI TOTAL:
    - Sistem lisensi lama (Google Sheets + GAS + WhatsApp flow + polling) DIHAPUS SELURUHNYA
    - Sistem lisensi baru: Supabase (tabel "licenses" + RPC activate_license())
    - Format key baru: TSM-0001, TSM-0002, dst.
    - Status baru: ready | active | blocked
    - Aktivasi: user input Nama + Kota + Key → RPC Supabase → simpan token lokal
    - 1 key = 1 perangkat (berdasarkan device_id)
    - Install ulang device sama: diizinkan otomatis
    - Ganti HP: admin reset manual di panel admin (device_id=null, status=ready)
    - Setelah aktif: token terenkripsi di flutter_secure_storage, offline selamanya
    - Tidak ada verifikasi harian/bulanan, tidak ada grace period, tidak ada polling
    - RLS aktif: Flutter TIDAK BOLEH akses tabel licenses langsung (hanya via RPC)
    - Jangan gunakan service_role key di aplikasi
    - Panel admin: cari nama/kota/key, lihat status, reset device, generate key, block/unblock
    - product_version di tabel licenses: v1 untuk semua lisensi awal, upgrade berbayar = version baru
    - Notifikasi admin via GAS dihapus (akan dihandle Supabase di versi berikutnya)
    - Tabel lisensi lokal (SQLite): diperbarui strukturnya sesuai field baru
    - Halaman aktivasi: form Nama + Kota + Key, tanpa WA flow, tanpa polling
  TIDAK ADA PERUBAHAN LAIN (semua fitur v3 tetap sama)

CHANGELOG v3.0 (dari blueprint v2.0):
  LISENSI:
    - Verifikasi bulanan DIHAPUS — 1 key = 1 device = selamanya aktif
    - Tidak ada verifikasi ulang berkala (tidak 30 hari, tidak harian)
    - Grace period offline tetap 30 hari tapi HANYA untuk banner peringatan, tidak lock app
    - Tidak ada celah bypass offline: aktivasi hanya bisa online 1x via WA → GAS
    - Setelah aktif, tidak ada polling/re-check kecuali status='dicabut' dari GAS
  UI / HALAMAN:
    - TIAP HALAMAN WAJIB tampilkan HST, Tanggal, ID Lahan di header/info bar
    - Halaman input (form): kolom HST, Tanggal, ID Lahan wajib ada dan berhubungan dgn tanaman/siklus
    - Notifikasi melayang (floating banner) di atas tiap halaman:
        Baris 1: "Semprot Pupuk Daun — X hari lagi" (hitung mundur realtime)
        Baris 2: "Semprot Obat — X hari lagi"
        Settingan interval dua alarm ini TERPISAH
    - Peringatan Resistensi Obat FRAC/IRAC di halaman Semprot Daun (bukan hanya Laporan)
    - Halaman Perawatan: diperlengkap (aktivitas, notifikasi, ID Lahan, catatan kejadian)
    - Halaman Stok & Notif Produk: total harga real, input/output/penggunaan realtime via dropdown
  DATABASE:
    - biaya_pembukaan: kolom lengkap (lihat Section 6)
    - pra_tanam_draft: sesuai skema (semua kolom modal pra-tanam ada di halaman modal)
    - Tabel produk: bisa disimpan di SQLite lokal MAUPUN Supabase
    - Produk dropdown di semua halaman yang menggunakan biaya
  KALKULATOR:
    - Dashboard: Kalkulator Pupuk Bebas (tanpa stok gudang) + Kalkulator Gram/Harga
    - Halaman Pemupukan: Kalkulator mengikuti stok gudang (real pengeluaran)
    - Tambah daftar produk di Dashboard (tanpa koneksi stok gudang), ada SQLite + Supabase
    - Dropdown produk di semua kalkulator
  SINKRONISASI & BACKUP:
    - Sinkronisasi lokal (backup ke file .agrotrack) JELAS tata letaknya
    - Sinkronisasi Supabase JELAS tata letaknya
    - Import/Ekspor: ada tombol Import dari lokal, Ekspor ke lokal, Import dari Supabase, Ekspor ke Supabase
    - Sinkronisasi otomatis: 2 opsi terpisah — otomatis lokal & otomatis Supabase
    - Tooltip di semua tombol backup/sync agar jelas fungsinya
  DAFTAR LAHAN:
    - Tombol "Tutup Siklus" ada di halaman Daftar Lahan (per card lahan)
    - Saat tutup siklus: peringatan wajib backup ke lokal dan Supabase
    - Perbaikan sinkronisasi saat tutup siklus agar tidak error
  PENGATURAN:
    - Riwayat semua ID Lahan yang pernah digunakan (tidak bisa dihapus) — info saja
    - Tersinkronisasi dengan lokal, Supabase, dan SQLite
    - Tombol sinkronisasi manual lokal + Supabase di Pengaturan
    - Tombol sinkronisasi otomatis lokal + Supabase (toggle terpisah)
  LAPORAN:
    - Ekspor laporan bisa dari awal buka lahan ATAU custom range tanggal
    - Pilih tanggal awal–akhir laporan bebas (tidak harus dari awal siklus)
  NOTIFIKASI PUSH HP:
    - Gunakan Supabase Realtime atau flutter_local_notifications terjadwal untuk notif di HP
    - Notif admin dari GAS pull tetap ada (v3, dihapus di v4)
  BUG FIXES v3:
    - Section 12 Daftar Lahan: diperbaiki agar sinkronisasi manual/otomatis tidak error
    - Section 17 Perawatan: diperlengkap
    - Section 21 Pengaturan: diperlengkap sinkronisasi & riwayat lahan
==============================================================================

==============================================================================
RULE 0: BUG KRITIS — WAJIB DIIMPLEMENTASI SEBELUM FITUR LAIN
==============================================================================

BUG 1 — SEED DATA: produkId harus diambil dari hasil INSERT, bukan asumsi
  SALAH: for produk in SEED { db.insert(produk); db.insert(notif, produkId: ???); }
  BENAR:
    for (final produk in SEED_PRODUK) {
      final produkId = await db.into(db.produk).insert(ProdukCompanion(...));
      for (final aktivitas in ['semprot_obat','semprot_pupuk','pemupukan','panen','perawatan']) {
        await db.into(db.notifikasiProduk).insert(
          NotifikasiProdukCompanion(produkId: Value(produkId), aktivitas: Value(aktivitas), hariSebelum: Value(2), isActive: Value(true))
        );
      }
      final batasMin = max((produk.stokGram * 0.1).round(), 1000);
      await db.into(db.batasStokProduk).insert(BatasStokProdukCompanion(produkId: Value(produkId), batasMinimalGram: Value(batasMin)));
    }

BUG 2 — TIMESTAMP: SEMUA timestamp disimpan dalam DETIK (bukan milidetik)
  Helper wajib (lib/core/timestamp.dart):
    int nowSec() => DateTime.now().millisecondsSinceEpoch ~/ 1000;
    int msToSec(int ms) => ms ~/ 1000;
    int secToMs(int s) => s * 1000;
    int hariKeDetik(int hari) => hari * 86400;
    int detikKeHari(int detik, int ref) => ((detik - ref) / 86400).round();
    // round: 0=hari ini, <0=telat, >0=hari ke depan
  JANGAN simpan DateTime.now().millisecondsSinceEpoch ke DB tanpa dibagi 1000.

BUG 3 — UNIQUE CONSTRAINT: Tabel berikut WAJIB punya UNIQUE constraint:
  notifikasi_produk: UNIQUE(produk_id, aktivitas)
  batas_stok_produk: UNIQUE(produk_id)
  jadwal_notifikasi_produk: UNIQUE(produk_id, aktivitas, siklus_id)

BUG 4 — jadwalkanNotifikasiProduk: hanya proses semprot dan pemupukan
  Dart guard:
    Future<void> jadwalkanNotif(String aktivitas, ...) async {
      if (!['semprot_obat','semprot_pupuk','pemupukan'].contains(aktivitas)) return;
      ...
    }

BUG 5 — TIPE TRANSAKSI STOK: CHECK constraint wajib ada
  tipe_transaksi TEXT CHECK(tipe_transaksi IN ('beli','pakai','koreksi_tambah','koreksi_kurang','kedaluwarsa'))
  Setiap produk dipakai di semprot/pemupukan → INSERT transaksi_stok tipe='pakai', jumlah_gram NEGATIF.

BUG 6 — DIVIDE BY ZERO: selalu guard sebelum bagi
  final biayaPerPohon = populasiHidup > 0 ? totalBiaya / populasiHidup : 0;
  final totalStok = stokLama + jumlahBaru;
  final hargaBaru = totalStok > 0 ? ((stokLama * hargaLama) + (jumlahBaru * hargaBeli)) / totalStok : hargaBeli;
  final omzetPerPohon = populasiHidup > 0 ? totalOmzetKumulatif / populasiHidup : 0;

BUG 7 — Tidak berlaku di Flutter (Capacitor-specific, skip)

BUG 8 — NOTIFIKASI MENUMPUK: cek duplikat sebelum insert notifikasi_aktivitas
  final ada = await (db.select(db.notifikasiAktivitas)
    ..where((t) => t.targetIdReferensi.equals(idRef) & t.tanggalNotif.equals(tglNotif) & t.isDibaca.equals(false))
  ).get();
  if (ada.isEmpty) { /* lanjut insert */ }

BUG 9 — NOTIFIKASI LAMA: query jadwal_notifikasi_produk pakai window waktu
  WHERE tanggal_notif BETWEEN (nowSec - 7*86400) AND (nowSec + 3*86400) AND is_done = 0

BUG 10 — FK INDEX: wajib ada
  CREATE INDEX idx_tenaga_kerja ON detail_tenaga_kerja(tipe_aktivitas, aktivitas_id);

BUG 11 — SATUAN PERSEN: kolom *_persen disimpan dalam x10000 (persen × 10000)
  n_persen = 460000 artinya N = 46.0%
  Konversi: persen = nilaiDB / 10000; gramUnsur = (nilaiDB / 1000000) * totalGram
  Tambahkan komentar di konstanta.dart:
    // *_persen di tabel produk = persen × 10000
    // Contoh: n_persen=460000 → N=46%. Rumus: persen=nilai/10000, gram=(nilai/1000000)*totalGram

BUG 12 — STATUS AKTIVITAS: tambahkan is_selesai + selesai_pada ke aktivitas
  Kolom wajib di tabel semprot, pemupukan, perawatan:
    is_selesai INTEGER DEFAULT 0
    selesai_pada INTEGER  -- epoch detik
  Panen: is_selesai DEFAULT 1 (langsung selesai saat dicatat)
  Query notifikasi slide 3: WHERE is_selesai = 1 AND selesai_pada >= nowSec - (48*3600)

BUG 13 — INSERT OR REPLACE NOTIF: hapus notif lama SEBELUM replace jadwal
  await (db.delete(db.notifikasiAktivitas)
    ..where((t) => t.targetIdReferensi.isIn(
      db.selectOnly(db.jadwalNotifikasiProduk)
        ..addColumns([db.jadwalNotifikasiProduk.id])
        ..where((j) => j.produkId.equals(produkId) & j.aktivitas.equals(aktivitas) & j.siklusId.equals(siklusId))
    ))
  ).go();
  // BARU kemudian INSERT OR REPLACE ke jadwal_notifikasi_produk

BUG 14 — softDelete: whitelist tabel wajib
  const TABEL_SOFTDELETE = ['semprot','pemupukan','panen','perawatan','catatan_lapangan',
    'aset','biaya_pembukaan','siklus','produk','pra_tanam_draft','modal_awal'];
  Future<void> softDelete(String tabel, Map<String,dynamic> baris) async {
    if (!TABEL_SOFTDELETE.contains(tabel)) throw Exception('Tabel tidak diizinkan: $tabel');
    final exp = nowSec() + 2592000; // 30 hari
    await db.into(db.keranjangSampah).insert(KeranjangSampahCompanion(
      tabelAsal: Value(tabel), barisIdAsal: Value(baris['id']),
      dihapusPada: Value(nowSec()), kadaluarsaPada: Value(exp),
      dataJson: Value(jsonEncode(baris))
    ));
    await db.customStatement('DELETE FROM $tabel WHERE id = ?', [baris['id']]);
  }

BUG 15 — OMZET PER POHON divide by zero: sudah di BUG 6

BUG 16 — BEP CARD "KURANG Rp X": rumus wajib ada
  final sudahTercapai = totalGramPanen >= bepGram;
  final selisihGram = max(0, bepGram - totalGramPanen);
  final kurangRp = hargaJualRataRata > 0 ? (selisihGram * hargaJualRataRata / 1000).round() : 0;
  // Tampil: sudahTercapai ? "✓ BEP Tercapai" (hijau) : "Belum – kurang Rp $kurangRp" (merah)

BUG 17 — TUTUP SIKLUS: wajib paksa backup sebelum ubah status
  Future<void> tutupSiklus(int siklusId) async {
    // 1. Cek backup lokal terakhir < 1 jam → tampilkan dialog paksa backup
    // 2. Dialog: "Backup ke HP dulu sebelum tutup siklus?"
    //    [Backup Sekarang] [Lanjut Tanpa Backup (tidak disarankan)]
    // 3. Jika ada Supabase aktif: juga prompt sync ke Supabase
    // 4. Setelah backup/sync atau user pilih lanjut: UPDATE siklus SET status='selesai'
  }

BUG 18 — SINKRONISASI: cek konflik sebelum push ke Supabase
  Saat sinkronisasi manual/otomatis ke Supabase:
    - Bandingkan updated_at lokal vs updated_at di Supabase
    - Jika Supabase lebih baru: tanya user "Data di cloud lebih baru. Pakai yang mana?"
    - Default: pakai lokal (overwrite cloud) jika tidak ada respon dalam 10 detik

==============================================================================
SECTION 1: TECH STACK & DEPENDENCIES
==============================================================================
Framework   : Flutter (Dart)
Min SDK     : Android 8.0 (API 26)
Target SDK  : Android 35
Database    : SQLite via drift (^2.x)
State Mgmt  : Riverpod (flutter_riverpod ^2.x)
Routing     : go_router (^13.x)
Charts      : fl_chart (^0.68.x)
HTTP        : dio (^5.x) — untuk HTTP calls umum (GAS license endpoint DIHAPUS di v4)
Supabase    : supabase_flutter (^2.x) — WAJIB (untuk lisensi + BYO sync data)
Notifikasi  : flutter_local_notifications (^17.x)
Biometrik   : local_auth (^2.x)
Device ID   : device_info_plus (^10.x)
Export      : excel (^4.x) — Excel generation
PDF Export  : pdf (^3.x) + printing (^5.x)
Share       : share_plus (^9.x)
File Pick   : file_picker (^8.x)
Storage     : path_provider (^2.x)
Secure Store: flutter_secure_storage (^9.x)
URL Launcher: url_launcher (^6.x) — untuk Google Maps link (WA activation dihapus di v4)
Intl        : intl (^0.19.x) — format Rupiah, tanggal Indonesia
Image       : screenshot (^2.x) — render grafik fl_chart ke PNG untuk Excel

BUILD RELEASE:
  flutter build apk --release
  Proguard: aktifkan minifyEnabled + shrinkResources di build.gradle

==============================================================================
SECTION 2: WARNA & TEMA
==============================================================================
MODE GELAP (Default):
  Latar utama           : #2b322d
  Latar kartu           : #44425c
  Garis border          : #57611f
  Teks utama            : #e0e0e0
  Teks sekunder         : #9e9e9e
  Aksen hijau (primer)  : #3ecf8e
  Tombol primer         : bg #3ecf8e, teks #121212
  Tombol sekunder       : bg #2e2e2e, teks #e0e0e0
  Input field           : bg #2a2a2a, border #3a3a3a, focus border #3ecf8e
  Tooltip               : bg #351515, teks #f0f0f0
  Badge merah (telat)   : #e53935
  Badge kuning (hari ini): #fdd835
  Badge biru (admin)    : #1e88e5
  Badge hijau (aman)    : #3ecf8e
  Grafik biaya/rugi     : #e53935
  Grafik omzet/laba     : #3ecf8e
  Grafik BEP line       : #fdd835 (putus-putus)
  Grafik area cashflow  : #3ecf8e dengan opacity 0.15
  Toast sukses          : bg #3ecf8e, teks #121212
  Toast error           : bg #e53935, teks #ffffff
  Toast warning         : bg #fdd835, teks #121212
  Disabled              : opacity 0.38
  Floating banner alarm : bg #1a2a1f, border #3ecf8e, teks #e0e0e0 (2 baris)

MODE TERANG:
  Latar utama           : #99cafb
  Latar kartu           : #ffa1a2
  Garis border          : #a8ff76
  Teks utama            : #000000
  Teks sekunder         : #6c757d
  Aksen hijau           : #2e7d32
  Tombol primer         : bg #2e7d32, teks #ffffff
  Input field           : bg #ffffff, border #ced4da, focus border #2e7d32

KONVENSI FLUTTER:
  ColorScheme.brightness: Brightness.dark / Brightness.light
  Simpan mode di SharedPreferences key 'theme_mode'

==============================================================================
SECTION 3: UKURAN & JARAK
==============================================================================
Sidebar lebar           : 280dp, overlay hitam opacity 50%
Icon hamburger          : 24dp, margin 16dp kiri serta kedip kedip cepat
Icon pencarian + lonceng: 24dp, margin 16dp kanan
Judul halaman           : 24sp bold, padding 16dp semua sisi
Card                    : borderRadius 12dp, padding 16dp, margin bottom 12dp
Label input             : 14sp medium, margin bottom 6dp
Input field             : tinggi 44dp, borderRadius 8dp, padding H 12dp
Icon info (tooltip)     : 18dp, warna hijau aksen, margin left 8dp dari label
Tooltip                 : maxWidth 250dp, padding 8dp, borderRadius 8dp
Tombol simpan           : tinggi 48dp, borderRadius 24dp, lebar penuh, margin top 24dp
Modal konfirmasi        : lebar 85% (max 400dp), borderRadius 16dp, padding 20dp
Toast                   : posisi bottom, margin 16dp, padding 12dp 20dp, borderRadius 40dp
FAB +                   : diameter 56dp, hijau, fixed kanan bawah margin 16dp
Grid 2 kolom form       : dua kolom 1fr 1fr, gap 12dp
Layar < 320dp           : 1 kolom
Panel notifikasi        : maxWidth 300dp, maxHeight 70% layar, borderRadius 12dp
Dashboard card angka    : 28sp bold
Dashboard card label    : 12sp regular #9e9e9e
Dashboard sub-nilai     : 14sp regular
Floating alarm banner   : tinggi auto (2 baris), lebar penuh, padding 8dp 16dp, posisi top sticky di bawah header
  Font alarm            : 12sp, ikon 🌿 (pupuk) dan 💊 (obat)

INFO BAR HALAMAN (wajib tiap halaman — di bawah judul/header):
  Format: [ID Lahan: URTR1] [HST: 45] [Tanggal: 12/06/2025]
  Font: 12sp, warna sekunder (#9e9e9e), background sedikit berbeda dari latar
  Update otomatis dari lahan_aktif_provider

==============================================================================
SECTION 4: STRUKTUR FOLDER FLUTTER
==============================================================================
lib/
  main.dart
  app.dart                        ← MaterialApp + GoRouter + Riverpod
  core/
    database/
      app_database.dart           ← drift database class + 31 tabel
      app_database.g.dart         ← generated (drift codegen)
      migrations.dart             ← runMigrations(db, from, to)
    timestamp.dart                ← nowSec(), msToSec(), hariKeDetik(), dll
    konstanta.dart                ← VERSI_APLIKASI, SUPABASE_LICENSE_URL, SUPABASE_ANON_KEY, warna, dll
                                  -- DIHAPUS: GAS_ENDPOINT
    format.dart                   ← formatRupiah(), formatGram(), formatTanggal()
    satuan.dart                   ← konversi gram, persen
    soft_delete.dart              ← softDelete(tabel, baris)
    backup.dart                   ← exportBackup(), importBackup(), exportToSupabase(), importFromSupabase()
    sinkronisasi.dart             ← syncToSupabase(), pullFromSupabase(), autoSyncLokal(), autoSyncSupabase()
    kalkulator_pupuk.dart         ← kalkulatorBebasGram(), kalkulatorGramDariHarga(), kalkulatorHargaDariGram()
  features/
    lisensi/
      lisensi_screen.dart         ← halaman aktivasi Supabase (1x seumur device)
      lisensi_provider.dart
      lisensi_service.dart        ← aktivasiKey() via Supabase RPC, TIDAK ada verifikasi berkala
                                  -- DIHAPUS: polling, WA flow, GAS endpoint calls
    auth/
      lock_screen.dart            ← overlay PIN/biometrik
      auth_provider.dart
    beranda/
      beranda_screen.dart         ← dashboard + grafik multifungsi + kalkulator
      beranda_provider.dart
      widgets/
        card_dashboard.dart
        grafik_multifungsi.dart   ← chart switcher + fl_chart
        card_vs_siklus.dart
        kalkulator_pupuk_widget.dart   ← kalkulator bebas (tanpa stok gudang)
        kalkulator_gram_harga_widget.dart ← konversi gram ↔ harga
        dropdown_produk_dashboard.dart ← daftar produk tanpa stok gudang
    daftar_lahan/
      daftar_lahan_screen.dart    ← seksi Berjalan + Selesai + tutup siklus
      tambah_lahan_screen.dart    ← form lahan 20+ kolom
      bandingkan_screen.dart      ← head-to-head 2 lahan
      daftar_lahan_provider.dart
    stok_produk/
      stok_produk_screen.dart     ← Produk + Stok + Notif SATU halaman (dropdown, total harga real)
      detail_produk_sheet.dart    ← bottom sheet: 3 tab (Data/Stok/Notif)
      beli_stok_screen.dart       ← form beli/tambah stok
      stok_produk_provider.dart
    semprot/
      semprot_screen.dart         ← + floating alarm banner + peringatan FRAC/IRAC
      semprot_provider.dart
    pemupukan/
      pemupukan_screen.dart       ← + kalkulator stok gudang realtime
      pemupukan_provider.dart
    panen/
      panen_screen.dart
      panen_provider.dart
      widgets/
        grafik_panen_combo.dart
        grafik_panen_kumulatif.dart
        grafik_grade_donut.dart
    perawatan/
      perawatan_screen.dart       ← DIPERLENGKAP: aktivitas, notifikasi, ID lahan, catatan kejadian
      perawatan_provider.dart
    catatan_lapangan/
      catatan_lapangan_screen.dart
      catatan_lapangan_provider.dart
    history/
      history_screen.dart
      history_provider.dart
    laporan/
      laporan_screen.dart         ← 5 tab + tombol laporan stok + pilih range tanggal
      laporan_stok_screen.dart
      laporan_provider.dart
      widgets/
        tab_ringkasan.dart
        tab_analytics.dart
        tab_cashflow.dart
        tab_hara.dart
        tab_ekspor.dart           ← pilih range tanggal awal–akhir laporan
    pengaturan/
      pengaturan_screen.dart      ← 5 sub-tab (tambah tab Lahan & Sinkronisasi diperlengkap)
      pengaturan_provider.dart
    keranjang_sampah/
      keranjang_sampah_screen.dart
    modal_pra_tanam/
      modal_pra_tanam_screen.dart ← 7 bagian, autosave draft, SEMUA kolom skema ada
      modal_pra_tanam_provider.dart
  shared/
    widgets/
      sidebar.dart
      header_widget.dart
      info_bar_widget.dart        ← BARU: bar HST + Tanggal + ID Lahan di tiap halaman
      floating_alarm_banner.dart  ← BARU: 2 baris alarm melayang (semprot pupuk + obat)
      notifikasi_panel.dart       ← 5 slide panel notifikasi
      alarm_collapsible.dart
      modal_konfirmasi.dart
      toast_widget.dart
      tooltip_info.dart
      empty_state.dart
      produk_search_widget.dart
      produk_dropdown_widget.dart ← BARU: dropdown produk dengan harga + total realtime
    providers/
      lahan_aktif_provider.dart
      theme_provider.dart

==============================================================================
SECTION 5: LISENSI & AKTIVASI (SUPABASE) — DIGANTI TOTAL v4
==============================================================================
FILOSOFI:
  1 key = 1 device = SELAMANYA aktif setelah diaktifkan.
  Tidak ada verifikasi ulang berkala (tidak bulanan, tidak harian).
  Tidak ada grace period. Tidak ada popup aktivasi ulang.
  Setelah aktif + token tersimpan lokal: app berjalan offline selamanya.
  Pencabutan hanya dilakukan admin via panel admin (ubah status='blocked' di Supabase).

FORMAT KUNCI: TSM-0001, TSM-0002, TSM-0003, dst.
  Dibuat oleh admin melalui panel admin atau SQL generate.
  1 key = 1 perangkat (dikunci oleh device_id saat aktivasi pertama).

STRUKTUR TABEL licenses (Supabase):
  id            BIGINT PRIMARY KEY AUTOINCREMENT
  license_key   TEXT UNIQUE NOT NULL        -- format: TSM-0001
  customer_name TEXT                        -- diisi saat aktivasi
  customer_city TEXT                        -- diisi saat aktivasi
  device_id     TEXT                        -- diisi saat aktivasi, null = belum aktif
  status        TEXT DEFAULT 'ready'        -- ready | active | blocked
  product_version INTEGER DEFAULT 1         -- versi produk lisensi
  activated_at  TIMESTAMP                   -- diisi saat pertama aktif
  created_at    TIMESTAMP DEFAULT now()

STATUS:
  ready   = key belum dipakai (bisa diaktifkan)
  active  = key sudah aktif di 1 device
  blocked = key diblokir admin (tidak bisa dipakai)

ALUR AKTIVASI (1x seumur pakai):
  1. User install APK → belum ada lisensi aktif → tampil halaman aktivasi.
  2. User isi form:
       - Nama Lengkap
       - Kota Asal
       - License Key (format TSM-XXXX)
  3. App ambil Device ID otomatis via device_info_plus → androidId.
  4. App panggil Supabase RPC activate_license():
       Input: { license_key, customer_name, customer_city, device_id }
  5. RPC validasi dan return hasil (sukses/gagal + pesan).
  6. Jika sukses:
       - Simpan token lisensi terenkripsi ke flutter_secure_storage.
       - Simpan ke tabel lisensi lokal SQLite.
       - Auto-navigasi ke beranda.
  7. Jika gagal: tampil pesan error, form tetap bisa diedit.

VALIDASI DI RPC activate_license():
  - Cari baris WHERE license_key = input.license_key.
  - Tidak ditemukan  → return error "Key tidak valid."
  - status = 'blocked' → return error "Key diblokir oleh admin."
  - status = 'ready'  → UPDATE: customer_name, customer_city, device_id, status='active', activated_at=now()
                         return sukses + product_version.
  - status = 'active' AND device_id = input.device_id → return sukses (install ulang device sama).
  - status = 'active' AND device_id ≠ input.device_id → return error "Key sudah dipakai di perangkat lain."

INSTALL ULANG (device sama):
  - User input key yang sama di device yang sama → device_id cocok → RPC sukses otomatis.
  - Tidak perlu bayar lagi. Token baru disimpan ke secure storage.

GANTI HP:
  - Tidak ada transfer otomatis.
  - Tidak ada override otomatis.
  - Admin reset manual di panel admin:
      SET device_id = null, activated_at = null, status = 'ready'
  - Setelah reset: user aktivasi dengan key yang sama di HP baru.

SETELAH AKTIVASI:
  - Token terenkripsi tersimpan di flutter_secure_storage key 'license_token'.
  - Data lisensi tersimpan di tabel lisensi lokal SQLite.
  - App berjalan offline sepenuhnya.
  - Tidak ada verifikasi harian/bulanan.
  - Tidak ada grace period.
  - Tidak ada popup aktivasi ulang.

VERSI PRODUK:
  Field product_version di tabel licenses Supabase:
  - Semua lisensi awal: product_version = 1.
  - Update bug + update minor (v1.0, v1.1, v1.5, v1.9.9): lisensi sama, tidak perlu beli baru.
  - Upgrade berbayar: HANYA jika dibuat Product Version baru (misal product_version = 2).
  - Jangan ikat lisensi ke nomor APK minor.
  - Jangan blokir update bug.

KEAMANAN:
  - Gunakan Supabase URL dan Publishable (Anon) Key di aplikasi.
  - JANGAN gunakan service_role key di Flutter.
  - Aktifkan Row Level Security (RLS) di tabel licenses.
  - Flutter TIDAK BOLEH mengubah tabel licenses secara langsung.
  - Semua operasi aktivasi HANYA melalui RPC activate_license().
  - Token lokal terenkripsi di flutter_secure_storage (bukan SharedPreferences).
  - ProGuard/R8 aktif — tidak ada hardcoded key di APK.

RPC activate_license() — SQL SUPABASE:
  CREATE OR REPLACE FUNCTION activate_license(
    p_license_key TEXT,
    p_customer_name TEXT,
    p_customer_city TEXT,
    p_device_id TEXT
  ) RETURNS JSON
  LANGUAGE plpgsql SECURITY DEFINER
  AS $$
  DECLARE
    v_row licenses%ROWTYPE;
  BEGIN
    SELECT * INTO v_row FROM licenses WHERE license_key = p_license_key;
    IF NOT FOUND THEN
      RETURN json_build_object('success', false, 'message', 'Key tidak valid.');
    END IF;
    IF v_row.status = 'blocked' THEN
      RETURN json_build_object('success', false, 'message', 'Key diblokir oleh admin.');
    END IF;
    IF v_row.status = 'ready' THEN
      UPDATE licenses SET
        customer_name = p_customer_name,
        customer_city = p_customer_city,
        device_id     = p_device_id,
        status        = 'active',
        activated_at  = now()
      WHERE license_key = p_license_key;
      RETURN json_build_object('success', true, 'message', 'Aktivasi berhasil.',
                               'product_version', v_row.product_version);
    END IF;
    IF v_row.status = 'active' THEN
      IF v_row.device_id = p_device_id THEN
        RETURN json_build_object('success', true, 'message', 'Aktivasi berhasil (install ulang).',
                                 'product_version', v_row.product_version);
      ELSE
        RETURN json_build_object('success', false, 'message', 'Key sudah dipakai di perangkat lain. Hubungi admin.');
      END IF;
    END IF;
    RETURN json_build_object('success', false, 'message', 'Status tidak dikenal.');
  END;
  $$;

RLS POLICY (Supabase):
  ALTER TABLE licenses ENABLE ROW LEVEL SECURITY;
  -- Anon & authenticated: TIDAK bisa SELECT/INSERT/UPDATE/DELETE langsung
  CREATE POLICY "deny_direct_access" ON licenses
    FOR ALL TO anon, authenticated USING (false);
  -- Hanya service_role (panel admin) yang bisa akses langsung.
  -- Flutter app hanya boleh panggil RPC activate_license().

STATUS LOKAL LISENSI (SQLite — tabel lisensi):
  Simpan hasil aktivasi terakhir di lokal.
  Status lokal: 'belum_aktif' | 'aktif' | 'dicabut'
  Simpan juga di flutter_secure_storage: key 'lisensi_status' → 'aktif' / 'belum_aktif' / 'dicabut'
  Double check saat app dibuka:
    - Cek tabel lisensi lokal + secure storage.
    - Jika keduanya 'aktif' → lanjut ke app (TANPA cek Supabase online).
    - Jika salah satu tidak ada / berbeda:
        → Ada internet: cek ulang status via Supabase (SELECT status WHERE license_key=? — gunakan anon key, RLS allow read own row, atau via RPC cek_status).
        → Offline: tampil halaman aktivasi.

PANEL ADMIN (akses service_role, terpisah dari app Flutter):
  Minimal menyediakan:
  - Cari berdasarkan customer_name
  - Cari berdasarkan customer_city
  - Cari berdasarkan license_key
  - Lihat status lisensi (ready/active/blocked)
  - Reset device: SET device_id=null, activated_at=null, status='ready'
  - Generate key baru (format TSM-XXXX, auto increment nomor urut)
  - Block / unblock key (ubah status='blocked' / 'ready')
  Panel admin bisa berupa: dashboard web terpisah, Supabase Studio, atau script SQL admin.

GENERATE KEY FORMAT TSM-XXXX (SQL admin):
  INSERT INTO licenses (license_key, status, product_version, created_at)
  VALUES (
    'TSM-' || LPAD(
      ((SELECT COALESCE(MAX(CAST(SUBSTRING(license_key FROM 5) AS INTEGER)), 0) FROM licenses) + 1)::TEXT,
      4, '0'),
    'ready', 1, now()
  );
  -- Contoh hasil: TSM-0001, TSM-0002, ..., TSM-9999

NOTIFIKASI ADMIN:
  GAS/Google Sheets untuk notifikasi admin DIHAPUS di v4.
  Untuk sementara: tabel notifikasi_admin lokal tetap ada (tapi tidak ada pull otomatis).
  Admin bisa INSERT ke tabel notif di Supabase untuk notifikasi di versi berikutnya.

SUPABASE UNTUK DATA (tetap BYO per user):
  Di Pengaturan → Sinkronisasi Supabase: input URL + Anon Key (project pribadi user).
  Supabase data sync OPSIONAL — app 100% jalan tanpa Supabase data sync.
  CATATAN: Supabase untuk LISENSI menggunakan project ClipSmart (bukan project user).
    Pisahkan config: SUPABASE_LICENSE_URL + SUPABASE_LICENSE_ANON_KEY (hardcoded di konstanta.dart)
    vs. supabase_url + supabase_anon_key user (disimpan di pengaturan lokal).

TIDAK ADA di v4:
  ✗ Google Sheets / Google Apps Script (GAS)
  ✗ Polling status lisensi
  ✗ WhatsApp activation flow
  ✗ Format key AGT1-XXXX-XXXX-XXXX
  ✗ Mode trial / grace period masuk gratis
  ✗ Tombol "Masuk Tanpa Aktivasi"
  ✗ Verifikasi berkala (harian/bulanan)
  ✗ service_role key di Flutter
  ✗ dio untuk GAS endpoint

==============================================================================
SECTION 6: DATABASE SCHEMA (31 TABEL)
==============================================================================
KONVENSI:
  Semua kolom waktu = INTEGER epoch DETIK (nowSec())
  Kolom *_persen = nilai × 10000 (46% → 460000)
  Drift: definisikan sebagai Dart class extends Table

-- 1. lahan
CREATE TABLE lahan (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  id_lahan TEXT UNIQUE NOT NULL,      -- ID unik, tidak bisa diedit/hapus
  nama TEXT NOT NULL,
  link_google_maps TEXT,
  foto_path TEXT,
  lokasi TEXT,
  koordinat_lat REAL,
  koordinat_lng REAL,
  ketinggian_mdpl INTEGER,
  luas_m2 INTEGER,
  luas_tanam_m2 INTEGER,
  jarak_tanam_cm TEXT,
  jenis_tanah TEXT CHECK(jenis_tanah IN ('liat','pasir','lempung','aluvial','gambut','lainnya')),
  ph_tanah_x10 INTEGER,
  drainase TEXT CHECK(drainase IN ('baik','sedang','buruk')),
  tingkat_kesuburan TEXT CHECK(tingkat_kesuburan IN ('rendah','sedang','tinggi')),
  tekstur_tanah TEXT,
  riwayat_penggunaan TEXT,
  jenis_tanaman_utama TEXT,
  varietas_default TEXT,
  sumber_air TEXT CHECK(sumber_air IN ('sumur','sungai','irigasi_desa','hujan','embung','lainnya')),
  sistem_irigasi TEXT CHECK(sistem_irigasi IN ('tetes','sprinkler','kocor_manual','genangan','lainnya')),
  ketersediaan_air TEXT CHECK(ketersediaan_air IN ('melimpah','cukup','terbatas','bergantung_hujan')),
  akses_jalan TEXT CHECK(akses_jalan IN ('mudah','sedang','sulit')),
  ada_gudang INTEGER DEFAULT 0,
  ada_listrik INTEGER DEFAULT 0,
  status_kepemilikan TEXT CHECK(status_kepemilikan IN ('milik_sendiri','sewa','bagi_hasil','lainnya')),
  biaya_sewa_per_musim INTEGER DEFAULT 0,
  nama_pemilik TEXT,
  catatan_tanah TEXT,
  catatan_umum TEXT,
  status TEXT DEFAULT 'aktif' CHECK(status IN ('aktif','selesai')),
  created_at INTEGER DEFAULT (unixepoch()),
  diperbarui_pada INTEGER DEFAULT (unixepoch())
);
-- id_lahan: format saran huruf+angka (contoh: URTR1, SEL12)
-- id_lahan TIDAK BOLEH diedit setelah tersimpan
-- id_lahan TIDAK BOLEH dihapus — hanya arsip (status='selesai')
-- id_lahan WAJIB sinkron ke Supabase + backup lokal

-- 2. siklus
CREATE TABLE siklus (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  lahan_id INTEGER NOT NULL,
  nama_siklus TEXT NOT NULL,
  jenis_tanaman TEXT NOT NULL,
  varietas TEXT,
  tanggal_tanam INTEGER NOT NULL,
  tanggal_selesai INTEGER,
  populasi_awal INTEGER NOT NULL,
  total_mati INTEGER DEFAULT 0,
  total_sulam INTEGER DEFAULT 0,
  notifikasi_nyala INTEGER DEFAULT 1,
  interval_notifikasi_semprot_pupuk_hari INTEGER DEFAULT 7,  -- TERPISAH dari semprot obat
  interval_notifikasi_semprot_obat_hari INTEGER DEFAULT 7,   -- TERPISAH dari semprot pupuk
  status TEXT DEFAULT 'aktif' CHECK(status IN ('aktif','selesai','dibatalkan')),
  akumulasi_biaya_per_pohon INTEGER DEFAULT 0,
  total_biaya_kumulatif INTEGER DEFAULT 0,
  total_omzet_kumulatif INTEGER DEFAULT 0,
  catatan TEXT,
  created_at INTEGER DEFAULT (unixepoch()),
  FOREIGN KEY (lahan_id) REFERENCES lahan(id) ON DELETE CASCADE
);

-- 3. produk
CREATE TABLE produk (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nama TEXT NOT NULL,
  kategori TEXT CHECK(kategori IN ('pupuk','obat')),
  barcode TEXT,
  stok_gram INTEGER DEFAULT 0,
  harga_rata_rata INTEGER DEFAULT 0,   -- WMA Rp/gram
  satuan_kemasan TEXT,
  -- UNSUR HARA (× 10000)
  n_persen INTEGER DEFAULT 0, p_persen INTEGER DEFAULT 0, k_persen INTEGER DEFAULT 0,
  ca_persen INTEGER DEFAULT 0, mg_persen INTEGER DEFAULT 0, s_persen INTEGER DEFAULT 0,
  b_persen INTEGER DEFAULT 0, fe_persen INTEGER DEFAULT 0, mn_persen INTEGER DEFAULT 0,
  zn_persen INTEGER DEFAULT 0, cu_persen INTEGER DEFAULT 0, mo_persen INTEGER DEFAULT 0,
  cl_persen INTEGER DEFAULT 0, si_persen INTEGER DEFAULT 0,
  -- PESTISIDA
  bahan_aktif1 TEXT, bahan_aktif2 TEXT, bahan_aktif3 TEXT,
  kode_frac1 TEXT, kode_frac2 TEXT, kode_frac3 TEXT,
  kode_irac1 TEXT, kode_irac2 TEXT, kode_irac3 TEXT,
  target_masalah TEXT,
  harga_per_kg INTEGER DEFAULT 0,       -- harga referensi per kg (bukan WMA, untuk kalkulator bebas)
  created_at INTEGER DEFAULT (unixepoch())
);

-- 4. riwayat_pembelian
CREATE TABLE riwayat_pembelian (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  produk_id INTEGER NOT NULL,
  jumlah_gram INTEGER NOT NULL,
  harga_total INTEGER NOT NULL,
  harga_per_gram INTEGER NOT NULL,
  harga_wma_sesudah INTEGER NOT NULL,
  tanggal_beli INTEGER DEFAULT (unixepoch()),
  pemasok TEXT,
  catatan TEXT,
  FOREIGN KEY (produk_id) REFERENCES produk(id)
);

-- 5. transaksi_stok (GLOBAL — tidak per lahan)
CREATE TABLE transaksi_stok (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  produk_id INTEGER NOT NULL,
  siklus_id INTEGER,
  lahan_id INTEGER,
  aktivitas_tipe TEXT,
  aktivitas_id INTEGER,
  tipe_transaksi TEXT NOT NULL CHECK(tipe_transaksi IN ('beli','pakai','koreksi_tambah','koreksi_kurang','kedaluwarsa')),
  jumlah_gram INTEGER NOT NULL,       -- positif=masuk, negatif=keluar
  stok_sebelum INTEGER NOT NULL,
  stok_setelah INTEGER NOT NULL,
  harga_satuan INTEGER,
  total_nilai INTEGER,
  catatan TEXT,
  tanggal_mutasi INTEGER DEFAULT (unixepoch()),
  FOREIGN KEY (produk_id) REFERENCES produk(id),
  FOREIGN KEY (siklus_id) REFERENCES siklus(id),
  FOREIGN KEY (lahan_id) REFERENCES lahan(id)
);

-- 6. detail_tenaga_kerja
CREATE TABLE detail_tenaga_kerja (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  tipe_aktivitas TEXT NOT NULL CHECK(tipe_aktivitas IN ('semprot','pemupukan','panen','perawatan')),
  aktivitas_id INTEGER NOT NULL,
  jenis_pekerjaan TEXT NOT NULL,
  jumlah_pekerja INTEGER NOT NULL,
  upah_per_hari INTEGER NOT NULL,
  total_upah INTEGER NOT NULL,
  catatan TEXT
  -- WAJIB: DELETE detail_tenaga_kerja SEBELUM DELETE aktivitas induknya
);

-- 7. semprot
CREATE TABLE semprot (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  siklus_id INTEGER NOT NULL,
  tanggal INTEGER NOT NULL,
  hst INTEGER NOT NULL,
  volume_air_ml INTEGER NOT NULL,
  target_opt TEXT NOT NULL,
  biaya_utilitas INTEGER DEFAULT 0,
  biaya_tambahan INTEGER DEFAULT 0,
  grade_label TEXT,
  total_n_gram INTEGER DEFAULT 0, total_p_gram INTEGER DEFAULT 0, total_k_gram INTEGER DEFAULT 0,
  total_ca_gram INTEGER DEFAULT 0, total_mg_gram INTEGER DEFAULT 0, total_s_gram INTEGER DEFAULT 0,
  total_b_gram INTEGER DEFAULT 0, total_fe_gram INTEGER DEFAULT 0, total_mn_gram INTEGER DEFAULT 0,
  total_zn_gram INTEGER DEFAULT 0, total_cu_gram INTEGER DEFAULT 0, total_mo_gram INTEGER DEFAULT 0,
  total_cl_gram INTEGER DEFAULT 0, total_si_gram INTEGER DEFAULT 0,
  total_biaya INTEGER DEFAULT 0,
  is_selesai INTEGER DEFAULT 0,
  selesai_pada INTEGER,
  ada_risiko_resistensi INTEGER DEFAULT 0,  -- 1 jika FRAC/IRAC sama > 3x berturut
  kode_frac_terpakai TEXT,                   -- JSON array kode FRAC yang dipakai
  kode_irac_terpakai TEXT,                   -- JSON array kode IRAC yang dipakai
  catatan TEXT,
  created_at INTEGER DEFAULT (unixepoch()),
  FOREIGN KEY (siklus_id) REFERENCES siklus(id)
);

-- 8. item_semprot
CREATE TABLE item_semprot (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  semprot_id INTEGER NOT NULL,
  produk_id INTEGER NOT NULL,
  dosis_per_liter_gram INTEGER NOT NULL,
  total_gram_pakai INTEGER NOT NULL,
  harga_satuan_wma INTEGER NOT NULL,
  estimasi_biaya INTEGER NOT NULL,
  catatan TEXT,
  FOREIGN KEY (semprot_id) REFERENCES semprot(id) ON DELETE CASCADE,
  FOREIGN KEY (produk_id) REFERENCES produk(id)
);

-- 9. pemupukan
CREATE TABLE pemupukan (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  siklus_id INTEGER NOT NULL,
  tanggal INTEGER NOT NULL,
  hst INTEGER NOT NULL,
  metode TEXT NOT NULL CHECK(metode IN ('kocor','fertigasi','tabur')),
  populasi_aplikasi INTEGER NOT NULL,
  kebutuhan_air_per_tanaman_ml INTEGER,
  total_air_ml INTEGER,
  biaya_utilitas INTEGER DEFAULT 0,
  biaya_tambahan INTEGER DEFAULT 0,
  grade_label TEXT,
  total_n_gram INTEGER DEFAULT 0, total_p_gram INTEGER DEFAULT 0, total_k_gram INTEGER DEFAULT 0,
  total_ca_gram INTEGER DEFAULT 0, total_mg_gram INTEGER DEFAULT 0, total_s_gram INTEGER DEFAULT 0,
  total_b_gram INTEGER DEFAULT 0, total_fe_gram INTEGER DEFAULT 0, total_mn_gram INTEGER DEFAULT 0,
  total_zn_gram INTEGER DEFAULT 0, total_cu_gram INTEGER DEFAULT 0, total_mo_gram INTEGER DEFAULT 0,
  total_cl_gram INTEGER DEFAULT 0, total_si_gram INTEGER DEFAULT 0,
  total_biaya INTEGER DEFAULT 0,
  is_selesai INTEGER DEFAULT 0,
  selesai_pada INTEGER,
  catatan TEXT,
  created_at INTEGER DEFAULT (unixepoch()),
  FOREIGN KEY (siklus_id) REFERENCES siklus(id)
);

-- 10. item_pemupukan
CREATE TABLE item_pemupukan (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  pemupukan_id INTEGER NOT NULL,
  produk_id INTEGER NOT NULL,
  dosis_per_tanaman_gram INTEGER NOT NULL,
  total_gram_pakai INTEGER NOT NULL,
  harga_satuan_wma INTEGER NOT NULL,
  estimasi_biaya INTEGER NOT NULL,
  catatan TEXT,
  FOREIGN KEY (pemupukan_id) REFERENCES pemupukan(id) ON DELETE CASCADE,
  FOREIGN KEY (produk_id) REFERENCES produk(id)
);

-- 11. item_tambahan_pemupukan
CREATE TABLE item_tambahan_pemupukan (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  pemupukan_id INTEGER NOT NULL,
  nama_produk TEXT NOT NULL,
  produk_id INTEGER,
  jumlah_gram INTEGER,
  jumlah_ml INTEGER,
  satuan_label TEXT NOT NULL DEFAULT 'g',
  harga_satuan INTEGER DEFAULT 0,
  total_biaya INTEGER NOT NULL DEFAULT 0,
  catatan TEXT,
  FOREIGN KEY (pemupukan_id) REFERENCES pemupukan(id) ON DELETE CASCADE,
  FOREIGN KEY (produk_id) REFERENCES produk(id)
);

-- 12. detail_unsur_per_pohon
CREATE TABLE detail_unsur_per_pohon (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  aktivitas_id INTEGER NOT NULL,
  tipe_aktivitas TEXT NOT NULL CHECK(tipe_aktivitas IN ('pemupukan','semprot')),
  unsur_kode TEXT NOT NULL CHECK(unsur_kode IN ('N','P','K','Ca','Mg','S','B','Fe','Mn','Zn','Cu','Mo','Cl','Si')),
  total_gram_unsur INTEGER NOT NULL,
  gram_per_pohon INTEGER NOT NULL,         -- × 1000 untuk 3 desimal
  populasi_saat_itu INTEGER NOT NULL,
  persen_dari_campuran INTEGER NOT NULL,   -- × 100 untuk 2 desimal
  created_at INTEGER DEFAULT (unixepoch())
);

-- 13. panen
CREATE TABLE panen (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  siklus_id INTEGER NOT NULL,
  tanggal INTEGER NOT NULL,
  hst INTEGER NOT NULL,
  grade_a_gram INTEGER NOT NULL DEFAULT 0,
  grade_b_gram INTEGER NOT NULL DEFAULT 0,
  reject_gram INTEGER NOT NULL DEFAULT 0,
  harga_grade_a_per_kg INTEGER NOT NULL,
  harga_grade_b_per_kg INTEGER NOT NULL,
  omzet_grade_a INTEGER NOT NULL,
  omzet_grade_b INTEGER NOT NULL,
  total_omzet INTEGER NOT NULL,
  biaya_transportasi INTEGER DEFAULT 0,
  biaya_tenaga_kerja INTEGER DEFAULT 0,
  omzet_bersih INTEGER NOT NULL,
  is_selesai INTEGER DEFAULT 1,
  selesai_pada INTEGER DEFAULT (unixepoch()),
  catatan TEXT,
  created_at INTEGER DEFAULT (unixepoch()),
  FOREIGN KEY (siklus_id) REFERENCES siklus(id)
);

-- 14. perawatan (DIPERLENGKAP v3)
CREATE TABLE perawatan (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  siklus_id INTEGER NOT NULL,
  lahan_id INTEGER NOT NULL,             -- BARU: wajib ada ID lahan
  tanggal INTEGER NOT NULL,
  hst INTEGER NOT NULL,
  jenis_kerja TEXT NOT NULL CHECK(jenis_kerja IN (
    'pruning','penyiangan','penyulaman','irigasi','perbaikan_ajir',
    'pengendalian_gulma','pembumbunan','pemangkasan_tunas','pengikatan_tanaman',
    'sanitasi_lahan','perbaikan_drainase','lainnya'
  )),
  -- AKTIVITAS DETAIL
  deskripsi_aktivitas TEXT,              -- apa yang dilakukan saat perawatan
  kondisi_tanaman TEXT,                  -- kondisi tanaman saat perawatan (baik/sedang/buruk/kritis)
  kondisi_cuaca TEXT CHECK(kondisi_cuaca IN ('cerah','berawan','hujan','setelah_hujan')),
  temuan_masalah TEXT,                   -- masalah yang ditemukan saat perawatan
  tindakan_lanjut TEXT,                  -- catatan tindakan yang perlu dilakukan berikutnya
  -- BIAYA
  biaya_utilitas INTEGER DEFAULT 0,
  biaya_bahan_habis_pakai INTEGER DEFAULT 0,  -- misal: tali, ajir baru, dll
  total_biaya INTEGER DEFAULT 0,
  -- STATUS
  is_selesai INTEGER DEFAULT 0,
  selesai_pada INTEGER,
  -- NOTIFIKASI
  jadwal_berikutnya INTEGER,             -- epoch detik jadwal perawatan berikutnya
  interval_hari INTEGER DEFAULT 7,       -- interval default notif perawatan
  -- CATATAN
  catatan TEXT,                          -- catatan umum / kejadian apapun
  foto_path TEXT,                        -- foto kondisi lahan/tanaman
  created_at INTEGER DEFAULT (unixepoch()),
  FOREIGN KEY (siklus_id) REFERENCES siklus(id),
  FOREIGN KEY (lahan_id) REFERENCES lahan(id)
);

-- 15. catatan_lapangan
CREATE TABLE catatan_lapangan (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  siklus_id INTEGER NOT NULL,
  lahan_id INTEGER NOT NULL,             -- BARU: ID lahan eksplisit
  tanggal INTEGER NOT NULL,
  hst INTEGER NOT NULL,
  jenis_masalah TEXT NOT NULL CHECK(jenis_masalah IN ('penyakit','hama','nutrisi','cuaca','keracunan','lainnya')),
  tingkat_bahaya TEXT NOT NULL CHECK(tingkat_bahaya IN ('rendah','sedang','tinggi','kritis')),
  deskripsi TEXT,
  loss_count INTEGER DEFAULT 0,
  nilai_kerugian_estimasi INTEGER DEFAULT 0,
  foto_path TEXT,
  created_at INTEGER DEFAULT (unixepoch()),
  FOREIGN KEY (siklus_id) REFERENCES siklus(id),
  FOREIGN KEY (lahan_id) REFERENCES lahan(id)
);

-- 16. aset
CREATE TABLE aset (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nama TEXT NOT NULL,
  foto_path TEXT,
  tanggal_beli INTEGER NOT NULL,
  harga_beli INTEGER NOT NULL,
  estimasi_siklus INTEGER,
  estimasi_hari INTEGER,
  metode_depresiasi TEXT DEFAULT 'linear' CHECK(metode_depresiasi IN ('linear','per_siklus')),
  siklus_terpakai INTEGER DEFAULT 0,
  created_at INTEGER DEFAULT (unixepoch())
);

-- 17. biaya_pembukaan (DIPERLENGKAP v3 — kolom lengkap)
CREATE TABLE biaya_pembukaan (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  siklus_id INTEGER NOT NULL,
  lahan_id INTEGER NOT NULL,             -- BARU: ID lahan eksplisit
  tanggal INTEGER NOT NULL,
  nama_pengeluaran TEXT NOT NULL,
  kategori TEXT NOT NULL CHECK(kategori IN (
    'olah_lahan','persiapan_tanah','mulsa','bibit','penanaman',
    'ajir','net_screen','analisa_tanah','depresiasi_aset',
    'transportasi','konsumsi_pekerja','irigasi_instalasi',
    'pupuk_dasar','dolomit','pupuk_kandang','npk_dasar',
    'bio_aktivator','pestisida_tanah','tali_rafia','lainnya'
  )),
  nominal INTEGER NOT NULL,
  jumlah_unit REAL,                      -- misal: 5 roll mulsa
  satuan_unit TEXT,                      -- misal: "roll", "kg", "batang", "orang"
  harga_satuan INTEGER,                  -- harga per unit
  nama_pemasok TEXT,                     -- pemasok/supplier item ini
  nomor_nota TEXT,                       -- nomor nota pembelian
  foto_nota_path TEXT,                   -- foto nota
  is_hutang INTEGER DEFAULT 0,           -- 1 jika belum lunas
  catatan TEXT,
  created_at INTEGER DEFAULT (unixepoch()),
  FOREIGN KEY (siklus_id) REFERENCES siklus(id),
  FOREIGN KEY (lahan_id) REFERENCES lahan(id)
);
-- CATATAN: kategori 'olah_lahan' mencakup cangkul+traktor,
--          kategori 'pupuk_dasar'/'dolomit'/'pupuk_kandang' = input persiapan tanah
--          Semua kategori pra-tanam masuk ke sini saat submit Modal Pra-Tanam

-- 18. modal_awal
CREATE TABLE modal_awal (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  lahan_id INTEGER,
  siklus_id INTEGER,
  tanggal INTEGER NOT NULL,
  nama_item TEXT NOT NULL,
  kategori TEXT,
  nominal INTEGER NOT NULL,
  supplier_id INTEGER,
  status_bayar TEXT DEFAULT 'lunas' CHECK(status_bayar IN ('lunas','hutang')),
  foto_nota_path TEXT,
  catatan TEXT,
  created_at INTEGER DEFAULT (unixepoch()),
  FOREIGN KEY (lahan_id) REFERENCES lahan(id),
  FOREIGN KEY (siklus_id) REFERENCES siklus(id),
  FOREIGN KEY (supplier_id) REFERENCES supplier(id)
);

-- 19. supplier
CREATE TABLE supplier (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nama TEXT NOT NULL,
  nomor_hp TEXT,
  alamat TEXT,
  catatan TEXT,
  created_at INTEGER DEFAULT (unixepoch())
);

-- 20. hutang
CREATE TABLE hutang (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  modal_awal_id INTEGER NOT NULL,
  supplier_id INTEGER,
  nominal INTEGER NOT NULL,
  tanggal_hutang INTEGER NOT NULL,
  jatuh_tempo INTEGER,
  status TEXT DEFAULT 'belum_lunas' CHECK(status IN ('belum_lunas','lunas')),
  dilunasi_pada INTEGER,
  catatan TEXT,
  created_at INTEGER DEFAULT (unixepoch()),
  FOREIGN KEY (modal_awal_id) REFERENCES modal_awal(id),
  FOREIGN KEY (supplier_id) REFERENCES supplier(id)
);

-- 21. cashflow_snapshot
CREATE TABLE cashflow_snapshot (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  siklus_id INTEGER NOT NULL,
  lahan_id INTEGER NOT NULL,             -- BARU: ID lahan eksplisit
  tanggal INTEGER NOT NULL,
  tipe TEXT NOT NULL CHECK(tipe IN (
    'biaya_pembukaan','biaya_semprot','biaya_pemupukan',
    'biaya_perawatan','biaya_tenaga_kerja','pendapatan_panen','biaya_mati_tanaman','biaya_modal_awal'
  )),
  aktivitas_id INTEGER,
  nominal INTEGER NOT NULL,
  saldo_kumulatif INTEGER NOT NULL,
  catatan TEXT,
  created_at INTEGER DEFAULT (unixepoch()),
  FOREIGN KEY (siklus_id) REFERENCES siklus(id),
  FOREIGN KEY (lahan_id) REFERENCES lahan(id)
);

-- 22. pra_tanam_draft (DIPERLENGKAP v3 — semua kolom dari skema modal lengkap)
CREATE TABLE pra_tanam_draft (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  lahan_id INTEGER NOT NULL,
  -- BAGIAN 1: INFO SIKLUS
  tanggal_mulai_olah INTEGER,
  tanggal_tanam INTEGER,
  populasi_tanam INTEGER,
  jenis_tanaman TEXT,
  varietas TEXT,
  -- BAGIAN 2: OLAH LAHAN
  metode_olah TEXT CHECK(metode_olah IN ('cangkul','traktor','keduanya')),
  cangkul_pekerja INTEGER DEFAULT 0,
  cangkul_upah_per_orang INTEGER DEFAULT 0,
  cangkul_hari INTEGER DEFAULT 0,
  traktor_biaya_sewa INTEGER DEFAULT 0,
  traktor_hari INTEGER DEFAULT 0,
  -- BAGIAN 3: PERSIAPAN TANAH
  dolomit_kg REAL DEFAULT 0,
  dolomit_harga_per_kg INTEGER DEFAULT 0,
  pupuk_kandang_kg REAL DEFAULT 0,
  pupuk_kandang_harga_per_kg INTEGER DEFAULT 0,
  npk_dasar_kg REAL DEFAULT 0,
  npk_dasar_harga_per_kg INTEGER DEFAULT 0,
  bio_aktivator_nama TEXT,
  bio_aktivator_biaya INTEGER DEFAULT 0,
  pestisida_tanah_nama TEXT,
  pestisida_tanah_biaya INTEGER DEFAULT 0,
  analisa_tanah_biaya INTEGER DEFAULT 0,
  -- BAGIAN 4: MULSA
  mulsa_roll REAL DEFAULT 0,
  mulsa_harga_per_roll INTEGER DEFAULT 0,
  mulsa_pekerja_pasang INTEGER DEFAULT 0,
  mulsa_upah_pasang INTEGER DEFAULT 0,
  mulsa_pekerja_lubangi INTEGER DEFAULT 0,
  mulsa_upah_lubangi INTEGER DEFAULT 0,
  -- BAGIAN 5: BIBIT
  sumber_bibit TEXT CHECK(sumber_bibit IN ('beli_batang','semai_sendiri')),
  bibit_jumlah INTEGER DEFAULT 0,
  bibit_harga_per_batang INTEGER DEFAULT 0,
  benih_gram REAL DEFAULT 0,
  benih_harga INTEGER DEFAULT 0,
  semai_biaya_media INTEGER DEFAULT 0,
  semai_biaya_tenaga INTEGER DEFAULT 0,
  cadangan_persen INTEGER DEFAULT 10,
  -- BAGIAN 6: PENANAMAN & AJIR
  tanam_pekerja INTEGER DEFAULT 0,
  tanam_upah_per_orang INTEGER DEFAULT 0,
  irigasi_awal_biaya INTEGER DEFAULT 0,
  ajir_jenis TEXT CHECK(ajir_jenis IN ('bambu','kayu','besi','tidak_pakai')),
  ajir_jumlah INTEGER DEFAULT 0,
  ajir_harga_per_pcs INTEGER DEFAULT 0,
  ajir_pekerja_pasang INTEGER DEFAULT 0,
  ajir_upah_pasang INTEGER DEFAULT 0,
  tali_biaya INTEGER DEFAULT 0,
  net_screen_biaya INTEGER DEFAULT 0,
  -- BAGIAN 7: LAIN-LAIN
  biaya_transportasi INTEGER DEFAULT 0,
  biaya_konsumsi_pekerja INTEGER DEFAULT 0,
  biaya_instalasi_irigasi INTEGER DEFAULT 0,
  biaya_lainnya INTEGER DEFAULT 0,
  catatan_lainnya TEXT,
  -- METADATA
  status TEXT DEFAULT 'draft' CHECK(status IN ('draft','tersimpan')),
  siklus_id INTEGER,
  total_biaya_pra_tanam INTEGER DEFAULT 0,
  -- SUB-TOTAL PER KATEGORI (dihitung otomatis, disimpan untuk tampilan cepat)
  subtotal_olah_lahan INTEGER DEFAULT 0,
  subtotal_persiapan_tanah INTEGER DEFAULT 0,
  subtotal_mulsa INTEGER DEFAULT 0,
  subtotal_bibit INTEGER DEFAULT 0,
  subtotal_penanaman_ajir INTEGER DEFAULT 0,
  subtotal_lainnya INTEGER DEFAULT 0,
  created_at INTEGER DEFAULT (unixepoch()),
  diperbarui_pada INTEGER DEFAULT (unixepoch()),
  FOREIGN KEY (lahan_id) REFERENCES lahan(id),
  FOREIGN KEY (siklus_id) REFERENCES siklus(id)
);

-- 23. pengaturan
CREATE TABLE pengaturan (
  kunci TEXT PRIMARY KEY,
  nilai TEXT,
  diperbarui_pada INTEGER DEFAULT (unixepoch())
);
-- Key-key penting:
-- 'versi_skema', 'theme_mode', 'auth_mode', 'app_pin_hash', 'session_timeout_menit',
-- 'last_active_sec', 'backup_terakhir_lokal', 'backup_terakhir_supabase',
-- 'supabase_url', 'supabase_anon_key',
-- 'lisensi_status', 'lahan_aktif_id',
-- 'auto_sync_lokal' (true/false), 'auto_sync_supabase' (true/false),
-- 'interval_alarm_semprot_pupuk_hari', 'interval_alarm_semprot_obat_hari'

-- 24. notifikasi_produk
CREATE TABLE notifikasi_produk (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  produk_id INTEGER NOT NULL,
  aktivitas TEXT NOT NULL CHECK(aktivitas IN ('semprot_obat','semprot_pupuk','pemupukan','panen','perawatan')),
  hari_sebelum INTEGER DEFAULT 2,
  is_active INTEGER DEFAULT 1,
  created_at INTEGER DEFAULT (unixepoch()),
  UNIQUE(produk_id, aktivitas),
  FOREIGN KEY (produk_id) REFERENCES produk(id) ON DELETE CASCADE
);

-- 25. batas_stok_produk
CREATE TABLE batas_stok_produk (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  produk_id INTEGER NOT NULL,
  batas_minimal_gram INTEGER DEFAULT 1000,
  is_notify INTEGER DEFAULT 1,
  created_at INTEGER DEFAULT (unixepoch()),
  UNIQUE(produk_id),
  FOREIGN KEY (produk_id) REFERENCES produk(id) ON DELETE CASCADE
);

-- 26. jadwal_notifikasi_produk
CREATE TABLE jadwal_notifikasi_produk (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  produk_id INTEGER NOT NULL,
  aktivitas TEXT NOT NULL CHECK(aktivitas IN ('semprot_obat','semprot_pupuk','pemupukan','panen','perawatan')),
  siklus_id INTEGER NOT NULL,
  tanggal_aktivitas INTEGER NOT NULL,
  tanggal_notif INTEGER NOT NULL,
  produk_json TEXT,
  is_done INTEGER DEFAULT 0,
  created_at INTEGER DEFAULT (unixepoch()),
  UNIQUE(produk_id, aktivitas, siklus_id),
  FOREIGN KEY (produk_id) REFERENCES produk(id),
  FOREIGN KEY (siklus_id) REFERENCES siklus(id)
);

-- 27. notifikasi_aktivitas
CREATE TABLE notifikasi_aktivitas (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  judul TEXT NOT NULL, isi TEXT NOT NULL,
  jenis TEXT NOT NULL CHECK(jenis IN ('jadwal_produk','stok_menipis','jadwal_umum','admin','perawatan')),
  warna TEXT NOT NULL CHECK(warna IN ('merah','kuning','hijau','biru')),
  target_halaman TEXT,
  target_lahan_id INTEGER,
  target_id_referensi INTEGER,
  produk_json TEXT,
  tanggal_notif INTEGER NOT NULL,
  is_dibaca INTEGER DEFAULT 0,
  created_at INTEGER DEFAULT (unixepoch())
);

-- 28. notifikasi_admin
CREATE TABLE notifikasi_admin (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  judul TEXT NOT NULL, isi TEXT NOT NULL,
  is_permanen INTEGER DEFAULT 0,
  tanggal_kirim INTEGER NOT NULL,
  sudah_dibaca INTEGER DEFAULT 0,
  created_at INTEGER DEFAULT (unixepoch())
);

-- 29. keranjang_sampah
CREATE TABLE keranjang_sampah (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  tabel_asal TEXT NOT NULL,
  baris_id_asal INTEGER NOT NULL,
  dihapus_pada INTEGER NOT NULL,
  kadaluarsa_pada INTEGER NOT NULL,
  data_json TEXT NOT NULL,
  dikembalikan_pada INTEGER,
  catatan TEXT
);

-- 30. lisensi (lokal — hasil aktivasi Supabase)
CREATE TABLE lisensi (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  license_key TEXT NOT NULL UNIQUE,       -- format TSM-XXXX
  device_id TEXT NOT NULL,
  customer_name TEXT,
  customer_city TEXT,
  status TEXT DEFAULT 'belum_aktif' CHECK(status IN ('belum_aktif','aktif','dicabut')),
  product_version INTEGER DEFAULT 1,
  diaktifkan_pada INTEGER,                -- epoch detik
  created_at INTEGER DEFAULT (unixepoch())
  -- DIHAPUS: versi_aplikasi (tidak relevan)
  -- DIHAPUS: terakhir_verifikasi (tidak ada verifikasi berkala)
);

-- 31. antrian_sinkronisasi (Supabase sync queue)
CREATE TABLE antrian_sinkronisasi (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nama_tabel TEXT NOT NULL,
  baris_id INTEGER NOT NULL,
  aksi TEXT NOT NULL CHECK(aksi IN ('INSERT','UPDATE','DELETE')),
  payload TEXT NOT NULL,
  status TEXT DEFAULT 'pending' CHECK(status IN ('pending','sukses','gagal')),
  percobaan INTEGER DEFAULT 0,
  pesan_error TEXT,
  created_at INTEGER DEFAULT (unixepoch())
);

-- 32. riwayat_id_lahan (BARU v3 — riwayat semua ID lahan, tidak bisa dihapus)
CREATE TABLE riwayat_id_lahan (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  id_lahan TEXT NOT NULL UNIQUE,         -- ID lahan yang pernah digunakan
  nama_lahan TEXT NOT NULL,
  jenis_tanaman TEXT,
  tanggal_pertama_digunakan INTEGER NOT NULL,
  tanggal_terakhir_aktif INTEGER,
  status_terakhir TEXT,                  -- 'aktif' atau 'selesai'
  total_siklus INTEGER DEFAULT 1,
  catatan TEXT,
  created_at INTEGER DEFAULT (unixepoch())
);
-- ATURAN: INSERT saat pertama buat lahan. UPDATE saat tutup siklus. TIDAK PERNAH DELETE.
-- Tersinkronisasi ke Supabase + backup lokal

-- INDEKS WAJIB:
CREATE INDEX idx_siklus_lahan ON siklus(lahan_id);
CREATE INDEX idx_siklus_status ON siklus(status);
CREATE INDEX idx_semprot_siklus ON semprot(siklus_id);
CREATE INDEX idx_pemupukan_siklus ON pemupukan(siklus_id);
CREATE INDEX idx_panen_siklus ON panen(siklus_id);
CREATE INDEX idx_perawatan_siklus ON perawatan(siklus_id);
CREATE INDEX idx_perawatan_lahan ON perawatan(lahan_id);
CREATE INDEX idx_catatan_siklus ON catatan_lapangan(siklus_id);
CREATE INDEX idx_transaksi_produk ON transaksi_stok(produk_id);
CREATE INDEX idx_transaksi_lahan ON transaksi_stok(lahan_id);
CREATE INDEX idx_cashflow_siklus ON cashflow_snapshot(siklus_id, tanggal);
CREATE INDEX idx_cashflow_lahan ON cashflow_snapshot(lahan_id);
CREATE INDEX idx_jadwal_notif_tanggal ON jadwal_notifikasi_produk(tanggal_notif);
CREATE INDEX idx_jadwal_notif_done ON jadwal_notifikasi_produk(is_done);
CREATE INDEX idx_notif_aktivitas_tanggal ON notifikasi_aktivitas(tanggal_notif);
CREATE INDEX idx_tenaga_kerja ON detail_tenaga_kerja(tipe_aktivitas, aktivitas_id);
CREATE INDEX idx_detail_unsur ON detail_unsur_per_pohon(tipe_aktivitas, aktivitas_id);
CREATE INDEX idx_item_semprot ON item_semprot(semprot_id);
CREATE INDEX idx_item_pemupukan ON item_pemupukan(pemupukan_id);
CREATE INDEX idx_item_tambahan ON item_tambahan_pemupukan(pemupukan_id);
CREATE INDEX idx_sampah_kadaluarsa ON keranjang_sampah(kadaluarsa_pada);
CREATE INDEX idx_hutang_status ON hutang(status);
CREATE INDEX idx_modal_awal_lahan ON modal_awal(lahan_id);
CREATE INDEX idx_pra_tanam_lahan ON pra_tanam_draft(lahan_id);
CREATE INDEX idx_biaya_pembukaan_lahan ON biaya_pembukaan(lahan_id);
CREATE INDEX idx_riwayat_id_lahan ON riwayat_id_lahan(id_lahan);

==============================================================================
SECTION 7: LOGIKA BISNIS
==============================================================================

--- 7.1 TIMESTAMP HELPER (lib/core/timestamp.dart) ---
  int nowSec() => DateTime.now().millisecondsSinceEpoch ~/ 1000;
  int hariKeDetik(int hari) => hari * 86400;
  int detikKeHari(int detik, int ref) => ((detik - ref) / 86400).round();

--- 7.2 KALKULATOR UNSUR HARA (lib/core/kalkulator_hara.dart) ---
  const DAFTAR_UNSUR = ['N','P','K','Ca','Mg','S','B','Fe','Mn','Zn','Cu','Mo','Cl','Si'];

  Langkah 1 – gram unsur per item:
    gramUnsurTotal[u] += (produk.xPersen / 1_000_000) * item.totalGramPakai

  Langkah 2 – per tanaman:
    gramPerTanaman[u] = gramUnsurTotal[u] / populasiAplikasi

  Langkah 3 – persen campuran:
    totalSemuaUnsur = sum(gramUnsurTotal.values)
    persenCampuran[u] = totalSemuaUnsur > 0 ? gramUnsurTotal[u]/totalSemuaUnsur*100 : 0.0

  Langkah 4 – grade label:
    totalNPK = gramPerTanaman[N] + gramPerTanaman[P] + gramPerTanaman[K]
    gradeLabel = 'N$indeksN-P$indeksP-K$indeksK'

  Langkah 5 – simpan ke detail_unsur_per_pohon:
    gram_per_pohon: (gramPerTanaman * 1000).round()
    persen_dari_campuran: (persenCampuran * 100).round()

  Untuk SEMPROT: total_gram_pakai = dosis_per_liter_gram × (volume_air_ml / 1000)

--- 7.3 WEIGHTED MOVING AVERAGE STOK ---
  Saat pembelian:
    totalStok = stokLama + jumlahBaru
    hargaBaru = totalStok > 0 ? ((stokLama*hargaLama)+(jumlahBaru*hargaBeli))/totalStok : hargaBeli
    UPDATE produk SET stok_gram=totalStok, harga_rata_rata=hargaBaru.round()
    INSERT INTO riwayat_pembelian (harga_wma_sesudah=hargaBaru.round())

--- 7.4 CASHFLOW SNAPSHOT ---
  biaya_semprot     → nominal = -totalBiayaSemprot
  biaya_pemupukan   → nominal = -totalBiayaPemupukan
  biaya_perawatan   → nominal = -totalBiayaPerawatan
  pendapatan_panen  → nominal = +omzetBersih
  biaya_pembukaan   → nominal = -nominalPengeluaran
  biaya_mati_tanaman → nominal = -nilaiKerugian
  biaya_modal_awal  → nominal = -nominal

  Hitung saldo kumulatif SEBELUM INSERT:
    SELECT COALESCE(SUM(nominal),0) FROM cashflow_snapshot WHERE siklus_id=?
    saldoBaru = saldoSebelum + nominalBaris

--- 7.5 BIAYA PER POHON BERJALAN ---
  populasiHidup = populasi_awal - total_mati + total_sulam
  biayaPerPohon = populasiHidup > 0 ? totalBiayaAktivitas / populasiHidup : 0
  UPDATE siklus SET akumulasi_biaya_per_pohon += biayaPerPohon.round()

--- 7.6 HPP, BEP, ROI ---
  totalBiaya = total_biaya_kumulatif + biaya_depresiasi_aset
  HPP_per_gram = totalGramPanen > 0 ? totalBiaya / totalGramPanen : 0
  laba_bersih = total_omzet_kumulatif - totalBiaya
  ROI = totalBiaya > 0 ? (laba_bersih / totalBiaya * 100) : 0
  BEP_gram = hargaJualRataRata > 0 ? (totalBiaya * 1000 / hargaJualRataRata).round() : 0

--- 7.7 DEPRESIASI ASET (saat tutup siklus) ---
  if aset.estimasiSiklus > 0: biayaDep = aset.hargaBeli / aset.estimasiSiklus
  else if aset.estimasiHari > 0: biayaDep = (aset.hargaBeli / aset.estimasiHari) * durasiHari
  INSERT biaya_pembukaan (kategori='depresiasi_aset', nominal=biayaDep.round())
  UPDATE aset SET siklus_terpakai = siklus_terpakai + 1

--- 7.8 POPULATION LOSS CASCADE ---
  UPDATE siklus SET total_mati += loss_count
  nilaiKerugian = loss_count * siklus.akumulasi_biaya_per_pohon
  INSERT cashflow_snapshot (tipe='biaya_mati_tanaman', nominal=-nilaiKerugian)

--- 7.9 VALIDASI STOK (tidak block save) ---
  Jika stok < dibutuhkan → tampil warning di modal konfirmasi, tetap bisa simpan.

--- 7.10 CEK ID LAHAN UNIK ---
  Future<bool> cekIdLahanUnik(String idLahan) async { ... }
  Saran auto: 3 huruf dari nama + angka urut
  UI: badge hijau "✓ ID tersedia" atau merah "✗ Sudah dipakai"
  Tombol Simpan disabled jika tidak unik

--- 7.11 SOFT DELETE ---
  const TABEL_SOFTDELETE = ['semprot','pemupukan','panen','perawatan','catatan_lapangan',
    'aset','biaya_pembukaan','siklus','produk','pra_tanam_draft','modal_awal'];

--- 7.12 NOTIFIKASI HARIAN ---
  Panggil saat app dibuka + resume.
  Query jadwal_notifikasi_produk: 7 hari lalu s.d. 3 hari ke depan, is_done=0, siklus aktif.
  hariSelisih < 0 → "TERLAMBAT X HARI"
  hariSelisih == 0 → "HARI INI"
  hariSelisih == 1 → "BESOK"
  else → "X HARI LAGI"

--- 7.13 MODAL AWAL → HUTANG ---
  Saat modal_awal disimpan dengan status_bayar='hutang':
    INSERT INTO hutang (...)
  Saat hutang dilunasi:
    UPDATE hutang SET status='lunas'
    UPDATE modal_awal SET status_bayar='lunas'

--- 7.14 FLOATING ALARM BANNER (BARU v3) ---
  Di setiap halaman, di bawah header/info bar: tampil 2 baris melayang:
    Baris 1: "🌿 Semprot Pupuk Daun — X hari lagi" (atau "HARI INI" / "TERLAMBAT X hari")
    Baris 2: "💊 Semprot Obat — X hari lagi"
  Hitung dari: jadwal_notifikasi_produk WHERE aktivitas IN ('semprot_pupuk','semprot_obat') AND siklus_id=aktif AND is_done=0
  Ambil yang paling dekat waktunya.
  Warna teks sesuai urgensi: hijau (> 3 hari), kuning (1-3 hari), merah (0/terlambat).
  Tap banner → navigasi ke halaman Semprot.
  Interval dua alarm ini diambil dari siklus.interval_notifikasi_semprot_pupuk_hari dan interval_notifikasi_semprot_obat_hari.
  Settingan interval ini ADA DI PENGATURAN dan juga bisa diedit di form Alarm Collapsible halaman Semprot.
  Banner bisa di-dismiss (slide up), akan muncul kembali setelah 1 jam.

--- 7.15 PERINGATAN RESISTENSI FRAC/IRAC (BARU v3) ---
  Di halaman Semprot Daun, saat pengisian produk obat:
  Cek: apakah produk dengan kode_frac/kode_irac SAMA sudah dipakai > 3x berturut-turut di siklus ini?
  Query: ambil 4 semprot terakhir siklus aktif → cek kode FRAC/IRAC dari item_semprot masing-masing
  Jika ya: tampilkan badge merah "⚠️ Risiko Resistensi" di bawah nama produk yang bersangkutan
  Teks tooltip: "Kode FRAC/IRAC [X] sudah dipakai [N] kali berturut-turut. Rotasi mekanisme aksi disarankan."
  Simpan flag ada_risiko_resistensi=1 di tabel semprot saat save.

--- 7.16 KALKULATOR PUPUK BEBAS (BARU v3, lib/core/kalkulator_pupuk.dart) ---
  A. Kalkulator Gram ↔ Harga:
     Input: jumlah uang (Rp) + harga per kg (Rp/kg) → Output: berapa gram
     Input: jumlah gram + harga per kg → Output: berapa harga (Rp)
     Rumus: gram = (uang / hargaPerKg) * 1000; harga = (gram / 1000) * hargaPerKg
     Realtime update saat ketik.
     Contoh 1: beli Rp 20.000 dengan harga Rp 75.000/kg → 266.67 gram
     Contoh 2: beli 300 gram dengan harga Rp 60.000/kg → Rp 18.000

  B. Kalkulator Pupuk Bebas (tanpa stok):
     Pilih produk dari dropdown (daftar produk lokal)
     Input: dosis g/tanaman + jumlah tanaman → Output: total gram + total biaya (dari harga_per_kg)
     Input: dosis g/liter + volume air (liter) → Output: total gram + total biaya
     Preview 14 unsur hara realtime
     TIDAK mengurangi stok gudang — hanya kalkulasi

  C. Kalkulator Pupuk dengan Stok (di halaman Pemupukan):
     Sama dengan B tapi menggunakan stok aktual (stok_gram) dan harga WMA
     Preview dampak stok sesudah penggunaan (stok sisa)
     Jika stok kurang: badge kuning ⚠️ tapi tidak block

--- 7.17 TUTUP SIKLUS (BARU v3) ---
  Lihat BUG 17. Flow:
  1. User tekan [Tutup Siklus] di card lahan
  2. Dialog: "Backup dulu sebelum tutup siklus?"
       [Backup ke HP] [Sync ke Supabase] [Lanjut Tanpa Backup ⚠️]
  3. Hitung depresiasi aset (7.7)
  4. UPDATE siklus SET status='selesai', tanggal_selesai=nowSec()
  5. UPDATE lahan: jika tidak ada siklus aktif lain → status='selesai'
  6. UPDATE riwayat_id_lahan SET tanggal_terakhir_aktif=nowSec(), status_terakhir='selesai'
  7. Tambah ke antrian_sinkronisasi jika Supabase aktif

==============================================================================
SECTION 8: FORM LAYOUT 2 KOLOM & TOOLTIP
==============================================================================
Flutter Widget: Row(children: [Expanded(), SizedBox(12), Expanded()])
MediaQuery: layar < 400dp → Column (1 kolom)
Setiap label WAJIB ada ikon ℹ 20dp warna hijau di kanannya.
Tooltip: GestureDetector onLongPress → tampil tooltip.

TOOLTIP PER KOLOM (sama seperti v2, ditambah):
  HST                : "Hari Setelah Tanam. Dihitung otomatis dari tanggal tanam. Bisa edit manual."
  Populasi Dipupuk   : "Jumlah tanaman yang menerima pupuk. Otomatis dari populasi hidup siklus."
  ID Lahan           : "ID unik lahan kamu. Tidak bisa diubah setelah tersimpan."
  Interval Semprot Pupuk: "Berapa hari antara semprot pupuk daun. Dipakai untuk alarm melayang."
  Interval Semprot Obat: "Berapa hari antara semprot obat. Alarm terpisah dari semprot pupuk."
  Kondisi Tanaman    : "Kondisi fisik tanaman saat perawatan ini dilakukan."
  Temuan Masalah     : "Masalah yang ditemukan: hama, penyakit, nutrisi defisiensi, dll."
  Tindakan Lanjut    : "Catatan apa yang perlu dilakukan di sesi perawatan berikutnya."
  Jadwal Berikutnya  : "Tanggal perawatan berikutnya — akan memicu notifikasi pengingat."
  Kode FRAC          : "Fungicide Resistance Action Committee. Rotasi kode berbeda tiap 3x spray."
  Kode IRAC          : "Insecticide Resistance Action Committee. Cek risiko resistensi."
  Harga per Kg       : "Harga referensi untuk kalkulator bebas di dashboard. Tidak mempengaruhi stok WMA."

==============================================================================
SECTION 9: MODAL KONFIRMASI (DOUBLE-CHECK)
==============================================================================
(Sama seperti v2 — ditambah:)

Modal PERAWATAN (diperlengkap v3):
  [KONFIRMASI PERAWATAN]
  Lahan | ID Lahan | Tanggal | HST
  Jenis Kerja | Kondisi Tanaman | Kondisi Cuaca
  Deskripsi Aktivitas
  Temuan Masalah (jika ada)
  Tindakan Lanjut (jika ada)
  Tenaga Kerja: X pekerja × Rp Y = Rp Z
  Biaya Utilitas: Rp A | Biaya Bahan: Rp B
  TOTAL BIAYA: Rp C
  Jadwal Berikutnya: [tanggal] (jika diisi)

  [Ya, Simpan] [Batal]

==============================================================================
SECTION 10: SIDEBAR, HEADER, NAVIGASI
==============================================================================
SIDEBAR (Drawer Flutter):
  Bagian atas: nama app + versi
  GLOBAL FARM SWITCHER: dropdown lahan aktif
  Menu navigasi:
    🏠 Beranda
    📋 Daftar Lahan
    🌱 Semprot
    💊 Pemupukan
    🌾 Panen
    🔧 Perawatan
    📝 Catatan Lapangan
    📦 Stok & Notif Produk
    🗃️ Aset
    📊 Laporan
    🕐 History
    🗑️ Keranjang Sampah
    ⚙️ Pengaturan

HEADER: hamburger | judul halaman | ikon pencarian | ikon notif (🔔)
INFO BAR (di bawah header, TIAP HALAMAN):
  [ID Lahan: URTR1] [HST: 45] [Tanggal: 12/06/2025]
  Tap → bisa ganti lahan aktif

FLOATING ALARM BANNER (di bawah info bar, TIAP HALAMAN):
  Baris 1: 🌿 Semprot Pupuk Daun — X hari lagi
  Baris 2: 💊 Semprot Obat — X hari lagi

PANEL NOTIFIKASI (5 slide):
  Slide 1: Jadwal mendatang (hari ini + besok + lusa)
  Slide 2: Keterlambatan
  Slide 3: Selesai baru (48 jam terakhir)
  Slide 4: Stok menipis
  Slide 5: Pesan admin

==============================================================================
SECTION 11: HALAMAN BERANDA — GRAFIK MULTIFUNGSI + KALKULATOR
==============================================================================
(Sama dengan v2, ditambah:)

KALKULATOR GRAM ↔ HARGA (widget baru, collapsible):
  Card di dashboard:
    Tab [Gram dari Harga]: Input Rp + Rp/kg → Output gram (realtime)
    Tab [Harga dari Gram]: Input gram + Rp/kg → Output Rp (realtime)
    Contoh: "Beli Rp 20.000 dengan harga Rp 75.000/kg = 266 gram"

KALKULATOR PUPUK BEBAS (widget baru, collapsible):
  Dropdown pilih produk (dari daftar produk lokal, tidak terhubung stok)
  Input dosis (g/tanaman atau g/liter) + jumlah tanaman/volume
  Output: total gram + total biaya + preview hara 14 unsur
  TIDAK mengurangi stok. Hanya kalkulasi.

TAMBAH DAFTAR PRODUK DI DASHBOARD:
  Tombol [+ Tambah Produk] di area kalkulator
  Form sederhana: Nama | Kategori | Harga/kg | Unsur hara (N/P/K/Ca/Mg) | Bahan aktif
  Tersimpan di tabel produk lokal (SQLite) + sinkronisasi ke Supabase jika aktif
  Tampil di dropdown kalkulator bebas maupun dropdown halaman lain

==============================================================================
SECTION 12: DAFTAR LAHAN — DIPERBAIKI v3
==============================================================================
LAYOUT 2 SEKSI:
  ── BERJALAN ──────────────────────────────────────────
  Card lahan aktif
  
  ── SELESAI ───────────────────────────────────────────
  Card lahan selesai
  Tombol per card: [Bandingkan] [Hapus dari Supabase]

CARD LAHAN (collapsed + expand):
  Collapsed: ID Lahan | Nama | Jenis Tanaman | HST Hari Ini | Badge status
  Tap → expand: detail lengkap
  Tombol [Aktifkan] | [Edit] | [Mulai Modal Pra-Tanam]
  TOMBOL BARU [Tutup Siklus] — hanya tampil jika status='aktif'
    → Flow: BUG 17 + 7.17: dialog paksa backup → tutup siklus → update riwayat_id_lahan

TUTUP SIKLUS — ALUR LENGKAP:
  1. Tap [Tutup Siklus] di card lahan
  2. Dialog konfirmasi:
     "⚠️ Sebelum menutup siklus, sangat disarankan untuk backup data terlebih dahulu."
     [💾 Backup ke HP]     → jalankan exportBackup() → toast "Backup tersimpan"
     [☁️ Sync ke Supabase] → jalankan syncToSupabase() → toast "Sinkronisasi selesai"
     [✓ Lanjut Tutup Siklus] → muncul setelah salah satu backup/sync berhasil, atau kapan saja
     [Batal]
  3. Konfirmasi kedua: "Tutup siklus [Nama Siklus] untuk lahan [Nama Lahan]? Aksi ini tidak bisa dibatalkan."
     [Ya, Tutup] [Batal]
  4. Proses: depresiasi aset → UPDATE siklus → UPDATE lahan → UPDATE riwayat_id_lahan → antrian sync

SINKRONISASI DAFTAR LAHAN (anti-error):
  - Sebelum tampil daftar lahan: reconcile lokal vs Supabase (jika aktif)
  - Sinkronisasi manual: antrian_sinkronisasi diproses per baris, bukan batch besar
  - Jika gagal sinkronisasi 1 baris: skip, tandai 'gagal', lanjut baris berikutnya
  - Tampilkan jumlah pending + error setelah sync selesai
  - Hapus dari Supabase: hanya operasi DELETE di Supabase, lokal tidak berubah

SEARCH + FILTER:
  Search bar (nama / id lahan)
  Filter: Semua | Berjalan | Selesai
  Filter jenis tanaman (dropdown)

FAB +: tambah lahan baru → tambah_lahan_screen.dart
  Setelah tambah lahan: INSERT ke riwayat_id_lahan juga

==============================================================================
SECTION 13: HALAMAN STOK & NOTIF PRODUK — DIPERLENGKAP v3
==============================================================================
HEADER INFO: ID Lahan aktif | HST | Tanggal (info bar standar)

LIST PRODUK — DROPDOWN BASED:
  Dropdown pilih produk (bukan list card scroll) atau tambah mode list, bisa toggle
  Saat pilih produk dari dropdown → tampil:
    Stok: X gram | Harga WMA: Rp Y/gram | Nilai Total: Rp Z (REALTIME)
    Badge ⚠️ jika stok < batas minimal
    Tombol [Beli/Tambah Stok] | [Lihat Detail] | [Edit]

TOTAL NILAI STOK KESELURUHAN (di atas list/dropdown):
  Card: "Total Nilai Stok Gudang: Rp [sum(stok_gram × harga_rata_rata)] "
  Update realtime setiap ada transaksi

INPUT/OUTPUT PRODUK (dropdown, realtime):
  Tombol [Catat Pemakaian Manual] → form:
    Pilih Produk (dropdown) | Jumlah (gram) | Tipe (pakai/koreksi_tambah/koreksi_kurang/kedaluwarsa)
    Lahan/Aktivitas (opsional) | Catatan
    Preview: Stok Sebelum → Stok Sesudah (realtime update)
    [Simpan] → INSERT transaksi_stok + UPDATE produk.stok_gram

RIWAYAT TRANSAKSI PER PRODUK:
  Dropdown produk → tampil list transaksi (beli/pakai/koreksi) dengan total harga tiap baris
  Kolom: Tanggal | Tipe | Jumlah | Harga Satuan | Total | Lahan/Aktivitas | Saldo Sesudah

SEARCH + FILTER: (Semua / Pupuk / Obat) + search nama

FAB +: tambah produk baru

DETAIL PRODUK (bottom sheet, 3 tab):
  Tab [Data Produk]: semua kolom produk + harga_per_kg
  Tab [Stok & Riwayat]: stok, WMA, nilai total, riwayat transaksi
  Tab [Notifikasi]: batas minimal stok, toggle per aktivitas, hari sebelum

==============================================================================
SECTION 14: HALAMAN SEMPROT — DIPERLENGKAP v3
==============================================================================
INFO BAR: ID Lahan | HST | Tanggal
FLOATING ALARM BANNER: 2 baris (semprot pupuk + obat)

ALARM COLLAPSIBLE GANDA:
  Alarm 1: Semprot Obat
    Toggle ON/OFF | Interval hari (edit inline) → simpan ke siklus.interval_notifikasi_semprot_obat_hari
  Alarm 2: Semprot Pupuk Daun
    Toggle ON/OFF | Interval hari → siklus.interval_notifikasi_semprot_pupuk_hari
  PENTING: interval 2 alarm INI TERPISAH dan bisa berbeda

Form input (2 kolom):
  Lahan Aktif (readonly) | ID Lahan (readonly, dari info bar)
  Tanggal Aktivitas | HST (otomatis, bisa edit)
  Volume Air (liter) | Target OPT (dropdown + custom)
  Jumlah Pekerja | Upah per Orang
  Biaya Utilitas | Biaya Tambahan

Seksi Produk:
  [+ Tambah Produk] → produk_search_widget
  Tabel: Nama | Dosis (g/L) | Total Gram | Harga WMA | Biaya | [Hapus]
  Di bawah nama produk: jika ada risiko resistensi → badge merah "⚠️ Risiko Resistensi [FRAC X]"
  Tooltip badge: "Kode ini sudah dipakai > 3x berturut-turut. Pertimbangkan rotasi."

[Hitung Unsur Hara] | [Hitung Total Biaya]
[Simpan] → validasiStok → modal konfirmasi → simpan

KALKULATOR PUPUK DAUN (collapsible, di halaman semprot):
  Dropdown pilih produk | Dosis g/liter | Volume air (liter)
  Output: total gram + total biaya (WMA) + preview hara
  INI menggunakan stok gudang → tampil stok sisa setelah pakai

List history semprot (10 terbaru, expand untuk detail)

==============================================================================
SECTION 15: HALAMAN PEMUPUKAN — DIPERLENGKAP v3
==============================================================================
INFO BAR: ID Lahan | HST | Tanggal
FLOATING ALARM BANNER

ALARM COLLAPSIBLE: Pemupukan
Form input (2 kolom):
  Lahan Aktif | ID Lahan (readonly)
  Tanggal | HST | Metode | Populasi Aplikasi
  Air/Tanaman (ml) | Total Air (otomatis)
  Jumlah Pekerja | Upah per Orang

KALKULATOR STOK REALTIME (BARU v3):
  Di bawah tiap produk yang ditambahkan:
    Stok Tersedia: [X] gram | Dibutuhkan: [Y] gram | Sisa: [Z] gram
    Z < 0: badge merah "Stok kurang"
    Z < batas_minimal: badge kuning "Di bawah minimum"
  Total biaya realtime update saat ubah dosis

Seksi Produk Utama: (sama v2 + kalkulator stok)
Seksi Produk Tambahan: (sama v2)
Seksi Tenaga Kerja
[Simpan] → validasiStok → modal konfirmasi

==============================================================================
SECTION 16: HALAMAN PANEN
==============================================================================
INFO BAR: ID Lahan | HST | Tanggal
FLOATING ALARM BANNER

(Sama dengan v2 — 3 grafik tetap ada)

Form input:
  Lahan Aktif | ID Lahan (readonly)
  Tanggal | HST | Populasi Hidup (readonly)
  Grade A (gram) | Harga Grade A (Rp/kg)
  Grade B (gram) | Harga Grade B (Rp/kg)
  Reject (gram)
  Omzet Kotor (otomatis) | Biaya Transport | Biaya TK
  Omzet Bersih (otomatis) | Omzet/Tanaman (otomatis)

==============================================================================
SECTION 17: HALAMAN PERAWATAN — DIPERLENGKAP TOTAL v3
==============================================================================
INFO BAR: ID Lahan | HST | Tanggal
FLOATING ALARM BANNER

NOTIFIKASI PERAWATAN:
  Saat jadwal_berikutnya diisi saat simpan perawatan:
    INSERT jadwal_notifikasi_produk (aktivitas='perawatan', tanggal_aktivitas=jadwal_berikutnya, ...)
    INSERT notifikasi_aktivitas (jenis='perawatan', judul="Jadwal Perawatan Lahan [ID Lahan]", isi=...)
  Tampil di panel notifikasi Slide 1 (jadwal mendatang)

FORM INPUT (2 kolom):
  Lahan Aktif (readonly) | ID Lahan (readonly)
  Tanggal Aktivitas | HST (otomatis, bisa edit)
  Jenis Kerja (dropdown — 12 pilihan) | Kondisi Cuaca (dropdown)
  Kondisi Tanaman (dropdown: baik/sedang/buruk/kritis)

AKTIVITAS DETAIL:
  Deskripsi Aktivitas [TextArea] — apa yang dilakukan
    Tooltip: "Jelaskan aktivitas perawatan: alat yang dipakai, area yang dikerjakan, dll."
  Temuan Masalah [TextArea] — masalah yang ditemukan (opsional)
    Tooltip: "Apakah ada hama, penyakit, kerusakan, tanaman layu, dll?"
  Tindakan Lanjut [TextArea] — rencana ke depan (opsional)
    Tooltip: "Apa yang perlu dilakukan di sesi berikutnya?"
  Foto [opsional] — ambil foto kondisi lahan

TENAGA KERJA:
  Jumlah Pekerja | Upah per Orang
  Jenis Pekerjaan (label singkat)

BIAYA:
  Biaya Utilitas | Biaya Bahan Habis Pakai (tali, ajir baru, dll)
  Total Biaya (otomatis)

JADWAL BERIKUTNYA & NOTIFIKASI:
  Tanggal Perawatan Berikutnya [DatePicker] (opsional)
    → Jika diisi: buat notifikasi reminder H-interval_hari
  Interval Pengingat: [___] hari sebelum jadwal
  Toggle notifikasi perawatan: ON/OFF

CATATAN KEJADIAN [TextArea]:
  Field bebas untuk catat kejadian apapun terkait lahan/tanaman saat hari itu
  Tooltip: "Catat hal apapun: hujan deras, serangan mendadak, temuan unik, keputusan tani, dll."

Modal konfirmasi: lihat Section 9 (modal perawatan diperlengkap)
[Simpan] → INSERT perawatan + detail_tenaga_kerja + jadwal notif + cashflow_snapshot

LIST HISTORY PERAWATAN (di bawah form):
  Sorted by tanggal DESC
  Card per item: Jenis Kerja | HST | Kondisi Tanaman | Total Biaya
  Expand: deskripsi aktivitas, temuan masalah, tindakan lanjut, foto

==============================================================================
SECTION 18: HALAMAN CATATAN LAPANGAN
==============================================================================
INFO BAR: ID Lahan | HST | Tanggal
FLOATING ALARM BANNER

Form: Lahan Aktif | ID Lahan (readonly) | Tanggal | HST
Jenis Masalah | Tingkat Bahaya | Deskripsi
Loss Count | Nilai Kerugian (otomatis)
Foto (opsional)
Simpan → UPDATE siklus.total_mati → INSERT cashflow_snapshot

==============================================================================
SECTION 19: HALAMAN HISTORY
==============================================================================
INFO BAR: ID Lahan | HST | Tanggal

Header: Hamburger | History | Dropdown Lahan | Lonceng
(Sama dengan v2 — ringkasan biaya realtime per kategori)

==============================================================================
SECTION 20: HALAMAN LAPORAN (5 TAB) — DIPERLENGKAP v3
==============================================================================
INFO BAR: ID Lahan | HST | Tanggal

SUB-TAB: [Ringkasan] [Analytics] [Cashflow] [Unsur Hara] [Ekspor]
Tombol terpisah: [Laporan Stok Gudang →]

RANGE TANGGAL LAPORAN (BARU v3):
  Di bagian atas laporan: pilihan range tanggal
    ○ Seluruh Siklus (dari tanggal_tanam s.d. sekarang/tanggal_selesai) — default
    ○ Kustom: [Tanggal Awal] s.d. [Tanggal Akhir] — pilih bebas
  Semua tab mengikuti range tanggal yang dipilih.
  Contoh: siklus sudah 3 bulan, tapi user mau laporan hanya 2 bulan pertama → bisa.
  Ekspor Excel/PDF juga mengikuti range yang dipilih.

TAB 1–4: (sama dengan v2)

TAB 5: EKSPOR (DIPERLENGKAP v3):
  Range tanggal aktif ditampilkan di sini
  [Ekspor Excel Lengkap (.xlsx)] — 10 sheet, mengikuti range
  [Ekspor Ringkasan PDF] — 1 halaman, mengikuti range
  [Ekspor Laporan Stok Gudang]
  Status: tanggal + nama file terakhir ekspor

==============================================================================
SECTION 21: HALAMAN PENGATURAN — DIPERLENGKAP v3 (5 SUB-TAB)
==============================================================================
Tab [Umum]:
  Toggle dark/light mode | Bahasa (Indonesia)
  Interval alarm Semprot Pupuk Daun (default: 7 hari) — BARU: terpisah dari obat
  Interval alarm Semprot Obat (default: 7 hari)         — BARU: terpisah dari pupuk
  Notifikasi: suara, getaran
  Ukuran Font, Mode Tampilan, Kontras Tinggi, Format Tanggal

Tab [Data & Backup]:
  ── BACKUP LOKAL ─────────────────────────────────────────────
  [💾 Backup ke HP Sekarang] — tooltip: "Ekspor semua data ke file .agrotrack di penyimpanan HP"
  [📂 Import dari HP] — tooltip: "Muat data dari file .agrotrack yang sudah ada di HP"
  Riwayat 7 backup terbaru (tanggal, ukuran, path)
  Toggle [Backup Otomatis Lokal]: ON/OFF — tooltip: "Backup otomatis setiap buka app jika > 24 jam sejak backup terakhir"
  Status: Backup lokal terakhir: [tanggal]
  
  ── SINKRONISASI SUPABASE ────────────────────────────────────
  Info: "Sinkronisasi Supabase menggunakan project Supabase milik Anda sendiri (gratis)."
  [☁️ Ekspor ke Supabase] — tooltip: "Kirim semua data lokal ke Supabase cloud"
  [⬇️ Import dari Supabase] — tooltip: "Ambil data dari Supabase ke lokal (overwrite lokal)"
  [🔄 Sinkronisasi Manual Supabase] — tooltip: "Proses antrian pending lokal → kirim ke Supabase"
  Toggle [Sinkronisasi Otomatis Supabase]: ON/OFF — tooltip: "Sinkronisasi otomatis setiap 30 menit jika ada antrian + ada koneksi"
  Status: Sinkronisasi terakhir: [tanggal] | Antrian pending: [N] item
  [Lihat Antrian Sinkronisasi] → halaman detail antrian

  ── HAPUS SIKLUS MANUAL ──────────────────────────────────────
  Daftar siklus 'selesai' → [Hapus Siklus] per baris

  ── IMPOR / EKSPOR FORMAT ────────────────────────────────────
  [Ekspor ke JSON] | [Import dari JSON] — untuk migrasi/debug

Tab [Keamanan]:
  Kunci App: ON/OFF
  PIN 4 digit ATAU Sidik Jari (radio)
  Session timeout: 5/10/30/60 menit / Tidak pernah

Tab [Sinkronisasi Supabase]:
  Input Supabase URL | Anon Key (obscure)
  [Uji Koneksi] | [Simpan]
  Info koneksi aktif: URL aktif, status, versi

Tab [Riwayat Lahan]:
  BARU v3 — Daftar semua ID Lahan yang pernah digunakan
  Tampil dari tabel riwayat_id_lahan
  Info per baris: ID Lahan | Nama | Jenis Tanaman | Tanggal Pertama | Total Siklus | Status Terakhir
  TIDAK ADA tombol hapus — hanya informasi
  Tersinkronisasi otomatis ke Supabase jika aktif
  Status sinkronisasi: [✓ Tersinkronisasi] atau [⏳ Menunggu sync]
  Tooltip: "Riwayat ini tidak bisa dihapus dan berfungsi sebagai audit trail semua lahan yang pernah digunakan."

==============================================================================
SECTION 22: HALAMAN KERANJANG SAMPAH
==============================================================================
(Sama dengan v2)

==============================================================================
SECTION 23: HALAMAN AKTIVASI LISENSI — DIREVISI v4 (SUPABASE)
==============================================================================
Tampil saat pertama install (lisensi belum aktif di lokal + secure storage).

LAYOUT:
  Logo AgroTrack + Logo ClipSmart (besar)
  Judul: "Aktivasi AgroTrack"
  Teks: "Masukkan data dan license key yang kamu terima dari ClipSmart. Aktivasi hanya dilakukan sekali."

  Form:
    Nama Lengkap [TextField]
    Kota Asal [TextField]
    License Key [TextField]
      → uppercase otomatis, hint: "Contoh: TSM-0001"
      → validasi format client-side: TSM- + 4 digit angka

  Info Device ID (readonly, tidak bisa diedit):
    Label: "ID Perangkat Anda"
    Value: [device_id otomatis via device_info_plus → androidId]

  [✅ Aktifkan Sekarang] — tombol hijau, lebar penuh
    → disabled jika ada field kosong atau format key salah

VALIDASI CLIENT-SIDE (sebelum kirim ke RPC):
  - Nama Lengkap: wajib, minimal 2 karakter.
  - Kota Asal: wajib.
  - License Key: wajib, format TSM-[4 digit angka] (regex: ^TSM-\d{4}$).
  - Tombol aktif hanya jika semua valid.

LOADING STATE:
  Saat tap [Aktifkan Sekarang]:
    - CircularProgressIndicator + teks "Mengecek lisensi..."
    - Tombol disabled selama proses.
    - Panggil: supabase.rpc('activate_license', params: { license_key, customer_name, customer_city, device_id })

HASIL SUKSES:
  - Simpan license_key + product_version ke flutter_secure_storage.
  - Simpan ke tabel lisensi lokal SQLite.
  - Snackbar hijau: "Aktivasi berhasil! Selamat datang, [Nama]."
  - Auto-navigasi ke beranda (GoRouter redirect).

HASIL GAGAL — PESAN ERROR PER KASUS:
  "Key tidak valid."           → tampil: "Key tidak ditemukan. Periksa kembali."
  "Key diblokir oleh admin."   → tampil: "Key ini diblokir. Hubungi ClipSmart."
  "Key sudah dipakai di perangkat lain." → tampil: "Key ini aktif di HP lain. Hubungi ClipSmart untuk reset device."
  Network error / timeout      → tampil: "Gagal terhubung. Periksa koneksi internet."
  Form tetap bisa diedit untuk coba ulang.

TIDAK ADA INTERNET:
  Jika offline saat tap [Aktifkan Sekarang]:
    → Banner merah: "Tidak ada koneksi internet. Aktivasi memerlukan internet sekali saja."
    → Tombol [Coba Lagi] muncul.

TIDAK ADA:
  ✗ Tombol "Masuk Tanpa Aktivasi"
  ✗ Mode Trial
  ✗ Polling berkala
  ✗ WhatsApp flow / url_launcher untuk WA
  ✗ Grace period untuk masuk gratis

==============================================================================
SECTION 24: MODAL PRA-TANAM (7 BAGIAN) — DIPERLENGKAP v3
==============================================================================
Akses dari: card lahan di Daftar Lahan → [Mulai Modal Pra-Tanam]
Fullscreen modal/page. Autosave draft setiap 30 detik ke pra_tanam_draft.
Banner kuning jika ada draft: "Ada draft tersimpan. [Lanjutkan] atau [Mulai Baru]?"

SEMUA KOLOM DI TABEL pra_tanam_draft HARUS ADA DI HALAMAN INI.

Bagian 1 — INFO SIKLUS:
  Lahan (readonly, nama + ID lahan) | Tanggal Mulai Olah | Tanggal Tanam (WAJIB AKURAT)
  Populasi Tanam | Jenis Tanaman | Varietas

Bagian 2 — OLAH LAHAN:
  Metode (dropdown: cangkul / traktor / keduanya)
  JIKA cangkul atau keduanya: Jumlah Pekerja | Upah/Orang | Hari Kerja
    Subtotal cangkul = pekerja × upah × hari (otomatis)
  JIKA traktor atau keduanya: Biaya Sewa | Hari Sewa
    Subtotal traktor = biaya_sewa × hari (otomatis)
  Subtotal Olah Lahan: Rp X (otomatis)

Bagian 3 — PERSIAPAN TANAH:
  Dolomit: berat (kg) | Rp/kg → Subtotal
  Pupuk Kandang: berat (kg) | Rp/kg → Subtotal
  NPK Dasar: berat (kg) | Rp/kg → Subtotal
  Bio-Aktivator: Nama produk | Biaya
  Pestisida Tanah: Nama produk | Biaya
  Analisa Tanah: Biaya
  Subtotal Persiapan Tanah: Rp X (otomatis)

Bagian 4 — MULSA:
  Jumlah Roll | Rp/Roll → Subtotal bahan
  Pemasangan: Pekerja Pasang | Upah Pasang
  Pengeboran: Pekerja Lubangi | Upah Lubangi
  Subtotal Mulsa: Rp X

Bagian 5 — BIBIT:
  Sumber (radio: Beli Batang / Semai Sendiri)
  BELI: Jumlah Batang | Rp/Batang → Subtotal
  SEMAI: Gram Benih | Rp Benih | Biaya Media Semai | Biaya Tenaga Semai → Subtotal
  Cadangan: % (default 10%) — info: "Bibit cadangan = N batang tambahan"
  Subtotal Bibit: Rp X

Bagian 6 — PENANAMAN & AJIR:
  Penanaman: Jumlah Pekerja | Upah/Orang → Subtotal
  Irigasi Awal: Biaya
  Ajir: Jenis (dropdown) | Jumlah | Rp/pcs → Subtotal bahan
    Pasang Ajir: Pekerja | Upah → Subtotal pasang
  Tali/Rafia: Biaya
  Net/Screen House: Biaya
  Subtotal Penanaman & Ajir: Rp X

Bagian 7 — LAIN-LAIN:
  Transportasi | Konsumsi Pekerja | Instalasi Irigasi
  Lainnya: bisa tambah label custom (+ Tambah Item)
  Subtotal Lain-lain: Rp X

RINGKASAN & SUBMIT:
  Tabel preview: per kategori — Subtotal | % dari total
  Total Biaya Pra-Tanam: Rp X (BESAR, di bawah tabel)
  [💾 Simpan Draft] — autosave, siklus belum dibuat
  [✅ Submit & Mulai Siklus] → buat siklus + INSERT biaya_pembukaan per item + INSERT cashflow_snapshot

==============================================================================
SECTION 25: EKSPOR EXCEL (10 SHEET + GRAFIK) — DIPERLENGKAP v3
==============================================================================
(Sama dengan v2, dengan tambahan:)

RANGE TANGGAL: semua sheet mengikuti range yang dipilih di Tab Ekspor Laporan.
  Header tiap sheet: "Periode: [Tanggal Awal] s.d. [Tanggal Akhir]"

SHEET 1–9: (sama dengan v2)

SHEET 10: MODAL AWAL & PRA-TANAM (sama dengan v2)

FORMAT ANGKA: (sama dengan v2)
  Header baris ID Lahan + HST + Tanggal di setiap sheet.

==============================================================================
SECTION 26: BACKUP & SINKRONISASI — DIPERJELAS TOTAL v3
==============================================================================

──────────────────────────────────────────────────────────────────────
A. BACKUP LOKAL (path_provider + dart:io)
──────────────────────────────────────────────────────────────────────
FORMAT: AgroTrack_backup_YYYYMMDD_HHmmss.agrotrack
ISI: JSON seluruh tabel (kecuali: antrian_sinkronisasi, keranjang_sampah,
     notifikasi_aktivitas, notifikasi_admin, jadwal_notifikasi_produk, lisensi)
PATH: getExternalStorageDirectory()/AgroTrack/backup/
RETENSI: pertahankan 7 file terbaru, hapus yang lama

BACKUP MANUAL (Pengaturan → Data & Backup → [Backup ke HP]):
  Jalankan exportBackup() → tulis file → toast "Backup tersimpan: [nama file]"
  Tooltip tombol: "Ekspor semua data tani ke file .agrotrack di HP kamu. Bisa dipindah ke HP lain."

IMPORT DARI HP (Pengaturan → Data & Backup → [Import dari HP]):
  file_picker → pilih file .agrotrack
  Parse JSON → validasi format → konfirmasi "Data lokal akan ditimpa. Lanjut?"
  Import → toast "Import berhasil"
  Tooltip: "Muat ulang data dari file backup .agrotrack. Data lokal saat ini akan ditimpa."

BACKUP OTOMATIS LOKAL:
  Toggle di Pengaturan (default: ON)
  Trigger: setiap app dibuka, jika (nowSec - backup_terakhir_lokal) > 86400 (24 jam)
  Tidak perlu konfirmasi user — silent background

──────────────────────────────────────────────────────────────────────
B. SINKRONISASI SUPABASE (supabase_flutter)
──────────────────────────────────────────────────────────────────────
KONFIGURASI: dari Pengaturan → Sinkronisasi Supabase: input URL + Anon Key
SUPABASE = project pribadi user (bukan ClipSmart central)
APP JALAN 100% TANPA SUPABASE.

EKSPOR KE SUPABASE (Pengaturan → Data & Backup → [Ekspor ke Supabase]):
  Kirim semua tabel WAJIB_SYNC ke Supabase (upsert berdasarkan id + id_lahan)
  Progress bar saat proses
  Toast: "Ekspor ke Supabase selesai: [N] tabel"
  Tooltip: "Kirim semua data lokal ke Supabase cloud. Data di Supabase akan diperbarui."

IMPORT DARI SUPABASE (Pengaturan → Data & Backup → [Import dari Supabase]):
  Ambil semua tabel dari Supabase → timpa lokal
  Konfirmasi: "Data lokal akan ditimpa dengan data dari Supabase. Lanjut?"
  Tooltip: "Ambil data dari Supabase ke HP ini. Cocok jika pindah HP atau restore dari cloud."

SINKRONISASI MANUAL SUPABASE (Pengaturan → Data & Backup → [Sinkronisasi Manual Supabase]):
  Proses antrian_sinkronisasi WHERE status='pending' → push ke Supabase
  Retry max 3x per baris → jika gagal: status='gagal'
  Tampil ringkasan: "X sukses, Y gagal"
  Tooltip: "Proses antrian perubahan data yang belum terkirim ke Supabase."

SINKRONISASI OTOMATIS SUPABASE:
  Toggle di Pengaturan (default: OFF sampai URL diisi)
  Trigger: setiap 30 menit, jika ada antrian pending + ada koneksi internet
  Background isolate (WorkManager atau timer)
  Tooltip: "Sinkronisasi otomatis ke Supabase setiap 30 menit jika ada koneksi."

TABEL WAJIB SINKRONISASI:
  lahan, riwayat_id_lahan, siklus, produk, riwayat_pembelian, transaksi_stok
  semprot, item_semprot, pemupukan, item_pemupukan, item_tambahan_pemupukan
  panen, perawatan, catatan_lapangan, aset, biaya_pembukaan
  modal_awal, hutang, supplier, cashflow_snapshot, pra_tanam_draft
  detail_unsur_per_pohon

TIDAK DISINKRONISASI:
  antrian_sinkronisasi, keranjang_sampah, notifikasi_aktivitas, notifikasi_admin
  jadwal_notifikasi_produk, lisensi, pengaturan (kecuali preferensi non-sensitif)

PERBEDAAN EKSPOR vs SINKRONISASI:
  Ekspor ke Supabase: kirim SEMUA data sekaligus (full snapshot)
  Sinkronisasi (manual/otomatis): kirim hanya PERUBAHAN (antrian_sinkronisasi)
  Import dari Supabase: AMBIL semua dari cloud ke lokal

──────────────────────────────────────────────────────────────────────
C. ANTRIAN SINKRONISASI
──────────────────────────────────────────────────────────────────────
Setiap INSERT/UPDATE/DELETE di tabel WAJIB_SYNC: tambah baris ke antrian_sinkronisasi
Payload: JSON baris yang berubah
Proses antrian: satu per satu (bukan batch), skip baris gagal, lanjut ke berikutnya
Konflik: bandingkan updated_at lokal vs Supabase (lihat BUG 18)

==============================================================================
SECTION 27: DATA SEED (PRODUK AWAL)
==============================================================================
(Sama dengan v2 — lihat BUG 1 untuk cara insert yang benar)

const SEED_PRODUK = [
  { nama: "Urea", kategori: "pupuk", n_persen: 460000, stok_gram: 50000, harga_rata_rata: 10, harga_per_kg: 10000, satuan_kemasan: "kg" },
  { nama: "MKP", kategori: "pupuk", p_persen: 520000, k_persen: 340000, stok_gram: 25000, harga_rata_rata: 25, harga_per_kg: 25000, satuan_kemasan: "kg" },
  { nama: "KCl", kategori: "pupuk", k_persen: 600000, stok_gram: 40000, harga_rata_rata: 15, harga_per_kg: 15000, satuan_kemasan: "kg" },
  { nama: "Magnesium Sulfat", kategori: "pupuk", mg_persen: 160000, s_persen: 130000, stok_gram: 20000, harga_rata_rata: 20, harga_per_kg: 20000, satuan_kemasan: "kg" },
  { nama: "Malika", kategori: "pupuk", ca_persen: 870000, b_persen: 30000, mg_persen: 10000, s_persen: 1000, stok_gram: 15000, harga_rata_rata: 35, harga_per_kg: 35000, satuan_kemasan: "kg" },
];
-- Kolom harga_per_kg BARU v3 — untuk kalkulator bebas di dashboard

Setelah INSERT: INSERT notifikasi_produk (5 aktivitas) + INSERT batas_stok_produk

==============================================================================
SECTION 28: MIGRASI DATABASE (DRIFT)
==============================================================================
@override
MigrationStrategy get migration => MigrationStrategy(
  onCreate: (m) async { await m.createAll(); await seedData(); },
  onUpgrade: (m, from, to) async {
    if (from < 2) {
      // v1 → v2: kolom baru
      await m.addColumn(lahan, lahan.linkGoogleMaps);
    }
    if (from < 3) {
      // v2 → v3: kolom baru
      await m.addColumn(siklus, siklus.intervalNotifikasiSemprotPupukHari);
      await m.addColumn(siklus, siklus.intervalNotifikasiSemprotObatHari);
      await m.addColumn(produk, produk.hargaPerKg);
      await m.addColumn(semprot, semprot.adaRisikoResistensi);
      await m.addColumn(semprot, semprot.kodeFracTerpakai);
      await m.addColumn(semprot, semprot.kodeIracTerpakai);
      await m.addColumn(perawatan, perawatan.lahanId);
      await m.addColumn(perawatan, perawatan.deskripsiAktivitas);
      await m.addColumn(perawatan, perawatan.kondisiTanaman);
      await m.addColumn(perawatan, perawatan.kondisiCuaca);
      await m.addColumn(perawatan, perawatan.temuanMasalah);
      await m.addColumn(perawatan, perawatan.tindakanLanjut);
      await m.addColumn(perawatan, perawatan.biayaBahanHabisPakai);
      await m.addColumn(perawatan, perawatan.jadwalBerikutnya);
      await m.addColumn(perawatan, perawatan.intervalHari);
      await m.addColumn(catatan_lapangan, catatan_lapangan.lahanId);
      await m.addColumn(biaya_pembukaan, biaya_pembukaan.lahanId);
      await m.addColumn(biaya_pembukaan, biaya_pembukaan.jumlahUnit);
      await m.addColumn(biaya_pembukaan, biaya_pembukaan.satuanUnit);
      await m.addColumn(biaya_pembukaan, biaya_pembukaan.hargaSatuan);
      await m.addColumn(biaya_pembukaan, biaya_pembukaan.namaPemasok);
      await m.addColumn(biaya_pembukaan, biaya_pembukaan.nomorNota);
      await m.addColumn(biaya_pembukaan, biaya_pembukaan.fotoNotaPath);
      await m.addColumn(biaya_pembukaan, biaya_pembukaan.isHutang);
      await m.addColumn(cashflow_snapshot, cashflow_snapshot.lahanId);
      await m.addColumn(pra_tanam_draft, pra_tanam_draft.subtotalOlahLahan);
      await m.addColumn(pra_tanam_draft, pra_tanam_draft.subtotalPersiapanTanah);
      await m.addColumn(pra_tanam_draft, pra_tanam_draft.subtotalMulsa);
      await m.addColumn(pra_tanam_draft, pra_tanam_draft.subtotalBibit);
      await m.addColumn(pra_tanam_draft, pra_tanam_draft.subtotalPenanamanAjir);
      await m.addColumn(pra_tanam_draft, pra_tanam_draft.subtotalLainnya);
      await m.createTable(riwayat_id_lahan);
    }
    if (from < 4) {
      // v3 → v4: tabel lisensi diperbarui (kolom baru, kolom lama dihapus via recreate)
      // Drift tidak support DROP COLUMN langsung → drop & recreate tabel lisensi
      await customStatement('DROP TABLE IF EXISTS lisensi');
      await m.createTable(lisensi);
      // Kolom baru: license_key, product_version
      // Kolom dihapus: versi_aplikasi (tidak relevan)
      // Kolom dihapus: nama_pengguna → diganti customer_name (di tabel baru)
      // CATATAN: data lisensi lama hilang, user akan diminta aktivasi ulang (1x).
    }
  },
  beforeOpen: (details) async {
    await customStatement('PRAGMA foreign_keys = ON');
  },
);
Versi skema: mulai 1, naikkan tiap perubahan tabel.

==============================================================================
SECTION 29: TAHAP PENGEMBANGAN
==============================================================================
TAHAP 1 — VISUAL & MOCK DATA:
  Semua halaman dengan data hardcoded
  Sidebar + header + info bar + floating alarm banner + panel notifikasi 5 slide
  Alarm collapsible ganda (semprot_obat + semprot_pupuk, interval TERPISAH)
  Modal konfirmasi dengan tabel 14 unsur + dampak stok + perawatan diperlengkap
  Dashboard: cards + grafik multifungsi 7 mode + kalkulator gram/harga + kalkulator bebas
  Panen: 3 grafik (mock)
  Laporan: 5 tab + range tanggal + donut + radar + cashflow + bar hara
  Daftar Lahan: seksi berjalan+selesai + tutup siklus + bandingkan
  Stok & Notif Produk: 1 halaman, dropdown produk, total nilai real
  Pengaturan: 5 tab termasuk Riwayat Lahan + Sinkronisasi diperlengkap
  Halaman aktivasi lisensi (tampilan saja, tanpa bypass)
  Halaman Perawatan: form lengkap + catatan kejadian + notifikasi
  Halaman Semprot: peringatan FRAC/IRAC
  Dark mode default

TAHAP 2 — DATABASE & LOGIKA:
  Aktifkan drift, buat 32 tabel + indeks + migrasi
  Hubungkan semua form ke database (CRUD)
  Kalkulator 14 unsur hara + grade label
  Kalkulator pupuk bebas + gram/harga (realtime)
  Cashflow snapshot setiap aktivitas
  WMA stok + riwayat pembelian
  Biaya per pohon berjalan
  HPP, BEP, ROI
  Population loss cascade
  Soft delete + keranjang sampah
  Notifikasi per produk + perawatan
  Validasi stok (tidak block)
  Floating alarm banner realtime
  Peringatan resistensi FRAC/IRAC
  Tutup siklus + riwayat_id_lahan

TAHAP 3 — LISENSI & NOTIFIKASI:
  Supabase license activation (RPC activate_license, 1x seumur hidup, tanpa verifikasi berkala)
  Setup Supabase project ClipSmart: tabel licenses, RLS, RPC activate_license()
  Form aktivasi: Nama + Kota + Key (TSM-XXXX) → RPC → simpan token ke secure storage
  Migrasi DB v3→v4: drop & recreate tabel lisensi lokal
  flutter_local_notifications untuk alarm harian
  Keamanan: PIN/biometrik, session timeout
  Backup lokal otomatis + manual

TAHAP 4 — SINKRONISASI & EKSPOR:
  Supabase BYO sync: antrian, manual, otomatis
  Ekspor ke Supabase + Import dari Supabase (terpisah dari sinkronisasi)
  Ekspor Excel 10 sheet + range tanggal + grafik PNG
  Ekspor PDF ringkasan
  Riwayat ID Lahan tersinkronisasi

TAHAP 5 — FITUR TAMBAHAN:
  Barcode scanner produk
  Kamera catatan lapangan
  Dashboard analytics multi-siklus
  Deteksi resistensi FRAC/IRAC otomatis

==============================================================================
SECTION 30: PENUTUP & PERINTAH MEMULAI
==============================================================================
Blueprint v4.0 selesai.
Total: 30 section, 32 tabel, 17+ halaman, 10 sheet ekspor
Tech: Flutter/Dart, Drift, Riverpod, go_router, fl_chart, Supabase
Perubahan dari v3 → v4: sistem lisensi diganti total dari GAS/Google Sheets ke Supabase.
  Key format baru: TSM-0001. Status: ready/active/blocked.
  Aktivasi: form Nama+Kota+Key → RPC activate_license() → token lokal.
  Tidak ada WA flow, tidak ada polling, tidak ada GAS.
  Semua fitur lain dari v3 tetap sama.

PERINTAH UNTUK AI DEVELOPER:
"Kerjakan aplikasi AgroTrack berdasarkan BLUEPRINT v4.0 ini (file .md ini).
Mulai dari TAHAP 1: buat semua halaman visual dengan mock data.
Ikuti semua aturan di RULE 0 (BUG 1-18, adaptasi Dart).
Implementasikan:
- Sidebar + Global Farm Switcher
- Header + Info Bar (ID Lahan + HST + Tanggal) di TIAP halaman
- Floating Alarm Banner (2 baris: semprot pupuk + obat) di TIAP halaman
- Panel notifikasi 5 slide
- Alarm collapsible GANDA (semprot_obat + semprot_pupuk, interval TERPISAH)
- Beranda: card dashboard + grafik MULTIFUNGSI 7 mode + kalkulator gram/harga + kalkulator pupuk bebas
- Daftar Lahan: seksi Berjalan + Selesai + Tutup Siklus (dengan paksa backup), Bandingkan
- Stok & Notif Produk: dropdown produk, total nilai real, input/output realtime
- Semprot: peringatan FRAC/IRAC badge merah
- Pemupukan: kalkulator stok realtime
- Perawatan: form lengkap (aktivitas, temuan, tindakan lanjut, notifikasi, catatan kejadian)
- Modal Pra-Tanam: 7 bagian LENGKAP sesuai skema pra_tanam_draft
- Laporan: 5 tab + range tanggal kustom
- Pengaturan: 5 tab (Umum, Data&Backup, Keamanan, Sinkronisasi Supabase, Riwayat Lahan)
  → Data&Backup: backup lokal + import lokal + ekspor supabase + import supabase + toggle otomatis masing-masing
- Halaman aktivasi lisensi v4: form Nama + Kota + Key (TSM-XXXX), tanpa WA, tanpa polling
  → Aktivasi via Supabase RPC activate_license()
  → Token terenkripsi di flutter_secure_storage
- Dark mode sebagai default
Belum ada koneksi ke SQLite/database atau API."

Kontak ClipSmart:
  Email: raufimohamadfauzi@gmail.com
  WhatsApp: 083112626136

==============================================================================
END OF BLUEPRINT AGROTRACK v4.0
==============================================================================
