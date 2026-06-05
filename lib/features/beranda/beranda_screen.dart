import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import '../../shared/widgets/sidebar.dart';
import '../../shared/widgets/animated_border_container.dart';
import '../../core/format.dart';
import '../../core/konstanta.dart';

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
    'totalOmzet': 25000000,
    'populasiAwal': 1000,
    'populasiHidup': 950,
    'totalPohonMati': 50,
    'biayaPerTanaman': 15789,
    'keuntunganPerTanaman': 10526,
    'omzetPerTanaman': 26316,
    'totalPanen': 2500,
    'persentaseReject': 5.2,
    'estimasiPanenBerikutnya': 15,
    'totalSemprot': 8,
    'totalPemupukan': 12,
    'totalBiaya': 15000000,
    'labaBersih': 10000000,
    'hppPerGram': 6000,
    'bepGram': 1500,
    'roi': 66.67,
  };

  // Notification panel state
  bool _showNotificationPanel = false;
  int _currentNotificationSlide = 0;

  // Local notifications
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  // Calculator widget state
  int _selectedCalculatorWidget = 0; // 0: Kalkulator Pupuk, 1: Kalkulator Gram/Harga

  // Kalkulator Gram/Harga state
  int _selectedGramHargaTab = 0; // 0: Gram dari Harga, 1: Harga dari Gram
  final TextEditingController _rupiahController = TextEditingController();
  final TextEditingController _hargaPerKgController = TextEditingController();
  final TextEditingController _gramController = TextEditingController();
  String _hasilKalkulasi = '';

  // Kalkulator Pupuk Bebas state
  final TextEditingController _targetCampuranController = TextEditingController(text: '1000');
  final List<Map<String, dynamic>> _pupukRows = [];
  String _hasilUnsurHara = '';
  bool _showKatalogPupuk = false;

  // Mock produk list with 14 nutrients
  final List<Map<String, dynamic>> _mockProdukList = [
    {
      'nama': 'NPK Mutiara',
      'kategori': 'pupuk',
      'hargaPerKg': 75000,
      'n_persen': 160000, 'p_persen': 160000, 'k_persen': 160000,
      'ca_persen': 0, 'mg_persen': 0, 's_persen': 0,
      'fe_persen': 0, 'mn_persen': 0, 'zn_persen': 0,
      'cu_persen': 0, 'b_persen': 0, 'mo_persen': 0,
      'cl_persen': 0, 'na_persen': 0
    },
    {
      'nama': 'Urea',
      'kategori': 'pupuk',
      'hargaPerKg': 60000,
      'n_persen': 460000, 'p_persen': 0, 'k_persen': 0,
      'ca_persen': 0, 'mg_persen': 0, 's_persen': 0,
      'fe_persen': 0, 'mn_persen': 0, 'zn_persen': 0,
      'cu_persen': 0, 'b_persen': 0, 'mo_persen': 0,
      'cl_persen': 0, 'na_persen': 0
    },
    {
      'nama': 'KCL',
      'kategori': 'pupuk',
      'hargaPerKg': 80000,
      'n_persen': 0, 'p_persen': 0, 'k_persen': 600000,
      'ca_persen': 0, 'mg_persen': 0, 's_persen': 0,
      'fe_persen': 0, 'mn_persen': 0, 'zn_persen': 0,
      'cu_persen': 0, 'b_persen': 0, 'mo_persen': 0,
      'cl_persen': 0, 'na_persen': 0
    },
  ];

  // Chart state
  int _selectedChartMode = 0;
  final List<String> _chartModes = [
    'Cashflow', 'Biaya Kumulatif', 'Omzet Kumulatif', 'Panen per Periode',
    'Biaya per Kategori', 'Populasi', 'Unsur Hara'
  ];
  
  // Time/Activity filter state
  int _selectedTimeFilter = 0;
  final List<String> _timeFilters = ['Per Aktivitas', 'Mingguan', 'Bulanan', 'Tahunan'];

  // Notification slide data
  final List<List<Map<String, dynamic>>> _notificationSlides = [
    // Slide 1: Jadwal mendatang
    [
      {'title': 'Semprot Pupuk', 'date': 'Besok', 'time': '08:00', 'lahan': 'URTR1'},
      {'title': 'Panen', 'date': 'Lusa', 'time': '07:00', 'lahan': 'URTR1'},
    ],
    // Slide 2: Keterlambatan
    [
      {'title': 'Semprot Obat', 'late': '2 hari', 'lahan': 'URTR1'},
    ],
    // Slide 3: Selesai baru (48 jam terakhir)
    [
      {'title': 'Pemupukan', 'completed': 'Kemarin', 'lahan': 'URTR1'},
      {'title': 'Perawatan', 'completed': '2 hari lalu', 'lahan': 'URTR1'},
    ],
    // Slide 4: Stok menipis
    [
      {'produk': 'Urea', 'stok': '500 gram', 'min': '1000 gram'},
      {'produk': 'KCL', 'stok': '800 gram', 'min': '1000 gram'},
    ],
    // Slide 5: Pesan admin
    [
      {'pesan': 'Backup data rutin disarankan setiap minggu.', 'date': '10/06/2025'},
      {'pesan': 'Versi baru tersedia: v1.1', 'date': '08/06/2025'},
    ],
  ];

  @override
  void initState() {
    super.initState();
    // Initialize local notifications
    _initializeNotifications();
    // Add listeners for realtime calculation
    _rupiahController.addListener(_hitungKalkulatorRealtime);
    _hargaPerKgController.addListener(_hitungKalkulatorRealtime);
    _gramController.addListener(_hitungKalkulatorRealtime);
    _targetCampuranController.addListener(_hitungPupukRealtime);
  }

  @override
  void dispose() {
    _rupiahController.dispose();
    _hargaPerKgController.dispose();
    _gramController.dispose();
    _targetCampuranController.dispose();
    super.dispose();
  }

  void _hitungKalkulatorRealtime() {
    if (_selectedGramHargaTab == 0) {
      // Gram dari Harga
      final rupiah = double.tryParse(_rupiahController.text) ?? 0;
      final hargaPerKg = double.tryParse(_hargaPerKgController.text) ?? 0;
      if (hargaPerKg > 0) {
        final gram = (rupiah / hargaPerKg) * 1000;
        setState(() {
          _hasilKalkulasi = '${gram.toStringAsFixed(2)} gram';
        });
      } else {
        setState(() {
          _hasilKalkulasi = '';
        });
      }
    } else {
      // Harga dari Gram
      final gram = double.tryParse(_gramController.text) ?? 0;
      final hargaPerKg = double.tryParse(_hargaPerKgController.text) ?? 0;
      if (hargaPerKg > 0) {
        final harga = (gram / 1000) * hargaPerKg;
        setState(() {
          _hasilKalkulasi = 'Rp ${harga.toStringAsFixed(0)}';
        });
      } else {
        setState(() {
          _hasilKalkulasi = '';
        });
      }
    }
  }

  void _hitungPupukRealtime() {
    setState(() {
      _hasilUnsurHara = '';
    });
  }

  void _hitungUnsurHara() {
    double totalGram = 0;
    Map<String, double> totalUnsur = {
      'N': 0, 'P': 0, 'K': 0, 'Ca': 0, 'Mg': 0, 'S': 0,
      'Fe': 0, 'Mn': 0, 'Zn': 0, 'Cu': 0, 'B': 0, 'Mo': 0, 'Cl': 0, 'Na': 0
    };

    for (var row in _pupukRows) {
      final gram = double.tryParse(row['gramController'].text) ?? 0;
      if (row['produk'] != null && gram > 0) {
        totalGram += gram;
        final produk = _mockProdukList.firstWhere((p) => p['nama'] == row['produk']);
        totalUnsur['N'] = totalUnsur['N']! + (gram * (produk['n_persen'] as int) / 1000000);
        totalUnsur['P'] = totalUnsur['P']! + (gram * (produk['p_persen'] as int) / 1000000);
        totalUnsur['K'] = totalUnsur['K']! + (gram * (produk['k_persen'] as int) / 1000000);
        totalUnsur['Ca'] = totalUnsur['Ca']! + (gram * (produk['ca_persen'] as int) / 1000000);
        totalUnsur['Mg'] = totalUnsur['Mg']! + (gram * (produk['mg_persen'] as int) / 1000000);
        totalUnsur['S'] = totalUnsur['S']! + (gram * (produk['s_persen'] as int) / 1000000);
        totalUnsur['Fe'] = totalUnsur['Fe']! + (gram * (produk['fe_persen'] as int) / 1000000);
        totalUnsur['Mn'] = totalUnsur['Mn']! + (gram * (produk['mn_persen'] as int) / 1000000);
        totalUnsur['Zn'] = totalUnsur['Zn']! + (gram * (produk['zn_persen'] as int) / 1000000);
        totalUnsur['Cu'] = totalUnsur['Cu']! + (gram * (produk['cu_persen'] as int) / 1000000);
        totalUnsur['B'] = totalUnsur['B']! + (gram * (produk['b_persen'] as int) / 1000000);
        totalUnsur['Mo'] = totalUnsur['Mo']! + (gram * (produk['mo_persen'] as int) / 1000000);
        totalUnsur['Cl'] = totalUnsur['Cl']! + (gram * (produk['cl_persen'] as int) / 1000000);
        totalUnsur['Na'] = totalUnsur['Na']! + (gram * (produk['na_persen'] as int) / 1000000);
      }
    }

    if (totalGram > 0) {
      List<String> unsurList = [];
      totalUnsur.forEach((key, value) {
        if (value > 0) {
          unsurList.add('$key: ${value.toStringAsFixed(2)}g');
        }
      });
      setState(() {
        _hasilUnsurHara = 'Unsur hara ini dibuat dari ${totalGram.toStringAsFixed(0)} gram\n${unsurList.join(', ')}';
      });
    }
  }

  void _resetPupukGramasi() {
    for (var row in _pupukRows) {
      row['gramController'].text = '';
    }
    setState(() {
      _hasilUnsurHara = '';
    });
  }

  Future<void> _initializeNotifications() async {
    tz_data.initializeTimeZones();
    
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _notificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _scheduleAlarmNotifications() async {
    // H-2: Notifikasi pertama
    await _notificationsPlugin.zonedSchedule(
      0,
      'Semprot Pupuk Daun',
      'Jadwal semprot pupuk daun dalam 2 hari',
      _getNextNotificationTime(days: 2),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'agrotrack_alarms',
          'Alarm Notifikasi',
          channelDescription: 'Notifikasi jadwal aktivitas',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    // H-1: Notifikasi kedua
    await _notificationsPlugin.zonedSchedule(
      1,
      'Semprot Pupuk Daun',
      'Jadwal semprot pupuk daun besok',
      _getNextNotificationTime(days: 1),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'agrotrack_alarms',
          'Alarm Notifikasi',
          channelDescription: 'Notifikasi jadwal aktivitas',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    // H: Notifikasi hari H (paling penting)
    await _notificationsPlugin.zonedSchedule(
      2,
      'Semprot Pupuk Daun - HARI INI',
      'Waktunya semprot pupuk daun hari ini!',
      _getNextNotificationTime(days: 0),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'agrotrack_alarms',
          'Alarm Notifikasi',
          channelDescription: 'Notifikasi jadwal aktivitas',
          importance: Importance.max,
          priority: Priority.max,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  tz.TZDateTime _getNextNotificationTime({required int days}) {
    // Mock implementation - in real app, calculate based on actual schedule
    final now = DateTime.now().add(Duration(days: days));
    return tz.TZDateTime.from(now, tz.local);
  }

  void _addPupukRow() {
    setState(() {
      _pupukRows.add({
        'produk': null,
        'gramController': TextEditingController(),
        'dosisController': TextEditingController(),
      });
    });
  }

  void _removePupukRow(int index) {
    _pupukRows[index]['gramController'].dispose();
    _pupukRows[index]['dosisController'].dispose();
    setState(() {
      _pupukRows.removeAt(index);
      _hasilUnsurHara = '';
    });
  }

  double _getTotalPupukGram() {
    double total = 0;
    for (var row in _pupukRows) {
      total += double.tryParse(row['gramController'].text) ?? 0;
    }
    return total;
  }

  double _getTotalPupukBiaya() {
    double total = 0;
    for (var row in _pupukRows) {
      final gram = double.tryParse(row['gramController'].text) ?? 0;
      if (row['produk'] != null) {
        final produk = _mockProdukList.firstWhere((p) => p['nama'] == row['produk']);
        total += (gram / 1000) * (produk['hargaPerKg'] as int);
      }
    }
    return total;
  }

  double _getSisaGram() {
    final target = double.tryParse(_targetCampuranController.text) ?? 1000;
    return target - _getTotalPupukGram();
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
            tooltip: 'Menu navigasi',
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
            tooltip: 'Cari',
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications, color: Color(0xffe0e0e0)),
                onPressed: () {
                  setState(() {
                    _showNotificationPanel = !_showNotificationPanel;
                  });
                },
                tooltip: 'Notifikasi',
              ),
              if (_notificationSlides.any((slide) => slide.isNotEmpty))
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: const Color(0xffe53935),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      '5',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          // Main content - Info Bar and Floating Banner now scroll with content
          Scrollbar(
            thumbVisibility: false,
            thickness: 0,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  // Info Bar
                  _buildInfoBar(),
                  
                  // Floating Alarm Banner
                  _buildFloatingAlarmBanner(),
                  
                  // Dashboard Cards
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Dashboard Cards
                      _buildDashboardCards(),
                      
                      const SizedBox(height: 16),
                      
                      // Grafik Multifungsi
                      _buildGrafikMultifungsi(),
                      
                      const SizedBox(height: 16),
                      
                      // Combined Calculator Widget
                      _buildCombinedCalculator(),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Blur background when notification panel is open
          if (_showNotificationPanel)
            GestureDetector(
              onTap: () {
                setState(() {
                  _showNotificationPanel = false;
                });
              },
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),
          
          // Notification Panel
          if (_showNotificationPanel) _buildNotificationPanel(),
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
    Color getPupukColor() {
      if (_hariSemprotPupuk == 0) return const Color(0xffe53935);
      if (_hariSemprotPupuk <= 3) return const Color(0xfffdd835);
      return const Color(0xff3ecf8e);
    }

    Color getObatColor() {
      if (_hariSemprotObat == 0) return const Color(0xffe53935);
      if (_hariSemprotObat <= 3) return const Color(0xfffdd835);
      return const Color(0xff3ecf8e);
    }

    return GestureDetector(
      onTap: () {
        context.push('/semprot');
      },
      child: Container(
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
                    style: TextStyle(
                      color: getPupukColor(),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
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
                    style: TextStyle(
                      color: getObatColor(),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCards() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use MediaQuery to get actual screen width, not constrained width
        final screenWidth = MediaQuery.of(context).size.width;
        final isSmallScreen = screenWidth < 365;
        
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
            
            // Total Omzet - Full width card at top
            Tooltip(
              message: 'Total pendapatan dari penjualan hasil panen',
              preferBelow: false,
              child: AnimatedBorderContainer(
                backgroundColor: const Color(0xff44425c),
                borderRadius: BorderRadius.circular(12),
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total Omzet',
                            style: TextStyle(
                              color: Color(0xff9e9e9e),
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            formatRupiah(_mockDashboardData['totalOmzet'] as int),
                            style: const TextStyle(
                              color: Color(0xff3ecf8e),
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.trending_up,
                      color: Color(0xff3ecf8e),
                      size: 40,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Responsive grid for remaining cards
            if (isSmallScreen) ...[
              // 1 column for small screens
              _buildDashboardCard(
                'Populasi Awal',
                '${_mockDashboardData['populasiAwal'].toString()} pohon',
                const Color(0xff1e88e5),
                tooltip: 'Jumlah tanaman awal saat tanam',
              ),
              const SizedBox(height: 12),
              _buildDashboardCard(
                'Populasi Hidup',
                '${_mockDashboardData['populasiHidup'].toString()} pohon',
                const Color(0xff1e88e5),
                tooltip: 'Jumlah tanaman yang masih hidup saat ini',
              ),
              const SizedBox(height: 12),
              _buildDashboardCard(
                'Total Pohon Mati',
                '${_mockDashboardData['totalPohonMati'].toString()} pohon',
                const Color(0xffe53935),
                tooltip: 'Jumlah tanaman yang mati',
              ),
              const SizedBox(height: 12),
              _buildDashboardCard(
                'Biaya/Pohon',
                formatRupiah(_mockDashboardData['biayaPerTanaman'] as int),
                const Color(0xffe53935),
                tooltip: 'Rata-rata biaya per tanaman hidup',
              ),
              const SizedBox(height: 12),
              _buildDashboardCard(
                'Keuntungan/Tanaman',
                formatRupiah(_mockDashboardData['keuntunganPerTanaman'] as int),
                const Color(0xff3ecf8e),
                tooltip: 'Rata-rata keuntungan per tanaman',
              ),
              const SizedBox(height: 12),
              _buildDashboardCard(
                'Omzet/Pohon',
                formatRupiah(_mockDashboardData['omzetPerTanaman'] as int),
                const Color(0xff3ecf8e),
                tooltip: 'Rata-rata omzet per tanaman',
              ),
              const SizedBox(height: 12),
              _buildDashboardCard(
                'Total Panen',
                '${(_mockDashboardData['totalPanen'] as int).toString()} kg',
                const Color(0xfffdd835),
                tooltip: 'Total berat hasil panen yang sudah dicatat',
              ),
              const SizedBox(height: 12),
              _buildDashboardCard(
                'Persentase Reject',
                '${(_mockDashboardData['persentaseReject'] as double).toStringAsFixed(1)}%',
                const Color(0xffe53935),
                tooltip: 'Persentase hasil panen yang reject',
              ),
              const SizedBox(height: 12),
              _buildDashboardCard(
                'Estimasi Panen',
                'H-${_mockDashboardData['estimasiPanenBerikutnya'].toString()}',
                const Color(0xfffdd835),
                tooltip: 'Perkiraan hari sampai panen berikutnya',
              ),
              const SizedBox(height: 12),
              _buildDashboardCard(
                'Total Semprot',
                '${_mockDashboardData['totalSemprot'].toString()} kali',
                const Color(0xff1e88e5),
                tooltip: 'Total aktivitas semprot yang sudah dilakukan',
              ),
              const SizedBox(height: 12),
              _buildDashboardCard(
                'Total Pemupukan',
                '${_mockDashboardData['totalPemupukan'].toString()} kali',
                const Color(0xff1e88e5),
                tooltip: 'Total aktivitas pemupukan yang sudah dilakukan',
              ),
              const SizedBox(height: 12),
              _buildDashboardCard(
                'Total Biaya',
                formatRupiah(_mockDashboardData['totalBiaya'] as int),
                const Color(0xffe53935),
                tooltip: 'Total seluruh biaya yang dikeluarkan dalam siklus ini',
              ),
              const SizedBox(height: 12),
              _buildDashboardCard(
                'Laba Bersih',
                formatRupiah(_mockDashboardData['labaBersih'] as int),
                const Color(0xff3ecf8e),
                tooltip: 'Omzet dikurangi total biaya',
              ),
              const SizedBox(height: 12),
              _buildDashboardCard(
                'HPP/kg',
                formatRupiah(_mockDashboardData['hppPerGram'] as int),
                const Color(0xffe53935),
                tooltip: 'Harga Pokok Produksi per gram hasil panen',
              ),
              const SizedBox(height: 12),
              _buildDashboardCard(
                'BEP',
                '${(_mockDashboardData['bepGram'] as int).toString()} kg',
                const Color(0xfffdd835),
                tooltip: 'Break Even Point - berat panen untuk balik modal',
              ),
              const SizedBox(height: 12),
              _buildDashboardCard(
                'ROI',
                '${(_mockDashboardData['roi'] as double).toStringAsFixed(2)}%',
                const Color(0xff3ecf8e),
                tooltip: 'Return on Investment - persentase keuntungan terhadap modal',
              ),
            ] else ...[
              // 2-column grid for larger screens
              Row(
                children: [
                  Expanded(
                    child: _buildDashboardCard(
                      'Populasi Awal',
                      '${_mockDashboardData['populasiAwal'].toString()} pohon',
                      const Color(0xff1e88e5),
                      tooltip: 'Jumlah tanaman awal saat tanam',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDashboardCard(
                      'Populasi Hidup',
                      '${_mockDashboardData['populasiHidup'].toString()} pohon',
                      const Color(0xff1e88e5),
                      tooltip: 'Jumlah tanaman yang masih hidup saat ini',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildDashboardCard(
                      'Total Pohon Mati',
                      '${_mockDashboardData['totalPohonMati'].toString()} pohon',
                      const Color(0xffe53935),
                      tooltip: 'Jumlah tanaman yang mati',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDashboardCard(
                      'Biaya/Pohon',
                      formatRupiah(_mockDashboardData['biayaPerTanaman'] as int),
                      const Color(0xffe53935),
                      tooltip: 'Rata-rata biaya per tanaman hidup',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildDashboardCard(
                      'Keuntungan/Tanaman',
                      formatRupiah(_mockDashboardData['keuntunganPerTanaman'] as int),
                      const Color(0xff3ecf8e),
                      tooltip: 'Rata-rata keuntungan per tanaman',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDashboardCard(
                      'Omzet/Pohon',
                      formatRupiah(_mockDashboardData['omzetPerTanaman'] as int),
                      const Color(0xff3ecf8e),
                      tooltip: 'Rata-rata omzet per tanaman',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildDashboardCard(
                      'Total Panen',
                      '${(_mockDashboardData['totalPanen'] as int).toString()} kg',
                      const Color(0xfffdd835),
                      tooltip: 'Total berat hasil panen yang sudah dicatat',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDashboardCard(
                      'Persentase Reject',
                      '${(_mockDashboardData['persentaseReject'] as double).toStringAsFixed(1)}%',
                      const Color(0xffe53935),
                      tooltip: 'Persentase hasil panen yang reject',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildDashboardCard(
                      'Estimasi Panen',
                      'H-${_mockDashboardData['estimasiPanenBerikutnya'].toString()}',
                      const Color(0xfffdd835),
                      tooltip: 'Perkiraan hari sampai panen berikutnya',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDashboardCard(
                      'Total Semprot',
                      '${_mockDashboardData['totalSemprot'].toString()} kali',
                      const Color(0xff1e88e5),
                      tooltip: 'Total aktivitas semprot yang sudah dilakukan',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildDashboardCard(
                      'Total Pemupukan',
                      '${_mockDashboardData['totalPemupukan'].toString()} kali',
                      const Color(0xff1e88e5),
                      tooltip: 'Total aktivitas pemupukan yang sudah dilakukan',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDashboardCard(
                      'Total Biaya',
                      formatRupiah(_mockDashboardData['totalBiaya'] as int),
                      const Color(0xffe53935),
                      tooltip: 'Total seluruh biaya yang dikeluarkan dalam siklus ini',
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
                      formatRupiah(_mockDashboardData['labaBersih'] as int),
                      const Color(0xff3ecf8e),
                      tooltip: 'Omzet dikurangi total biaya',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDashboardCard(
                      'HPP/kg',
                      formatRupiah(_mockDashboardData['hppPerGram'] as int),
                      const Color(0xffe53935),
                      tooltip: 'Harga Pokok Produksi per gram hasil panen',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildDashboardCard(
                      'BEP',
                      '${(_mockDashboardData['bepGram'] as int).toString()} kg',
                      const Color(0xfffdd835),
                      tooltip: 'Break Even Point - berat panen untuk balik modal',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDashboardCard(
                      'ROI',
                      '${(_mockDashboardData['roi'] as double).toStringAsFixed(2)}%',
                      const Color(0xff3ecf8e),
                      tooltip: 'Return on Investment - persentase keuntungan terhadap modal',
                    ),
                  ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildDashboardCard(String label, String value, Color color, {String? tooltip}) {
    return Tooltip(
      message: tooltip ?? label,
      preferBelow: false,
      child: AnimatedBorderContainer(
        backgroundColor: const Color(0xff44425c),
        borderRadius: BorderRadius.circular(12),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          label,
                          style: const TextStyle(
                            color: Color(0xff9e9e9e),
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (tooltip != null) ...[
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.info_outline,
                          color: Color(0xff3ecf8e),
                          size: 14,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    value,
                    style: TextStyle(
                      color: color,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrafikMultifungsi() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Grafik Multifungsi',
                style: TextStyle(
                  color: Color(0xffe0e0e0),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedChartMode = (_selectedChartMode + 1) % _chartModes.length;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xff3ecf8e),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _chartModes[_selectedChartMode],
                    style: const TextStyle(
                      color: Color(0xff121212),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Time/Activity Filter
          SegmentedButton<int>(
            segments: List.generate(
              _timeFilters.length,
              (index) => ButtonSegment(
                value: index,
                label: Text(
                  _timeFilters[index],
                  style: TextStyle(
                    fontSize: 11,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
            selected: {_selectedTimeFilter},
            onSelectionChanged: (Set<int> newSelection) {
              setState(() {
                _selectedTimeFilter = newSelection.first;
              });
            },
            style: SegmentedButton.styleFrom(
              backgroundColor: isDarkMode ? const Color(0xff2b322d) : Colors.grey[200],
              foregroundColor: isDarkMode ? Colors.white : Colors.black,
              selectedBackgroundColor: const Color(0xff3ecf8e),
              selectedForegroundColor: const Color(0xff121212),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Chart with watermark (inside each chart)
          SizedBox(
            height: 250,
            child: _buildChartContent(isDarkMode),
          ),
          
          // Legend
          const SizedBox(height: 12),
          _buildChartLegend(isDarkMode),
        ],
      ),
    );
  }

  Widget _buildChartLegend(bool isDarkMode) {
    final textColor = isDarkMode ? const Color(0xff9e9e9e) : Colors.black87;
    
    switch (_selectedChartMode) {
      case 0: // Cashflow
      case 2: // Omzet Kumulatif
        return Row(
          children: [
            _buildLegendItem('Omzet/Laba', const Color(0xff3ecf8e), textColor),
            const SizedBox(width: 16),
            _buildLegendItem('BEP Line', const Color(0xfffdd835), textColor),
          ],
        );
      case 1: // Biaya Kumulatif
        return Row(
          children: [
            _buildLegendItem('Biaya/Rugi', const Color(0xffe53935), textColor),
            const SizedBox(width: 16),
            _buildLegendItem('BEP Line', const Color(0xfffdd835), textColor),
          ],
        );
      case 4: // Biaya per Kategori
        return Row(
          children: [
            _buildLegendItem('Pupuk', const Color(0xffe53935), textColor),
            const SizedBox(width: 16),
            _buildLegendItem('Obat', const Color(0xfffdd835), textColor),
            const SizedBox(width: 16),
            _buildLegendItem('Tenaga Kerja', const Color(0xff3ecf8e), textColor),
            const SizedBox(width: 16),
            _buildLegendItem('Lainnya', const Color(0xff1e88e5), textColor),
          ],
        );
      case 6: // Unsur Hara
        return Row(
          children: [
            _buildLegendItem('N', const Color(0xff3ecf8e), textColor),
            const SizedBox(width: 16),
            _buildLegendItem('P', const Color(0xfffdd835), textColor),
            const SizedBox(width: 16),
            _buildLegendItem('K', const Color(0xff1e88e5), textColor),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildLegendItem(String label, Color color, Color textColor) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildWatermark() {
    return IgnorePointer(
      child: Align(
        alignment: Alignment.center,
        child: Opacity(
          opacity: watermarkOpacity,
          child: Image.asset(
            'assets/images/clipsmart logo.png',
            width: watermarkWidth,
            height: watermarkHeight,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _buildChartContent(bool isDarkMode) {
    final gridColor = isDarkMode ? const Color(0xff57611f).withOpacity(0.3) : Colors.grey.withOpacity(0.3);
    final axisTextColor = isDarkMode ? const Color(0xff9e9e9e) : Colors.black87;
    final tooltipBgColor = isDarkMode ? const Color(0xff44425c) : Colors.white;
    final tooltipTextColor = isDarkMode ? Colors.white : Colors.black;
    
    switch (_selectedChartMode) {
      case 0: // Cashflow
        return Stack(
          children: [
            LineChart(
              LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 5,
              getDrawingHorizontalLine: (value) => FlLine(
                color: gridColor,
                strokeWidth: 1,
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toString(),
                      style: TextStyle(
                        color: axisTextColor,
                        fontSize: 10,
                      ),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toString(),
                      style: TextStyle(
                        color: axisTextColor,
                        fontSize: 10,
                      ),
                    );
                  },
                ),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: gridColor),
            ),
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                tooltipRoundedRadius: 8,
                getTooltipColor: (touchedSpot) => tooltipBgColor,
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((spot) {
                    return LineTooltipItem(
                      '${spot.y.toStringAsFixed(2)}',
                      TextStyle(
                        color: tooltipTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }).toList();
                },
              ),
              touchCallback: (FlTouchEvent event, LineTouchResponse? response) {},
              handleBuiltInTouches: true,
            ),
            lineBarsData: [
              LineChartBarData(
                spots: const [
                  FlSpot(0, 5),
                  FlSpot(1, 10),
                  FlSpot(2, 8),
                  FlSpot(3, 15),
                  FlSpot(4, 12),
                  FlSpot(5, 20),
                  FlSpot(6, 18),
                ],
                isCurved: true,
                color: const Color(0xff3ecf8e),
                barWidth: 3,
                dotData: const FlDotData(show: true),
                belowBarData: BarAreaData(
                  show: true,
                  color: const Color(0xff3ecf8e).withOpacity(0.3),
                ),
              ),
              LineChartBarData(
                spots: const [
                  FlSpot(0, 10),
                  FlSpot(1, 10),
                  FlSpot(2, 10),
                  FlSpot(3, 10),
                  FlSpot(4, 10),
                  FlSpot(5, 10),
                  FlSpot(6, 10),
                ],
                isCurved: false,
                color: const Color(0xfffdd835),
                barWidth: 2,
                dotData: const FlDotData(show: false),
                dashArray: [5, 5],
              ),
            ],
          ),
        ),
            _buildWatermark(),
          ],
        );
      case 1: // Biaya Kumulatif
        return Stack(
          children: [
            LineChart(
              LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 5,
              getDrawingHorizontalLine: (value) => FlLine(
                color: gridColor,
                strokeWidth: 1,
              ),
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      '${value.toInt()}M',
                      style: TextStyle(color: axisTextColor, fontSize: 10),
                    );
                  },
                ),
              ),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      'H${value.toInt()}',
                      style: TextStyle(color: axisTextColor, fontSize: 10),
                    );
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                tooltipRoundedRadius: 8,
                getTooltipColor: (touchedSpot) => tooltipBgColor,
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((spot) {
                    return LineTooltipItem(
                      'Rp ${spot.y.toInt()}jt',
                      TextStyle(color: tooltipTextColor, fontSize: 12),
                    );
                  }).toList();
                },
              ),
              handleBuiltInTouches: true,
            ),
            lineBarsData: [
              LineChartBarData(
                spots: const [
                  FlSpot(0, 2),
                  FlSpot(1, 5),
                  FlSpot(2, 8),
                  FlSpot(3, 11),
                  FlSpot(4, 15),
                ],
                isCurved: true,
                color: const Color(0xffe53935),
                barWidth: 3,
                dotData: const FlDotData(show: true),
              ),
              // BEP Line
              LineChartBarData(
                spots: const [
                  FlSpot(0, 10),
                  FlSpot(4, 10),
                ],
                isCurved: false,
                color: const Color(0xfffdd835),
                barWidth: 2,
                dashArray: [5, 5],
                dotData: const FlDotData(show: false),
              ),
            ],
          ),
        ),
            _buildWatermark(),
          ],
        );
      case 2: // Omzet Kumulatif
        return Stack(
          children: [
            LineChart(
              LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 5,
              getDrawingHorizontalLine: (value) => FlLine(
                color: gridColor,
                strokeWidth: 1,
              ),
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      '${value.toInt()}M',
                      style: TextStyle(color: axisTextColor, fontSize: 10),
                    );
                  },
                ),
              ),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      'H${value.toInt()}',
                      style: TextStyle(color: axisTextColor, fontSize: 10),
                    );
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                tooltipRoundedRadius: 8,
                getTooltipColor: (touchedSpot) => tooltipBgColor,
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((spot) {
                    return LineTooltipItem(
                      'Rp ${spot.y.toInt()}jt',
                      TextStyle(color: tooltipTextColor, fontSize: 12),
                    );
                  }).toList();
                },
              ),
              handleBuiltInTouches: true,
            ),
            lineBarsData: [
              LineChartBarData(
                spots: const [
                  FlSpot(0, 5),
                  FlSpot(1, 8),
                  FlSpot(2, 12),
                  FlSpot(3, 15),
                  FlSpot(4, 20),
                ],
                isCurved: true,
                color: const Color(0xff3ecf8e),
                barWidth: 3,
                dotData: const FlDotData(show: true),
              ),
              // BEP Line
              LineChartBarData(
                spots: const [
                  FlSpot(0, 10),
                  FlSpot(4, 10),
                ],
                isCurved: false,
                color: const Color(0xfffdd835),
                barWidth: 2,
                dashArray: [5, 5],
                dotData: const FlDotData(show: false),
              ),
            ],
          ),
        ),
            _buildWatermark(),
          ],
        );
      case 3: // Panen per Periode
        return Stack(
          children: [
            BarChart(
              BarChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 400,
              getDrawingHorizontalLine: (value) => FlLine(
                color: gridColor,
                strokeWidth: 1,
              ),
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      '${value.toInt()}kg',
                      style: TextStyle(color: axisTextColor, fontSize: 10),
                    );
                  },
                ),
              ),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      'P${value.toInt()}',
                      style: TextStyle(color: axisTextColor, fontSize: 10),
                    );
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                tooltipRoundedRadius: 8,
                getTooltipColor: (group) => tooltipBgColor,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  return BarTooltipItem(
                    '${rod.toY.round()}kg',
                    TextStyle(color: tooltipTextColor, fontWeight: FontWeight.bold),
                  );
                },
              ),
              handleBuiltInTouches: true,
            ),
            barGroups: [
              BarChartGroupData(
                x: 0,
                barRods: [
                  BarChartRodData(
                    toY: 500,
                    color: const Color(0xff3ecf8e),
                    width: 16,
                  ),
                ],
              ),
              BarChartGroupData(
                x: 1,
                barRods: [
                  BarChartRodData(
                    toY: 800,
                    color: const Color(0xff3ecf8e),
                    width: 16,
                  ),
                ],
              ),
              BarChartGroupData(
                x: 2,
                barRods: [
                  BarChartRodData(
                    toY: 1200,
                    color: const Color(0xff3ecf8e),
                    width: 16,
                  ),
                ],
              ),
              BarChartGroupData(
                x: 3,
                barRods: [
                  BarChartRodData(
                    toY: 1500,
                    color: const Color(0xff3ecf8e),
                    width: 16,
                  ),
                ],
              ),
              BarChartGroupData(
                x: 4,
                barRods: [
                  BarChartRodData(
                    toY: 1800,
                    color: const Color(0xff3ecf8e),
                    width: 16,
                  ),
                ],
              ),
            ],
          ),
        ),
            _buildWatermark(),
          ],
        );
      case 4: // Biaya per Kategori
        return Stack(
          children: [
            PieChart(
              PieChartData(
            sectionsSpace: 2,
            centerSpaceRadius: 40,
            sections: [
              PieChartSectionData(
                value: 40,
                color: const Color(0xffe53935),
                title: '40%',
                radius: 50,
                titleStyle: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              PieChartSectionData(
                value: 30,
                color: const Color(0xfffdd835),
                title: '30%',
                radius: 50,
                titleStyle: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              PieChartSectionData(
                value: 20,
                color: const Color(0xff3ecf8e),
                title: '20%',
                radius: 50,
                titleStyle: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              PieChartSectionData(
                value: 10,
                color: const Color(0xff1e88e5),
                title: '10%',
                radius: 50,
                titleStyle: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
            _buildWatermark(),
          ],
        );
      case 5: // Populasi
        return Stack(
          children: [
            LineChart(
              LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 20,
              getDrawingHorizontalLine: (value) => FlLine(
                color: gridColor,
                strokeWidth: 1,
              ),
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      '${value.toInt()}',
                      style: TextStyle(color: axisTextColor, fontSize: 10),
                    );
                  },
                ),
              ),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      'H${value.toInt()}',
                      style: TextStyle(color: axisTextColor, fontSize: 10),
                    );
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                tooltipRoundedRadius: 8,
                getTooltipColor: (touchedSpot) => tooltipBgColor,
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((spot) {
                    return LineTooltipItem(
                      '${spot.y.toInt()} pohon',
                      TextStyle(color: tooltipTextColor, fontSize: 12),
                    );
                  }).toList();
                },
              ),
              handleBuiltInTouches: true,
            ),
            lineBarsData: [
              LineChartBarData(
                spots: const [
                  FlSpot(0, 1000),
                  FlSpot(1, 980),
                  FlSpot(2, 970),
                  FlSpot(3, 960),
                  FlSpot(4, 950),
                ],
                isCurved: true,
                color: const Color(0xff1e88e5),
                barWidth: 3,
                dotData: const FlDotData(show: true),
              ),
            ],
          ),
        ),
            _buildWatermark(),
          ],
        );
      case 6: // Unsur Hara
        return Stack(
          children: [
            BarChart(
              BarChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 15,
              getDrawingHorizontalLine: (value) => FlLine(
                color: gridColor,
                strokeWidth: 1,
              ),
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      '${value.toInt()}%',
                      style: TextStyle(color: axisTextColor, fontSize: 10),
                    );
                  },
                ),
              ),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final labels = ['N', 'P', 'K'];
                    if (value.toInt() >= 0 && value.toInt() < labels.length) {
                      return Text(
                        labels[value.toInt()],
                        style: TextStyle(color: axisTextColor, fontSize: 10),
                      );
                    }
                    return const Text('');
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                tooltipRoundedRadius: 8,
                getTooltipColor: (group) => tooltipBgColor,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  return BarTooltipItem(
                    '${rod.toY.toInt()}%',
                    TextStyle(color: tooltipTextColor, fontWeight: FontWeight.bold),
                  );
                },
              ),
              handleBuiltInTouches: true,
            ),
            barGroups: [
              BarChartGroupData(
                x: 0,
                barRods: [
                  BarChartRodData(
                    toY: 46,
                    color: const Color(0xff3ecf8e),
                    width: 30,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
              BarChartGroupData(
                x: 1,
                barRods: [
                  BarChartRodData(
                    toY: 16,
                    color: const Color(0xfffdd835),
                    width: 30,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
              BarChartGroupData(
                x: 2,
                barRods: [
                  BarChartRodData(
                    toY: 16,
                    color: const Color(0xff1e88e5),
                    width: 30,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            ],
          ),
        ),
            _buildWatermark(),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildCombinedCalculator() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff44425c),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xff57611f).withOpacity(0.5)),
      ),
      child: Column(
        children: [
          // Top options selector
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCalculatorWidget = 0;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _selectedCalculatorWidget == 0
                            ? const Color(0xff3ecf8e)
                            : const Color(0xff2e2e2e),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Kalkulator Pupuk',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _selectedCalculatorWidget == 0
                              ? const Color(0xff121212)
                              : const Color(0xffe0e0e0),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCalculatorWidget = 1;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _selectedCalculatorWidget == 1
                            ? const Color(0xff3ecf8e)
                            : const Color(0xff2e2e2e),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Kalkulator Gram/Harga',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _selectedCalculatorWidget == 1
                              ? const Color(0xff121212)
                              : const Color(0xffe0e0e0),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Color(0xff57611f)),
          // Calculator content
          Padding(
            padding: const EdgeInsets.all(16),
            child: _selectedCalculatorWidget == 0
                ? _buildKalkulatorPupukBebas()
                : _buildKalkulatorGramHarga(),
          ),
        ],
      ),
    );
  }

  Widget _buildKalkulatorGramHarga() {
    return Column(
      children: [
        // Tab buttons
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedGramHargaTab = 0;
                    _hasilKalkulasi = '';
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedGramHargaTab == 0
                      ? const Color(0xff3ecf8e)
                      : const Color(0xff2e2e2e),
                  foregroundColor: _selectedGramHargaTab == 0
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
                    _selectedGramHargaTab = 1;
                    _hasilKalkulasi = '';
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedGramHargaTab == 1
                      ? const Color(0xff3ecf8e)
                      : const Color(0xff2e2e2e),
                  foregroundColor: _selectedGramHargaTab == 1
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
        if (_selectedGramHargaTab == 0) ...[
          Tooltip(
            message: 'Masukkan jumlah uang yang ingin dibelanjakan',
            preferBelow: false,
            child: TextField(
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
                suffixIcon: const Icon(Icons.info_outline, color: Color(0xff3ecf8e), size: 18),
              ),
              style: const TextStyle(color: Color(0xffe0e0e0)),
            ),
          ),
          const SizedBox(height: 12),
          Tooltip(
            message: 'Masukkan harga per kilogram produk',
            preferBelow: false,
            child: TextField(
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
                suffixIcon: const Icon(Icons.info_outline, color: Color(0xff3ecf8e), size: 18),
              ),
              style: const TextStyle(color: Color(0xffe0e0e0)),
            ),
          ),
        ] else ...[
          Tooltip(
            message: 'Masukkan jumlah gram yang ingin dikonversi',
            preferBelow: false,
            child: TextField(
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
                suffixIcon: const Icon(Icons.info_outline, color: Color(0xff3ecf8e), size: 18),
              ),
              style: const TextStyle(color: Color(0xffe0e0e0)),
            ),
          ),
          const SizedBox(height: 12),
          Tooltip(
            message: 'Masukkan harga per kilogram produk',
            preferBelow: false,
            child: TextField(
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
                suffixIcon: const Icon(Icons.info_outline, color: Color(0xff3ecf8e), size: 18),
              ),
              style: const TextStyle(color: Color(0xffe0e0e0)),
            ),
          ),
        ],
        
        const SizedBox(height: 16),
        
        // Result (realtime)
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
    );
  }

  Widget _buildKalkulatorPupukBebas() {
    return Column(
      children: [
        // Baris 1: Target Campuran (default 1000 gram) | Sisa Gram (realtime)
        Row(
          children: [
            Expanded(
              child: Tooltip(
                message: 'Masukkan target berat campuran pupuk dalam gram',
                preferBelow: false,
                child: TextField(
                  controller: _targetCampuranController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Target Campuran (gram)',
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
                    suffixIcon: const Icon(Icons.info_outline, color: Color(0xff3ecf8e), size: 18),
                  ),
                  style: const TextStyle(color: Color(0xffe0e0e0)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xff2a2a2a),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xff3a3a3a)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sisa Gram',
                      style: TextStyle(color: Color(0xff9e9e9e), fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_getSisaGram().toStringAsFixed(0)} gram',
                      style: TextStyle(
                        color: _getSisaGram() >= 0 ? const Color(0xff3ecf8e) : const Color(0xffe53935),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        // Garis pemisah
        const Divider(color: Color(0xff57611f)),
        const SizedBox(height: 12),
        
        // Baris 2 (repeatable): Kolom Produk (autocomplete) | Dosis (gram) | Tombol Edit | Tombol Hapus (X)
        ..._pupukRows.asMap().entries.map((entry) {
          final index = entry.key;
          final row = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Tooltip(
                    message: 'Ketik nama produk atau pilih dari daftar',
                    preferBelow: false,
                    child: Autocomplete<String>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text.isEmpty) {
                          return _mockProdukList.map((p) => p['nama'] as String);
                        }
                        return _mockProdukList
                            .where((p) => (p['nama'] as String).toLowerCase()
                                .contains(textEditingValue.text.toLowerCase()))
                            .map((p) => p['nama'] as String);
                      },
                      onSelected: (String selection) {
                        setState(() {
                          row['produk'] = selection;
                          _hasilUnsurHara = '';
                        });
                      },
                      fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                        row['textEditingController'] = textEditingController;
                        return TextField(
                          controller: textEditingController,
                          focusNode: focusNode,
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
                            suffixIcon: GestureDetector(
                              onLongPress: () {
                                if (row['produk'] != null) {
                                  final produk = _mockProdukList.firstWhere((p) => p['nama'] == row['produk']);
                                  String tooltip = 'Unsur Hara:\n';
                                  tooltip += 'N: ${((produk['n_persen'] as int) / 10000).toStringAsFixed(1)}%\n';
                                  tooltip += 'P: ${((produk['p_persen'] as int) / 10000).toStringAsFixed(1)}%\n';
                                  tooltip += 'K: ${((produk['k_persen'] as int) / 10000).toStringAsFixed(1)}%\n';
                                  tooltip += 'Ca: ${((produk['ca_persen'] as int) / 10000).toStringAsFixed(1)}%\n';
                                  tooltip += 'Mg: ${((produk['mg_persen'] as int) / 10000).toStringAsFixed(1)}%\n';
                                  tooltip += 'S: ${((produk['s_persen'] as int) / 10000).toStringAsFixed(1)}%\n';
                                  tooltip += 'Fe: ${((produk['fe_persen'] as int) / 10000).toStringAsFixed(1)}%\n';
                                  tooltip += 'Mn: ${((produk['mn_persen'] as int) / 10000).toStringAsFixed(1)}%\n';
                                  tooltip += 'Zn: ${((produk['zn_persen'] as int) / 10000).toStringAsFixed(1)}%\n';
                                  tooltip += 'Cu: ${((produk['cu_persen'] as int) / 10000).toStringAsFixed(1)}%\n';
                                  tooltip += 'B: ${((produk['b_persen'] as int) / 10000).toStringAsFixed(1)}%\n';
                                  tooltip += 'Mo: ${((produk['mo_persen'] as int) / 10000).toStringAsFixed(1)}%\n';
                                  tooltip += 'Cl: ${((produk['cl_persen'] as int) / 10000).toStringAsFixed(1)}%\n';
                                  tooltip += 'Na: ${((produk['na_persen'] as int) / 10000).toStringAsFixed(1)}%';
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(tooltip),
                                      backgroundColor: const Color(0xff3ecf8e),
                                      duration: const Duration(seconds: 3),
                                    ),
                                  );
                                }
                              },
                              child: const Icon(Icons.info_outline, color: Color(0xff3ecf8e), size: 18),
                            ),
                          ),
                          style: const TextStyle(color: Color(0xffe0e0e0)),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Tooltip(
                    message: 'Masukkan dosis pupuk dalam gram',
                    preferBelow: false,
                    child: TextField(
                      controller: row['gramController'] as TextEditingController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Dosis (gram)',
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
                      onChanged: (_) {
                        setState(() {
                          _hasilUnsurHara = '';
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.edit, color: Color(0xff3ecf8e), size: 20),
                  onPressed: () {
                    // TODO: Edit product dialog (nama + 14 unsur hara)
                  },
                  tooltip: 'Edit produk',
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: const Icon(Icons.close, color: Color(0xffe53935), size: 20),
                  onPressed: () => _removePupukRow(index),
                  tooltip: 'Hapus baris',
                ),
              ],
            ),
          );
        }).toList(),
        
        // Baris 3: Tombol [+ Tambah Kolom] | [Kelola Katalog]
        Row(
          children: [
            Expanded(
              child: Tooltip(
                message: 'Tambah baris produk baru',
                preferBelow: false,
                child: AnimatedBorderContainer(
                  onTap: _addPupukRow,
                  borderRadius: BorderRadius.circular(8),
                  child: ElevatedButton.icon(
                    onPressed: _addPupukRow,
                    icon: const Icon(Icons.add),
                    label: const Text('Tambah Kolom'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff3ecf8e),
                      foregroundColor: const Color(0xff121212),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Tooltip(
                message: 'Kelola katalog produk pupuk',
                preferBelow: false,
                child: AnimatedBorderContainer(
                  onTap: () {
                    setState(() {
                      _showKatalogPupuk = !_showKatalogPupuk;
                    });
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _showKatalogPupuk = !_showKatalogPupuk;
                      });
                    },
                    icon: const Icon(Icons.list),
                    label: const Text('Kelola Katalog'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff2e2e2e),
                      foregroundColor: const Color(0xffe0e0e0),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        
        // Katalog Pupuk Dialog
        if (_showKatalogPupuk) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xff2a2a2a),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xff3ecf8e)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Katalog Pupuk',
                  style: TextStyle(
                    color: Color(0xffe0e0e0),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ..._mockProdukList.map((produk) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    '${produk['nama']} - Rp ${produk['hargaPerKg']}/kg',
                    style: const TextStyle(color: Color(0xff9e9e9e)),
                  ),
                )),
                const SizedBox(height: 8),
                Text(
                  '(Simpan otomatis ke SharedPreferences/SQLite)',
                  style: TextStyle(
                    color: const Color(0xff9e9e9e).withOpacity(0.7),
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
        
        const SizedBox(height: 12),
        
        // Baris 4: Tombol Reset (25% lebar, kecil) | Tombol Hitung Unsur (75% lebar)
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Tooltip(
                message: 'Reset nilai gram saja, nama produk tetap',
                preferBelow: false,
                child: AnimatedBorderContainer(
                  onTap: _resetPupukGramasi,
                  borderRadius: BorderRadius.circular(8),
                  child: OutlinedButton(
                    onPressed: _resetPupukGramasi,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xff9e9e9e),
                      side: const BorderSide(color: Color(0xff57611f)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Reset'),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 3,
              child: Tooltip(
                message: 'Hitung total unsur hara dari campuran',
                preferBelow: false,
                child: AnimatedBorderContainer(
                  onTap: _hitungUnsurHara,
                  borderRadius: BorderRadius.circular(8),
                  child: ElevatedButton(
                    onPressed: _hitungUnsurHara,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff3ecf8e),
                      foregroundColor: const Color(0xff121212),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Hitung Unsur'),
                  ),
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        // Hasil hitung
        if (_hasilUnsurHara.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xff1a2a1f),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xff3ecf8e)),
            ),
            child: Text(
              _hasilUnsurHara,
              style: const TextStyle(
                color: Color(0xff3ecf8e),
                fontSize: 14,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildNotificationPanel() {
    return Positioned(
      top: 60,
      right: 16,
      child: Container(
        width: 300,
        constraints: const BoxConstraints(maxHeight: 400),
        decoration: BoxDecoration(
          color: const Color(0xff44425c),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xff57611f)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with slide navigation
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xff3ecf8e),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Color(0xff121212)),
                    onPressed: () {
                      setState(() {
                        _currentNotificationSlide = (_currentNotificationSlide - 1 + _notificationSlides.length) % _notificationSlides.length;
                      });
                    },
                  ),
                  Text(
                    _getNotificationSlideTitle(_currentNotificationSlide),
                    style: const TextStyle(
                      color: Color(0xff121212),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward, color: Color(0xff121212)),
                    onPressed: () {
                      setState(() {
                        _currentNotificationSlide = (_currentNotificationSlide + 1) % _notificationSlides.length;
                      });
                    },
                  ),
                ],
              ),
            ),
            // Slide content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ..._notificationSlides[_currentNotificationSlide].map((item) => _buildNotificationItem(item)),
                  ],
                ),
              ),
            ),
            // Close button
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextButton.icon(
                onPressed: () {
                  setState(() {
                    _showNotificationPanel = false;
                  });
                },
                icon: const Icon(Icons.close, color: Color(0xffe0e0e0)),
                label: const Text('Tutup', style: TextStyle(color: Color(0xffe0e0e0))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getNotificationSlideTitle(int index) {
    switch (index) {
      case 0: return 'Jadwal Mendatang';
      case 1: return 'Keterlambatan';
      case 2: return 'Selesai Baru';
      case 3: return 'Stok Menipis';
      case 4: return 'Pesan Admin';
      default: return '';
    }
  }

  Widget _buildNotificationItem(Map<String, dynamic> item) {
    // Determine color based on notification type
    Color getStatusColor() {
      if (item.containsKey('late')) return const Color(0xffe53935); // Merah - terlambat
      if (item.containsKey('date') && item['date'] == 'H') return const Color(0xfffdd835); // Kuning - hari ini
      if (item.containsKey('pesan')) return const Color(0xff1e88e5); // Biru - pesan admin
      return const Color(0xff3ecf8e); // Hijau - aman
    }
    
    String getStatusEmoji() {
      if (item.containsKey('late')) return '🔴';
      if (item.containsKey('date') && item['date'] == 'H') return '🟡';
      if (item.containsKey('pesan')) return '🔵';
      return '🟢';
    }
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xff2a2a2a),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: getStatusColor().withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                getStatusEmoji(),
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(width: 8),
              if (item.containsKey('title'))
                Expanded(
                  child: Text(
                    item['title'],
                    style: const TextStyle(
                      color: Color(0xffe0e0e0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          if (item.containsKey('date'))
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                item['date'],
                style: const TextStyle(color: Color(0xff9e9e9e), fontSize: 12),
              ),
            ),
          if (item.containsKey('time'))
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                item['time'],
                style: const TextStyle(color: Color(0xff3ecf8e), fontSize: 12),
              ),
            ),
          if (item.containsKey('lahan'))
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                'Lahan: ${item['lahan']}',
                style: const TextStyle(color: Color(0xff9e9e9e), fontSize: 12),
              ),
            ),
          if (item.containsKey('late'))
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                'Terlambat: ${item['late']}',
                style: const TextStyle(color: Color(0xffe53935), fontSize: 12),
              ),
            ),
          if (item.containsKey('completed'))
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                item['completed'],
                style: const TextStyle(color: Color(0xff3ecf8e), fontSize: 12),
              ),
            ),
          if (item.containsKey('produk'))
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                item['produk'],
                style: const TextStyle(
                  color: Color(0xffe0e0e0),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          if (item.containsKey('stok'))
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                'Stok: ${item['stok']}',
                style: const TextStyle(color: Color(0xffe53935), fontSize: 12),
              ),
            ),
          if (item.containsKey('min'))
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                'Min: ${item['min']}',
                style: const TextStyle(color: Color(0xff9e9e9e), fontSize: 12),
              ),
            ),
          if (item.containsKey('pesan'))
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                item['pesan'],
                style: const TextStyle(color: Color(0xff1e88e5)),
              ),
            ),
          if (item.containsKey('date') && item.containsKey('pesan'))
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                item['date'],
                style: const TextStyle(color: Color(0xff9e9e9e), fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}
