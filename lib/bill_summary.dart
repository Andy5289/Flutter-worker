import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting the date and time
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'service_item.dart';
import 'package:firebase_database/firebase_database.dart'; // Ensure Firebase is initialized
import 'package:background_sms/background_sms.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart'; // Import the Fluttertoast package

class BillSummaryPage extends StatefulWidget {
  final List<ServiceItem> selectedServices;
  final int subTotal;
  final DateTime selectedDateTime;

  const BillSummaryPage({
    Key? key,
    required this.selectedServices,
    required this.subTotal,
    required this.selectedDateTime,
  }) : super(key: key);

  @override
  _BillSummaryPageState createState() => _BillSummaryPageState();
}

class _BillSummaryPageState extends State<BillSummaryPage> {
  String? userPhoneNumber;

  @override
  void initState() {
    super.initState();
    _initializeSharedPreferences();
  }

  Future<void> _initializeSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userPhoneNumber = prefs.getString('userPhoneNumber');
    });
  }

  Future<bool> _isPermissionGranted() async =>
      await Permission.sms.status.isGranted;

  Future<void> _sendMessage(String phoneNumber, String message, {int? simSlot}) async {
    var result = await BackgroundSms.sendMessage(
      phoneNumber: phoneNumber,
      message: message,
      simSlot: simSlot,
    );

    // Using WidgetsBinding to ensure toast runs in the next frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (result == SmsStatus.sent) {
        Fluttertoast.showToast(
          msg: "SMS Sent: Your service has been booked!",
          toastLength: Toast.LENGTH_LONG, // Increase toast length
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Failed to send SMS",
          toastLength: Toast.LENGTH_LONG, // Increase toast length
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final gst = (widget.subTotal * 0.18).round();
    final totalAmount = widget.subTotal + gst;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Bill Summary'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Service Date & Time: ${DateFormat('yyyy-MM-dd').format(widget.selectedDateTime)} ${DateFormat('HH:mm').format(widget.selectedDateTime)}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Sub Total: ₹ ${widget.subTotal}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'GST (18%): ₹ $gst',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Total Amount: ₹ $totalAmount',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (userPhoneNumber == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User phone number not found')),
                  );
                  return;
                }

                final dateTime = DateFormat('yyyy-MM-dd-HH:mm').format(DateTime.now());

                // Save data to Firebase Realtime Database using userPhoneNumber as the key
                final databaseRef = FirebaseDatabase.instance.ref('serviceBooking/$userPhoneNumber').child(dateTime);
                await databaseRef.set({
                  'servicesDetails': {
                    'services': widget.selectedServices.map((service) => {
                      'name': service.name,
                      'price': service.price,
                    }).toList(),
                    'serviceTime': DateFormat('HH:mm').format(widget.selectedDateTime),
                    'serviceDate': DateFormat('yyyy-MM-dd').format(widget.selectedDateTime),
                  },
                  'bookingTime': DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()), // Current date and time
                  'cost': {
                    'subTotal': widget.subTotal,
                    'gst': gst,
                    'totalAmount': totalAmount,
                  },
                }).then((_) async {
                  // Send SMS if permission is granted
                  if (await _isPermissionGranted()) {
                    _sendMessage(
                      userPhoneNumber!, // Replace with desired phone number
                      "Your total bill is ₹ $totalAmount",
                    );
                  } else {
                    // Notify the user if permission is not granted
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("SMS permission is required to send the message."),
                      ),
                    );
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Booking confirmed!')),
                  );
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to confirm booking: $error')),
                  );
                });
              },
              child: const Text('Confirm Booking'),
            ),
          ],
        ),
      ),
    );
  }
}
