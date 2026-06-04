import 'package:intl/intl.dart';

/// Format angka ke format Rupiah dengan titik pemisah ribuan
/// Contoh: 1000000 -> Rp 1.000.000
String formatRupiah(int amount) {
  final formatter = NumberFormat.decimalPattern('id_ID');
  return 'Rp ${formatter.format(amount)}';
}

/// Format angka ke format Rupiah dengan desimal
/// Contoh: 1000000.5 -> Rp 1.000.000,50
String formatRupiahDecimal(double amount) {
  final formatter = NumberFormat.decimalPattern('id_ID');
  return 'Rp ${formatter.format(amount)}';
}

/// Format gram dengan titik pemisah ribuan
/// Contoh: 1000 -> 1.000 gram
String formatGram(int gram) {
  final formatter = NumberFormat.decimalPattern('id_ID');
  return '${formatter.format(gram)} gram';
}

/// Format tanggal ke format Indonesia
/// Contoh: 2025-06-12 -> 12/06/2025
String formatTanggal(DateTime date) {
  return DateFormat('dd/MM/yyyy').format(date);
}

/// Format tanggal dari epoch detik
String formatTanggalFromEpoch(int epochSeconds) {
  return formatTanggal(DateTime.fromMillisecondsSinceEpoch(epochSeconds * 1000));
}
