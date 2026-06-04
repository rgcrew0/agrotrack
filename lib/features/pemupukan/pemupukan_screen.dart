import 'package:flutter/material.dart';

class PemupukanScreen extends StatefulWidget {
  const PemupukanScreen({super.key});

  @override
  State<PemupukanScreen> createState() => _PemupukanScreenState();
}

class _PemupukanScreenState extends State<PemupukanScreen> {
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
  final TextEditingController _volumeAirController = TextEditingController(text: '200');
  final TextEditingController _jumlahPekerjaController = TextEditingController(text: '2');
  final TextEditingController _upahPerOrangController = TextEditingController(text: '100000');
  final TextEditingController _biayaUtilitasController = TextEditingController(text: '0');
  final TextEditingController _biayaTambahanController = TextEditingController(text: '0');

  // Produk state
  final List<Map<String, dynamic>> _addedProduk = [];
  String _selectedProduk = '';
  final TextEditingController _dosisController = TextEditingController();

  // Mock produk list (pupuk only)
  final List<Map<String, dynamic>> _mockProdukList = [
    {
      'nama': 'NPK Mutiara',
      'kategori': 'pupuk',
      'stok_gram': 5000,
      'harga_rata_rata': 75,
      'harga_per_kg': 75000,
      'n_persen': 160000,
      'p_persen': 160000,
      'k_persen': 160000,
    },
    {
      'nama': 'Urea',
      'kategori': 'pupuk',
      'stok_gram': 800,
      'harga_rata_rata': 60,
      'harga_per_kg': 60000,
      'n_persen': 460000,
      'p_persen': 0,
      'k_persen': 0,
    },
    {
      'nama': 'KCL',
      'kategori': 'pupuk',
      'stok_gram': 3000,
      'harga_rata_rata': 80,
      'harga_per_kg': 80000,
      'n_persen': 0,
      'p_persen': 0,
      'k_persen': 600000,
    },
    {
      'nama': 'Dolomit',
      'kategori': 'pupuk',
      'stok_gram': 2000,
      'harga_rata_rata': 50,
      'harga_per_kg': 50000,
      'n_persen': 0,
      'p_persen': 0,
      'k_persen': 0,
    },
    {
      'nama': 'ZK (Kieserite)',
      'kategori': 'pupuk',
      'stok_gram': 1500,
      'harga_rata_rata': 90,
      'harga_per_kg': 90000,
      'n_persen': 0,
      'p_persen': 0,
      'k_persen': 250000,
    },
  ];

  // Mock history pemupukan
  final List<Map<String, dynamic>> _mockHistoryPemupukan = [
    {
      'tanggal': '05/06/2025',
      'hst': 38,
      'volume_air': 200,
      'total_biaya': 150000,
      'total_n': 80,
      'total_p': 80,
      'total_k': 80,
      'produk_count': 1,
    },
    {
      'tanggal': '20/05/2025',
      'hst': 33,
      'volume_air': 180,
      'total_biaya': 120000,
      'total_n': 60,
      'total_p': 60,
      'total_k': 60,
      'produk_count': 1,
    },
    {
      'tanggal': '05/05/2025',
      'hst': 18,
      'volume_air': 200,
      'total_biaya': 180000,
      'total_n': 100,
      'total_p': 100,
      'total_k': 100,
      'produk_count': 2,
    },
  ];

  // History expanded state
  final Set<int> _expandedHistory = {};

  @override
  void dispose() {
    _tanggalController.dispose();
    _hstController.dispose();
    _volumeAirController.dispose();
    _jumlahPekerjaController.dispose();
    _upahPerOrangController.dispose();
    _biayaUtilitasController.dispose();
    _biayaTambahanController.dispose();
    _dosisController.dispose();
    super.dispose();
  }

  void _addProduk() {
    if (_selectedProduk.isEmpty || _dosisController.text.isEmpty) return;

    final produk = _mockProdukList.firstWhere((p) => p['nama'] == _selectedProduk);
    final dosis = double.tryParse(_dosisController.text) ?? 0;
    final volumeAir = double.tryParse(_volumeAirController.text) ?? 0;
    final totalGram = dosis * volumeAir;
    final hargaWMA = produk['harga_rata_rata'] as int;
    final biaya = (totalGram / 1000) * hargaWMA;

    // Calculate nutrients
    final nPersen = produk['n_persen'] as int;
    final pPersen = produk['p_persen'] as int;
    final kPersen = produk['k_persen'] as int;
    final totalN = ((nPersen / 1000000) * totalGram).round();
    final totalP = ((pPersen / 1000000) * totalGram).round();
    final totalK = ((kPersen / 1000000) * totalGram).round();

    setState(() {
      _addedProduk.add({
        'nama': produk['nama'],
        'dosis': dosis,
        'total_gram': totalGram,
        'harga_wma': hargaWMA,
        'biaya': biaya,
        'total_n': totalN,
        'total_p': totalP,
        'total_k': totalK,
      });
      _selectedProduk = '';
      _dosisController.clear();
    });
  }

  void _removeProduk(int index) {
    setState(() {
      _addedProduk.removeAt(index);
    });
  }

