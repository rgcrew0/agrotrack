import 'package:flutter/material.dart';

class StokProdukScreen extends StatefulWidget {
  const StokProdukScreen({super.key});

  @override
  State<StokProdukScreen> createState() => _StokProdukScreenState();
}

class _StokProdukScreenState extends State<StokProdukScreen> {
  // Mock data for Info Bar
  final String _mockIdLahan = 'URTR1';
  final int _mockHST = 45;
  final String _mockTanggal = '12/06/2025';

  // Mock data for Floating Alarm Banner
  final int _hariSemprotPupuk = 3;
  final int _hariSemprotObat = 5;

  // Mock data for Produk
  final List<Map<String, dynamic>> _mockProdukList = [
    {
      'id': 1,
      'nama': 'NPK Mutiara',
      'kategori': 'pupuk',
      'stok_gram': 5000,
      'harga_rata_rata': 75,
      'harga_per_kg': 75000,
      'batas_minimal_gram': 1000,
      'n_persen': 160000,
      'p_persen': 160000,
      'k_persen': 160000,
      'bahan_aktif': null,
    },
    {
      'id': 2,
      'nama': 'Urea',
      'kategori': 'pupuk',
      'stok_gram': 800,
      'harga_rata_rata': 60,
      'harga_per_kg': 60000,
      'batas_minimal_gram': 1000,
      'n_persen': 460000,
      'p_persen': 0,
      'k_persen': 0,
      'bahan_aktif': null,
    },
    {
      'id': 3,
      'nama': 'KCL',
      'kategori': 'pupuk',
      'stok_gram': 3000,
      'harga_rata_rata': 80,
      'harga_per_kg': 80000,
      'batas_minimal_gram': 1000,
      'n_persen': 0,
      'p_persen': 0,
      'k_persen': 600000,
      'bahan_aktif': null,
    },
    {
      'id': 4,
      'nama': 'Abamectin',
      'kategori': 'obat',
      'stok_gram': 500,
      'harga_rata_rata': 250,
      'harga_per_kg': 250000,
      'batas_minimal_gram': 500,
      'n_persen': 0,
      'p_persen': 0,
      'k_persen': 0,
      'bahan_aktif': 'Abamectin 1.8%',
    },
    {
      'id': 5,
      'nama': 'Mancozeb',
      'kategori': 'obat',
      'stok_gram': 2000,
      'harga_rata_rata': 120,
      'harga_per_kg': 120000,
      'batas_minimal_gram': 1000,
      'n_persen': 0,
      'p_persen': 0,
      'k_persen': 0,
      'bahan_aktif': 'Mancozeb 80%',
    },
  ];

  // Mock data for Riwayat Transaksi
  final List<Map<String, dynamic>> _mockRiwayatTransaksi = [
    {
      'tanggal': '10/06/2025',
      'tipe': 'beli',
      'jumlah_gram': 2000,
      'harga_satuan': 75,
      'total': 150000,
      'lahan_aktivitas': '-',
      'saldo_sesudah': 5000,
    },
    {
      'tanggal': '08/06/2025',
      'tipe': 'pakai',
      'jumlah_gram': -500,
      'harga_satuan': 75,
      'total': -37500,
      'lahan_aktivitas': 'URTR1 - Semprot',
      'saldo_sesudah': 3000,
    },
    {
      'tanggal': '05/06/2025',
      'tipe': 'beli',
      'jumlah_gram': 1500,
      'harga_satuan': 75,
      'total': 112500,
      'lahan_aktivitas': '-',
      'saldo_sesudah': 3500,
    },
  ];

  // State
  String? _selectedProduk;
  String _filterKategori = 'semua'; // semua, pupuk, obat
  final TextEditingController _searchController = TextEditingController();
  bool _isListMode = false; // false = dropdown mode, true = list mode

