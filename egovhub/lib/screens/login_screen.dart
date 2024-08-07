import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api_service.dart';
import 'publication_screen.dart';
import 'registration_screen.dart'; // Import RegistrationScreen
import '../widgets/custom_text_field.dart';
import '../user_provider.dart'; // Import UserProvider
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(
              child: SvgPicture.string(
                '<svg width="169" height="169" viewBox="0 0 169 169" fill="none" xmlns="http://www.w3.org/2000/svg"><path className="path" fill-rule="evenodd" clip-rule="evenodd" stroke="#FFFFFF" stroke-width="2" d="M14.0625 63.2812L84.375 14.0625L154.688 63.2812H14.0625ZM21.0938 140.625V133.594H147.656V140.625H21.0938ZM21.0938 147.656V154.688H147.656V147.656H21.0938ZM84.375 22.4999L132.187 56.2499H36.5624L84.375 22.4999ZM42.1875 126.562V70.3125H35.1562V126.562H42.1875ZM70.3125 70.3125V126.562H63.2812V70.3125H70.3125ZM105.469 126.562V70.3125H98.4375V126.562H105.469ZM133.594 70.3125V126.562H126.562V70.3125H133.594Z"/></svg>',
                width: 169,
                color: Colors.black, // Adjust color as needed
                height: 169,
              ),
            ),
          ),
          Positioned(
            top: 169,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'EGOV-HUB',
                style: TextStyle(
                  fontSize: 20, // Adjust font size as needed
                  color: Colors.black, // Adjust color as needed
                ),
              ),
            ),
          ),
          Positioned(
            top: 169 + 20, // Height of SVG + Text size
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CustomTextField(
                    label: 'Email',
                    controller: emailController,
                  ),
                  SizedBox(height: 16.0),
                  CustomTextField(
                    label: 'Password',
                    isPassword: true,
                    controller: passwordController,
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      // Call login method from ApiService
                      print('\nAttempting to log in...');
                      apiService
                          .loginUser(emailController.text,
                              passwordController.text, context)
                          .then((data) {
                        // Handle successful login
                        print(
                            'Login successful.\nNavigating to PublicationScreen...');
                        print('DATA DATA ${data['userId']}');

                        // Set the user ID using UserProvider
                        Provider.of<UserProvider>(context, listen: false)
                            .setUserId(data['userId']);

                        // Navigate to the PublicationScreen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PublicationScreen(),
                          ),
                        );
                      }).catchError((error) {
                        // Handle login error
                        print('Error logging in: $error');
                        // Show error message to the user
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Failed to login. Please try again.'),
                        ));
                      });
                    },
                    child: Text('Login'),
                  ),

                  SizedBox(height: 16.0),
                  TextButton(
                    onPressed: () {
                      // Navigate to the registration screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegistrationScreen(),
                        ),
                      );
                    },
                    child: Text('Don\'t have an account? Register'),
                  ),
                  // Consumer to print the user ID from the UserProvider
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
