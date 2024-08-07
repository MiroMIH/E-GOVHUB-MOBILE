import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';

class RegistrationStep1 extends StatelessWidget {
  final TextEditingController firstNameController =
      TextEditingController(); // Controller for first name field
  final TextEditingController lastNameController =
      TextEditingController(); // Controller for last name field
  final TextEditingController dateController =
      TextEditingController(); // Controller for date field
  final TextEditingController nationalIDController =
      TextEditingController(); // Controller for national ID field

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          label: 'First Name',
          controller: firstNameController,
        ),
        SizedBox(height: 16.0),
        CustomTextField(
          label: 'Last Name',
          controller: lastNameController,
        ),
        SizedBox(height: 16.0),
        CustomTextField(
          label: 'Date of Birth',
          controller: dateController,
          isDate: true,
        ), // Date field
        SizedBox(height: 16.0),
        CustomTextField(
          label: 'National ID Number',
          controller: nationalIDController,
        ),
        SizedBox(height: 16.0),
      ],
    );
  }
}
