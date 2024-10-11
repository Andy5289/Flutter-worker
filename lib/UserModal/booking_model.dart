// booking_model.dart
import 'package:firebase_database/firebase_database.dart';

class Booking {
  String? id;
  String serviceName;
  List<ServiceItem> selectedServices;
  int totalAmount;
  DateTime bookingTime;

  Booking({
    this.id,
    required this.serviceName,
    required this.selectedServices,
    required this.totalAmount,
    required this.bookingTime,
  });

  // Convert a Booking object to a map
  Map<String, dynamic> toMap() {
    return {
      'serviceName': serviceName,
      'selectedServices': selectedServices.map((e) => e.toMap()).toList(),
      'totalAmount': totalAmount,
      'bookingTime': bookingTime.toIso8601String(),
    };
  }

  // Convert a map to a Booking object
  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      id: map['id'],
      serviceName: map['serviceName'],
      selectedServices: List<ServiceItem>.from(
          map['selectedServices'].map((x) => ServiceItem.fromMap(x))
      ),
      totalAmount: map['totalAmount'],
      bookingTime: DateTime.parse(map['bookingTime']),
    );
  }
}

class ServiceItem {
  String name;
  int price;

  ServiceItem({
    required this.name,
    required this.price,
  });

  // Convert a ServiceItem object to a map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
    };
  }

  // Convert a map to a ServiceItem object
  factory ServiceItem.fromMap(Map<String, dynamic> map) {
    return ServiceItem(
      name: map['name'],
      price: map['price'],
    );
  }
}
