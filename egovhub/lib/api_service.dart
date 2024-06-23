import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'appGlobals.dart';

class ApiService {
  static const String baseUrl =
      'https://locally-ready-bass.ngrok-free.app'; // Updated URL with 'http://'

  Future<Map<String, dynamic>> fetchData() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print('Received data: $jsonData'); // Log received data
      return jsonData;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> sendData(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      print('Data sent successfully: $data'); // Log sent data
    } else {
      throw Exception('Failed to send data');
    }
  }

  Future<Map<String, dynamic>> loginUser(
      String email, String password, BuildContext context) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print('Login successful. Token: ${jsonData['token']}');

      // Decode the token to extract user information
      Map<String, dynamic> decodedToken = JwtDecoder.decode(jsonData['token']);

      // Extract user ID from the decoded token
      String? userId = decodedToken['userId'];
      print('Extracted User ID: $userId');
      AppGlobals().setUserId(userId);
      String? test = AppGlobals().userId;
      print('Test User ID: $test');

      // Extract commune from the decoded token
      String? commune = decodedToken['commune'];
      print('Extracted Commune: $commune');
      AppGlobals().setCommun(commune);
      String? communeTest = AppGlobals().commun;
      print('Test Commune: $communeTest');

      AppGlobals().setToken(jsonData['token']);
      String? tokenTest = AppGlobals().token;
      print('Test Token: $tokenTest');

      // Set the user ID into the global state
      Provider.of<UserProvider>(context, listen: false).setUserId(userId);

      if (userId != null) {
        return jsonData;
      } else {
        throw Exception('User ID is missing in the API response.');
      }
    } else {
      throw Exception('Failed to login. Status code: ${response.statusCode}');
    }
  }

  Future<void> uploadFile(File file) async {
    var fileName = file.path.split('/').last; // Extract filename from file path
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/upload'),
    );

    // Attach the file to the request
    request.files.add(
      http.MultipartFile(
        'files[]', // Name of the field in the form data
        file.readAsBytes().asStream(), // File stream
        file.lengthSync(), // Length of the file
        filename: fileName, // Filename to be used on the server
      ),
    );

    print('Uploading file...');

    try {
      // Send the request and get the response
      var response = await request.send();

      // Check the response status
      if (response.statusCode == 200) {
        print('File uploaded successfully');
      } else {
        print('Failed to upload file: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error uploading file: $error');
    }
  }

  Future<void> verifyToken(String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/verify-token'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'token': token}),
    );
    if (response.statusCode == 200) {
      print('Token verification successful.');
    } else {
      throw Exception(
          'Failed to verify token. Status code: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> registerUser(
      Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register/registrations'), // Updated URL
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(userData),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print('User registration successful. Data: $jsonData');
      return jsonData;
    } else {
      throw Exception(
          'Failed to register user. Status code: ${response.statusCode}');
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllPublications() async {
    final response =
        await http.get(Uri.parse('$baseUrl/publication/publications'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body) as List;
      List<Map<String, dynamic>> publications =
          jsonData.map((item) => item as Map<String, dynamic>).toList();
      print('Received publications: $publications');
      return publications;
    } else {
      throw Exception('Failed to load publications');
    }
  }

  Future<void> updatePublication(
      String publicationId, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse(
          '$baseUrl/publication/publications/$publicationId'), // Updated URL
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      print('Publication updated successfully: $data');
    } else {
      throw Exception('Failed to update publication');
    }
  }

  Future<Map<String, dynamic>> fetchUserInformation(String? token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/general/user'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token', // Include authorization token
      },
    );
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print('Received user information: $jsonData');
      return jsonData;
    } else {
      throw Exception('Failed to load user information');
    }
  }

  Future<void> sendEmail(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse(
            '$baseUrl/emails'), // Update with your backend endpoint for sending emails
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'Bearer ${AppGlobals().token}', // Include authorization token if required
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print('Email sent successfully: $data');
      } else {
        throw Exception(
            'Failed to send email. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error sending email: $error');
      throw Exception('Failed to send email: $error');
    }
  }
}
