import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting the date
import 'electrician_booking.dart'; // Import the booking page
import 'service_item.dart';

class DateTimeSelectionPage extends StatefulWidget {
  final String serviceName;
  final String serviceImagePath;
  final List<ServiceItem> selectedServices;
  final int totalCharge;

  const DateTimeSelectionPage({
    Key? key,
    required this.serviceName,
    required this.serviceImagePath,
    required this.selectedServices,
    required this.totalCharge,
  }) : super(key: key);

  @override
  _DateTimeSelectionPageState createState() => _DateTimeSelectionPageState();
}

class _DateTimeSelectionPageState extends State<DateTimeSelectionPage> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue,
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue,
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  void _confirmBooking() {
    if (selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both date and time.')),
      );
      return;
    }

    final selectedDateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ElectricianBookingPage(
          serviceName: widget.serviceName,
          serviceImagePath: widget.serviceImagePath,
          serviceOptions: widget.selectedServices,
          totalCharge: widget.totalCharge,
          selectedDateTime: selectedDateTime,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Select Date & Time",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Picker
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ListTile(
                leading: const Icon(Icons.calendar_today, color: Colors.blue),
                title: Text(
                  selectedDate == null
                      ? 'Select Date'
                      : DateFormat('yyyy-MM-dd').format(selectedDate!),
                  style: const TextStyle(fontSize: 16),
                ),
                onTap: () => _selectDate(context),
              ),
            ),
            const SizedBox(height: 16),
            // Time Picker
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ListTile(
                leading: const Icon(Icons.access_time, color: Colors.blue),
                title: Text(
                  selectedTime == null
                      ? 'Select Time'
                      : selectedTime!.format(context),
                  style: const TextStyle(fontSize: 16),
                ),
                onTap: () => _selectTime(context),
              ),
            ),
            const SizedBox(height: 32),
            // Confirm Booking Button
            Center(
              child: ElevatedButton(
                onPressed: _confirmBooking,
                child: const Text('Next'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Background color
                  foregroundColor: Colors.white, // Text color
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
