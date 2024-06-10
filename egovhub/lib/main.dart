import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'user_provider.dart'; // Import UserProvider

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) =>
          UserProvider(), // Provide an instance of UserProvider
      child: MaterialApp(
        home: LoginScreen(),
      ),
    ),
  );
}
