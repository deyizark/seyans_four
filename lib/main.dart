import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  // 1. Lyen imaj ak Assets (Enonse a mande itilize lyen ak assets)
  final String networkImage = "https://picsum.photos/200/300";
  final String assetImage = "assets/images/logo.png";

  // Nou kreye instans stockage la
  final stockage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lakou Kajou"),
        actions: [
          // 3. Bouton nan navbar pou ale nan Lis Achte
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LisAchte()),
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          // Pwodwi 1: Asset
          Image.asset(assetImage, width: 100, height: 100),
          ElevatedButton(
            onPressed: () async {
              // 2. stockage.write() - anrejistre lyen an
              await stockage.write(key: 'Pwodwi_Asset', value: assetImage);
            },
            child: const Text("Achte"),
          ),

          const Divider(),

          // Pwodwi 2: Network
          Image.network(networkImage, width: 100, height: 100),
          ElevatedButton(
            onPressed: () async {
              // 2. stockage.write() - anrejistre lyen an
              await stockage.write(key: 'Pwodwi_Network', value: networkImage);
            },
            child: const Text("Achte"),
          ),
        ],
      ),
    );
  }
}

// 4. Ekran Lis Achte
class LisAchte extends StatefulWidget {
  const LisAchte({super.key});

  @override
  State<LisAchte> createState() => _LisAchteState();
}

class _LisAchteState extends State<LisAchte> {
  final stockage = const FlutterSecureStorage();
  Map<String, String> toutDone = {};

  @override
  void initState() {
    super.initState();
    chargerDone();
  }

  // 5. stockage.readAll() - Afiche tout lyen ki anrejistre yo
  Future<void> chargerDone() async {
    var done = await stockage.readAll();
    setState(() {
      toutDone = done;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lis Achte")),
      body: ListView(
        children: toutDone.entries.map((entry) {
          return ListTile(
            title: Text(entry.key),
            subtitle: Text(entry.value), // Sa a se lyen an
          );
        }).toList(),
      ),
    );
  }
}