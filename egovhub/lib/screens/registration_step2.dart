import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_file_picker.dart';

class RegistrationStep2 extends StatefulWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String? selectedPhotos; // Variable to hold the selected file name
  String? selectedWilaya; // Variable to hold the selected Wilaya
  String? selectedCommune; // Variable to hold the selected Commune

  final Function(String?) onFileSelected; // Callback for file selection
  final void Function(String?)?
      onWilayaChanged; // Callback for Wilaya selection
  final void Function(String?)?
      onCommuneChanged; // Callback for Commune selection

  RegistrationStep2({
    required this.onFileSelected,
    required this.onWilayaChanged,
    required this.onCommuneChanged,
  });

  @override
  _RegistrationStep2State createState() => _RegistrationStep2State();
}

class _RegistrationStep2State extends State<RegistrationStep2> {
  TextEditingController _wilayaController = TextEditingController();
  TextEditingController _communeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          label: 'Email',
          controller: widget.emailController,
        ),
        SizedBox(height: 16.0),
        CustomTextField(
          label: 'Password',
          isPassword: true,
          controller: widget.passwordController,
        ),
        SizedBox(height: 16.0),
        CustomTextField(
          label: 'Address',
          controller: widget.addressController,
        ),
        SizedBox(height: 16.0),
        CustomTextField(
          label: 'Phone Number',
          controller: widget.phoneController,
        ),
        SizedBox(height: 16.0),
        CustomTextField(
          label: 'Wilaya',
          isDropdown: true,
          initialValue: widget.selectedWilaya,
          onChanged: (value) {
            setState(() {
              widget.selectedWilaya = value;
              widget.onWilayaChanged!(value);
            });
          },
        ),
        SizedBox(height: 16.0),
        CustomTextField(
          label: 'Commune',
          isDropdown: true,
          initialValue: widget.selectedCommune,
          onChanged: (value) {
            setState(() {
              widget.selectedCommune = value;
              widget.onCommuneChanged!(value);
            });
          },
        ),
        SizedBox(height: 16.0),
        CustomFilePicker(
          label: 'Upload Photos',
          onFileSelected: (fileName) {
            widget.selectedPhotos = fileName;
            widget.onFileSelected(fileName);
          },
        ),
        SizedBox(height: 16.0),
      ],
    );
  }
}
