import 'package:flutter/material.dart';

class CatatanLapanganScreen extends StatefulWidget {
  const CatatanLapanganScreen({super.key});

  @override
  State<CatatanLapanganScreen> createState() => _CatatanLapanganScreenState();
}

class _CatatanLapanganScreenState extends State<CatatanLapanganScreen> {
  // Mock data for Info Bar
  final String _mockIdLahan = 'URTR1';
  final int _mockHST = 45;
  final String _mockTanggal = '12/06/2025';

  // Mock data for Floating Alarm Banner
  final int _hariSemprotPupuk = 3;
  final int _hariSemprotObat = 5;

  // Form state
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController(text: '12/06/2025');
  final TextEditingController _hstController = TextEditingController(text: '45');
  final TextEditingController _isiCatatanController = TextEditingController();
  String _kategori = 'umum';

  // Mock kategori list
  final List<String> _kategoriList = [
    'umum',
    'hama',
    'penyakit',
    'cuaca',
    'tanaman',
    'perawatan',
    'pemupukan',
    'semprot',
    'panen',
    'lainnya',
  ];

  // Mock history catatan
  final List<Map<String, dynamic>> _mockHistoryCatatan = [
    {
      'id': 1,
      'judul': 'Gejala hama thrips meningkat',
      'tanggal': '10/06/2025',
      'hst': 43,
      'kategori': 'hama',
      'isi': 'Ditemukan gejala serangan thrips pada daun bagian bawah. Perlu perhatian khusus dan mungkin perlu semprot obat.',
      'lahan': 'URTR1',
    },
    {
      'id': 2,
      'judul': 'Curah hujan tinggi',
      'tanggal': '08/06/2025',
      'hst': 41,
      'kategori': 'cuaca',
      'isi': 'Hujan deras sejak 2 hari terakhir. Drainase perlu diperiksa untuk mencegah genangan.',
      'lahan': 'URTR1',
    },
    {
      'judul': 'Pemupukan berjalan lancar',
      'tanggal': '05/06/2025',
      'hst': 38,
      'kategori': 'pemupukan',
      'isi': 'Pemupukan fase vegetatif selesai. Tanaman terlihat sehat dan hijau.',
      'lahan': 'URTR1',
    },
    {
      'judul': 'Inspeksi rutin mingguan',
      'tanggal': '01/06/2025',
      'hst': 34,
      'kategori': 'umum',
      'isi': 'Inspeksi rutin menunjukkan kondisi tanaman baik. Populasi tanaman stabil.',
      'lahan': 'URTR1',
    },
    {
      'judul': 'Gejala layu pada beberapa tanaman',
      'tanggal': '28/05/2025',
      'hst': 31,
      'kategori': 'penyakit',
      'isi': 'Ditemukan 3 tanaman dengan gejala layu. Perlu investigasi lebih lanjut dan isolasi jika perlu.',
      'lahan': 'URTR1',
    },
  ];

  // History expanded state
  final Set<int> _expandedHistory = {};

  @override
  void dispose() {
    _judulController.dispose();
    _tanggalController.dispose();
    _hstController.dispose();
    _isiCatatanController.dispose();
    super.dispose();
  }

