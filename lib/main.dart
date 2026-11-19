
import 'package:flutter/material.dart';

void main() => runApp(const QMarketApp());

const categories = <String>[
  'Todos',
  'Peixe e mariscos',
  'Agricultura',
  'Alimentos',
  'Roupa e calçado',
  'Telemóveis e eletrónicos',
  'Casa e mobiliário',
  'Construção e ferramentas',
  'Beleza e higiene',
  'Outros',
];

class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final String unit;
  final String location;
  final String description;
  final String sellerPhone;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.unit,
    required this.location,
    required this.description,
    required this.sellerPhone,
  });
}

class MarketOrder {
  final String productName;
  final int quantity;
  final String buyerName;
  final String buyerPhone;
  final String location;

  const MarketOrder({
    required this.productName,
    required this.quantity,
    required this.buyerName,
    required this.buyerPhone,
    required this.location,
  });
}

class QMarketApp extends StatelessWidget {
  const QMarketApp({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF146B50),
      brightness: Brightness.light,
    );
    return MaterialApp(
      title: 'QMarket',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: scheme,
        scaffoldBackgroundColor: const Color(0xFFF6F8F6),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF6F8F6),
          foregroundColor: Color(0xFF173B2F),
          centerTitle: false,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE1E9E3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF146B50), width: 1.5),
          ),
        ),
      ),
      home: const MarketHomePage(),
    );
  }
}

class MarketHomePage extends StatefulWidget {
  const MarketHomePage({super.key});

  @override
  State<MarketHomePage> createState() => _MarketHomePageState();
}

class _MarketHomePageState extends State<MarketHomePage> {
  int _tab = 0;
  String _category = 'Todos';
  String _search = '';

  final List<Product> _products = [
    const Product(
      id: 'p1', name: 'Peixe fresco', category: 'Peixe e mariscos',
      price: 250, unit: 'kg', location: 'Quitunda',
      description: 'Peixe fresco disponível para venda. Confirme a quantidade com o vendedor.',
      sellerPhone: '',
    ),
    const Product(
      id: 'p2', name: 'Tomate', category: 'Agricultura',
      price: 100, unit: 'kg', location: 'Quitunda',
      description: 'Tomate fresco para venda.', sellerPhone: '',
    ),
    const Product(
      id: 'p3', name: 'Camisa', category: 'Roupa e calçado',
      price: 350, unit: 'unidade', location: 'Palma',
      description: 'Camisa em bom estado.', sellerPhone: '',
    ),
    const Product(
      id: 'p4', name: 'Carregador USB', category: 'Telemóveis e eletrónicos',
      price: 200, unit: 'unidade', location: 'Quitunda',
      description: 'Carregador para telemóvel. Consulte a compatibilidade.',
      sellerPhone: '',
    ),
    const Product(
      id: 'p5', name: 'Cadeira', category: 'Casa e mobiliário',
      price: 900, unit: 'unidade', location: 'Palma',
      description: 'Cadeira para casa ou escritório.', sellerPhone: '',
    ),
  ];
  final List<MarketOrder> _orders = [];

  List<Product> get _visibleProducts {
    final query = _search.trim().toLowerCase();
    return _products.where((product) {
      final matchesCategory = _category == 'Todos' || product.category == _category;
      final searchable = '${product.name} ${product.category} ${product.location} ${product.description}'.toLowerCase();
      return matchesCategory && (query.isEmpty || searchable.contains(query));
    }).toList();
  }

