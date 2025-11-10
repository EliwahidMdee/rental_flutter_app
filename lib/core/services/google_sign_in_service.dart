import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Google Sign-In Service
/// 
/// Handles Google authentication

class GoogleSignInService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
    ],
  );

  static const _storage = FlutterSecureStorage();

  /// Sign in with Google
  static Future<Map<String, dynamic>?> signIn() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      
      if (account == null) {
        return null; // User canceled
      }

      final GoogleSignInAuthentication auth = await account.authentication;
      
      // Store Google tokens
      if (auth.accessToken != null) {
        await _storage.write(key: 'google_access_token', value: auth.accessToken);
      }
      if (auth.idToken != null) {
        await _storage.write(key: 'google_id_token', value: auth.idToken);
      }

      return {
        'id': account.id,
        'email': account.email,
        'displayName': account.displayName,
        'photoUrl': account.photoUrl,
        'accessToken': auth.accessToken,
        'idToken': auth.idToken,
      };
    } catch (error) {
      print('Error signing in with Google: $error');
      return null;
    }
  }

  /// Sign out from Google
  static Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _storage.delete(key: 'google_access_token');
      await _storage.delete(key: 'google_id_token');
    } catch (error) {
      print('Error signing out from Google: $error');
    }
  }

  /// Check if user is signed in
  static Future<bool> isSignedIn() async {
    return await _googleSignIn.isSignedIn();
  }

  /// Get current user
  static Future<GoogleSignInAccount?> getCurrentUser() async {
    return _googleSignIn.currentUser;
  }

  /// Silent sign in (automatic)
  static Future<GoogleSignInAccount?> signInSilently() async {
    try {
      return await _googleSignIn.signInSilently();
    } catch (error) {
      print('Error silent sign in: $error');
      return null;
    }
  }
}
