import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'basescaffold.dart';

class CarouselScreen extends StatefulWidget {
  @override
  _CarouselScreenState createState() => _CarouselScreenState();
}

class _CarouselScreenState extends State<CarouselScreen> {
  final List<String> imageUrls = [
    'assets/hone.jpg',
    'assets/htwo.jpg',
    'assets/hone.jpg',
    'assets/htwo.jpg',
  ];

  int _current = 0;
  String? userPhoneNumber;

  @override
  void initState() {
    super.initState();
    _initializeSharedPreferences();
    _requestSmsPermission(context); // Request SMS permission on home screen load
  }

  Future<void> _initializeSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userPhoneNumber = prefs.getString('userPhoneNumber');
    });
  }

  Future<void> _requestSmsPermission(BuildContext context) async {
    var status = await Permission.sms.status;
    if (!status.isGranted) {
      var result = await Permission.sms.request();
      if (result.isDenied) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Permission Required"),
              content: Text("This app needs SMS permission to send messages."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    openAppSettings();
                  },
                  child: Text("Open Settings"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel"),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: "Home Screen",
      body: Column(
        children: [
          CarouselSlider(
            items: imageUrls.map((imageUrl) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: AssetImage(imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              );
            }).toList(),
            options: CarouselOptions(
              height: 200,
              enlargeCenterPage: true,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              viewportFraction: 0.8,
              aspectRatio: 2.0,
              initialPage: 0,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: imageUrls.asMap().entries.map((entry) {
              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black)
                      .withOpacity(_current == entry.key ? 0.9 : 0.4),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 20),
          if (userPhoneNumber != null)
            Text('User Phone Number: $userPhoneNumber'),
        ],
      ),
    );
  }
}