  void _addProduct(Product product) {
    setState(() {
      _products.insert(0, product);
      _tab = 0;
      _category = 'Todos';
      _search = '';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Produto adicionado à lista deste dispositivo.')),
    );
  }

  void _placeOrder(Product product, int quantity, String buyerName, String buyerPhone) {
    setState(() {
      _orders.insert(0, MarketOrder(
        productName: product.name,
        quantity: quantity,
        buyerName: buyerName,
        buyerPhone: buyerPhone,
        location: product.location,
      ));
    });
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pedido registado neste dispositivo. Combine os detalhes com o vendedor.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _home(),
      SellPage(onPublish: _addProduct),
      AccountPage(products: _products, orders: _orders),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 38, height: 38,
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, borderRadius: BorderRadius.circular(12)),
              child: const Center(child: Text('Q', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w900))),
            ),
            const SizedBox(width: 10),
            const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('QMarket', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
              Text('O teu mercado, num só lugar', style: TextStyle(fontSize: 11, fontWeight: FontWeight.normal)),
            ]),
          ],
        ),
      ),
      body: pages[_tab],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (index) => setState(() => _tab = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.storefront_outlined), selectedIcon: Icon(Icons.storefront), label: 'Início'),
          NavigationDestination(icon: Icon(Icons.add_business_outlined), selectedIcon: Icon(Icons.add_business), label: 'Vender'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Conta'),
        ],
      ),
    );
  }

  Widget _home() {
    final products = _visibleProducts;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF145B45), Color(0xFF27845F)]),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Bem-vindo ao QMarket!', style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.bold)),
            SizedBox(height: 6),
            Text('Encontre produtos e descubra vendedores perto de si.', style: TextStyle(color: Colors.white, height: 1.35)),
          ]),
        ),
        const SizedBox(height: 16),
        TextField(
          onChanged: (value) => setState(() => _search = value),
          decoration: const InputDecoration(hintText: 'Pesquisar produtos ou locais...', prefixIcon: Icon(Icons.search)),
        ),
        const SizedBox(height: 20),
        const Text('Categorias', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Wrap(spacing: 8, runSpacing: 8, children: categories.map((category) => ChoiceChip(
          label: Text(category), selected: _category == category,
          onSelected: (_) => setState(() => _category = category),
        )).toList()),
        const SizedBox(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Produtos disponíveis', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text('${products.length} produto(s)', style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
        ]),
        const SizedBox(height: 10),
        if (products.isEmpty)
          const Padding(padding: EdgeInsets.all(24), child: Center(child: Text('Não foram encontrados produtos.')))
        else
          ...products.map((product) => ProductCard(product: product, onTap: () => Navigator.push(context, MaterialPageRoute(
            builder: (_) => ProductDetailsPage(product: product, onOrder: (quantity, name, phone) => _placeOrder(product, quantity, name, phone)),
          )))),
        const SizedBox(height: 8),
        const Text('QMarket • Começamos em Quitunda, com visão para todo Moçambique.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 11)),
      ],
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  const ProductCard({super.key, required this.product, required this.onTap});

  IconData get _icon {
    switch (product.category) {
      case 'Peixe e mariscos': return Icons.set_meal;
      case 'Agricultura': return Icons.agriculture;
      case 'Alimentos': return Icons.shopping_basket;
      case 'Roupa e calçado': return Icons.checkroom;
      case 'Telemóveis e eletrónicos': return Icons.phone_android;
      case 'Casa e mobiliário': return Icons.chair_alt;
      case 'Construção e ferramentas': return Icons.handyman;
      case 'Beleza e higiene': return Icons.spa;
      default: return Icons.storefront;
    }
  }

  @override
  Widget build(BuildContext context) => Card(
    color: Colors.white, margin: const EdgeInsets.only(bottom: 10), clipBehavior: Clip.antiAlias,
    child: ListTile(
      onTap: onTap, contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      leading: Container(width: 54, height: 54, decoration: BoxDecoration(color: const Color(0xFFE8F3EC), borderRadius: BorderRadius.circular(14)), child: Icon(_icon, color: const Color(0xFF146B50), size: 29)),
      title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text('${product.category}\n${product.price.toStringAsFixed(0)} MT/${product.unit}  •  ${product.location}', maxLines: 2),
      isThreeLine: true,
      trailing: const Icon(Icons.chevron_right),
    ),
  );
}

