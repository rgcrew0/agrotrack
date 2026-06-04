import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'features/beranda/beranda_screen.dart';
import 'features/catatan_lapangan/catatan_lapangan_screen.dart';
import 'features/daftar_lahan/daftar_lahan_screen.dart';
import 'features/laporan/laporan_screen.dart';
import 'features/lisensi/lisensi_screen.dart';
import 'features/panen/panen_screen.dart';
import 'features/pemupukan/pemupukan_screen.dart';
import 'features/pengaturan/pengaturan_screen.dart';
import 'features/perawatan/perawatan_screen.dart';
import 'features/semprot/semprot_screen.dart';
import 'features/stok_produk/stok_produk_screen.dart';
import 'shared/widgets/sidebar.dart';

// GoRouter configuration
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/lisensi',
    routes: [
      GoRoute(
        path: '/lisensi',
        name: 'lisensi',
        builder: (context, state) => const LisensiScreen(),
      ),
      GoRoute(
        path: '/beranda',
        name: 'beranda',
        builder: (context, state) => const BerandaScreen(),
      ),
      GoRoute(
        path: '/daftar-lahan',
        name: 'daftar-lahan',
        builder: (context, state) => const DaftarLahanScreen(),
      ),
      GoRoute(
        path: '/stok-produk',
        name: 'stok-produk',
        builder: (context, state) => const StokProdukScreen(),
      ),
      GoRoute(
        path: '/semprot',
        name: 'semprot',
        builder: (context, state) => const SemprotScreen(),
      ),
      GoRoute(
        path: '/pemupukan',
        name: 'pemupukan',
        builder: (context, state) => const PemupukanScreen(),
      ),
      GoRoute(
        path: '/panen',
        name: 'panen',
        builder: (context, state) => const PanenScreen(),
      ),
      GoRoute(
        path: '/perawatan',
        name: 'perawatan',
        builder: (context, state) => const PerawatanScreen(),
      ),
      GoRoute(
        path: '/catatan-lapangan',
        name: 'catatan-lapangan',
        builder: (context, state) => const CatatanLapanganScreen(),
      ),
      GoRoute(
        path: '/laporan',
        name: 'laporan',
        builder: (context, state) => const LaporanScreen(),
      ),
      GoRoute(
        path: '/pengaturan',
        name: 'pengaturan',
        builder: (context, state) => const PengaturanScreen(),
      ),
    ],
  );
});

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'AgroTrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3ecf8e),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF2b322d),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2b322d),
          elevation: 0,
          foregroundColor: Color(0xFFe0e0e0),
        ),
        drawerTheme: const DrawerThemeData(
          backgroundColor: Color(0xFF2b322d),
        ),
        cardColor: const Color(0xFF44425c),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF2a2a2a),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF3a3a3a)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF3ecf8e)),
          ),
          labelStyle: const TextStyle(color: Color(0xFF9e9e9e)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3ecf8e),
            foregroundColor: const Color(0xFF121212),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ),
      ),
      routerConfig: router,
    );
  }
}
