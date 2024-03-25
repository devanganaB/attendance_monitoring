import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRGenerationScreen extends StatelessWidget {
  final String selectedOption;

  const QRGenerationScreen({Key? key, required this.selectedOption})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate QR'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImageView(
              data:
                  'Class: $selectedOption ${DateTime.now()}\nFacultyEmail: sakshichoudhary@email.com',
              version: QrVersions.auto,
              size: 320,
              gapless: false,
            ),
            const SizedBox(height: 20.0) // Display the encoded data
          ],
        ),
      ),
    );
  }
}
