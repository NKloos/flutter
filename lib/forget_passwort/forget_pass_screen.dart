import 'package:flutter/material.dart';

class ForgetPasswort extends StatefulWidget {
  @override
  State<ForgetPasswort> createState() => _ForgetPasswortState();
}

class _ForgetPasswortState extends State<ForgetPasswort> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Passwort vergessen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Geben Sie Ihre E-Mail-Adresse ein, um das Passwort zurückzusetzen:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'E-Mail-Adresse',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final email = _emailController.text;
                // Fügen Sie hier den Code für das Zurücksetzen des Passworts hinzu
              },
              child: const Text('Passwort zurücksetzen'),
            ),
          ],
        ),
      ),
    );
  }
}