  // Catat Pemakaian Manual state
  bool _showCatatPemakaian = false;
  final TextEditingController _jumlahGramController = TextEditingController();
  String _tipeTransaksi = 'pakai';
  final TextEditingController _catatanController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    _jumlahGramController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredProdukList {
    return _mockProdukList.where((produk) {
      // Filter by kategori
      if (_filterKategori != 'semua' && produk['kategori'] != _filterKategori) {
        return false;
      }
      
      // Filter by search
      final search = _searchController.text.toLowerCase();
      if (search.isNotEmpty) {
        final nama = (produk['nama'] as String).toLowerCase();
        if (!nama.contains(search)) return false;
      }
      
      return true;
    }).toList();
  }

  int get _totalNilaiStok {
    return _mockProdukList.fold(0, (sum, produk) {
      final stok = produk['stok_gram'] as int;
      final harga = produk['harga_rata_rata'] as int;
      return sum + (stok * harga);
    });
  }

  Map<String, dynamic>? get _selectedProdukData {
    if (_selectedProduk == null) return null;
    return _mockProdukList.firstWhere((p) => p['nama'] == _selectedProduk);
  }

  void _showDetailProdukBottomSheet(Map<String, dynamic> produk) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xff44425c),
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Color(0xff44425c),
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xff57611f),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  produk['nama'],
                  style: const TextStyle(
                    color: Color(0xffe0e0e0),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TabBar(
                indicatorColor: const Color(0xff3ecf8e),
                labelColor: const Color(0xff3ecf8e),
                unselectedLabelColor: const Color(0xff9e9e9e),
                tabs: const [
                  Tab(text: 'Data Produk'),
                  Tab(text: 'Stok & Riwayat'),
                  Tab(text: 'Notifikasi'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildTabDataProduk(produk),
                    _buildTabStokRiwayat(produk),
                    _buildTabNotifikasi(produk),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabDataProduk(Map<String, dynamic> produk) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildDetailRow('Nama', produk['nama']),
        _buildDetailRow('Kategori', produk['kategori']),
        _buildDetailRow('Stok', '${produk['stok_gram']} gram'),
        _buildDetailRow('Harga WMA', 'Rp ${produk['harga_rata_rata']}/gram'),
        _buildDetailRow('Harga per Kg', 'Rp ${produk['harga_per_kg']}/kg'),
        _buildDetailRow('Batas Minimal', '${produk['batas_minimal_gram']} gram'),
        if (produk['bahan_aktif'] != null)
          _buildDetailRow('Bahan Aktif', produk['bahan_aktif']),
        if (produk['kategori'] == 'pupuk') ...[
          _buildDetailRow('N', '${(produk['n_persen'] as int) / 10000}%'),
          _buildDetailRow('P', '${(produk['p_persen'] as int) / 10000}%'),
          _buildDetailRow('K', '${(produk['k_persen'] as int) / 10000}%'),
        ],
      ],
    );
  }

  Widget _buildTabStokRiwayat(Map<String, dynamic> produk) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildDetailRow('Stok Saat Ini', '${produk['stok_gram']} gram'),
        _buildDetailRow('Harga WMA', 'Rp ${produk['harga_rata_rata']}/gram'),
        _buildDetailRow('Nilai Total', 'Rp ${(produk['stok_gram'] as int) * (produk['harga_rata_rata'] as int)}'),
        const SizedBox(height: 16),
        const Text(
          'Riwayat Transaksi',
          style: TextStyle(
            color: Color(0xff3ecf8e),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ..._mockRiwayatTransaksi.map((transaksi) => _buildTransaksiCard(transaksi)),
      ],
    );
  }

  Widget _buildTabNotifikasi(Map<String, dynamic> produk) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildDetailRow('Batas Minimal Stok', '${produk['batas_minimal_gram']} gram'),
        const SizedBox(height: 16),
        const Text(
          'Notifikasi per Aktivitas',
          style: TextStyle(
            color: Color(0xff3ecf8e),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildNotifikasiToggle('Semprot Obat', true),
        _buildNotifikasiToggle('Semprot Pupuk', true),
        _buildNotifikasiToggle('Pemupukan', true),
        _buildNotifikasiToggle('Panen', false),
        _buildNotifikasiToggle('Perawatan', false),
        const SizedBox(height: 16),
        const Text(
          'Hari Sebelum Notifikasi',
          style: TextStyle(
            color: Color(0xff3ecf8e),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          decoration: InputDecoration(
            labelText: 'Hari Sebelum',
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
          keyboardType: TextInputType.number,
          controller: TextEditingController(text: '2'),
        ),
      ],
    );
  }

  Widget _buildNotifikasiToggle(String label, bool value) {
    return SwitchListTile(
      title: Text(
        label,
        style: const TextStyle(color: Color(0xffe0e0e0)),
      ),
      value: value,
      onChanged: (newValue) {
        setState(() {});
      },
      activeColor: const Color(0xff3ecf8e),
    );
  }

  Widget _buildTransaksiCard(Map<String, dynamic> transaksi) {
    final isPakai = transaksi['tipe'] == 'pakai';
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                transaksi['tanggal'],
                style: const TextStyle(
                  color: Color(0xff9e9e9e),
                  fontSize: 12,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isPakai ? const Color(0xffe53935) : const Color(0xff3ecf8e),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  transaksi['tipe'].toString().toUpperCase(),
                  style: TextStyle(
                    color: isPakai ? const Color(0xffffffff) : const Color(0xff121212),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${transaksi['jumlah_gram']} gram',
            style: TextStyle(
              color: isPakai ? const Color(0xffe53935) : const Color(0xff3ecf8e),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Rp ${transaksi['total']}',
            style: const TextStyle(
              color: Color(0xffe0e0e0),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Saldo Sesudah: ${transaksi['saldo_sesudah']} gram',
            style: const TextStyle(
              color: Color(0xff9e9e9e),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                color: Color(0xff9e9e9e),
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xffe0e0e0),
                fontSize: 12,
              ),
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
          'Stok & Notif Produk',
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
          
          // Search and Filter
          _buildSearchAndFilter(),
          
          // Main content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Total Nilai Stok
                  _buildTotalNilaiStok(),
                  
                  const SizedBox(height: 16),
                  
                  // Mode toggle
                  _buildModeToggle(),
                  
                  const SizedBox(height: 16),
                  
                  // Produk List or Dropdown
                  if (_isListMode)
                    _buildProdukList()
                  else
                    _buildProdukDropdown(),
                  
                  const SizedBox(height: 16),
                  
                  // Catat Pemakaian Manual
                  if (_showCatatPemakaian)
                    _buildCatatPemakaianManual(),
                  
                  const SizedBox(height: 16),
                  
                  // Riwayat Transaksi (if produk selected)
                  if (_selectedProduk != null)
                    _buildRiwayatTransaksi(),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Fitur tambah produk akan segera hadir'),
              backgroundColor: Color(0xff3ecf8e),
            ),
          );
        },
        backgroundColor: const Color(0xff3ecf8e),
        child: const Icon(Icons.add, color: Color(0xff121212)),
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

  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff353a35),
        border: Border(
          bottom: BorderSide(color: const Color(0xff57611f).withOpacity(0.3)),
        ),
      ),
      child: Column(
        children: [
          // Search bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Cari nama produk',
              hintStyle: const TextStyle(color: Color(0xff9e9e9e)),
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
              prefixIcon: const Icon(Icons.search, color: Color(0xff9e9e9e)),
            ),
            style: const TextStyle(color: Color(0xffe0e0e0)),
            onChanged: (value) {
              setState(() {});
            },
          ),
          const SizedBox(height: 12),
          
          // Filter kategori
          DropdownButtonFormField<String>(
            value: _filterKategori,
            decoration: InputDecoration(
              labelText: 'Kategori',
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
            items: const [
              DropdownMenuItem(value: 'semua', child: Text('Semua')),
              DropdownMenuItem(value: 'pupuk', child: Text('Pupuk')),
              DropdownMenuItem(value: 'obat', child: Text('Obat')),
            ],
            onChanged: (value) {
              setState(() {
                _filterKategori = value!;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTotalNilaiStok() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff44425c),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xff57611f).withOpacity(0.5)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.inventory_2,
            color: Color(0xff3ecf8e),
            size: 32,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Nilai Stok Gudang',
                  style: TextStyle(
                    color: Color(0xff9e9e9e),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Rp $_totalNilaiStok',
                  style: const TextStyle(
                    color: Color(0xff3ecf8e),
                    fontSize: 20,
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

  Widget _buildModeToggle() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _isListMode = false;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: !_isListMode ? const Color(0xff3ecf8e) : const Color(0xff2e2e2e),
              foregroundColor: !_isListMode ? const Color(0xff121212) : const Color(0xffe0e0e0),
            ),
            child: const Text('Dropdown'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _isListMode = true;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _isListMode ? const Color(0xff3ecf8e) : const Color(0xff2e2e2e),
              foregroundColor: _isListMode ? const Color(0xff121212) : const Color(0xffe0e0e0),
            ),
            child: const Text('List'),
          ),
        ),
      ],
    );
  }

  Widget _buildProdukDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff44425c),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xff57611f).withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: DropdownButtonFormField<String>(
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
              items: _filteredProdukList.map((produk) {
                return DropdownMenuItem<String>(
                  value: produk['nama'] as String,
                  child: Text(
                    '${produk['nama']} (${produk['kategori']})',
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedProduk = value;
                });
              },
            ),
          ),
          
          // Selected produk info
          if (_selectedProdukData != null) ...[
            const Divider(color: Color(0xff57611f)),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Stok: ${_selectedProdukData!['stok_gram']} gram',
                          style: const TextStyle(
                            color: Color(0xffe0e0e0),
                            fontSize: 14,
                          ),
                        ),
                      ),
                      if (_selectedProdukData!['stok_gram'] < _selectedProdukData!['batas_minimal_gram'])
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xfffdd835),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            '⚠️ Stok Menipis',
                            style: TextStyle(
                              color: Color(0xff121212),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Harga WMA: Rp ${_selectedProdukData!['harga_rata_rata']}/gram',
                    style: const TextStyle(
                      color: Color(0xff9e9e9e),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Nilai Total: Rp ${(_selectedProdukData!['stok_gram'] as int) * (_selectedProdukData!['harga_rata_rata'] as int)}',
                    style: const TextStyle(
                      color: Color(0xff3ecf8e),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Fitur beli stok akan segera hadir'),
                                backgroundColor: Color(0xff3ecf8e),
                              ),
                            );
                          },
                          icon: const Icon(Icons.shopping_cart, size: 18),
                          label: const Text('Beli/Tambah Stok'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff3ecf8e),
                            foregroundColor: const Color(0xff121212),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _showDetailProdukBottomSheet(_selectedProdukData!);
                          },
                          icon: const Icon(Icons.visibility, size: 18),
                          label: const Text('Lihat Detail'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff2e2e2e),
                            foregroundColor: const Color(0xffe0e0e0),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _showCatatPemakaian = !_showCatatPemakaian;
                        });
                      },
                      icon: Icon(_showCatatPemakaian ? Icons.close : Icons.edit, size: 18),
                      label: Text(_showCatatPemakaian ? 'Tutup Form' : 'Catat Pemakaian Manual'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff2e2e2e),
                        foregroundColor: const Color(0xffe0e0e0),
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

  Widget _buildProdukList() {
    return Column(
      children: _filteredProdukList.map((produk) {
        final isBelowMin = produk['stok_gram'] < produk['batas_minimal_gram'];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xff44425c),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xff57611f).withOpacity(0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      produk['nama'],
                      style: const TextStyle(
                        color: Color(0xffe0e0e0),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (isBelowMin)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xfffdd835),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        '⚠️',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Kategori: ${produk['kategori']}',
                style: const TextStyle(
                  color: Color(0xff9e9e9e),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    'Stok: ${produk['stok_gram']} gram',
                    style: const TextStyle(
                      color: Color(0xffe0e0e0),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Rp ${produk['harga_rata_rata']}/gram',
                    style: const TextStyle(
                      color: Color(0xff9e9e9e),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Nilai Total: Rp ${(produk['stok_gram'] as int) * (produk['harga_rata_rata'] as int)}',
                style: const TextStyle(
                  color: Color(0xff3ecf8e),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _selectedProduk = produk['nama'];
                          _isListMode = false;
                        });
                      },
                      icon: const Icon(Icons.shopping_cart, size: 18),
                      label: const Text('Beli/Tambah Stok'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff3ecf8e),
                        foregroundColor: const Color(0xff121212),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showDetailProdukBottomSheet(produk);
                      },
                      icon: const Icon(Icons.visibility, size: 18),
                      label: const Text('Lihat Detail'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff2e2e2e),
                        foregroundColor: const Color(0xffe0e0e0),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCatatPemakaianManual() {
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
            'Catat Pemakaian Manual',
            style: TextStyle(
              color: Color(0xffe0e0e0),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Produk dropdown (readonly)
          DropdownButtonFormField<String>(
            value: _selectedProduk,
            decoration: InputDecoration(
              labelText: 'Produk',
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
                child: Text(produk['nama']),
              );
            }).toList(),
            onChanged: null,
          ),
          const SizedBox(height: 12),
          
          // Jumlah gram
          TextField(
            controller: _jumlahGramController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Jumlah (gram)',
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
          
          // Tipe transaksi
          DropdownButtonFormField<String>(
            value: _tipeTransaksi,
            decoration: InputDecoration(
              labelText: 'Tipe',
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
            items: const [
              DropdownMenuItem(value: 'pakai', child: Text('Pakai')),
              DropdownMenuItem(value: 'koreksi_tambah', child: Text('Koreksi Tambah')),
              DropdownMenuItem(value: 'koreksi_kurang', child: Text('Koreksi Kurang')),
              DropdownMenuItem(value: 'kedaluwarsa', child: Text('Kedaluwarsa')),
            ],
            onChanged: (value) {
              setState(() {
                _tipeTransaksi = value!;
              });
            },
          ),
          const SizedBox(height: 12),
          
          // Catatan
          TextField(
            controller: _catatanController,
            decoration: InputDecoration(
              labelText: 'Catatan (opsional)',
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
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          
          // Preview stok
          if (_selectedProdukData != null && _jumlahGramController.text.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xff1a2a1f),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xff3ecf8e)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Stok Sebelum: ${_selectedProdukData!['stok_gram']} gram',
                    style: const TextStyle(
                      color: Color(0xff9e9e9e),
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '→',
                    style: TextStyle(
                      color: const Color(0xff3ecf8e),
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    'Stok Sesudah: ${(_selectedProdukData!['stok_gram'] as int) - (int.tryParse(_jumlahGramController.text) ?? 0)} gram',
                    style: const TextStyle(
                      color: Color(0xff3ecf8e),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          
          const SizedBox(height: 16),
          
          // Simpan button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                // Mock save
                setState(() {
                  _showCatatPemakaian = false;
                  _jumlahGramController.clear();
                  _catatanController.clear();
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pemakaian berhasil dicatat'),
                    backgroundColor: Color(0xff3ecf8e),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff3ecf8e),
                foregroundColor: const Color(0xff121212),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text('Simpan'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiwayatTransaksi() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff44425c),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xff57611f).withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Riwayat Transaksi',
                  style: TextStyle(
                    color: Color(0xffe0e0e0),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _selectedProduk ?? '',
                  style: const TextStyle(
                    color: Color(0xff3ecf8e),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Color(0xff57611f)),
          ..._mockRiwayatTransaksi.map((transaksi) => _buildTransaksiCard(transaksi)),
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
            leading: const Icon(Icons.grass, color: Color(0xff9e9e9e)),
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
            leading: const Icon(Icons.inventory, color: Color(0xff3ecf8e)),
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
