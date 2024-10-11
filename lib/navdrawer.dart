import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'homescreen.dart'; // Import your home screen
import 'services.dart'; // Import your service screen
import 'mybookings.dart'; // Import your my bookings screen
import 'service_item.dart'; // Import your ServiceItem model
import 'signin.dart'; // Import your sign-in screen
import 'basescaffold.dart'; // Import your BaseScaffold

class SideNavigationBar extends StatelessWidget {
  const SideNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Navigation Menu',
      body: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: const Text(
                'Navigation Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => CarouselScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.miscellaneous_services),
              title: const Text('Service'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ServicesScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('My Bookings'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => mybooking(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Log Out'),
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isLoggedIn', false);

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignInScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
