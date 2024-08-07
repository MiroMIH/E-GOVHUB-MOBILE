import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../api_service.dart'; // Import your ApiService class

class CustomFilePicker extends StatefulWidget {
  final String label;
  final Function(String?) onFileSelected; // Callback function

  const CustomFilePicker({
    Key? key,
    required this.label,
    required this.onFileSelected,
  }) : super(key: key);

  @override
  _CustomFilePickerState createState() => _CustomFilePickerState();
}

class _CustomFilePickerState extends State<CustomFilePicker> {
  final ApiService _apiService = ApiService();
  File? _pickedImage;
  String? _selectedFileName;

  Future<void> _pickImage() async {
    final pickedImageFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImageFile == null) {
      return;
    }
    final pickedImage = File(pickedImageFile.path);
    setState(() {
      _pickedImage = pickedImage;
      _selectedFileName = pickedImage.path.split('/').last;
    });

    widget.onFileSelected(_selectedFileName); // Call the callback function
    if (_pickedImage != null) {
      await _apiService.uploadFile(_pickedImage!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.0),
        ElevatedButton(
          onPressed: _pickImage,
          child: Text('Choose File'),
        ),
        SizedBox(height: 8.0),
        if (_pickedImage != null)
          Text(
            'Selected File: $_selectedFileName',
          ),
      ],
    );
  }
}
