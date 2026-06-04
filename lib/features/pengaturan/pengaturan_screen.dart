import 'package:flutter/material.dart';

class PengaturanScreen extends StatefulWidget {
  const PengaturanScreen({super.key});

  @override
  State<PengaturanScreen> createState() => _PengaturanScreenState();
}

class _PengaturanScreenState extends State<PengaturanScreen> {
  // Mock data for Info Bar
  final String _mockIdLahan = 'URTR1';
  final int _mockHST = 45;
  final String _mockTanggal = '12/06/2025';

  // Mock data for Floating Alarm Banner
  final int _hariSemprotPupuk = 3;
  final int _hariSemprotObat = 5;

  // Settings state
  bool _notifikasiSemprot = true;
  bool _notifikasiPemupukan = true;
  bool _notifikasiPanen = true;
  bool _notifikasiStok = true;
  bool _darkMode = true;
  String _bahasa = 'id';

  // Mock user data
  final Map<String, dynamic> _mockUserData = {
    'nama': 'Petani Agro',
    'email': 'petani@agrotrack.com',
    'kota': 'Jakarta',
    'tanggal_daftar': '01/01/2025',
  };

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
          'Pengaturan',
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
                  // Profil Section
                  _buildProfilSection(),
                  
                  const SizedBox(height: 16),
                  
                  // Notifikasi Section
                  _buildNotifikasiSection(),
                  
                  const SizedBox(height: 16),
                  
                  // Tampilan Section
                  _buildTampilanSection(),
                  
                  const SizedBox(height: 16),
                  
                  // Data Section
                  _buildDataSection(),
                  
                  const SizedBox(height: 16),
                  
                  // Tentang Section
                  _buildTentangSection(),
                  
                  const SizedBox(height: 16),
                  
                  // Logout Button
                  _buildLogoutButton(),
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

  Widget _buildProfilSection() {
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
            'Profil Pengguna',
            style: TextStyle(
              color: Color(0xffe0e0e0),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildProfileRow('Nama', _mockUserData['nama']),
          _buildProfileRow('Email', _mockUserData['email']),
          _buildProfileRow('Kota', _mockUserData['kota']),
          _buildProfileRow('Tanggal Daftar', _mockUserData['tanggal_daftar']),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Fitur edit profil akan segera hadir'),
                    backgroundColor: Color(0xff3ecf8e),
                  ),
                );
              },
              icon: const Icon(Icons.edit, size: 18),
              label: const Text('Edit Profil'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff3ecf8e),
                foregroundColor: const Color(0xff121212),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
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

  Widget _buildNotifikasiSection() {
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
            'Notifikasi',
            style: TextStyle(
              color: Color(0xffe0e0e0),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildSwitchTile('Notifikasi Semprot', _notifikasiSemprot, (value) {
            setState(() {
              _notifikasiSemprot = value;
            });
          }),
          _buildSwitchTile('Notifikasi Pemupukan', _notifikasiPemupukan, (value) {
            setState(() {
              _notifikasiPemupukan = value;
            });
          }),
          _buildSwitchTile('Notifikasi Panen', _notifikasiPanen, (value) {
            setState(() {
              _notifikasiPanen = value;
            });
          }),
          _buildSwitchTile('Notifikasi Stok Produk', _notifikasiStok, (value) {
            setState(() {
              _notifikasiStok = value;
            });
          }),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(
        title,
        style: const TextStyle(color: Color(0xffe0e0e0)),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: const Color(0xff3ecf8e),
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildTampilanSection() {
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
            'Tampilan',
            style: TextStyle(
              color: Color(0xffe0e0e0),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildSwitchTile('Dark Mode', _darkMode, (value) {
            setState(() {
              _darkMode = value;
            });
          }),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _bahasa,
            decoration: InputDecoration(
              labelText: 'Bahasa',
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
              DropdownMenuItem(value: 'id', child: Text('Bahasa Indonesia')),
              DropdownMenuItem(value: 'en', child: Text('English')),
            ],
            onChanged: (value) {
              setState(() {
                _bahasa = value!;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDataSection() {
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
            'Data',
            style: TextStyle(
              color: Color(0xffe0e0e0),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingTile(
            'Backup Data',
            'Simpan data lokal ke file',
            Icons.backup,
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Backup data berhasil disimpan'),
                  backgroundColor: Color(0xff3ecf8e),
                ),
              );
            },
          ),
          _buildSettingTile(
            'Restore Data',
            'Pulihkan data dari file backup',
            Icons.restore,
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fitur restore akan segera hadir'),
                  backgroundColor: Color(0xff3ecf8e),
                ),
              );
            },
          ),
          _buildSettingTile(
            'Sync ke Cloud',
            'Sinkronisasi data ke Supabase',
            Icons.cloud_upload,
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sinkronisasi ke cloud berhasil'),
                  backgroundColor: Color(0xff3ecf8e),
                ),
              );
            },
          ),
          _buildSettingTile(
            'Hapus Data Lokal',
            'Hapus semua data dari perangkat',
            Icons.delete_forever,
            () {
              _showHapusDataDialog();
            },
            color: const Color(0xffe53935),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile(
    String title,
    String subtitle,
    IconData icon,
    Function() onTap, {
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? const Color(0xff3ecf8e)),
      title: Text(
        title,
        style: const TextStyle(color: Color(0xffe0e0e0)),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Color(0xff9e9e9e), fontSize: 12),
      ),
      trailing: const Icon(Icons.chevron_right, color: Color(0xff9e9e9e)),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }

  void _showHapusDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff44425c),
        title: const Text(
          'Hapus Data Lokal',
          style: TextStyle(color: Color(0xffe0e0e0)),
        ),
        content: const Text(
          'Apakah Anda yakin ingin menghapus semua data dari perangkat? Tindakan ini tidak dapat dibatalkan.',
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data lokal berhasil dihapus'),
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

  Widget _buildTentangSection() {
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
            'Tentang',
            style: TextStyle(
              color: Color(0xffe0e0e0),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingTile(
            'Versi Aplikasi',
            'AgroTrack v1.0.0',
            Icons.info,
            () {},
          ),
          _buildSettingTile(
            'Kebijakan Privasi',
            'Baca kebijakan privasi kami',
            Icons.privacy_tip,
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Halaman kebijakan privasi akan segera hadir'),
                  backgroundColor: Color(0xff3ecf8e),
                ),
              );
            },
          ),
          _buildSettingTile(
            'Syarat & Ketentuan',
            'Baca syarat dan ketentuan',
            Icons.description,
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Halaman syarat & ketentuan akan segera hadir'),
                  backgroundColor: Color(0xff3ecf8e),
                ),
              );
            },
          ),
          _buildSettingTile(
            'Bantuan',
            'Dapatkan bantuan penggunaan aplikasi',
            Icons.help,
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Halaman bantuan akan segera hadir'),
                  backgroundColor: Color(0xff3ecf8e),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: () {
          _showLogoutDialog();
        },
        icon: const Icon(Icons.logout, size: 18),
        label: const Text('Keluar'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xffe53935),
          foregroundColor: const Color(0xffffffff),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff44425c),
        title: const Text(
          'Keluar',
          style: TextStyle(color: Color(0xffe0e0e0)),
        ),
        content: const Text(
          'Apakah Anda yakin ingin keluar dari aplikasi?',
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logout berhasil'),
                  backgroundColor: Color(0xff3ecf8e),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffe53935),
              foregroundColor: const Color(0xffffffff),
            ),
            child: const Text('Ya, Keluar'),
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
