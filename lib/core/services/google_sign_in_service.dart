import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Google Sign-In Service (compatible with google_sign_in 7.2.0)
///
/// The google_sign_in package switched to a singleton-style API. This service
/// wraps the new API and exposes helper methods similar to the previous
/// implementation (signIn, signOut, isSignedIn, getCurrentUser, signInSilently).
class GoogleSignInService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  static const _storage = FlutterSecureStorage();

  /// Sign in with Google (interactive)
  /// Returns a map with id, email, displayName, photoUrl, idToken and accessToken
  static Future<Map<String, dynamic>?> signIn({List<String> scopes = const ['email', 'profile']}) async {
    try {
      // authenticate() starts an interactive sign-in flow
      final GoogleSignInAccount account = await _googleSignIn.authenticate();

      if (account == null) return null; // defensive, though authenticate throws on failure

      // id token (if available)
      final auth = account.authentication;
      final idToken = auth.idToken;

      // access token may need to be requested via authorization client
      String? accessToken;
      try {
        final clientAuth = await account.authorizationClient.authorizationForScopes(scopes);
        accessToken = clientAuth?.accessToken;
      } catch (_) {
        accessToken = null;
      }

      // Persist tokens if present
      if (accessToken != null) await _storage.write(key: 'google_access_token', value: accessToken);
      if (idToken != null) await _storage.write(key: 'google_id_token', value: idToken);

      return {
        'id': account.id,
        'email': account.email,
        'displayName': account.displayName,
        'photoUrl': account.photoUrl,
        'accessToken': accessToken,
        'idToken': idToken,
      };
    } catch (error) {
      // authenticate throws a GoogleSignInException on failure
      // Keep the error handling simple and return null on failure
      // (the caller can show an error message if desired)
      // ignore: avoid_print
      print('GoogleSignIn.signIn error: $error');
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
      // ignore: avoid_print
      print('Error signing out from Google: $error');
    }
  }

  /// Check if a user is signed in.
  /// Uses a non-interactive lightweight attempt when available.
  static Future<bool> isSignedIn() async {
    try {
      final Future<GoogleSignInAccount?>? fut = _googleSignIn.attemptLightweightAuthentication();
      if (fut == null) return false;
      final acc = await fut;
      return acc != null;
    } catch (_) {
      return false;
    }
  }

  /// Attempt to get the current user without forcing interactive sign-in.
  static Future<GoogleSignInAccount?> getCurrentUser() async {
    try {
      final Future<GoogleSignInAccount?>? fut = _googleSignIn.attemptLightweightAuthentication();
      if (fut == null) return null;
      return await fut;
    } catch (_) {
      return null;
    }
  }

  /// Silent sign in (non-interactive)
  static Future<GoogleSignInAccount?> signInSilently() async {
    try {
      final Future<GoogleSignInAccount?>? fut = _googleSignIn.attemptLightweightAuthentication();
      if (fut == null) return null;
      return await fut;
    } catch (error) {
      // ignore: avoid_print
      print('Error silent sign in: $error');
      return null;
    }
  }
}
