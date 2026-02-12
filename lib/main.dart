import 'package:flutter/material.dart';
import 'dart:async';

// --- DONE GLOBAL ---
Map<String, String> fakeDatabase = {"lakoukajou@gmail.com": "poutimoun"};
List<String> panierList = [];
List<String> favorisList = [];

// Done pou kategori yo
Map<String, List<String>> kategotyData = {
  "Kategori Elektwonik": ["Laptop Dell", "iPhone 15 Pro"],
  "Kategori Rad": ["Chemiz Lakou", "Wòb Tradisyonèl"],
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

// --- 1. SPLASH SCREEN ---
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

// --- 2. LOGIN PAGE ---
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void doLogin() {
    if (fakeDatabase[emailController.text] == passwordController.text) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Imel oswa modpas pa bon!")));
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
            // Bouton ki mennen nan Sign Up
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

// --- NOUVO: SIGN UP PAGE ---
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final confirmEmailController = TextEditingController();
  final passwordController = TextEditingController();

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
                  controller: confirmEmailController,
                  decoration: const InputDecoration(labelText: "Konfime Imel", border: OutlineInputBorder()),
                  validator: (value) => (value != emailController.text) ? "Imel yo pa koresponn" : null,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: "Modpas", border: OutlineInputBorder()),
                  validator: (value) => (value == null || value.length < 8) ? "Modpas la dwe gen 8 karaktè min." : null,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        fakeDatabase[emailController.text] = passwordController.text;
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Kont kreye ak siksè!")));
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("ENSKRI"),
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

// --- 3. HOME SCREEN ---
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("EBoutikoo")),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildCat("Kategori Elektwonik"),
            _buildCat("Kategori Rad"),
            const Padding(padding: EdgeInsets.all(15), child: Align(alignment: Alignment.centerLeft, child: Text("Top Pwodwi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)))),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.8, mainAxisSpacing: 10, crossAxisSpacing: 10),
              itemBuilder: (context, index) => _rectCard("Pwodwi Top $index"),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (i) {
          if (i == 1) Navigator.push(context, MaterialPageRoute(builder: (_) => ListDisplayPage(title: "Favoris mwen", data: favorisList)));
          if (i == 2) Navigator.push(context, MaterialPageRoute(builder: (_) => ListDisplayPage(title: "Panier mwen", data: panierList)));
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favoris'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Panier'),
        ],
      ),
    );
  }

  Widget _buildCat(String name) {
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

  Widget _rectCard(String name) {
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

// --- EKRAN KATEGORI (LIS REKTANGILÈ) ---
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

// --- 4. DETAY (BOUTON + POU PANIER) ---
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
          const Padding(padding: EdgeInsets.all(20), child: Text("Sa se deskripsyon rektangilè pou pwodwi ou chwazi a.", textAlign: TextAlign.center)),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: FloatingActionButton.extended(
              backgroundColor: Colors.orange,
              onPressed: () {
                panierList.add(productName);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$productName ajoute nan panier!")));
              },
              label: const Text("Ajoute nan Panier"),
              icon: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}

// --- 5. LIS PWODWI (VIA MENU) ---
class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});
  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tout Pwodwi")),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.75, mainAxisSpacing: 10, crossAxisSpacing: 10),
        itemCount: 6,
        itemBuilder: (context, index) {
          String name = "Savon Kalite $index";
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
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Ajoute nan panier!")));
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

// --- PAJ DISPLAY (FAVORIS / PANIER) ---
class ListDisplayPage extends StatelessWidget {
  final String title;
  final List<String> data;
  const ListDisplayPage({super.key, required this.title, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: data.isEmpty
          ? const Center(child: Text("Pa gen anyen isit la!"))
          : ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) => ListTile(
          leading: const Icon(Icons.check_box, color: Color(0xFF0D2A5B)),
          title: Text(data[index]),
          trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () {
            // Ti bouton pou retire si w vle
          }),
        ),
      ),
    );
  }
}

// --- DRAWER ---
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
              accountEmail: Text("lakoukajou@gmail.com")
          ),
          ListTile(
              leading: const Icon(Icons.list),
              title: const Text("Lis Pwodwi"),
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