/// API Endpoints
/// 
/// All API endpoint definitions for the backend

class ApiEndpoints {
  // Prevent instantiation
  ApiEndpoints._();
  
  // Authentication
  static const String login = '/login';
  static const String register = '/register';
  static const String logout = '/logout';
  static const String refreshToken = '/refresh';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  
  // User
  static const String currentUser = '/user';
  static const String updateProfile = '/user/profile';
  static const String changePassword = '/user/change-password';
  static const String uploadAvatar = '/user/avatar';
  
  // Dashboard
  static const String dashboard = '/dashboard';
  static const String dashboardStats = '/dashboard/stats';
  
  // Properties
  static const String properties = '/properties';
  static String propertyDetail(int id) => '/properties/$id';
  static String propertyUnits(int id) => '/properties/$id/units';
  static String propertyImages(int id) => '/properties/$id/images';
  
  // Tenants
  static const String tenants = '/tenants';
  static String tenantDetail(int id) => '/tenants/$id';
  
  // Leases
  static const String leases = '/leases';
  static String leaseDetail(int id) => '/leases/$id';
  
  // Payments
  static const String payments = '/payments';
  static String paymentDetail(int id) => '/payments/$id';
  static String verifyPayment(int id) => '/payments/$id/verify';
  static String rejectPayment(int id) => '/payments/$id/reject';
  static const String pendingPayments = '/payments/pending/list';
  
  // Reports
  static const String revenueReport = '/reports/revenue';
  static const String expensesReport = '/reports/expenses';
  static const String occupancyReport = '/reports/occupancy';
  static const String balanceSheet = '/reports/balance-sheet';
  static const String profitLoss = '/reports/profit-loss';
  static const String tenantReport = '/reports/tenant';
  static const String propertyReport = '/reports/property';
  
  // Notifications
  static const String notifications = '/notifications';
  static String notificationDetail(int id) => '/notifications/$id';
  static String markNotificationRead(int id) => '/notifications/$id/read';
  static const String markAllNotificationsRead = '/notifications/read-all';
  
  // Maintenance
  static const String maintenanceRequests = '/maintenance';
  static String maintenanceDetail(int id) => '/maintenance/$id';
  
  // Messages
  static const String messages = '/messages';
  static String conversation(int id) => '/messages/$id';
}
