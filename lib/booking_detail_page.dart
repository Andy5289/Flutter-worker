import 'package:flutter/material.dart';
import 'service_item.dart';

class BookingDetailPage extends StatelessWidget {
  final List<dynamic> services;
  final String? serviceDate;
  final String? serviceTime;

  BookingDetailPage({
    required this.services,
    this.serviceDate,
    this.serviceTime,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Service Date: $serviceDate",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "Service Time: $serviceTime",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final service = services[index] as Map<Object?, Object?>;
                  final serviceName = service['name'] as String;
                  final servicePrice = service['price'] as int;

                  return ListTile(
                    title: Text(serviceName),
                    subtitle: Text("Price: ₹$servicePrice"),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
