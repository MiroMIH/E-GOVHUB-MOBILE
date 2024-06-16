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
        theme: ThemeData(
          primaryColor: Colors.teal, // Example primary color
          backgroundColor: Colors.white, // Example background color
          scaffoldBackgroundColor:
              Colors.grey[200], // Example scaffold background color
          appBarTheme: AppBarTheme(
            backgroundColor:
                Color(0xFF072923), // Custom app bar background color
            iconTheme:
                IconThemeData(color: Colors.white), // White icons in app bar
          ),
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.blue, // Default button color
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(0.0), // Rectangular button shape
              side: BorderSide(color: Colors.blue), // Optional: border color
            ),
            textTheme: ButtonTextTheme.primary, // Use primary button text style
            padding: EdgeInsets.symmetric(
                vertical: 12.0, horizontal: 24.0), // Button padding
            minWidth: 150, // Minimum button width
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0), // Custom input border
            ),
            fillColor: Colors.white, // Input field background color
            filled: true,
          ),
          textTheme: TextTheme(
            bodyText1: TextStyle(
                fontSize: 16, color: Colors.black87), // Default text style
            // Secondary text style
          ),
        ),
        home: LoginScreen(),
      ),
    ),
  );
}
