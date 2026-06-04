import 'package:flutter/material.dart';
import '../../shared/widgets/sidebar.dart';

class DaftarLahanScreen extends StatefulWidget {
  const DaftarLahanScreen({super.key});

  @override
  State<DaftarLahanScreen> createState() => _DaftarLahanScreenState();
}

class _DaftarLahanScreenState extends State<DaftarLahanScreen> {
  // Mock data for Info Bar
  final String _mockIdLahan = 'URTR1';
  final int _mockHST = 45;
  final String _mockTanggal = '12/06/2025';

  // Mock data for Floating Alarm Banner
  final int _hariSemprotPupuk = 3;
  final int _hariSemprotObat = 5;

  // Mock data for Lahan
  final List<Map<String, dynamic>> _mockLahanList = [
    {
      'id': 1,
      'id_lahan': 'URTR1',
      'nama': 'Lahan Utara',
      'jenis_tanaman': 'Cabai',
      'varietas': 'PM 999',
      'luas_m2': 5000,
      'lokasi': 'Desa Suka Maju',
      'status': 'aktif',
      'hst_hari_ini': 45,
      'tanggal_tanam': '28/04/2025',
      'populasi_awal': 1000,
      'total_mati': 50,
      'total_sulam': 0,
      'siklus_aktif': 'Siklus Cabai 2025',
    },
    {
      'id': 2,
      'id_lahan': 'SEL12',
      'nama': 'Lahan Selatan',
      'jenis_tanaman': 'Tomat',
      'varietas': 'Tomat Cherry',
      'luas_m2': 3000,
      'lokasi': 'Desa Suka Maju',
      'status': 'aktif',
      'hst_hari_ini': 30,
      'tanggal_tanam': '13/05/2025',
      'populasi_awal': 800,
      'total_mati': 20,
      'total_sulam': 0,
      'siklus_aktif': 'Siklus Tomat 2025',
    },
    {
      'id': 3,
      'id_lahan': 'TIM03',
      'nama': 'Lahan Timur',
      'jenis_tanaman': 'Cabai',
      'varietas': 'PM 999',
      'luas_m2': 4000,
      'lokasi': 'Desa Suka Maju',
      'status': 'selesai',
      'hst_hari_ini': 120,
      'tanggal_tanam': '12/02/2025',
      'tanggal_selesai': '12/06/2025',
      'populasi_awal': 900,
      'total_mati': 30,
      'total_sulam': 0,
      'siklus_aktif': 'Siklus Cabai Q1 2025',
    },
  ];

  // Filter state
  String _filterStatus = 'semua'; // semua, berjalan, selesai
  String _filterTanaman = 'semua'; // semua, cabai, tomat
  final TextEditingController _searchController = TextEditingController();

  // Expanded state for cards
  final Set<int> _expandedCards = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredLahanList {
    var list = _mockLahanList.where((lahan) {
      // Filter by status
      if (_filterStatus == 'berjalan' && lahan['status'] != 'aktif') return false;
      if (_filterStatus == 'selesai' && lahan['status'] != 'selesai') return false;
      
      // Filter by tanaman
      if (_filterTanaman != 'semua') {
        final jenisTanaman = (lahan['jenis_tanaman'] as String).toLowerCase();
        if (!jenisTanaman.contains(_filterTanaman)) return false;
      }
      
      // Filter by search
      final search = _searchController.text.toLowerCase();
      if (search.isNotEmpty) {
        final nama = (lahan['nama'] as String).toLowerCase();
        final idLahan = (lahan['id_lahan'] as String).toLowerCase();
        if (!nama.contains(search) && !idLahan.contains(search)) return false;
      }
      
      return true;
    }).toList();
    
    return list;
  }

  void _toggleExpand(int id) {
    setState(() {
      if (_expandedCards.contains(id)) {
        _expandedCards.remove(id);
      } else {
        _expandedCards.add(id);
      }
    });
  }

