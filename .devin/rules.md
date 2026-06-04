\# AgroTrack v4.0 — Rules for Devin



\## Referensi Utama

Blueprint lengkap ada di: docs/agrotrack\_blueprint\_v4.md

Baca blueprint SEBELUM coding apapun.



\## Stack Wajib

Flutter/Dart, Drift, Riverpod, go\_router, fl\_chart, Supabase



\## RULE 0 — Bug Kritis (WAJIB semua diimplementasi)

\- BUG 2: Timestamp SELALU dalam detik. Pakai helper nowSec() di lib/core/timestamp.dart. JANGAN simpan millisecondsSinceEpoch tanpa \~/1000

\- BUG 6: Guard divide-by-zero SEBELUM semua operasi bagi

\- BUG 11: Kolom \*\_persen disimpan × 10000 (contoh: 46% → 460000)

\- BUG 1: produkId HARUS dari hasil INSERT, bukan hardcode/asumsi

\- BUG 3: UNIQUE constraint wajib di notifikasi\_produk, batas\_stok\_produk, jadwal\_notifikasi\_produk



\## UI — Wajib di SETIAP halaman

1\. Info Bar: \[ID Lahan] \[HST] \[Tanggal] — di bawah header, font 12sp, warna #9e9e9e

2\. Floating Alarm Banner: 2 baris (🌿 semprot pupuk + 💊 semprot obat), interval TERPISAH

3\. Dark mode = default (bg #2b322d, aksen #3ecf8e)



\## Lisensi v4 — Supabase Only

\- Format key: TSM-0001

\- Aktivasi 1x via RPC activate\_license() di Supabase

\- Token simpan di flutter\_secure\_storage

\- Flutter TIDAK BOLEH akses tabel licenses langsung

\- Tidak ada WA flow, tidak ada polling, tidak ada GAS



\## Tahap Sekarang: TAHAP 1

Buat semua halaman visual dengan mock data hardcoded.

Belum ada koneksi SQLite/database atau API.



\## Status

\- Tahap 1: SEDANG BERJALAN