class ProductDetailsPage extends StatelessWidget {
  final Product product;
  final void Function(int, String, String) onOrder;
  const ProductDetailsPage({super.key, required this.product, required this.onOrder});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Detalhes do produto')),
    body: ListView(padding: const EdgeInsets.all(20), children: [
      Container(height: 190, decoration: BoxDecoration(color: const Color(0xFFE8F3EC), borderRadius: BorderRadius.circular(20)), child: const Icon(Icons.shopping_bag_outlined, size: 85, color: Color(0xFF146B50))),
      const SizedBox(height: 18),
      Text(product.name, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
      const SizedBox(height: 6),
      Text(product.category, style: TextStyle(color: Colors.grey.shade700)),
      const SizedBox(height: 8),
      Text('${product.price.toStringAsFixed(0)} MT/${product.unit}', style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: Color(0xFF146B50))),
      const SizedBox(height: 8),
      Text('Localização: ${product.location}'),
      const SizedBox(height: 20),
      const Text('Descrição', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
      const SizedBox(height: 6),
      Text(product.description.isEmpty ? 'Sem descrição.' : product.description),
      const SizedBox(height: 24),
      FilledButton.icon(onPressed: () => _showOrderDialog(context), icon: const Icon(Icons.shopping_cart_outlined), label: const Text('Fazer pedido')),
      const SizedBox(height: 8),
      if (product.sellerPhone.isNotEmpty) OutlinedButton.icon(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Contacto do vendedor: ${product.sellerPhone}'))), icon: const Icon(Icons.phone), label: const Text('Ver contacto do vendedor')),
    ]),
  );

  void _showOrderDialog(BuildContext context) {
    final quantity = TextEditingController(text: '1');
    final name = TextEditingController();
    final phone = TextEditingController();
    showDialog(context: context, builder: (dialogContext) => AlertDialog(
      title: const Text('Fazer pedido'),
      content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: quantity, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Quantidade')),
        const SizedBox(height: 10),
        TextField(controller: name, decoration: const InputDecoration(labelText: 'O teu nome')),
        const SizedBox(height: 10),
        TextField(controller: phone, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'O teu telefone')),
      ])),
      actions: [
        TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancelar')),
        FilledButton(onPressed: () {
          final amount = int.tryParse(quantity.text.trim());
          if (amount == null || amount < 1 || name.text.trim().isEmpty || phone.text.trim().isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Indique uma quantidade, o nome e o telefone.')));
            return;
          }
          onOrder(amount, name.text.trim(), phone.text.trim());
        }, child: const Text('Enviar pedido')),
      ],
    ));
  }
}

class SellPage extends StatefulWidget {
  final ValueChanged<Product> onPublish;
  const SellPage({super.key, required this.onPublish});
  @override
  State<SellPage> createState() => _SellPageState();
}