  void _showTutupSiklusDialog(Map<String, dynamic> lahan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff44425c),
        title: const Text(
          'Tutup Siklus',
          style: TextStyle(color: Color(0xffe0e0e0)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '⚠️ Sebelum menutup siklus, sangat disarankan untuk backup data terlebih dahulu.',
              style: TextStyle(color: Color(0xff9e9e9e)),
            ),
            const SizedBox(height: 16),
            Text(
              'Lahan: ${lahan['nama']}',
              style: const TextStyle(color: Color(0xffe0e0e0)),
            ),
            Text(
              'Siklus: ${lahan['siklus_aktif']}',
              style: const TextStyle(color: Color(0xffe0e0e0)),
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Backup tersimpan'),
                  backgroundColor: Color(0xff3ecf8e),
                ),
              );
            },
            icon: const Icon(Icons.save, color: Color(0xff3ecf8e)),
            label: const Text(
              'Backup ke HP',
              style: TextStyle(color: Color(0xff3ecf8e)),
            ),
          ),
          TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sinkronisasi selesai'),
                  backgroundColor: Color(0xff3ecf8e),
                ),
              );
            },
            icon: const Icon(Icons.cloud_upload, color: Color(0xff3ecf8e)),
            label: const Text(
              'Sync ke Supabase',
              style: TextStyle(color: Color(0xff3ecf8e)),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
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
                  _showKonfirmasiTutupSiklus(lahan);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff3ecf8e),
                  foregroundColor: const Color(0xff121212),
                ),
                child: const Text('Lanjut Tutup Siklus'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showKonfirmasiTutupSiklus(Map<String, dynamic> lahan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff44425c),
        title: const Text(
          'Konfirmasi Tutup Siklus',
          style: TextStyle(color: Color(0xffe0e0e0)),
        ),
        content: Text(
          'Tutup siklus "${lahan['siklus_aktif']}" untuk lahan "${lahan['nama']}"? Aksi ini tidak bisa dibatalkan.',
          style: const TextStyle(color: Color(0xff9e9e9e)),
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
              // Mock update status
              setState(() {
                final index = _mockLahanList.indexWhere((l) => l['id'] == lahan['id']);
                if (index != -1) {
                  _mockLahanList[index]['status'] = 'selesai';
                  _mockLahanList[index]['tanggal_selesai'] = '12/06/2025';
                }
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Siklus berhasil ditutup'),
                  backgroundColor: Color(0xff3ecf8e),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff3ecf8e),
              foregroundColor: const Color(0xff121212),
            ),
            child: const Text('Ya, Tutup'),
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
          'Daftar Lahan',
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
                  // Section BERJALUN
                  if (_filterStatus == 'semua' || _filterStatus == 'berjalan')
                    _buildSection('BERJALUN', 'aktif'),
                  
                  const SizedBox(height: 16),
                  
                  // Section SELESAI
                  if (_filterStatus == 'semua' || _filterStatus == 'selesai')
                    _buildSection('SELESAI', 'selesai'),
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
              content: Text('Fitur tambah lahan akan segera hadir'),
              backgroundColor: Color(0xff3ecf8e),
            ),
          );
        },
        backgroundColor: const Color(0xff3ecf8e),
        child: const Icon(Icons.add, color: Color(0xff121212)),
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
              hintText: 'Cari nama atau ID lahan',
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
          
          // Filter row
          Row(
            children: [
              // Status filter
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _filterStatus,
                  decoration: InputDecoration(
                    labelText: 'Status',
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
                    DropdownMenuItem(value: 'berjalan', child: Text('Berjalan')),
                    DropdownMenuItem(value: 'selesai', child: Text('Selesai')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _filterStatus = value!;
                    });
                  },
                ),
              ),
              const SizedBox(width: 12),
              
              // Tanaman filter
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _filterTanaman,
                  decoration: InputDecoration(
                    labelText: 'Tanaman',
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
                    DropdownMenuItem(value: 'cabai', child: Text('Cabai')),
                    DropdownMenuItem(value: 'tomat', child: Text('Tomat')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _filterTanaman = value!;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String statusFilter) {
    final lahanInSection = _filteredLahanList
        .where((lahan) => lahan['status'] == (statusFilter == 'aktif' ? 'aktif' : 'selesai'))
        .toList();
    
    if (lahanInSection.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '── $title ──────────────────────────────────────────',
          style: const TextStyle(
            color: Color(0xff3ecf8e),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...lahanInSection.map((lahan) => _buildLahanCard(lahan)),
      ],
    );
  }

  Widget _buildLahanCard(Map<String, dynamic> lahan) {
    final isExpanded = _expandedCards.contains(lahan['id']);
    final isAktif = lahan['status'] == 'aktif';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xff44425c),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xff57611f).withOpacity(0.5)),
      ),
      child: Column(
        children: [
          // Collapsed view
          InkWell(
            onTap: () => _toggleExpand(lahan['id']),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              lahan['id_lahan'],
                              style: const TextStyle(
                                color: Color(0xff3ecf8e),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: isAktif ? const Color(0xff3ecf8e) : const Color(0xff9e9e9e),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                isAktif ? 'AKTIF' : 'SELESAI',
                                style: TextStyle(
                                  color: isAktif ? const Color(0xff121212) : const Color(0xff2b322d),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          lahan['nama'],
                          style: const TextStyle(
                            color: Color(0xffe0e0e0),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              lahan['jenis_tanaman'],
                              style: const TextStyle(
                                color: Color(0xff9e9e9e),
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '•',
                              style: const TextStyle(color: Color(0xff9e9e9e)),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'HST: ${lahan['hst_hari_ini']}',
                              style: const TextStyle(
                                color: Color(0xff9e9e9e),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: const Color(0xff3ecf8e),
                  ),
                ],
              ),
            ),
          ),
          
          // Expanded view
          if (isExpanded) ...[
            const Divider(color: Color(0xff57611f)),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow('Varietas', lahan['varietas']),
                  _buildDetailRow('Luas', '${lahan['luas_m2']} m²'),
                  _buildDetailRow('Lokasi', lahan['lokasi']),
                  _buildDetailRow('Tanggal Tanam', lahan['tanggal_tanam']),
                  if (lahan['status'] == 'selesai')
                    _buildDetailRow('Tanggal Selesai', lahan['tanggal_selesai']),
                  _buildDetailRow('Populasi Awal', '${lahan['populasi_awal']} pohon'),
                  _buildDetailRow('Total Mati', '${lahan['total_mati']} pohon'),
                  _buildDetailRow('Siklus Aktif', lahan['siklus_aktif']),
                  
                  const SizedBox(height: 16),
                  
                  // Action buttons
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (!isAktif)
                        ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Lahan diaktifkan'),
                                backgroundColor: Color(0xff3ecf8e),
                              ),
                            );
                          },
                          icon: const Icon(Icons.play_arrow, size: 18),
                          label: const Text('Aktifkan'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff3ecf8e),
                            foregroundColor: const Color(0xff121212),
                          ),
                        ),
                      ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Fitur edit akan segera hadir'),
                              backgroundColor: Color(0xff3ecf8e),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit, size: 18),
                        label: const Text('Edit'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff2e2e2e),
                          foregroundColor: const Color(0xffe0e0e0),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Fitur modal pra-tanam akan segera hadir'),
                              backgroundColor: Color(0xff3ecf8e),
                            ),
                          );
                        },
                        icon: const Icon(Icons.agriculture, size: 18),
                        label: const Text('Modal Pra-Tanam'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff2e2e2e),
                          foregroundColor: const Color(0xffe0e0e0),
                        ),
                      ),
                      if (isAktif)
                        ElevatedButton.icon(
                          onPressed: () => _showTutupSiklusDialog(lahan),
                          icon: const Icon(Icons.stop, size: 18),
                          label: const Text('Tutup Siklus'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffe53935),
                            foregroundColor: const Color(0xffffffff),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
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
}
