import 'package:flutter/material.dart';
import '../../shared/widgets/sidebar.dart';

class PanenScreen extends StatefulWidget {
  const PanenScreen({super.key});

  @override
  State<PanenScreen> createState() => _PanenScreenState();
}

class _PanenScreenState extends State<PanenScreen> {
  // Mock data for Info Bar
  final String _mockIdLahan = 'URTR1';
  final int _mockHST = 45;
  final String _mockTanggal = '12/06/2025';

  // Mock data for Floating Alarm Banner
  final int _hariSemprotPupuk = 3;
  final int _hariSemprotObat = 5;

  // Form state
  final TextEditingController _tanggalController = TextEditingController(text: '12/06/2025');
  final TextEditingController _hstController = TextEditingController(text: '45');
  final TextEditingController _jumlahPekerjaController = TextEditingController(text: '3');
  final TextEditingController _upahPerOrangController = TextEditingController(text: '100000');
  final TextEditingController _biayaUtilitasController = TextEditingController(text: '0');
  final TextEditingController _biayaTambahanController = TextEditingController(text: '0');

  // Produk state
  final List<Map<String, dynamic>> _addedProduk = [];
  String _selectedProduk = '';
  final TextEditingController _beratController = TextEditingController();
  final TextEditingController _hargaJualController = TextEditingController();

  // Mock produk list (hasil panen)
  final List<Map<String, dynamic>> _mockProdukList = [
    {
      'nama': 'Cabai Merah',
      'kategori': 'hasil',
      'satuan': 'kg',
      'harga_jual_default': 30000,
    },
    {
      'nama': 'Cabai Hijau',
      'kategori': 'hasil',
      'satuan': 'kg',
      'harga_jual_default': 25000,
    },
    {
      'nama': 'Tomat',
      'kategori': 'hasil',
      'satuan': 'kg',
      'harga_jual_default': 15000,
    },
    {
      'nama': 'Buah Sisa',
      'kategori': 'sisa',
      'satuan': 'kg',
      'harga_jual_default': 5000,
    },
  ];

  // Mock history panen
  final List<Map<String, dynamic>> _mockHistoryPanen = [
    {
      'tanggal': '05/06/2025',
      'hst': 38,
      'total_berat': 150,
      'total_omzet': 4500000,
      'total_biaya': 300000,
      'laba_bersih': 4200000,
      'produk_count': 2,
    },
    {
      'tanggal': '20/05/2025',
      'hst': 33,
      'total_berat': 120,
      'total_omzet': 3600000,
      'total_biaya': 250000,
      'laba_bersih': 3350000,
      'produk_count': 1,
    },
    {
      'tanggal': '05/05/2025',
      'hst': 18,
      'total_berat': 100,
      'total_omzet': 3000000,
      'total_biaya': 200000,
      'laba_bersih': 2800000,
      'produk_count': 2,
    },
  ];

  // History expanded state
  final Set<int> _expandedHistory = {};

  @override
  void dispose() {
    _tanggalController.dispose();
    _hstController.dispose();
    _jumlahPekerjaController.dispose();
    _upahPerOrangController.dispose();
    _biayaUtilitasController.dispose();
    _biayaTambahanController.dispose();
    _beratController.dispose();
    _hargaJualController.dispose();
    super.dispose();
  }

  void _addProduk() {
    if (_selectedProduk.isEmpty || _beratController.text.isEmpty) return;

    final produk = _mockProdukList.firstWhere((p) => p['nama'] == _selectedProduk);
    final berat = double.tryParse(_beratController.text) ?? 0;
    final hargaJual = int.tryParse(_hargaJualController.text) ?? (produk['harga_jual_default'] as int);
    final omzet = berat * hargaJual;

    setState(() {
      _addedProduk.add({
        'nama': produk['nama'],
        'kategori': produk['kategori'],
        'satuan': produk['satuan'],
        'berat': berat,
        'harga_jual': hargaJual,
        'omzet': omzet,
      });
      _selectedProduk = '';
      _beratController.clear();
      _hargaJualController.clear();
    });
  }

  void _removeProduk(int index) {
    setState(() {
      _addedProduk.removeAt(index);
    });
  }

