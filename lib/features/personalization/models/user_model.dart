import 'package:cinema_app/utils/formatters/formatter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  // Keep those values final which you do not want to update
  final String id;
  String firstName;
  String lastName;
  final String username;
  final String email;
  String phoneNumber;
  String profilePicture;
  final String role; // Added role parameter
  List<String> favourite_movies; // Array for favourite movies

  // Constructor for UserModel
  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.profilePicture,
    required this.role, // Initialize role
    required this.favourite_movies, // Initialize favourite_movies
  });

  // Helper function to get the full name.
  String get fullName => '$firstName $lastName';

  // Helper function to format phone number.
  String get formattedPhoneNumber => Formatter.formatPhoneNumber(phoneNumber);

  // Static function to split full name and return a List<String> with first and last name
  static List<String> splitName(String fullName) {
    final nameParts = fullName.split(' ');
    return nameParts.length == 2 ? nameParts : [fullName];
  }

  static List<String> nameParts(fullName) => fullName.split(" ");
  
  static String generateUsername(String fullName){
    List<String> nameParts = fullName.split(" ");
    String firstName = nameParts[0].toLowerCase();
    String lastName = nameParts.length > 1 ? nameParts[1].toLowerCase() : "";

    String camelCaseUsername = "$firstName$lastName";
    String usernameWithPrefix = "cwt_$camelCaseUsername";
    return usernameWithPrefix;
  }

  static UserModel empty() {
    return UserModel(
      id: '',
      firstName: '',
      lastName: '',
      username: '',
      email: '',
      phoneNumber: '',
      profilePicture: '',
      role: 'User', // Default role is 'user'
      favourite_movies: [], // Empty list for favourite movies
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'FirstName': firstName,
      'LastName': lastName,
      'Username': username,
      'Email': email,
      'PhoneNumber': phoneNumber,
      'ProfilePicture': profilePicture,
      'Role': role, // Add role to the JSON
      'favourite_movies': favourite_movies, // Add favourite_movies to the JSON
    };
  }

  /// Factory method to create a UserModel from a Firebase document snapshot.
  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;

      return UserModel(
        id: document.id,
        firstName: data['FirstName'] ?? '',
        lastName: data['LastName'] ?? '',
        username: data['Username'] ?? '',
        email: data['Email'] ?? '',
        phoneNumber: data['PhoneNumber'] ?? '',
        profilePicture: data['ProfilePicture'] ?? '',
        role: data['Role'] ?? 'User', // Default to 'user' if no role is provided
        favourite_movies: List<String>.from(data['favourite_movies'] ?? []), // Parse favourite_movies
      );
    } else {
      return UserModel.empty();
    }
  }
}
