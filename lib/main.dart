import 'package:flutter/material.dart';
import 'dart:async';

Map<String, String> fakeDatabase = {"lakoukajou@gmail.com": "poutimoun"};
List<String> panierList = [];
List<String> favorisList = [];

Map<String, List<String>> kategotyData = {
  "Kategori Elektwonik": ["Dell XPS", "iPhone 15 Pro", "Samsung S23", "Aplle Watch"],
  "Kategori Rad": ["Chemiz Polo", "Birkin", "Linèt ZARA", "Jeans LEVIS"],
};

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EBoutikoo',
      theme: ThemeData(
        primaryColor: const Color(0xFF0D2A5B),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF5E81F4)),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Icon(Icons.shopping_bag_rounded, size: 100, color: Color(0xFF5E81F4))),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void doLogin() {
    String email = emailController.text;
    String password = passwordController.text;

    if (!isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Verifye enfòmasyon ou yo")));
      return;
    }
    if (password.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Modpas la dwe gen 8 karaktè pou pi piti")));
      return;
    }

    if (fakeDatabase[email] == password) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainNavigationScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Imel oswa modpas la pa bon!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Koneksyon")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: const InputDecoration(labelText: "Imel", border: OutlineInputBorder())),
            const SizedBox(height: 15),
            TextField(controller: passwordController, obscureText: true, decoration: const InputDecoration(labelText: "Modpas", border: OutlineInputBorder())),
            const SizedBox(height: 20),
            SizedBox(width: double.infinity, child: ElevatedButton(onPressed: doLogin, child: const Text("KONEKTE"))),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SignUpPage())),
              child: const Text("Ou pa gen kont? Enskri"),
            ),
          ],
        ),
      ),
    );
  }
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Enskripsyon")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: "Imel", border: OutlineInputBorder()),
                  validator: (value) => (value == null || !isValidEmail(value)) ? "Format imel la pa bon" : null,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: "Modpas dwe gen 8 karaktè pou pi piti)", border: OutlineInputBorder()),
                  validator: (value) => (value == null || value.length < 8) ? "8 karaktè pou pi piti" : null,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: "Konfime Modpas", border: OutlineInputBorder()),
                  validator: (value) => (value != passwordController.text) ? "Modpas yo pa koresponn" : null,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        fakeDatabase[emailController.text] = passwordController.text;
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Kont kreye! Kounye a konekte.")));
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Enskri"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- 4. MAIN NAVIGATION (LOCK BOTTOM NAV) ---
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});
  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomeScreen(),
      ListDisplayPage(title: "Favori mwen yo", data: favorisList, onRemove: () => setState(() {})),
      ListDisplayPage(title: "Panye mwen", data: panierList, onRemove: () => setState(() {})),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Akèy'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favori'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Panye'),
        ],
      ),
    );
  }
}

// --- 5. HOME SCREEN ---
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("EBoutikoo")),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildCat(context, "Kategori Elektwonik"),
            _buildCat(context, "Kategori Rad ak Akseswa"),
            const Padding(padding: EdgeInsets.all(15), child: Align(alignment: Alignment.centerLeft, child: Text("Top Pwodui", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)))),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.8, mainAxisSpacing: 10, crossAxisSpacing: 10),
              itemBuilder: (context, index) => _rectCard(context, "Pwodui Top $index"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCat(BuildContext context, String name) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CategoryView(catName: name))),
      child: Container(
        height: 100, width: double.infinity, margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: const Color(0xFF0D2A5B), borderRadius: BorderRadius.circular(10)),
        alignment: Alignment.center,
        child: Text(name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _rectCard(BuildContext context, String name) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(productName: name))),
      child: Card(
        child: Column(
          children: [
            Expanded(child: Container(color: const Color(0xFF0D2A5B), width: double.infinity)),
            Padding(padding: const EdgeInsets.all(8.0), child: Text(name, style: const TextStyle(fontWeight: FontWeight.bold))),
          ],
        ),
      ),
    );
  }
}

class CategoryView extends StatelessWidget {
  final String catName;
  const CategoryView({super.key, required this.catName});

  @override
  Widget build(BuildContext context) {
    List<String> prods = kategotyData[catName] ?? [];
    return Scaffold(
      appBar: AppBar(title: Text(catName)),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: prods.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.8, mainAxisSpacing: 10, crossAxisSpacing: 10),
        itemBuilder: (context, index) => GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(productName: prods[index]))),
          child: Card(
            child: Column(
              children: [
                Expanded(child: Container(color: const Color(0xFF0D2A5B), width: double.infinity)),
                Padding(padding: const EdgeInsets.all(8.0), child: Text(prods[index], style: const TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final String productName;
  const DetailScreen({super.key, required this.productName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detay")),
      body: Column(
        children: [
          Container(height: 250, color: const Color(0xFF0D2A5B), width: double.infinity),
          const SizedBox(height: 20),
          Text(productName, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          const Padding(padding: EdgeInsets.all(20), child: Text("Deskripsyon pwodwi EBoutikoo.", textAlign: TextAlign.center)),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: FloatingActionButton.extended(
              backgroundColor: Colors.orange,
              onPressed: () {
                panierList.add(productName);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$productName ajoute nan panye a!")));
              },
              label: const Text("Ajoute nan Panye"),
              icon: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});
  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final List<String> allProducts = [
    "Dell XPS", "iPhone 15 Pro", "Samsung S23", "Aplle Watch",
    "Chemiz Polo", "Birkin", "Linèt ZARA", "Jeans LEVIS"
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tout Pwodui")),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.75, mainAxisSpacing: 10, crossAxisSpacing: 10),
        itemCount: allProducts.length,
        itemBuilder: (context, index) {
          String name = allProducts[index];
          return Card(
            child: Column(
              children: [
                Expanded(child: Container(color: const Color(0xFF0D2A5B), width: double.infinity)),
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(icon: const Icon(Icons.shopping_cart, color: Colors.blue), onPressed: () {
                      setState(() => panierList.add(name));
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Ajoute nan panye!")));
                    }),
                    IconButton(
                      icon: Icon(favorisList.contains(name) ? Icons.favorite : Icons.favorite_border, color: Colors.red),
                      onPressed: () => setState(() => favorisList.contains(name) ? favorisList.remove(name) : favorisList.add(name)),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class ListDisplayPage extends StatefulWidget {
  final String title;
  final List<String> data;
  final VoidCallback onRemove;
  const ListDisplayPage({super.key, required this.title, required this.data, required this.onRemove});

  @override
  State<ListDisplayPage> createState() => _ListDisplayPageState();
}

class _ListDisplayPageState extends State<ListDisplayPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: widget.data.isEmpty
          ? const Center(child: Text("Pa gen anyen la!"))
          : ListView.builder(
        itemCount: widget.data.length,
        itemBuilder: (context, index) => ListTile(
          leading: const Icon(Icons.check_box, color: Color(0xFF0D2A5B)),
          title: Text(widget.data[index]),
          trailing: IconButton(
            icon: const Icon(Icons.delete_sweep, color: Colors.red),
            onPressed: () {
              setState(() {
                widget.data.removeAt(index);
              });
              widget.onRemove();
            },
          ),
        ),
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF5E81F4)),
              accountName: Text("EBoutikoo"),
              accountEmail: Text("Byenvini Kliyan!")
          ),
          ListTile(
              leading: const Icon(Icons.list),
              title: const Text("Lis Pwodui"),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProductListScreen()))
          ),
          ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Dekonekte"),
              onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()))
          ),
        ],
      ),
    );
  }
}