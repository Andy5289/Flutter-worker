import 'package:flutter/material.dart';
import 'package:dh/basescaffold.dart'; // Import BaseScaffold
import 'electrician.dart'; // Import individual service pages
// Import other services similarly

class ServicesScreen extends StatefulWidget {
  @override
  _ServicesScreenState createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  // List of all Services names
  final List<String> services = [
    'Electrician',
    'Plumber',
    'Househelp',
    'Laundry',
    'Gardener',
    'Grocery',
    'Bicycle Booking',
    'Local Transport',
    'Turf & Club',
  ];

  // Names of a particular service's sub-services
  final List<List<String>> serviceNames = [
    ['Fan Installation', 'Light Repair', 'Wiring Check', 'UnInstallation'],
    ['Pipe Leak Repair', 'Tap Installation', 'Drain Cleaning'],
    ['House Cleaning', 'Dish Washing', 'Laundry'],
    ['Wash and Iron', 'Dry Cleaning', 'Iron Only'],
    ['Lawn Mowing', 'Plant Watering', 'Garden Maintenance'],
    ['Home Delivery', 'Bulk Order', 'Express Delivery'],
    ['Hourly Rental', 'Daily Rental', 'Weekly Rental'],
    ['Taxi Booking', 'Auto Rickshaw', 'Bus Pass'],
    ['Turf Booking', 'Club Membership', 'Event Hosting'],
  ];

  // Price of all sub-services of each service
  final List<List<int>> servicesCharge = [
    [50, 52, 54, 56],
    [50, 52, 54],
    [50, 52, 54],
    [50, 52, 54],
    [50, 52, 54],
    [50, 52, 54],
    [50, 52, 54],
    [50, 52, 54],
    [50, 52, 54],
  ];

  // Images of services
  final List<String> serviceImages = [
    'assets/electrician.png',
    'assets/plumber.png',
    'assets/househelp.png',
    'assets/laundry.png',
    'assets/gardener.png',
    'assets/grocery.png',
    'assets/bicycle.png',
    'assets/transport.png',
    'assets/turf.png',
  ];

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Services',
      body: SingleChildScrollView(
        child: Column(
          children: [
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(8.0),
              children: List.generate(services.length, (index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ElectricianPage(
                          title: services[index],
                          imagePath: serviceImages[index],
                          serviceOptions: [serviceNames[index]],
                          servicesCharge: [servicesCharge[index]],
                        ),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          image: DecorationImage(
                            image: AssetImage(serviceImages[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                        width: 75,
                        height: 75,
                      ),
                      SizedBox(height: 4),
                      Text(
                        services[index],
                        style: TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
