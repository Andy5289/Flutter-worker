import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'basescaffold.dart';
import 'booking_detail_page.dart'; // Import the booking detail page

class mybooking extends StatefulWidget {
  @override
  _mybookingState createState() => _mybookingState();
}

class _mybookingState extends State<mybooking> {
  List<Map<String, dynamic>> bookings = []; // List to store all bookings with details
  bool isLoading = true; // Flag to show loading indicator

  @override
  void initState() {
    super.initState();
    _fetchBookedServices();
  }

  Future<void> _fetchBookedServices() async {
    final prefs = await SharedPreferences.getInstance();
    final userPhoneNumber = prefs.getString('userPhoneNumber');

    if (userPhoneNumber != null) {
      final databaseRef = FirebaseDatabase.instance.ref('serviceBooking/$userPhoneNumber');
      try {
        final snapshot = await databaseRef.get();

        if (snapshot.exists) {
          final data = snapshot.value as Map<Object?, Object?>?;
          if (data != null) {
            // Clear previous data before adding new entries
            bookings.clear();

            // Loop through each booking entry
            data.forEach((bookingID, booking) {
              final bookingMap = booking as Map<Object?, Object?>?;
              final servicesDetails = bookingMap?['servicesDetails'] as Map<Object?, Object?>?;
              final cost = bookingMap?['cost'] as Map<Object?, Object?>?;

              if (servicesDetails != null && cost != null) {
                final services = servicesDetails['services'] as List<dynamic>?;
                final serviceTime = servicesDetails['serviceTime'] as String?;
                final serviceDate = servicesDetails['serviceDate'] as String?;
                final totalAmount = cost['totalAmount'] as int?;
                final bookingTime = bookingMap?['bookingTime'] as String?;

                if (services != null && totalAmount != null && bookingTime != null) {
                  bookings.add({
                    'bookingTime': bookingTime,
                    'totalAmount': totalAmount,
                    'serviceTime': serviceTime,
                    'serviceDate': serviceDate,
                    'services': services,
                  });
                }
              }
            });

            setState(() {
              isLoading = false; // Data fetched, stop loading
            });

            // Log the bookings for debugging
            print("Bookings: $bookings");
          } else {
            setState(() {
              bookings = [];
              isLoading = false; // No data found, stop loading
            });
          }
        } else {
          setState(() {
            bookings = [];
            isLoading = false; // No data found, stop loading
          });
        }
      } catch (error) {
        setState(() {
          isLoading = false; // Stop loading on error
        });
        print('Error fetching data: $error');
      }
    } else {
      setState(() {
        isLoading = false; // User phone number not found, stop loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: "My Bookings",
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator while fetching data
          : bookings.isNotEmpty
          ? ListView.builder(
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];

          return GestureDetector(
            onTap: () {
              // Navigate to the detailed booking page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingDetailPage(
                    services: booking['services'],
                    serviceDate: booking['serviceDate'],
                    serviceTime: booking['serviceTime'],
                  ),
                ),
              );
            },
            child: Card(
              margin: EdgeInsets.all(10),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Booking Time: ${booking['bookingTime']}",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Service Time: ${booking['serviceTime']}",
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Total Cost: ₹${booking['totalAmount']}",
                      style: TextStyle(fontSize: 14, color: Colors.green),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      )
          : Center(
        child: const Text(
          "No bookings yet",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}
