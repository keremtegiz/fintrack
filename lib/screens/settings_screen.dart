import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profil Bilgileri
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Adınız'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'E-posta'),
            ),
            ElevatedButton(
              onPressed: () {
                // Profil bilgilerini güncelle
                print("Name: ${_nameController.text}, Email: ${_emailController.text}");
              },
              child: const Text("Kaydet"),
            ),
          ],
        ),
      ),
    );
  }
}
