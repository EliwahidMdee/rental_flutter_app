/// Application Constants
/// 
/// Shared constants used throughout the application

class AppConstants {
  // Prevent instantiation
  AppConstants._();
  
  // Date Formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
  static const String displayDateFormat = 'MMM dd, yyyy';
  static const String displayTimeFormat = 'hh:mm a';
  static const String displayDateTimeFormat = 'MMM dd, yyyy hh:mm a';
  
  // Payment Status
  static const String paymentStatusPending = 'pending';
  static const String paymentStatusPaid = 'paid';
  static const String paymentStatusRejected = 'rejected';
  static const String paymentStatusPartial = 'partial';
  
  // Payment Methods
  static const String paymentMethodCash = 'cash';
  static const String paymentMethodCard = 'card';
  static const String paymentMethodBankTransfer = 'bank_transfer';
  static const String paymentMethodMobileMoney = 'mobile_money';
  static const String paymentMethodCheque = 'cheque';
  
  // Property Status
  static const String propertyStatusAvailable = 'available';
  static const String propertyStatusOccupied = 'occupied';
  static const String propertyStatusMaintenance = 'maintenance';
  static const String propertyStatusInactive = 'inactive';
  
  // Lease Status
  static const String leaseStatusActive = 'active';
  static const String leaseStatusExpired = 'expired';
  static const String leaseStatusPending = 'pending';
  static const String leaseStatusTerminated = 'terminated';
  
  // User Roles
  static const String roleAdmin = 'admin';
  static const String roleLandlord = 'landlord';
  static const String roleTenant = 'tenant';
  
  // Notification Types
  static const String notificationRentDue = 'rent_due';
  static const String notificationPaymentReceived = 'payment_received';
  static const String notificationLeaseExpiring = 'lease_expiring';
  static const String notificationMaintenanceRequest = 'maintenance_request';
  static const String notificationMessage = 'message';
  static const String notificationGeneral = 'general';
  
  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 32;
  static const int minPhoneLength = 10;
  static const int maxPhoneLength = 15;
  static const int maxFileSize = 5 * 1024 * 1024; // 5MB
  
  // Pagination
  static const int defaultPageSize = 15;
  static const int maxPageSize = 100;
  
  // Image Sizes
  static const double profileImageSize = 200.0;
  static const double propertyImageSize = 800.0;
  static const double thumbnailSize = 150.0;
  
  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration normalAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
  
  // Debounce Duration
  static const Duration debounceDuration = Duration(milliseconds: 500);
  
  // Cache Duration
  static const Duration shortCacheDuration = Duration(hours: 1);
  static const Duration normalCacheDuration = Duration(hours: 24);
  static const Duration longCacheDuration = Duration(days: 7);
  
  // UI Sizes
  static const double borderRadius = 12.0;
  static const double cardElevation = 2.0;
  static const double iconSize = 24.0;
  static const double largeIconSize = 48.0;
  static const double spacing = 16.0;
  static const double largeSpacing = 24.0;
  
  // Grid
  static const int gridCrossAxisCount = 2;
  static const double gridChildAspectRatio = 0.75;
  
  // Error Messages
  static const String errorGeneric = 'An error occurred. Please try again.';
  static const String errorNetwork = 'Network error. Check your connection.';
  static const String errorUnauthorized = 'Unauthorized. Please login again.';
  static const String errorNotFound = 'Resource not found.';
  static const String errorServer = 'Server error. Please try again later.';
  
  // Success Messages
  static const String successLogin = 'Login successful!';
  static const String successLogout = 'Logout successful!';
  static const String successSaved = 'Saved successfully!';
  static const String successDeleted = 'Deleted successfully!';
  static const String successUpdated = 'Updated successfully!';
  
  // Empty States
  static const String emptyProperties = 'No properties found';
  static const String emptyPayments = 'No payments found';
  static const String emptyNotifications = 'No notifications';
  static const String emptyTenants = 'No tenants found';
  
  // Loading Messages
  static const String loadingPleaseWait = 'Please wait...';
  static const String loadingData = 'Loading data...';
  static const String processingRequest = 'Processing request...';
}
