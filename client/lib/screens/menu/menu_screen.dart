import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/menu_provider.dart';
import '../../widgets/category_expansion_tile.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<MenuProvider>().loadProductos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final menu = context.watch<MenuProvider>();

    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 12),
          const Text(
            'SOLO PASTAS',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.darkRed,
            ),
          ),
          const Text(
            'Menú y Precios',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.darkText,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              onChanged: menu.setSearch,
              decoration: InputDecoration(
                hintText: 'Buscar plato o bebida...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _buildBody(menu),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(MenuProvider menu) {
    if (menu.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (menu.error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(menu.error!, style: TextStyle(color: AppColors.red)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: menu.loadProductos,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    final categorias = menu.categorias;
    if (categorias.isEmpty) {
      return const Center(child: Text('No se encontraron productos'));
    }

    return RefreshIndicator(
      onRefresh: menu.loadProductos,
      child: ListView.builder(
        itemCount: categorias.length,
        padding: const EdgeInsets.only(bottom: 80),
        itemBuilder: (context, index) {
          final cat = categorias[index];
          return CategoryExpansionTile(
            categoria: cat,
            onToggleEstado: (productId, _) {
              final producto = cat.productos
                  .firstWhere((p) => p.idProducto == productId);
              menu.toggleEstado(producto);
            },
            onUpdatePrecio: (productId, newPrecio) {
              final producto = cat.productos
                  .firstWhere((p) => p.idProducto == productId);
              try {
                final precio = Decimal.parse(newPrecio);
                menu.updatePrecio(producto, precio);
              } catch (_) {
                // invalid input
              }
            },
          );
        },
      ),
    );
  }
}