class _SellPageState extends State<SellPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _price = TextEditingController();
  final _location = TextEditingController(text: 'Quitunda');
  final _description = TextEditingController();
  final _phone = TextEditingController();
  String _category = 'Peixe e mariscos';

  @override
  void dispose() { _name.dispose(); _price.dispose(); _location.dispose(); _description.dispose(); _phone.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Form(
    key: _formKey,
    child: ListView(padding: const EdgeInsets.all(20), children: [
      const Text('Vender no QMarket', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
      const SizedBox(height: 6),
      const Text('Publique um produto para os compradores encontrarem.'),
      const SizedBox(height: 20),
      TextFormField(controller: _name, decoration: const InputDecoration(labelText: 'Nome do produto'), validator: (v) => v == null || v.trim().isEmpty ? 'Indique o nome do produto.' : null),
      const SizedBox(height: 12),
      DropdownButtonFormField<String>(value: _category, isExpanded: true, decoration: const InputDecoration(labelText: 'Categoria'), items: categories.where((c) => c != 'Todos').map((c) => DropdownMenuItem(value: c, child: Text(c, overflow: TextOverflow.ellipsis))).toList(), onChanged: (v) => setState(() => _category = v ?? _category)),
      const SizedBox(height: 12),
      TextFormField(controller: _price, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'Preço em meticais (MT)'), validator: (v) { final n = double.tryParse((v ?? '').replaceAll(',', '.')); return n == null || n <= 0 ? 'Indique um preço válido.' : null; }),
      const SizedBox(height: 12),
      TextFormField(controller: _location, decoration: const InputDecoration(labelText: 'Localização'), validator: (v) => v == null || v.trim().isEmpty ? 'Indique a localização.' : null),
      const SizedBox(height: 12),
      TextFormField(controller: _phone, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Telefone do vendedor (opcional)')),
      const SizedBox(height: 12),
      TextFormField(controller: _description, maxLines: 3, decoration: const InputDecoration(labelText: 'Descrição do produto')),
      const SizedBox(height: 20),
      FilledButton.icon(onPressed: _publish, icon: const Icon(Icons.publish), label: const Text('Publicar produto')),
      const SizedBox(height: 10),
      const Text('Nota: nesta versão de teste, os produtos ficam guardados apenas enquanto a aplicação estiver aberta neste dispositivo.', style: TextStyle(fontSize: 12, color: Colors.grey)),
    ]),
  );

  void _publish() {
    if (!_formKey.currentState!.validate()) return;
    final price = double.parse(_price.text.trim().replaceAll(',', '.'));
    widget.onPublish(Product(
      id: DateTime.now().microsecondsSinceEpoch.toString(), name: _name.text.trim(), category: _category,
      price: price, unit: 'unidade', location: _location.text.trim(), description: _description.text.trim(), sellerPhone: _phone.text.trim(),
    ));
    _formKey.currentState!.reset();
    _name.clear(); _price.clear(); _location.text = 'Quitunda'; _description.clear(); _phone.clear();
    setState(() => _category = 'Peixe e mariscos');
  }
}

class AccountPage extends StatelessWidget {
  final List<Product> products;
  final List<MarketOrder> orders;
  const AccountPage({super.key, required this.products, required this.orders});

  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(20), children: [
    const CircleAvatar(radius: 42, child: Icon(Icons.person, size: 45)),
    const SizedBox(height: 12),
    const Center(child: Text('Área da conta', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold))),
    const SizedBox(height: 18),
    Row(children: [
      Expanded(child: _StatCard(label: 'Produtos', value: '${products.length}', icon: Icons.inventory_2_outlined)),
      const SizedBox(width: 10),
      Expanded(child: _StatCard(label: 'Pedidos', value: '${orders.length}', icon: Icons.shopping_cart_outlined)),
    ]),
    const SizedBox(height: 20),
    const Text('Produtos publicados neste dispositivo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
    const SizedBox(height: 8),
    ...products.map((p) => ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.sell_outlined), title: Text(p.name), subtitle: Text('${p.price.toStringAsFixed(0)} MT • ${p.location}'))),
    const Divider(height: 28),
    const Text('Pedidos recebidos nesta sessão', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
    const SizedBox(height: 8),
    if (orders.isEmpty) const Text('Ainda não há pedidos.'),
    ...orders.map((o) => ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.receipt_long_outlined), title: Text(o.productName), subtitle: Text('${o.quantity} unidade(s) • ${o.buyerName} • ${o.buyerPhone}'))),
  ]);
}

class _StatCard extends StatelessWidget {
  final String label; final String value; final IconData icon;
  const _StatCard({required this.label, required this.value, required this.icon});
  @override
  Widget build(BuildContext context) => Card(color: Colors.white, child: Padding(padding: const EdgeInsets.all(14), child: Column(children: [Icon(icon, color: Theme.of(context).colorScheme.primary), const SizedBox(height: 5), Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)), Text(label, style: const TextStyle(color: Colors.grey))])));
}
