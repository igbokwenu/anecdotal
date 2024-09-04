import 'package:anecdotal/utils/reusable_function.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';
import 'package:anecdotal/services/database_service.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _createUserDocumentIfNeeded(User? user) async {
    if (user != null) {
      final databaseService = DatabaseService(uid: user.uid);
      final docSnapshot =
          await databaseService.userCollection.doc(user.uid).get();

      if (!docSnapshot.exists) {
        await databaseService.createUserDocument();
      }
    }
  }

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user document if it doesn't exist
      await _createUserDocumentIfNeeded(userCredential.user);

      // Save email to shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', email);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      ReusableFunctions.showCustomToast(
          description: "Error: $e", type: ToastificationType.error);
      return null;
    }
  }

  // Sign up with email and password
  Future<UserCredential?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user document
      await _createUserDocumentIfNeeded(userCredential.user);

      // Save email to shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', email);

      ReusableFunctions.showCustomToast(
        description: "Sign-up successful",
        type: ToastificationType.success,
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      ReusableFunctions.showCustomToast(
          description: "Error: $e", type: ToastificationType.error);
      return null;
    }
  }

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      // Create user document
      await _createUserDocumentIfNeeded(userCredential.user);

      ReusableFunctions.showCustomToast(
        description: "Sign-in successful",
        type: ToastificationType.success,
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      ReusableFunctions.showCustomToast(
          description: "Error: $e", type: ToastificationType.error);
      return null;
    }
  }

  // Sign in anonymously
  Future<UserCredential?> signInAnonymously() async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInAnonymously();

      // Create user document
      await _createUserDocumentIfNeeded(userCredential.user);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      ReusableFunctions.showCustomToast(
        description: "Error: $e",
        type: ToastificationType.error,
      );
      return null;
    }
  }

  // Password reset
  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  // Sign out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }

  // Delete user and their corresponding document
  Future<void> deleteUser() async {
    try {
      // Get the currently signed-in user
      User? user = _firebaseAuth.currentUser;

      if (user != null) {
        // Delete the user's document in Firestore
        final databaseService = DatabaseService(uid: user.uid);
        await databaseService.userCollection.doc(user.uid).delete();

        // Delete the user from Firebase Authentication
        await user.delete();

        ReusableFunctions.showCustomToast(
          description: "User and their data deleted successfully",
          type: ToastificationType.success,
        );
      } else {
        ReusableFunctions.showCustomToast(
          description: "No user is currently signed in",
          type: ToastificationType.warning,
        );
      }
    } on FirebaseAuthException catch (e) {
      ReusableFunctions.showCustomToast(
          description: "Error deleting user: $e",
          type: ToastificationType.error);
    }
  }

    // Method to check if the user signed in anonymously
  bool isUserAnonymous() {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      return user.isAnonymous;
    }
    return false;
  }
}
