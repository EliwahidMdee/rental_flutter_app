import 'package:hive_flutter/hive_flutter.dart';

/// Local Storage Service
/// 
/// Manages local data storage using Hive for caching and offline support

class LocalStorage {
  // Box names
  static const String _propertiesBox = 'properties';
  static const String _paymentsBox = 'payments';
  static const String _notificationsBox = 'notifications';
  static const String _dashboardBox = 'dashboard';
  static const String _settingsBox = 'settings';
  
  static Box? _propertiesCache;
  static Box? _paymentsCache;
  static Box? _notificationsCache;
  static Box? _dashboardCache;
  static Box? _settingsCache;
  
  /// Initialize Hive and open boxes
  static Future<void> init() async {
    try {
      _propertiesCache = await Hive.openBox(_propertiesBox);
      _paymentsCache = await Hive.openBox(_paymentsBox);
      _notificationsCache = await Hive.openBox(_notificationsBox);
      _dashboardCache = await Hive.openBox(_dashboardBox);
      _settingsCache = await Hive.openBox(_settingsBox);
    } catch (e) {
      throw Exception('Failed to initialize local storage: $e');
    }
  }
  
  /// Get Properties Box
  static Box get propertiesBox {
    if (_propertiesCache == null || !_propertiesCache!.isOpen) {
      throw Exception('Properties box not initialized');
    }
    return _propertiesCache!;
  }
  
  /// Get Payments Box
  static Box get paymentsBox {
    if (_paymentsCache == null || !_paymentsCache!.isOpen) {
      throw Exception('Payments box not initialized');
    }
    return _paymentsCache!;
  }
  
  /// Get Notifications Box
  static Box get notificationsBox {
    if (_notificationsCache == null || !_notificationsCache!.isOpen) {
      throw Exception('Notifications box not initialized');
    }
    return _notificationsCache!;
  }
  
  /// Get Dashboard Box
  static Box get dashboardBox {
    if (_dashboardCache == null || !_dashboardCache!.isOpen) {
      throw Exception('Dashboard box not initialized');
    }
    return _dashboardCache!;
  }
  
  /// Get Settings Box
  static Box get settingsBox {
    if (_settingsCache == null || !_settingsCache!.isOpen) {
      throw Exception('Settings box not initialized');
    }
    return _settingsCache!;
  }
  
  /// Save data to specific box
  static Future<void> save(String boxName, String key, dynamic value) async {
    final box = await Hive.openBox(boxName);
    await box.put(key, value);
  }
  
  /// Get data from specific box
  static Future<dynamic> get(String boxName, String key) async {
    final box = await Hive.openBox(boxName);
    return box.get(key);
  }
  
  /// Delete data from specific box
  static Future<void> delete(String boxName, String key) async {
    final box = await Hive.openBox(boxName);
    await box.delete(key);
  }
  
  /// Clear specific box
  static Future<void> clearBox(String boxName) async {
    final box = await Hive.openBox(boxName);
    await box.clear();
  }
  
  /// Clear all cached data
  static Future<void> clearAll() async {
    try {
      await _propertiesCache?.clear();
      await _paymentsCache?.clear();
      await _notificationsCache?.clear();
      await _dashboardCache?.clear();
      // Don't clear settings as they should persist
    } catch (e) {
      throw Exception('Failed to clear cache: $e');
    }
  }
  
  /// Close all boxes
  static Future<void> close() async {
    await _propertiesCache?.close();
    await _paymentsCache?.close();
    await _notificationsCache?.close();
    await _dashboardCache?.close();
    await _settingsCache?.close();
  }
}
