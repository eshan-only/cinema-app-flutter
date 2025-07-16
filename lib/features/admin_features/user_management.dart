import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cinema_app/features/personalization/models/user_model.dart';
import 'package:cinema_app/data/repositories/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserManagement extends StatelessWidget {
  UserManagement({super.key});

  final UserRepository _userRepository = Get.put(UserRepository());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin - Manage Users"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Users').snapshots(), // Stream listening to Firestore
        builder: (context, snapshot) {
          // Handle loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Handle error state
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          // Handle empty data state
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No users found."));
          }

          // Process and map snapshot data to user models
          final users = snapshot.data!.docs
              .map((doc) => UserModel.fromSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>))
              .toList();

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return UserCard(user: user);
            },
          );
        },
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  final UserModel user;

  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // User Info
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.fullName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(user.email),
                Text("Role: ${user.role}", style: const TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
            // Role Change Button
            ElevatedButton(
              onPressed: () {
                _showConfirmationDialog(context, user);
              },
              child: const Text("Change Role"),
            ),
          ],
        ),
      ),
    );
  }

  // Show a confirmation dialog before changing the role
  Future<void> _showConfirmationDialog(BuildContext context, UserModel user) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Role Change"),
          content: Text(
              "Are you sure you want to change the role of ${user.fullName} to ${user.role == 'Admin' ? 'User' : 'Admin'}?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                await _changeRole(context, user); // Proceed with role change
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  // Method to change the role of the user
  Future<void> _changeRole(BuildContext context, UserModel user) async {
  String newRole = user.role == 'Admin' ? 'User' : 'Admin';

  // Update user role in Firestore
  try {
    await UserRepository.instance.updateUserRole(user.id, newRole); // Call the updateUserRole method
    Get.snackbar('Success', 'Role updated to $newRole');
  } catch (e) {
    Get.snackbar('Error', 'Failed to update role');
  }
}
}