  void _hitungUnsurHara() {
    int totalN = 0;
    int totalP = 0;
    int totalK = 0;

    for (var item in _addedProduk) {
      totalN += item['total_n'] as int;
      totalP += item['total_p'] as int;
      totalK += item['total_k'] as int;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Total Unsur Hara: N=${totalN}g, P=${totalP}g, K=${totalK}g'),
        backgroundColor: const Color(0xff3ecf8e),
      ),
    );
  }

  void _simpan() {
    _showKonfirmasiModal();
  }

  void _showKonfirmasiModal() {
    int totalBiaya = 0;
    int totalN = 0;
    int totalP = 0;
    int totalK = 0;

    for (var item in _addedProduk) {
      totalBiaya += (item['biaya'] as double).round();
      totalN += item['total_n'] as int;
      totalP += item['total_p'] as int;
      totalK += item['total_k'] as int;
    }

    final biayaUtilitas = int.tryParse(_biayaUtilitasController.text) ?? 0;
    final biayaTambahan = int.tryParse(_biayaTambahanController.text) ?? 0;
    final jumlahPekerja = int.tryParse(_jumlahPekerjaController.text) ?? 0;
    final upahPerOrang = int.tryParse(_upahPerOrangController.text) ?? 0;

    totalBiaya += biayaUtilitas + biayaTambahan + (jumlahPekerja * upahPerOrang);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff44425c),
        title: const Text(
          'Konfirmasi Pemupukan',
          style: TextStyle(color: Color(0xffe0e0e0)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildKonfirmasiRow('Lahan', 'Lahan Utama (URTR1)'),
            _buildKonfirmasiRow('Tanggal', _tanggalController.text),
            _buildKonfirmasiRow('HST', _hstController.text),
            _buildKonfirmasiRow('Volume Air', '${_volumeAirController.text} liter'),
            _buildKonfirmasiRow('Jumlah Produk', '${_addedProduk.length} item'),
            _buildKonfirmasiRow('Total N', '${totalN}g'),
            _buildKonfirmasiRow('Total P', '${totalP}g'),
            _buildKonfirmasiRow('Total K', '${totalK}g'),
            _buildKonfirmasiRow('Total Biaya', 'Rp $totalBiaya'),
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
                  content: Text('Data pemupukan berhasil disimpan'),
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
          'Pemupukan',
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
                  
                  // History Pemupukan
                  _buildHistoryPemupukan(),
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
                  'Tanggal Aktivitas',
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
          
          // Row 3: Volume Air
          _buildTextField(
            'Volume Air (liter)',
            null,
            controller: _volumeAirController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          
          // Row 4: Jumlah Pekerja | Upah per Orang
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
          
          // Row 5: Biaya Utilitas | Biaya Tambahan
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
            'Seksi Produk',
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
                    labelText: 'Pilih Produk Pupuk',
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
                      child: Text('${produk['nama']} - Stok: ${produk['stok_gram']}g'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedProduk = value!;
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 100,
                child: TextField(
                  controller: _dosisController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Dosis (g/L)',
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
                      'Dosis: ${item['dosis']} g/L',
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
                'Total: ${item['total_gram'].round()} gram',
                style: const TextStyle(color: Color(0xffe0e0e0), fontSize: 12),
              ),
              Text(
                'Rp ${item['harga_wma']}/g',
                style: const TextStyle(color: Color(0xff9e9e9e), fontSize: 12),
              ),
              Text(
                'Biaya: Rp ${item['biaya'].round()}',
                style: const TextStyle(
                  color: Color(0xff3ecf8e),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Nutrient preview
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xff1a2a1f),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNutrientBadge('N', item['total_n']),
                _buildNutrientBadge('P', item['total_p']),
                _buildNutrientBadge('K', item['total_k']),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientBadge(String label, int value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xff9e9e9e),
            fontSize: 10,
          ),
        ),
        Text(
          '${value}g',
          style: const TextStyle(
            color: Color(0xff3ecf8e),
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _hitungUnsurHara,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff2e2e2e),
              foregroundColor: const Color(0xffe0e0e0),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text('Hitung Unsur Hara'),
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

  Widget _buildHistoryPemupukan() {
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
            'History Pemupukan (10 Terbaru)',
            style: TextStyle(
              color: Color(0xffe0e0e0),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ..._mockHistoryPemupukan.asMap().entries.map((entry) {
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
                          Text(
                            'Rp ${item['total_biaya']}',
                            style: const TextStyle(
                              color: Color(0xff3ecf8e),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
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
                          _buildHistoryRow('Volume Air', '${item['volume_air']} liter'),
                          _buildHistoryRow('Total Biaya', 'Rp ${item['total_biaya']}'),
                          _buildHistoryRow('Total N', '${item['total_n']} g'),
                          _buildHistoryRow('Total P', '${item['total_p']} g'),
                          _buildHistoryRow('Total K', '${item['total_k']} g'),
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
            leading: const Icon(Icons.home, color: Color(0xff9e9e9e)),
            title: const Text('Beranda', style: TextStyle(color: Color(0xffe0e0e0))),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.list, color: Color(0xff9e9e9e)),
            title: const Text('Daftar Lahan', style: TextStyle(color: Color(0xffe0e0e0))),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.eco, color: Color(0xff9e9e9e)),
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
            leading: const Icon(Icons.agriculture, color: Color(0xff9e9e9e)),
            title: const Text('Panen', style: TextStyle(color: Color(0xffe0e0e0))),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.build, color: Color(0xff9e9e9e)),
            title: const Text('Perawatan', style: TextStyle(color: Color(0xffe0e0e0))),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.note, color: Color(0xff9e9e9e)),
            title: const Text('Catatan Lapangan', style: TextStyle(color: Color(0xffe0e0e0))),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.inventory, color: Color(0xff9e9e9e)),
            title: const Text('Stok & Notif Produk', style: TextStyle(color: Color(0xffe0e0e0))),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.assessment, color: Color(0xff9e9e9e)),
            title: const Text('Laporan', style: TextStyle(color: Color(0xffe0e0e0))),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Color(0xff9e9e9e)),
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
