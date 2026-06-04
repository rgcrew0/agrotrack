import 'package:flutter/material.dart';

class BerandaScreen extends StatefulWidget {
  const BerandaScreen({super.key});

  @override
  State<BerandaScreen> createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  // Mock data for Info Bar
  final String _mockIdLahan = 'URTR1';
  final int _mockHST = 45;
  final String _mockTanggal = '12/06/2025';

  // Mock data for Floating Alarm Banner
  final int _hariSemprotPupuk = 3;
  final int _hariSemprotObat = 5;

  // Mock data for Dashboard cards
  final Map<String, dynamic> _mockDashboardData = {
    'totalBiaya': 15000000,
    'totalOmzet': 25000000,
    'labaBersih': 10000000,
    'populasiHidup': 950,
    'totalPanen': 2500,
  };

  // Calculator state
  int _selectedCalculatorTab = 0; // 0: Gram dari Harga, 1: Harga dari Gram
  final TextEditingController _rupiahController = TextEditingController();
  final TextEditingController _hargaPerKgController = TextEditingController();
  final TextEditingController _gramController = TextEditingController();
  String _hasilKalkulasi = '';

  // Pupuk calculator state
  String? _selectedProduk;
  final TextEditingController _dosisController = TextEditingController();
  final TextEditingController _jumlahTanamanController = TextEditingController();
  String _hasilPupukGram = '';
  String _hasilPupukBiaya = '';

  // Mock produk list
  final List<Map<String, dynamic>> _mockProdukList = [
    {'nama': 'NPK Mutiara', 'kategori': 'pupuk', 'hargaPerKg': 75000, 'n_persen': 160000, 'p_persen': 160000, 'k_persen': 160000},
    {'nama': 'Urea', 'kategori': 'pupuk', 'hargaPerKg': 60000, 'n_persen': 460000, 'p_persen': 0, 'k_persen': 0},
    {'nama': 'KCL', 'kategori': 'pupuk', 'hargaPerKg': 80000, 'n_persen': 0, 'p_persen': 0, 'k_persen': 600000},
    {'nama': 'Abamectin', 'kategori': 'obat', 'hargaPerKg': 250000, 'bahanAktif': 'Abamectin 1.8%'},
  ];

  // Collapsible states
  bool _isCalculatorExpanded = false;
  bool _isPupukCalculatorExpanded = false;

  @override
  void dispose() {
    _rupiahController.dispose();
    _hargaPerKgController.dispose();
    _gramController.dispose();
    _dosisController.dispose();
    _jumlahTanamanController.dispose();
    super.dispose();
  }

  void _hitungKalkulator() {
    if (_selectedCalculatorTab == 0) {
      // Gram dari Harga
      final rupiah = double.tryParse(_rupiahController.text) ?? 0;
      final hargaPerKg = double.tryParse(_hargaPerKgController.text) ?? 0;
      if (hargaPerKg > 0) {
        final gram = (rupiah / hargaPerKg) * 1000;
        setState(() {
          _hasilKalkulasi = '${gram.toStringAsFixed(2)} gram';
        });
      }
    } else {
      // Harga dari Gram
      final gram = double.tryParse(_gramController.text) ?? 0;
      final hargaPerKg = double.tryParse(_hargaPerKgController.text) ?? 0;
      final harga = (gram / 1000) * hargaPerKg;
      setState(() {
        _hasilKalkulasi = 'Rp ${harga.toStringAsFixed(0)}';
      });
    }
  }

  void _hitungPupuk() {
    if (_selectedProduk != null) {
      final dosis = double.tryParse(_dosisController.text) ?? 0;
      final jumlahTanaman = double.tryParse(_jumlahTanamanController.text) ?? 0;
      final produk = _mockProdukList.firstWhere((p) => p['nama'] == _selectedProduk);
      final hargaPerKg = produk['hargaPerKg'] as int;

      final totalGram = dosis * jumlahTanaman;
      final totalBiaya = (totalGram / 1000) * hargaPerKg;

      setState(() {
        _hasilPupukGram = '${totalGram.toStringAsFixed(0)} gram';
        _hasilPupukBiaya = 'Rp ${totalBiaya.toStringAsFixed(0)}';
      });
    }
  }

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
          'Beranda',
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
                  // Dashboard Cards
                  _buildDashboardCards(),
                  
                  const SizedBox(height: 16),
                  
                  // Kalkulator Gram ↔ Harga
                  _buildKalkulatorGramHarga(),
                  
                  const SizedBox(height: 16),
                  
                  // Kalkulator Pupuk Bebas
                  _buildKalkulatorPupukBebas(),
                  
                  const SizedBox(height: 16),
                  
