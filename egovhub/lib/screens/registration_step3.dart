import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';

class RegistrationStep3 extends StatelessWidget {
  final TextEditingController occupationController =
      TextEditingController(); // Controller for occupation field
  final TextEditingController employerNameController =
      TextEditingController(); // Controller for employer name field
  final TextEditingController workAddressController =
      TextEditingController(); // Controller for work address field
  final TextEditingController educationLevelController =
      TextEditingController(); // Controller for education level field
  final TextEditingController institutionAttendedController =
      TextEditingController(); // Controller for institution attended field
  final TextEditingController degreeEarnedController =
      TextEditingController(); // Controller for degree earned field

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          label: 'Occupation',
          controller: occupationController,
        ),
        SizedBox(height: 16.0),
        CustomTextField(
          label: 'Employer Name',
          controller: employerNameController,
        ),
        SizedBox(height: 16.0),
        CustomTextField(
          label: 'Work Address',
          controller: workAddressController,
        ),
        SizedBox(height: 16.0),
        CustomTextField(
          label: 'Education Level',
          controller: educationLevelController,
        ),
        SizedBox(height: 16.0),
        CustomTextField(
          label: 'Institution Attended',
          controller: institutionAttendedController,
        ),
        SizedBox(height: 16.0),
        CustomTextField(
          label: 'Degree Earned',
          controller: degreeEarnedController,
        ),
      ],
    );
  }
}
