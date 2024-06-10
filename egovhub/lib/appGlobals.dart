class AppGlobals {
  // Singleton instance
  static final AppGlobals _instance = AppGlobals._internal();

  // Private constructor
  AppGlobals._internal();

  // Factory constructor to return the singleton instance
  factory AppGlobals() => _instance;

  // User ID variable
  String? _userId;

  // Token variable
  String? _token;

  // Getter for user ID
  String? get userId => _userId;

  // Setter for user ID
  void setUserId(String? userId) {
    _userId = userId;
  }

  // Getter for token
  String? get token => _token;

  // Setter for token
  void setToken(String? token) {
    _token = token;
  }
}