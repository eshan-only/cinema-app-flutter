import 'package:cloud_firestore/cloud_firestore.dart';

class Ticket {
  final String userId;
  final int numberOfSeats;
  final List<String> seatNames;
  final int totalPrice;
  final String userPhoneNumber;
  final String userEmail;
  final String movieName;
  final String movieTiming;
  final String bookingDate;

  Ticket({
    required this.userId,
    required this.numberOfSeats,
    required this.seatNames,
    required this.totalPrice,
    required this.userPhoneNumber,
    required this.userEmail,
    required this.movieName,
    required this.movieTiming,
    required this.bookingDate,
  });

  // Convert the Ticket object to a Map to store it in Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'numberOfSeats': numberOfSeats,
      'seatNames': seatNames.toList(),
      'totalPrice': totalPrice,
      'userPhoneNumber': userPhoneNumber,
      'userEmail': userEmail,
      'movieName': movieName,
      'movieTiming': movieTiming,
      'bookingDate': bookingDate,
    };
  }

  // Create a Ticket object from Firestore data
  factory Ticket.fromDocument(DocumentSnapshot doc) {
    return Ticket(
      userId: doc['userId'],
      numberOfSeats: doc['numberOfSeats'],
      seatNames: List<String>.from(doc['seatNames']),
      totalPrice: doc['totalPrice'],
      userPhoneNumber: doc['userPhoneNumber'],
      userEmail: doc['userEmail'],
      movieName: doc['movieName'],
      movieTiming: doc['movieTiming'],
      bookingDate: doc['bookingDate'],
    );
  }
}
