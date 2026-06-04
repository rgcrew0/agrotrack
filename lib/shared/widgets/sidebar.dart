import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 280,
      backgroundColor: const Color(0xFF2b322d),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF3ecf8e),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'AgroTrack',
                  style: TextStyle(
                    color: Color(0xFF121212),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sistem Cerdas Siklus Tani',
                  style: TextStyle(
                    color: const Color(0xFF121212).withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          _buildMenuItem(
            context,
            icon: Icons.home,
            title: 'Beranda',
            route: '/beranda',
          ),
          _buildMenuItem(
            context,
            icon: Icons.agriculture,
            title: 'Daftar Lahan',
            route: '/daftar-lahan',
          ),
          _buildMenuItem(
            context,
            icon: Icons.inventory_2,
            title: 'Stok Produk',
            route: '/stok-produk',
          ),
          _buildMenuItem(
            context,
            icon: Icons.water_drop,
            title: 'Semprot',
            route: '/semprot',
          ),
          _buildMenuItem(
            context,
            icon: Icons.eco,
            title: 'Pemupukan',
            route: '/pemupukan',
          ),
          _buildMenuItem(
            context,
            icon: Icons.grass,
            title: 'Panen',
            route: '/panen',
          ),
          _buildMenuItem(
            context,
            icon: Icons.build,
            title: 'Perawatan',
            route: '/perawatan',
          ),
          _buildMenuItem(
            context,
            icon: Icons.note,
            title: 'Catatan Lapangan',
            route: '/catatan-lapangan',
          ),
          _buildMenuItem(
            context,
            icon: Icons.assessment,
            title: 'Laporan',
            route: '/laporan',
          ),
          _buildMenuItem(
            context,
            icon: Icons.history,
            title: 'History',
            route: '/history',
          ),
          _buildMenuItem(
            context,
            icon: Icons.settings,
            title: 'Pengaturan',
            route: '/pengaturan',
          ),
          const Divider(color: Color(0xFF57611f)),
          _buildMenuItem(
            context,
            icon: Icons.delete_outline,
            title: 'Keranjang Sampah',
            route: '/keranjang-sampah',
          ),
          _buildMenuItem(
            context,
            icon: Icons.description,
            title: 'Modal Pra-Tanam',
            route: '/modal-pra-tanam',
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String route,
  }) {
    final currentRoute = GoRouterState.of(context).matchedLocation;
    final isSelected = currentRoute == route;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? const Color(0xFF3ecf8e) : const Color(0xFFe0e0e0),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? const Color(0xFF3ecf8e) : const Color(0xFFe0e0e0),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: const Color(0xFF44425c),
      onTap: () {
        context.push(route);
        Navigator.pop(context);
      },
    );
  }
}
