class ApiConstants {
  // Base URL untuk environment development  
  static const String baseUrl = 'http://10.0.2.2:3000'; // Untuk emulator Android
  // static const String baseUrl = 'http://localhost:3000/api'; // Untuk iOS Simulator  

  // Endpoint Authentication  
  static const String loginEndpoint = '$baseUrl/auth/login';
  static const String registerEndpoint = '$baseUrl/auth/register';
  static const String refreshTokenEndpoint = '$baseUrl/auth/refresh-token';

  // Endpoint Banboo  
  static const String banboosEndpoint = '$baseUrl/banboos';
  static const String banbooDetailEndpoint = '$baseUrl/banboos/';

  // Endpoint Cart  
  static const String cartEndpoint = '$baseUrl/cart';
  static const String addToCartEndpoint = '$baseUrl/cart/add';
  static const String removeFromCartEndpoint = '$baseUrl/cart/remove/';

  // Endpoint Order  
  static const String ordersEndpoint = '$baseUrl/orders';
  static const String createOrderEndpoint = '$baseUrl/orders/create';

  // Timeout durations  
  static const int connectionTimeout = 30; // detik  
  static const int receiveTimeout = 30; // detik  
}