import 'dart:convert';

import 'package:flutter/material.dart';
import 'registration_step1.dart';
import 'registration_step2.dart';
import 'registration_step3.dart';
import 'login_screen.dart'; // Import your login screen file
import '../api_service.dart'; // Import your ApiService class

class RegistrationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Registration',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: RegistrationForm(),
    );
  }
}

class RegistrationForm extends StatefulWidget {
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  int _currentStep = 0;
  bool _isLastStep = false;

  List<Step> _steps = [
    Step(
      title: Text(
        'Step 1',
      ),
      content: RegistrationStep1(),
    ),
    Step(
      title: Text('Step 2'),
      content: RegistrationStep2(
        onFileSelected: (fileName) {
          // Handle file selection
        },
        onWilayaChanged: (value) {
          // Handle Wilaya selection
        },
        onCommuneChanged: (value) {
          // Handle Commune selection
        },
      ),
    ),
    Step(
      title: Text('Step 3'),
      content: RegistrationStep3(),
    ),
  ];

  Map<String, dynamic> registrationData = {};

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stepper(
            currentStep: _currentStep,
            type: StepperType.horizontal, // Set stepper to horizontal
            onStepContinue: () {
              setState(() {
                if (_currentStep < _steps.length - 1) {
                  _currentStep++;
                  _isLastStep = _currentStep == _steps.length - 1;
                } else {
                  // Handle submit action
                  _submitRegistration();
                }
              });
            },
            onStepCancel: () {
              setState(() {
                if (_currentStep > 0) {
                  _currentStep--;
                  _isLastStep = false;
                }
              });
            },
            onStepTapped: (step) {
              setState(() {
                _currentStep = step;
                _isLastStep = _currentStep == _steps.length - 1;
              });
            },
            steps: _steps.map((Step step) {
              // Modify step titles to display as "Step 1", "Step 2", "Step 3"
              String stepTitle = 'Step ${_steps.indexOf(step) + 1}';
              return Step(
                title: Text(
                  stepTitle,
                  style: TextStyle(
                    color: _currentStep == _steps.indexOf(step)
                        ? Colors.green // Change color of current step number
                        : null, // Use default color for other steps
                  ),
                ),
                content: step.content,
              );
            }).toList(),
            controlsBuilder: (BuildContext context, ControlsDetails details) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  if (_currentStep != 0 && details.onStepCancel != null)
                    ElevatedButton(
                      onPressed: details.onStepCancel!,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Text('Back'),
                    ),
                  ElevatedButton(
                    onPressed: () {
                      if (_isLastStep) {
                        _submitRegistration();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      } else if (details.onStepContinue != null) {
                        details.onStepContinue!();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Text(_isLastStep ? 'Submit' : 'Next'),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  void _submitRegistration() async {
    // Collect registration data from all steps
    RegistrationStep1 step1 = _steps[0].content as RegistrationStep1;
    RegistrationStep2 step2 = _steps[1].content as RegistrationStep2;
    RegistrationStep3 step3 = _steps[2].content as RegistrationStep3;

    registrationData = {
      'firstName': step1.firstNameController.text,
      'lastName': step1.lastNameController.text,
      'dateOfBirth': step1.dateController.text,
      'nationalIDNumber': step1.nationalIDController.text,
      'email': step2.emailController.text,
      'password': step2.passwordController.text,
      'address': step2.addressController.text,
      'phoneNumber': step2.phoneController.text,
      'occupation': step3.occupationController.text,
      'employerName': step3.employerNameController.text,
      'workAddress': step3.workAddressController.text,
      'educationLevel': step3.educationLevelController.text,
      'institutionAttended': step3.institutionAttendedController.text,
      'degreeEarned': step3.degreeEarnedController.text,
      'photos': step2.selectedPhotos,
      'wilaya': step2.selectedWilaya, // Add selected Wilaya value
      'commune': step2.selectedCommune, // Add selected Commune value
    };

    // Log registration data as JSON
    print(jsonEncode(registrationData));

    try {
      // Send registration data to the backend API
      final apiService = ApiService();
      await apiService.registerUser(registrationData);

      // If registration is successful, navigate to the login screen
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      // Handle registration failure
      print('Registration failed: $e');
      // Show error message to the user or retry registration
    }
  }
}
