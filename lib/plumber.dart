// plumber.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PlumberPage extends StatefulWidget {
  const PlumberPage({super.key});

  @override
  State<PlumberPage> createState() => _PlumberPageState();
}

class _PlumberPageState extends State<PlumberPage> {
  final String _phoneNumber = '+91 8104269344';

  // Make a phone call to the saved number
  Future<void> _makePhoneCall() async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: _phoneNumber,
    );
    if (!await launchUrl(launchUri)) {
      throw Exception('Could not launch $launchUri');
    }
  }

  // Book a service (open a booking URL or page)
  Future<void> _bookService() async {
    // Replace with the actual booking URL
    final Uri bookingUri = Uri.parse('https://www.yourbookingpage.com');
    if (!await launchUrl(bookingUri)) {
      throw Exception('Could not launch $bookingUri');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Plumber Service',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Card(
          elevation: 5,
          margin: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(
                    color: Colors.blue, // Border color
                    width: 3.0, // Border width
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.asset(
                    'assets/plumber.png', // Ensure you have this image in your assets folder
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Pool Cleaning',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Visiting charge: Rs 99',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: _makePhoneCall,
                    child: const Text('Call'),
                  ),
                  ElevatedButton(
                    onPressed: _bookService,
                    child: const Text('Book'),
                  ),
                ],
              ),
              const SizedBox(height: 150),
            ],
          ),
        ),
      ),
    );
  }
}
