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

  // Commun variable
  String? _commun;

  // Status variable
  String? _status;

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

  // Getter for commun
  String? get commun => _commun;

  // Setter for commun
  void setCommun(String? commun) {
    _commun = commun;
  }

  // Getter for status
  String? get status => _status;

  // Setter for status
  void setStatus(String? status) {
    _status = status;
  }
}
