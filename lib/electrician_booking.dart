import 'package:flutter/material.dart';
import 'bill_summary.dart'; // Import the BillSummaryPage
import 'service_item.dart';

class ElectricianBookingPage extends StatefulWidget {
  final String serviceName;
  final String serviceImagePath;
  final List<ServiceItem> serviceOptions;
  final int totalCharge;
  final DateTime selectedDateTime; // New field for date and time

  const ElectricianBookingPage({
    Key? key,
    required this.serviceName,
    required this.serviceImagePath,
    required this.serviceOptions,
    required this.totalCharge,
    required this.selectedDateTime, // Initialize the new field
  }) : super(key: key);

  @override
  State<ElectricianBookingPage> createState() => _ElectricianBookingPageState();
}

class _ElectricianBookingPageState extends State<ElectricianBookingPage> {
  List<ServiceItem> _selectedServices = [];
  int _currentCharge = 99;

  void _onServiceSelected(ServiceItem service, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedServices.add(service);
        _currentCharge += service.price;
      } else {
        _selectedServices.remove(service);
        _currentCharge -= service.price;
      }
    });
  }

  void _showBill() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BillSummaryPage(
          selectedServices: _selectedServices,
          subTotal: _currentCharge,
          selectedDateTime: widget.selectedDateTime, // Pass the date and time
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
          widget.serviceName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Service Image at the top
          Container(
            margin: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(
                color: Colors.blue,
                width: 3.0,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.asset(
                widget.serviceImagePath,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Display Charge
          Text(
            'Charge: ₹ $_currentCharge',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          // Expanded List of Services in Card Format
          Expanded(
            child: ListView.builder(
              itemCount: widget.serviceOptions.length,
              itemBuilder: (context, index) {
                final serviceItem = widget.serviceOptions[index];
                return Card(
                  color: const Color(0xFFE6EAFF), // Applying the color shade to the card
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            serviceItem.name,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        Text(
                          '₹ ${serviceItem.price}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Checkbox(
                          value: _selectedServices.contains(serviceItem),
                          onChanged: (bool? isChecked) {
                            _onServiceSelected(serviceItem, isChecked ?? false);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _showBill,
            child: const Text('Show Bill'),
          ),
        ],
      ),
    );
  }
}