  void _simpan() {
    if (_judulController.text.isEmpty || _isiCatatanController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Judul dan isi catatan wajib diisi'),
          backgroundColor: Color(0xffe53935),
        ),
      );
      return;
    }

    _showKonfirmasiModal();
  }

  void _showKonfirmasiModal() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff44425c),
        title: const Text(
          'Konfirmasi Catatan',
          style: TextStyle(color: Color(0xffe0e0e0)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildKonfirmasiRow('Judul', _judulController.text),
            _buildKonfirmasiRow('Kategori', _kategori),
            _buildKonfirmasiRow('Tanggal', _tanggalController.text),
            _buildKonfirmasiRow('HST', _hstController.text),
            _buildKonfirmasiRow('Lahan', 'Lahan Utama (URTR1)'),
            const SizedBox(height: 8),
            const Text(
              'Isi Catatan:',
              style: TextStyle(color: Color(0xff9e9e9e), fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              _isiCatatanController.text,
              style: const TextStyle(color: Color(0xffe0e0e0), fontSize: 12),
            ),
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
              // Mock save - add to history
              setState(() {
                _mockHistoryCatatan.insert(0, {
                  'id': _mockHistoryCatatan.length + 1,
                  'judul': _judulController.text,
                  'tanggal': _tanggalController.text,
                  'hst': int.tryParse(_hstController.text) ?? 0,
                  'kategori': _kategori,
                  'isi': _isiCatatanController.text,
                  'lahan': 'URTR1',
                });
                _judulController.clear();
                _isiCatatanController.clear();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Catatan berhasil disimpan'),
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

  void _hapusCatatan(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff44425c),
        title: const Text(
          'Hapus Catatan',
          style: TextStyle(color: Color(0xffe0e0e0)),
        ),
        content: const Text(
          'Apakah Anda yakin ingin menghapus catatan ini?',
          style: TextStyle(color: Color(0xff9e9e9e)),
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
              setState(() {
                _mockHistoryCatatan.removeWhere((catatan) => catatan['id'] == id);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Catatan berhasil dihapus'),
                  backgroundColor: Color(0xff3ecf8e),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffe53935),
              foregroundColor: const Color(0xffffffff),
            ),
            child: const Text('Ya, Hapus'),
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
          'Catatan Lapangan',
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
                  
                  // History Catatan
                  _buildHistoryCatatan(),
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
            'Tambah Catatan Baru',
            style: TextStyle(
              color: Color(0xffe0e0e0),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Judul
          TextField(
            controller: _judulController,
            decoration: InputDecoration(
              labelText: 'Judul Catatan',
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
          
          // Row: Tanggal | HST
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _tanggalController,
                  decoration: InputDecoration(
                    labelText: 'Tanggal',
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
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _hstController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'HST',
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
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Kategori
          DropdownButtonFormField<String>(
            value: _kategori,
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
            ),
            dropdownColor: const Color(0xff2a2a2a),
            style: const TextStyle(color: Color(0xffe0e0e0)),
            items: _kategoriList.map((kategori) {
              return DropdownMenuItem<String>(
                value: kategori,
                child: Text(kategori[0].toUpperCase() + kategori.substring(1)),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _kategori = value!;
              });
            },
          ),
          const SizedBox(height: 12),
          
          // Isi Catatan
          TextField(
            controller: _isiCatatanController,
            maxLines: 5,
            decoration: InputDecoration(
              labelText: 'Isi Catatan',
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
          
          // Simpan button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _simpan,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff3ecf8e),
                foregroundColor: const Color(0xff121212),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text('Simpan Catatan'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCatatan() {
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
            'History Catatan',
            style: TextStyle(
              color: Color(0xffe0e0e0),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ..._mockHistoryCatatan.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isExpanded = _expandedHistory.contains(item['id']);
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
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
                          _expandedHistory.remove(item['id']);
                        } else {
                          _expandedHistory.add(item['id']);
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
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: _getKategoriColor(item['kategori']),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        item['kategori'][0].toUpperCase() + item['kategori'].substring(1),
                                        style: const TextStyle(
                                          color: Color(0xff121212),
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        item['judul'],
                                        style: const TextStyle(
                                          color: Color(0xffe0e0e0),
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      item['tanggal'],
                                      style: const TextStyle(color: Color(0xff9e9e9e), fontSize: 11),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '•',
                                      style: TextStyle(color: Color(0xff9e9e9e)),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'HST: ${item['hst']}',
                                      style: const TextStyle(color: Color(0xff9e9e9e), fontSize: 11),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '•',
                                      style: TextStyle(color: Color(0xff9e9e9e)),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      item['lahan'],
                                      style: const TextStyle(color: Color(0xff9e9e9e), fontSize: 11),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => _hapusCatatan(item['id']),
                            icon: const Icon(Icons.delete, color: Color(0xffe53935), size: 18),
                          ),
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
                          _buildHistoryRow('Judul', item['judul']),
                          _buildHistoryRow('Kategori', item['kategori']),
                          _buildHistoryRow('Tanggal', item['tanggal']),
                          _buildHistoryRow('HST', '${item['hst']}'),
                          _buildHistoryRow('Lahan', item['lahan']),
                          const SizedBox(height: 8),
                          const Text(
                            'Isi Catatan:',
                            style: TextStyle(color: Color(0xff9e9e9e), fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['isi'],
                            style: const TextStyle(color: Color(0xffe0e0e0), fontSize: 12),
                          ),
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

  Color _getKategoriColor(String kategori) {
    switch (kategori) {
      case 'hama':
        return const Color(0xfffdd835);
      case 'penyakit':
        return const Color(0xffe53935);
      case 'cuaca':
        return const Color(0xff42a5f5);
      case 'tanaman':
        return const Color(0xff3ecf8e);
      case 'perawatan':
        return const Color(0xffab47bc);
      case 'pemupukan':
        return const Color(0xff66bb6a);
      case 'semprot':
        return const Color(0xffffa726);
      case 'panen':
        return const Color(0xff26a69a);
      default:
        return const Color(0xff9e9e9e);
    }
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
            leading: const Icon(Icons.note, color: Color(0xff3ecf8e)),
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
