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
    // `checkConnectivity()` may return either a ConnectivityResult or a List<ConnectivityResult>
    if (result is List) {
      return result.every((r) => r == ConnectivityResult.none) == false;
    }
    return (result as ConnectivityResult) != ConnectivityResult.none;
  }
  
  /// Stream of connectivity changes
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map((result) {
      if (result is List) {
        return result.every((r) => r == ConnectivityResult.none) == false;
      }
      return (result as ConnectivityResult) != ConnectivityResult.none;
    });
  }
  
  /// Get current connectivity type
  Future<dynamic> get connectivityType async {
    // Return whatever the underlying API provides (ConnectivityResult or List<ConnectivityResult>)
    return await _connectivity.checkConnectivity();
  }
}
