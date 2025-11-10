import 'package:connectivity_plus/connectivity_plus.dart';

/// Network Info
/// 
/// Checks device connectivity status

class NetworkInfo {
  final Connectivity _connectivity;
  
  NetworkInfo(this._connectivity);
  
  /// Check if device is connected to the internet
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }
  
  /// Stream of connectivity changes
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map(
      (result) => result != ConnectivityResult.none,
    );
  }
  
  /// Get current connectivity type
  Future<ConnectivityResult> get connectivityType {
    return _connectivity.checkConnectivity();
  }
}
