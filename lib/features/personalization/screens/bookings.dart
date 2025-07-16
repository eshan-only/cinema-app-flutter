import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});

  @override
  _BookingsPageState createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _firestore.collection('Users').doc(userId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            );
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Text(
                'No bookings yet!',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            );
          }

          // Extract ticket IDs from the user document
          final userData = snapshot.data!.data() as Map<String, dynamic>?;
          final List<String> ticketIds = List<String>.from(userData?['tickets'] ?? []);

          if (ticketIds.isEmpty) {
            return Center(
              child: Text(
                'No bookings yet!',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            );
          }

          // Stream for fetching ticket details
          return StreamBuilder<List<Map<String, dynamic>>>(
            stream: fetchTickets(ticketIds),
            builder: (context, ticketSnapshot) {
              if (ticketSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (ticketSnapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${ticketSnapshot.error}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                );
              }

              final tickets = ticketSnapshot.data ?? [];

              if (tickets.isEmpty) {
                return Center(
                  child: Text(
                    'No bookings yet!',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: tickets.length,
                itemBuilder: (context, index) {
                  final ticket = tickets[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ticket['movieName'] ?? 'Unknown Movie',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 8.0),
                          Text('Seats: ${ticket['seatNames']?.join(', ') ?? 'N/A'}'),
                          Text('Showtime: ${ticket['movieTiming'] ?? 'N/A'}'),
                          Text('Booking Date: ${ticket['bookingDate'] ?? 'N/A'}'),
                          Text('Total Price: PKR ${ticket['totalPrice'] ?? 0}'),
                          const SizedBox(height: 8.0),
                          Text(
                            'Contact: ${ticket['userEmail'] ?? 'N/A'}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  // Stream to fetch ticket details in real-time
  Stream<List<Map<String, dynamic>>> fetchTickets(List<String> ticketIds) async* {
    List<Map<String, dynamic>> fetchedTickets = [];

    for (String ticketId in ticketIds) {
      final ticketDoc = await _firestore.collection('Tickets').doc(ticketId).get();
      if (ticketDoc.exists) {
        fetchedTickets.add(ticketDoc.data()!);
      }
    }

    yield fetchedTickets;
  }
}
