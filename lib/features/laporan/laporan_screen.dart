import 'package:flutter/material.dart';
import '../../shared/widgets/sidebar.dart';

class LaporanScreen extends StatefulWidget {
  const LaporanScreen({super.key});

  @override
  State<LaporanScreen> createState() => _LaporanScreenState();
}

class _LaporanScreenState extends State<LaporanScreen> {
  // Mock data for Info Bar
  final String _mockIdLahan = 'URTR1';
  final int _mockHST = 45;
  final String _mockTanggal = '12/06/2025';

  // Mock data for Floating Alarm Banner
  final int _hariSemprotPupuk = 3;
  final int _hariSemprotObat = 5;

  // Mock report data
  final Map<String, dynamic> _mockKeuanganData = {
    'total_pemasukan': 25000000,
    'total_pengeluaran': 15000000,
    'laba_bersih': 10000000,
    'margin_keuntungan': 40,
  };

  final Map<String, dynamic> _mockPanenData = {
    'total_panen_kg': 2500,
    'total_omzet': 25000000,
    'rata_rata_harga': 10000,
    'jumlah_kali_panen': 5,
  };

  final Map<String, dynamic> _mockAktivitasData = {
    'total_semprot': 8,
    'total_pemupukan': 6,
    'total_perawatan': 4,
    'total_panen': 5,
    'total_jam_kerja': 120,
  };