  void _hitungTotalOmzet() {
    int totalOmzet = 0;
    for (var item in _addedProduk) {
      totalOmzet += (item['omzet'] as double).round();
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Total Omzet: Rp $totalOmzet'),
        backgroundColor: const Color(0xff3ecf8e),
      ),
    );
  }

  void _simpan() {
    _showKonfirmasiModal();
  }

  void _showKonfirmasiModal() {
    int totalOmzet = 0;
    double totalBerat = 0;

    for (var item in _addedProduk) {
      totalOmzet += (item['omzet'] as double).round();
      totalBerat += item['berat'] as double;
    }

    final biayaUtilitas = int.tryParse(_biayaUtilitasController.text) ?? 0;
    final biayaTambahan = int.tryParse(_biayaTambahanController.text) ?? 0;
    final jumlahPekerja = int.tryParse(_jumlahPekerjaController.text) ?? 0;
    final upahPerOrang = int.tryParse(_upahPerOrangController.text) ?? 0;

    final totalBiaya = biayaUtilitas + biayaTambahan + (jumlahPekerja * upahPerOrang);
    final labaBersih = totalOmzet - totalBiaya;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff44425c),
        title: const Text(
          'Konfirmasi Panen',
          style: TextStyle(color: Color(0xffe0e0e0)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildKonfirmasiRow('Lahan', 'Lahan Utama (URTR1)'),
            _buildKonfirmasiRow('Tanggal', _tanggalController.text),
            _buildKonfirmasiRow('HST', _hstController.text),
            _buildKonfirmasiRow('Total Berat', '${totalBerat.round()} kg'),
            _buildKonfirmasiRow('Jumlah Produk', '${_addedProduk.length} item'),
            _buildKonfirmasiRow('Total Omzet', 'Rp $totalOmzet'),
            _buildKonfirmasiRow('Total Biaya', 'Rp $totalBiaya'),
            _buildKonfirmasiRow('Laba Bersih', 'Rp $labaBersih'),
          ],
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
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data panen berhasil disimpan'),
                  backgroundColor: Color(0xff3ecf8e),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff3ecf8e),
              foregroundColor: const Color(0xff121212),
            ),
            child: const Text('Ya, Simpan'),
          ),
        ],
      ),
    );
  }

  Widget _buildKonfirmasiRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(color: Color(0xff9e9e9e), fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Color(0xffe0e0e0), fontSize: 12),
            ),
          ),
        ],
      ),
    );
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
          'Panen',
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
                  // Form Input
                  _buildFormInput(),
                  
                  const SizedBox(height: 16),
                  
                  // Seksi Produk
                  _buildSeksiProduk(),
                  
                  const SizedBox(height: 16),
                  
                  // Action Buttons
                  _buildActionButtons(),
                  
                  const SizedBox(height: 16),
                  
                  // History Panen
                  _buildHistoryPanen(),
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

  Widget _buildFormInput() {
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
            'Form Input',
            style: TextStyle(
              color: Color(0xffe0e0e0),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Row 1: Lahan Aktif | ID Lahan
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  'Lahan Aktif',
                  'Lahan Utama',
                  readonly: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  'ID Lahan',
                  'URTR1',
                  readonly: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Row 2: Tanggal Aktivitas | HST
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  'Tanggal Panen',
                  null,
                  controller: _tanggalController,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  'HST',
                  null,
                  controller: _hstController,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Row 3: Jumlah Pekerja | Upah per Orang
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  'Jumlah Pekerja',
                  null,
                  controller: _jumlahPekerjaController,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  'Upah per Orang (Rp)',
                  null,
                  controller: _upahPerOrangController,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Row 4: Biaya Utilitas | Biaya Tambahan
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  'Biaya Utilitas (Rp)',
                  null,
                  controller: _biayaUtilitasController,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  'Biaya Tambahan (Rp)',
                  null,
                  controller: _biayaTambahanController,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String? value, {
    TextEditingController? controller,
    bool readonly = false,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readonly,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xff9e9e9e)),
        filled: true,
        fillColor: readonly ? const Color(0xff1a1a1a) : const Color(0xff2a2a2a),
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
    );
  }

  Widget _buildSeksiProduk() {
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
            'Seksi Produk Hasil Panen',
            style: TextStyle(
              color: Color(0xffe0e0e0),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Add produk row
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedProduk.isEmpty ? null : _selectedProduk,
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
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  dropdownColor: const Color(0xff2a2a2a),
                  style: const TextStyle(color: Color(0xffe0e0e0)),
                  hint: const Text('Pilih Produk', style: TextStyle(color: Color(0xff9e9e9e))),
                  items: _mockProdukList.map((produk) {
                    return DropdownMenuItem<String>(
                      value: produk['nama'] as String,
                      child: Text('${produk['nama']} (${produk['kategori']})'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedProduk = value!;
                      // Auto-fill harga jual default
                      final produk = _mockProdukList.firstWhere((p) => p['nama'] == value);
                      _hargaJualController.text = (produk['harga_jual_default'] as int).toString();
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 80,
                child: TextField(
                  controller: _beratController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Berat',
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
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  ),
                  style: const TextStyle(color: Color(0xffe0e0e0)),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 100,
                child: TextField(
                  controller: _hargaJualController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Harga/kg',
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
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  ),
                  style: const TextStyle(color: Color(0xffe0e0e0)),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _addProduk,
                icon: const Icon(Icons.add, color: Color(0xff3ecf8e)),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xff3ecf8e),
                  foregroundColor: const Color(0xff121212),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Produk table
          if (_addedProduk.isEmpty)
            const Center(
              child: Text(
                'Belum ada produk ditambahkan',
                style: TextStyle(color: Color(0xff9e9e9e)),
              ),
            )
          else
            ..._addedProduk.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return _buildProdukCard(item, index);
            }),
        ],
      ),
    );
  }

  Widget _buildProdukCard(Map<String, dynamic> item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xff2a2a2a),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xff57611f).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['nama'],
                      style: const TextStyle(
                        color: Color(0xffe0e0e0),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Kategori: ${item['kategori']}',
                      style: const TextStyle(color: Color(0xff9e9e9e), fontSize: 12),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _removeProduk(index),
                icon: const Icon(Icons.delete, color: Color(0xffe53935), size: 20),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Berat: ${item['berat'].round()} ${item['satuan']}',
                style: const TextStyle(color: Color(0xffe0e0e0), fontSize: 12),
              ),
              Text(
                'Rp ${item['harga_jual']}/${item['satuan']}',
                style: const TextStyle(color: Color(0xff9e9e9e), fontSize: 12),
              ),
              Text(
                'Omzet: Rp ${item['omzet'].round()}',
                style: const TextStyle(
                  color: Color(0xff3ecf8e),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _hitungTotalOmzet,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff2e2e2e),
              foregroundColor: const Color(0xffe0e0e0),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text('Hitung Total Omzet'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: _simpan,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff3ecf8e),
              foregroundColor: const Color(0xff121212),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text('Simpan'),
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryPanen() {
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
            'History Panen (10 Terbaru)',
            style: TextStyle(
              color: Color(0xffe0e0e0),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ..._mockHistoryPanen.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isExpanded = _expandedHistory.contains(index);
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: const Color(0xff2a2a2a),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xff57611f).withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (isExpanded) {
                          _expandedHistory.remove(index);
                        } else {
                          _expandedHistory.add(index);
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['tanggal'],
                                  style: const TextStyle(
                                    color: Color(0xffe0e0e0),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      'HST: ${item['hst']}',
                                      style: const TextStyle(color: Color(0xff9e9e9e), fontSize: 12),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '•',
                                      style: TextStyle(color: Color(0xff9e9e9e)),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${item['produk_count']} produk',
                                      style: const TextStyle(color: Color(0xff9e9e9e), fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Rp ${item['total_omzet']}',
                                style: const TextStyle(
                                  color: Color(0xff3ecf8e),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${item['total_berat']} kg',
                                style: const TextStyle(color: Color(0xff9e9e9e), fontSize: 11),
                              ),
                            ],
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            isExpanded ? Icons.expand_less : Icons.expand_more,
                            color: const Color(0xff3ecf8e),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (isExpanded) ...[
                    const Divider(color: Color(0xff57611f)),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHistoryRow('Total Berat', '${item['total_berat']} kg'),
                          _buildHistoryRow('Total Omzet', 'Rp ${item['total_omzet']}'),
                          _buildHistoryRow('Total Biaya', 'Rp ${item['total_biaya']}'),
                          _buildHistoryRow('Laba Bersih', 'Rp ${item['laba_bersih']}'),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildHistoryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(color: Color(0xff9e9e9e), fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Color(0xffe0e0e0), fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