                  // Tambah Produk Button
                  _buildTambahProdukButton(),
                ],
              ),
            ),
          ),
        ],
      ),
      drawer: _buildSidebar(),
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

  Widget _buildDashboardCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ringkasan Siklus',
          style: TextStyle(
            color: Color(0xffe0e0e0),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildDashboardCard(
                'Total Biaya',
                'Rp ${(_mockDashboardData['totalBiaya'] as int).toString()}',
                const Color(0xffe53935),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDashboardCard(
                'Total Omzet',
                'Rp ${(_mockDashboardData['totalOmzet'] as int).toString()}',
                const Color(0xff3ecf8e),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildDashboardCard(
                'Laba Bersih',
                'Rp ${(_mockDashboardData['labaBersih'] as int).toString()}',
                const Color(0xff3ecf8e),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDashboardCard(
                'Populasi Hidup',
                '${_mockDashboardData['populasiHidup'].toString()} pohon',
                const Color(0xff1e88e5),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildDashboardCard(
          'Total Panen',
          '${(_mockDashboardData['totalPanen'] as int).toString()} kg',
          const Color(0xfffdd835),
        ),
      ],
    );
  }

  Widget _buildDashboardCard(String label, String value, Color color) {
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
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKalkulatorGramHarga() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff44425c),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xff57611f).withOpacity(0.5)),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isCalculatorExpanded = !_isCalculatorExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Kalkulator Gram ↔ Harga',
                    style: TextStyle(
                      color: Color(0xffe0e0e0),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    _isCalculatorExpanded ? Icons.expand_less : Icons.expand_more,
                    color: const Color(0xff3ecf8e),
                  ),
                ],
              ),
            ),
          ),
          if (_isCalculatorExpanded) ...[
            const Divider(color: Color(0xff57611f)),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Tab buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedCalculatorTab = 0;
                              _hasilKalkulasi = '';
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _selectedCalculatorTab == 0
                                ? const Color(0xff3ecf8e)
                                : const Color(0xff2e2e2e),
                            foregroundColor: _selectedCalculatorTab == 0
                                ? const Color(0xff121212)
                                : const Color(0xffe0e0e0),
                          ),
                          child: const Text('Gram dari Harga'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedCalculatorTab = 1;
                              _hasilKalkulasi = '';
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _selectedCalculatorTab == 1
                                ? const Color(0xff3ecf8e)
                                : const Color(0xff2e2e2e),
                            foregroundColor: _selectedCalculatorTab == 1
                                ? const Color(0xff121212)
                                : const Color(0xffe0e0e0),
                          ),
                          child: const Text('Harga dari Gram'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Input fields based on tab
                  if (_selectedCalculatorTab == 0) ...[
                    TextField(
                      controller: _rupiahController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Jumlah Uang (Rp)',
                        labelStyle: const TextStyle(color: Color(0xff9e9e9e)),
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
                      ),
                      style: const TextStyle(color: Color(0xffe0e0e0)),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _hargaPerKgController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Harga per Kg (Rp/kg)',
                        labelStyle: const TextStyle(color: Color(0xff9e9e9e)),
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
                      ),
                      style: const TextStyle(color: Color(0xffe0e0e0)),
                    ),
                  ] else ...[
                    TextField(
                      controller: _gramController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Jumlah Gram',
                        labelStyle: const TextStyle(color: Color(0xff9e9e9e)),
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
                      ),
                      style: const TextStyle(color: Color(0xffe0e0e0)),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _hargaPerKgController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Harga per Kg (Rp/kg)',
                        labelStyle: const TextStyle(color: Color(0xff9e9e9e)),
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
                      ),
                      style: const TextStyle(color: Color(0xffe0e0e0)),
                    ),
                  ],
                  
                  const SizedBox(height: 16),
                  
                  // Hitung button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _hitungKalkulator,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff3ecf8e),
                        foregroundColor: const Color(0xff121212),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text('Hitung'),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Result
                  if (_hasilKalkulasi.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xff1a2a1f),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xff3ecf8e)),
                      ),
                      child: Text(
                        'Hasil: $_hasilKalkulasi',
                        style: const TextStyle(
                          color: Color(0xff3ecf8e),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildKalkulatorPupukBebas() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff44425c),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xff57611f).withOpacity(0.5)),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isPupukCalculatorExpanded = !_isPupukCalculatorExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Kalkulator Pupuk Bebas',
                    style: TextStyle(
                      color: Color(0xffe0e0e0),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    _isPupukCalculatorExpanded ? Icons.expand_less : Icons.expand_more,
                    color: const Color(0xff3ecf8e),
                  ),
                ],
              ),
            ),
          ),
          if (_isPupukCalculatorExpanded) ...[
            const Divider(color: Color(0xff57611f)),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Dropdown produk
                  DropdownButtonFormField<String>(
                    value: _selectedProduk,
                    decoration: InputDecoration(
                      labelText: 'Pilih Produk',
                      labelStyle: const TextStyle(color: Color(0xff9e9e9e)),
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
                    ),
                    dropdownColor: const Color(0xff2a2a2a),
                    style: const TextStyle(color: Color(0xffe0e0e0)),
                    items: _mockProdukList.map((produk) {
                      return DropdownMenuItem<String>(
                        value: produk['nama'] as String,
                        child: Text(
                          '${produk['nama']} (${produk['kategori']}) - Rp ${produk['hargaPerKg']}/kg',
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedProduk = value;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  
                  // Input dosis
                  TextField(
                    controller: _dosisController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Dosis (gram/tanaman)',
                      labelStyle: const TextStyle(color: Color(0xff9e9e9e)),
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
                    ),
                    style: const TextStyle(color: Color(0xffe0e0e0)),
                  ),
                  const SizedBox(height: 12),
                  
                  // Input jumlah tanaman
                  TextField(
                    controller: _jumlahTanamanController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Jumlah Tanaman',
                      labelStyle: const TextStyle(color: Color(0xff9e9e9e)),
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
                    ),
                    style: const TextStyle(color: Color(0xffe0e0e0)),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Hitung button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _hitungPupuk,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff3ecf8e),
                        foregroundColor: const Color(0xff121212),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text('Hitung'),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Results
                  if (_hasilPupukGram.isNotEmpty || _hasilPupukBiaya.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xff1a2a1f),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xff3ecf8e)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_hasilPupukGram.isNotEmpty)
                            Text(
                              'Total Gram: $_hasilPupukGram',
                              style: const TextStyle(
                                color: Color(0xff3ecf8e),
                                fontSize: 14,
                              ),
                            ),
                          if (_hasilPupukBiaya.isNotEmpty)
                            Text(
                              'Total Biaya: $_hasilPupukBiaya',
                              style: const TextStyle(
                                color: Color(0xff3ecf8e),
                                fontSize: 14,
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTambahProdukButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: () {
          _showTambahProdukDialog();
        },
        icon: const Icon(Icons.add),
        label: const Text('Tambah Produk'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff3ecf8e),
          foregroundColor: const Color(0xff121212),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
    );
  }

  void _showTambahProdukDialog() {
    final namaController = TextEditingController();
    final kategoriController = TextEditingController();
    final hargaPerKgController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff44425c),
        title: const Text(
          'Tambah Produk',
          style: TextStyle(color: Color(0xffe0e0e0)),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: namaController,
                decoration: InputDecoration(
                  labelText: 'Nama Produk',
                  labelStyle: const TextStyle(color: Color(0xff9e9e9e)),
                  filled: true,
                  fillColor: const Color(0xff2a2a2a),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xff3a3a3a)),
                  ),
                ),
                style: const TextStyle(color: Color(0xffe0e0e0)),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: kategoriController,
                decoration: InputDecoration(
                  labelText: 'Kategori (pupuk/obat)',
                  labelStyle: const TextStyle(color: Color(0xff9e9e9e)),
                  filled: true,
                  fillColor: const Color(0xff2a2a2a),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xff3a3a3a)),
                  ),
                ),
                style: const TextStyle(color: Color(0xffe0e0e0)),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: hargaPerKgController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Harga per Kg (Rp)',
                  labelStyle: const TextStyle(color: Color(0xff9e9e9e)),
                  filled: true,
                  fillColor: const Color(0xff2a2a2a),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xff3a3a3a)),
                  ),
                ),
                style: const TextStyle(color: Color(0xffe0e0e0)),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Batal',
              style: TextStyle(color: Color(0xff9e9e9e)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Mock save - in real app, would save to database
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Produk berhasil ditambahkan'),
                  backgroundColor: Color(0xff3ecf8e),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff3ecf8e),
              foregroundColor: const Color(0xff121212),
            ),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Drawer(
      backgroundColor: const Color(0xff2b322d),
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xff44425c),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'AgroTrack',
                  style: TextStyle(
                    color: Color(0xff3ecf8e),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Versi 1.0',
                  style: TextStyle(
                    color: const Color(0xff9e9e9e),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home, color: Color(0xff3ecf8e)),
            title: const Text('Beranda', style: TextStyle(color: Color(0xffe0e0e0))),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.list, color: Color(0xff3ecf8e)),
            title: const Text('Daftar Lahan', style: TextStyle(color: Color(0xffe0e0e0))),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.eco, color: Color(0xff3ecf8e)),
            title: const Text('Semprot', style: TextStyle(color: Color(0xffe0e0e0))),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.grass, color: Color(0xff3ecf8e)),
            title: const Text('Pemupukan', style: TextStyle(color: Color(0xffe0e0e0))),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.agriculture, color: Color(0xff3ecf8e)),
            title: const Text('Panen', style: TextStyle(color: Color(0xffe0e0e0))),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.build, color: Color(0xff3ecf8e)),
            title: const Text('Perawatan', style: TextStyle(color: Color(0xffe0e0e0))),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.note, color: Color(0xff3ecf8e)),
            title: const Text('Catatan Lapangan', style: TextStyle(color: Color(0xffe0e0e0))),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.inventory, color: Color(0xff3ecf8e)),
            title: const Text('Stok & Notif Produk', style: TextStyle(color: Color(0xffe0e0e0))),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.assessment, color: Color(0xff3ecf8e)),
            title: const Text('Laporan', style: TextStyle(color: Color(0xffe0e0e0))),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Color(0xff3ecf8e)),
            title: const Text('Pengaturan', style: TextStyle(color: Color(0xffe0e0e0))),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