  // Mock monthly data for charts
  final List<Map<String, dynamic>> _mockMonthlyData = [
    {'bulan': 'Jan', 'pemasukan': 5000000, 'pengeluaran': 3000000, 'panen': 500},
    {'bulan': 'Feb', 'pemasukan': 6000000, 'pengeluaran': 3500000, 'panen': 600},
    {'bulan': 'Mar', 'pemasukan': 4000000, 'pengeluaran': 4000000, 'panen': 400},
    {'bulan': 'Apr', 'pemasukan': 7000000, 'pengeluaran': 2500000, 'panen': 700},
    {'bulan': 'Mei', 'pemasukan': 3000000, 'pengeluaran': 2000000, 'panen': 300},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff2b322d),
      appBar: AppBar(
        backgroundColor: const Color(0xff2b322d),
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Color(0xffe0e0e0)),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          'Laporan',
          style: TextStyle(
            color: Color(0xffe0e0e0),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xffe0e0e0)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: Color(0xffe0e0e0)),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Info Bar
          _buildInfoBar(),
          
          // Floating Alarm Banner
          _buildFloatingAlarmBanner(),
          
          // Main content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Period selector
                  _buildPeriodSelector(),
                  
                  const SizedBox(height: 16),
                  
                  // Keuangan Section
                  _buildKeuanganSection(),
                  
                  const SizedBox(height: 16),
                  
                  // Panen Section
                  _buildPanenSection(),
                  
                  const SizedBox(height: 16),
                  
                  // Aktivitas Section
                  _buildAktivitasSection(),
                  
                  const SizedBox(height: 16),
                  
                  // Monthly Chart Section
                  _buildMonthlyChartSection(),
                ],
              ),
            ),
          ),
        ],
      ),
      drawer: const Sidebar(),
    );
  }

  Widget _buildInfoBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xff353a35),
        border: Border(
          bottom: BorderSide(color: const Color(0xff57611f).withOpacity(0.3)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            'ID Lahan: $_mockIdLahan',
            style: const TextStyle(
              color: Color(0xff9e9e9e),
              fontSize: 12,
            ),
          ),
          Text(
            'HST: $_mockHST',
            style: const TextStyle(
              color: Color(0xff9e9e9e),
              fontSize: 12,
            ),
          ),
          Text(
            'Tanggal: $_mockTanggal',
            style: const TextStyle(
              color: Color(0xff9e9e9e),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingAlarmBanner() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xff1a2a1f),
        border: Border.all(color: const Color(0xff3ecf8e)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text('🌿 ', style: TextStyle(fontSize: 12)),
              Expanded(
                child: Text(
                  'Semprot Pupuk Daun — $_hariSemprotPupuk hari lagi',
                  style: const TextStyle(
                    color: Color(0xffe0e0e0),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Text('💊 ', style: TextStyle(fontSize: 12)),
              Expanded(
                child: Text(
                  'Semprot Obat — $_hariSemprotObat hari lagi',
                  style: const TextStyle(
                    color: Color(0xffe0e0e0),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff44425c),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xff57611f).withOpacity(0.5)),
      ),
      child: Row(
        children: [
          const Text(
            'Periode:',
            style: TextStyle(color: Color(0xff9e9e9e), fontSize: 14),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: 'bulan_ini',
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xff2a2a2a),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xff3a3a3a)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xff3ecf8e)),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              dropdownColor: const Color(0xff2a2a2a),
              style: const TextStyle(color: Color(0xffe0e0e0)),
              items: const [
                DropdownMenuItem(value: 'bulan_ini', child: Text('Bulan Ini')),
                DropdownMenuItem(value: 'bulan_lalu', child: Text('Bulan Lalu')),
                DropdownMenuItem(value: '3_bulan', child: Text('3 Bulan Terakhir')),
                DropdownMenuItem(value: '6_bulan', child: Text('6 Bulan Terakhir')),
                DropdownMenuItem(value: 'tahun_ini', child: Text('Tahun Ini')),
                DropdownMenuItem(value: 'custom', child: Text('Custom')),
              ],
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeuanganSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff44425c),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xff57611f).withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Laporan Keuangan',
            style: TextStyle(
              color: Color(0xffe0e0e0),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildKeuanganCard(
                  'Total Pemasukan',
                  'Rp ${(_mockKeuanganData['total_pemasukan'] as int).toString()}',
                  const Color(0xff3ecf8e),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildKeuanganCard(
                  'Total Pengeluaran',
                  'Rp ${(_mockKeuanganData['total_pengeluaran'] as int).toString()}',
                  const Color(0xffe53935),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildKeuanganCard(
                  'Laba Bersih',
                  'Rp ${(_mockKeuanganData['laba_bersih'] as int).toString()}',
                  const Color(0xff3ecf8e),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildKeuanganCard(
                  'Margin Keuntungan',
                  '${(_mockKeuanganData['margin_keuntungan'] as int).toString()}%',
                  const Color(0xff42a5f5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKeuanganCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xff2a2a2a),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xff57611f).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xff9e9e9e),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPanenSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff44425c),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xff57611f).withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Laporan Panen',
            style: TextStyle(
              color: Color(0xffe0e0e0),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildPanenCard(
                  'Total Panen',
                  '${(_mockPanenData['total_panen_kg'] as int).toString()} kg',
                  const Color(0xff3ecf8e),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildPanenCard(
                  'Total Omzet',
                  'Rp ${(_mockPanenData['total_omzet'] as int).toString()}',
                  const Color(0xff3ecf8e),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildPanenCard(
                  'Rata-rata Harga',
                  'Rp ${(_mockPanenData['rata_rata_harga'] as int).toString()}/kg',
                  const Color(0xff9e9e9e),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildPanenCard(
                  'Jumlah Kali Panen',
                  '${(_mockPanenData['jumlah_kali_panen'] as int).toString()}x',
                  const Color(0xff42a5f5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPanenCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xff2a2a2a),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xff57611f).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xff9e9e9e),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAktivitasSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff44425c),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xff57611f).withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Laporan Aktivitas',
            style: TextStyle(
              color: Color(0xffe0e0e0),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildAktivitasCard(
                  'Semprot',
                  '${(_mockAktivitasData['total_semprot'] as int).toString()}x',
                  Icons.eco,
                  const Color(0xff3ecf8e),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildAktivitasCard(
                  'Pemupukan',
                  '${(_mockAktivitasData['total_pemupukan'] as int).toString()}x',
                  Icons.grass,
                  const Color(0xff66bb6a),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildAktivitasCard(
                  'Perawatan',
                  '${(_mockAktivitasData['total_perawatan'] as int).toString()}x',
                  Icons.build,
                  const Color(0xffab47bc),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildAktivitasCard(
                  'Panen',
                  '${(_mockAktivitasData['total_panen'] as int).toString()}x',
                  Icons.agriculture,
                  const Color(0xff26a69a),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildAktivitasCard(
            'Total Jam Kerja',
            '${(_mockAktivitasData['total_jam_kerja'] as int).toString()} jam',
            Icons.access_time,
            const Color(0xff42a5f5),
          ),
        ],
      ),
    );
  }

  Widget _buildAktivitasCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xff2a2a2a),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xff57611f).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xff9e9e9e),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyChartSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff44425c),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xff57611f).withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Grafik Bulanan',
            style: TextStyle(
              color: Color(0xffe0e0e0),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          // Simple bar chart representation
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: const Color(0xff2a2a2a),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xff57611f).withOpacity(0.3)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: _mockMonthlyData.map((data) {
                  final maxPemasukan = _mockMonthlyData.map((d) => d['pemasukan'] as int).reduce((a, b) => a > b ? a : b);
                  final height = ((data['pemasukan'] as int) / maxPemasukan) * 150;
                  return Column(
                    children: [
                      Container(
                        width: 30,
                        height: height.toDouble(),
                        decoration: BoxDecoration(
                          color: const Color(0xff3ecf8e),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        data['bulan'],
                        style: const TextStyle(color: Color(0xff9e9e9e), fontSize: 12),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: const Color(0xff3ecf8e),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Pemasukan',
                style: TextStyle(color: Color(0xff9e9e9e), fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
