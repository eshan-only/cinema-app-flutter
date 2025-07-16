import 'package:cinema_app/data/repositories/user_repository.dart';
import 'package:cinema_app/features/admin_features/navigation_page/navigation_menu_admin.dart';
import 'package:cinema_app/features/authetication/screens/login/login.dart';
import 'package:cinema_app/features/authetication/screens/onboarding/onboarding.dart';
import 'package:cinema_app/features/authetication/screens/signup/widgets/verify_email.dart';
import 'package:cinema_app/features/movie_discovery/screens/navigation_menu.dart';
import 'package:cinema_app/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:cinema_app/utils/exceptions/firebase_exceptions.dart';
import 'package:cinema_app/utils/exceptions/format_exceptions.dart';
import 'package:cinema_app/utils/exceptions/platform_exceptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  // Variables
  final deviceStorage = GetStorage();
  final _auth = FirebaseAuth.instance;

  User? get authUser => _auth.currentUser;

  @override
  void onReady() {
    super.onReady();
    FlutterNativeSplash.remove();
    screenRedirect();
  }

void screenRedirect() async {
  final user = _auth.currentUser;

  if (user != null) {
    if (user.emailVerified) {
      try {
        // Fetch the user's role from Firestore
        final userDoc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          final userRole = userDoc.data()?['Role']; // Ensure role field matches your database schema

          if (userRole == 'User') {
            // Admin role: navigate to admin dashboard
            Get.offAll(() => NavigationMenu());
          } else if (userRole == 'Admin') {
            // Regular user: navigate to user dashboard
            Get.offAll(() => NavigationMenuAdmin());
          } else {
            // Unrecognized role or empty
            throw Exception('Unauthorized role: Access denied');
          }
        } else {
          // User record not found in Firestore
          throw Exception('User document does not exist');
        }
      } catch (e) {
        // Log the error and navigate to a safe screen
        if (kDebugMode) print('Error during role verification: $e');
        Get.snackbar('Access Denied', 'Unauthorized access attempt detected.');
        Get.offAll(() => const LoginScreen()); // Redirect to login screen or safe page
      }
    } else {
      // Email not verified: Redirect to email verification screen
      Get.offAll(() => VerifyEmailScreen(email: user.email));
    }
  } else {
    // First-time user flow
    deviceStorage.writeIfNull('isFirstTime', true);

    if (deviceStorage.read('isFirstTime') == true) {
      Get.offAll(() => const OnBoardingScreen());
    } else {
      Get.offAll(() => const LoginScreen());
    }
  }
}


  // Email/Password Sign In
  Future<UserCredential> loginWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw MyFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw MyFirebaseException(e.code).message;
    } on FormatException {
      throw const MyFormatException();
    } on PlatformException catch (e) {
      throw MyPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }
  /// ReAuthenticate) RE AUTHENTICATE USER
Future<void> reAuthenticateWithEmailAndPassword(String email, String password) async {
  try {
    // Create a credential
    AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);

    // ReAuthenticate
    await _auth.currentUser!.reauthenticateWithCredential(credential);
  }   on FirebaseAuthException catch (e) {
        throw MyFirebaseAuthException(e.code).message;
      } on FirebaseException catch (e) {
        throw MyFirebaseException(e.code).message;
      } on FormatException {
        throw const MyFormatException();
      } on PlatformException catch (e) {
        throw MyPlatformException(e.code).message;
      } catch (e) {
        throw 'Something went wrong. Please try again.';
      }
  }

  /// [EmailAuthentication] - REGISTER
  Future<UserCredential> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
    } on FirebaseAuthException catch (e) {
      throw MyFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw MyFirebaseException(e.code).message;
    } on FormatException {
      throw const MyFormatException();
    } on PlatformException catch (e) {
      throw MyPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }
  /// DELETE USER - Remove user Auth and Firestore Account.
  Future<void> deleteAccount() async {
    try {
      await UserRepository.instance.removeUserRecord(_auth.currentUser!.uid);
      await _auth.currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      throw MyFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw  MyFirebaseException(e.code).message;
    } on FormatException {
      throw const MyFormatException();
    } on PlatformException catch (e) {
      throw MyPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }
// Forget Password 
Future<void> sendPasswordResetEmail(String email) async{
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw MyFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw  MyFirebaseException(e.code).message;
    } on FormatException {
      throw const MyFormatException();
    } on PlatformException catch (e) {
      throw MyPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }
  
// Email Verification
  Future<void> sendEmailVerification() async{
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw MyFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw  MyFirebaseException(e.code).message;
    } on FormatException {
      throw const MyFormatException();
    } on PlatformException catch (e) {
      throw MyPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? userAccount = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await userAccount?.authentication;

      // Create a new credential
      AuthCredential credentials = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
 
      // Once signed in, return the UserCredential
      return await _auth.signInWithCredential(credentials);

    } on FirebaseAuthException catch (e) {
      throw MyFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw MyFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const MyFormatException();
    } on PlatformException catch (e) {
      throw MyPlatformException(e.code).message;
    } catch (e) {
      if (kDebugMode) {
        print('Something went wrong: $e');
      }
      return null;
    }
  }
  // log out
  Future<void> logout() async {
  try {
    // Sign out from Firebase
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();

    // Navigate to the Login Screen
    Get.offAll(() => const LoginScreen());
  } on FirebaseAuthException catch (e) {
    // Handle Firebase-specific exceptions
    Get.snackbar('Logout Failed', 'Error Code: ${e.code}');
  } on FirebaseException catch (e) {
    // Handle general Firebase exceptions
    Get.snackbar('Error', 'Firebase Error: ${e.message}');
  } on PlatformException catch (e) {
    // Handle platform-specific exceptions
    Get.snackbar('Platform Error', 'Message: ${e.message}');
  } catch (e) {
    // Handle all other exceptions
    Get.snackbar('Unexpected Error', 'Something went wrong: $e');
  }
}


}
