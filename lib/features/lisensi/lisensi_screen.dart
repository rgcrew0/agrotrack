import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LisensiScreen extends StatefulWidget {
  const LisensiScreen({super.key});

  @override
  State<LisensiScreen> createState() => _LisensiScreenState();
}

class _LisensiScreenState extends State<LisensiScreen> {
  // Form state
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _kotaController = TextEditingController();
  final TextEditingController _keyController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _namaController.dispose();
    _kotaController.dispose();
    _keyController.dispose();
    super.dispose();
  }

  void _aktivasiLisensi() {
    // Validate form
    if (_namaController.text.isEmpty ||
        _kotaController.text.isEmpty ||
        _keyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua field wajib diisi'),
          backgroundColor: Color(0xffe53935),
        ),
      );
      return;
    }

    // Validate key format (TSM-XXXX)
    final key = _keyController.text.toUpperCase();
    if (!key.startsWith('TSM-') || key.length != 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Format key harus TSM-XXXX (contoh: TSM-0001)'),
          backgroundColor: Color(0xffe53935),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Mock activation - UI only, no Supabase connection
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
      _showSuccessDialog();
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff44425c),
        title: const Text(
          'Aktivasi Berhasil',
          style: TextStyle(color: Color(0xff3ecf8e)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: Color(0xff3ecf8e),
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'Selamat, ${_namaController.text}!',
              style: const TextStyle(
                color: Color(0xffe0e0e0),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Lisensi Anda telah berhasil diaktifkan.',
              style: TextStyle(color: Color(0xff9e9e9e)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Nama', _namaController.text),
            _buildDetailRow('Kota', _kotaController.text),
            _buildDetailRow('Key', _keyController.text.toUpperCase()),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to home (mock)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Navigasi ke Beranda...'),
                  backgroundColor: Color(0xff3ecf8e),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff3ecf8e),
              foregroundColor: const Color(0xff121212),
            ),
            child: const Text('Mulai Menggunakan'),
          ),
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
            width: 60,
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

  Future<void> _openWhatsApp() async {
    final phoneNumber = '6283112626136';
    final message = 'Halo, saya ingin bertanya tentang aktivasi lisensi AgroTrack.';
    final url = 'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}';
    
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tidak dapat membuka WhatsApp'),
          backgroundColor: Color(0xffe53935),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff2b322d),
      appBar: AppBar(
        backgroundColor: const Color(0xff2b322d),
        elevation: 0,
        title: const Text(
          'Aktivasi Lisensi',
          style: TextStyle(
            color: Color(0xffe0e0e0),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              
              // Logo/Icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xff44425c),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: const Color(0xff3ecf8e), width: 2),
                ),
                child: const Icon(
                  Icons.agriculture,
                  color: Color(0xff3ecf8e),
                  size: 50,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Title
              const Text(
                'AgroTrack',
                style: TextStyle(
                  color: Color(0xff3ecf8e),
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 8),
              
              const Text(
                'Sistem Manajemen Pertanian',
                style: TextStyle(
                  color: Color(0xff9e9e9e),
                  fontSize: 14,
                ),
              ),
              
              const SizedBox(height: 48),
              
              // Form Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xff44425c),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xff57611f).withOpacity(0.5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Aktivasi Lisensi',
                      style: TextStyle(
                        color: Color(0xffe0e0e0),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Nama field
                    TextField(
                      controller: _namaController,
                      decoration: InputDecoration(
                        labelText: 'Nama Lengkap',
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
                        prefixIcon: const Icon(Icons.person, color: Color(0xff9e9e9e)),
                      ),
                      style: const TextStyle(color: Color(0xffe0e0e0)),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Kota field
                    TextField(
                      controller: _kotaController,
                      decoration: InputDecoration(
                        labelText: 'Kota',
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
                        prefixIcon: const Icon(Icons.location_city, color: Color(0xff9e9e9e)),
                      ),
                      style: const TextStyle(color: Color(0xffe0e0e0)),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Key field
                    TextField(
                      controller: _keyController,
                      textCapitalization: TextCapitalization.characters,
                      decoration: InputDecoration(
                        labelText: 'Kode Lisensi',
                        labelStyle: const TextStyle(color: Color(0xff9e9e9e)),
                        hintText: 'TSM-XXXX',
                        hintStyle: const TextStyle(color: Color(0xff57611f)),
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
                        prefixIcon: const Icon(Icons.key, color: Color(0xff9e9e9e)),
                      ),
                      style: const TextStyle(color: Color(0xffe0e0e0)),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    const Text(
                      'Format: TSM-XXXX (contoh: TSM-0001)',
                      style: TextStyle(
                        color: Color(0xff57611f),
                        fontSize: 11,
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Aktivasi button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _aktivasiLisensi,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff3ecf8e),
                          foregroundColor: const Color(0xff121212),
                          disabledBackgroundColor: const Color(0xff57611f),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Color(0xff121212),
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Aktivasi',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // WhatsApp button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _openWhatsApp,
                  icon: const Icon(Icons.chat, size: 20),
                  label: const Text('Hubungi via WhatsApp'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff25D366),
                    foregroundColor: const Color(0xffffffff),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Info text
              const Text(
                'Belum punya kode lisensi?',
                style: TextStyle(
                  color: Color(0xff9e9e9e),
                  fontSize: 14,
                ),
              ),
              
              const SizedBox(height: 8),
              
              const Text(
                'Hubungi kami via WhatsApp untuk mendapatkan kode lisensi.',
                style: TextStyle(
                  color: Color(0xff57611f),
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 48),
              
              // Version info
              Text(
                'Versi 1.0.0',
                style: TextStyle(
                  color: const Color(0xff57611f).withOpacity(0.5),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
