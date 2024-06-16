import 'package:flutter/material.dart';
import '../appGlobals.dart'; // Import AppGlobals
import '../api_service.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    try {
      // Fetch user information using the token
      String? tokenString = AppGlobals().token;
      final userData = await ApiService().fetchUserInformation(tokenString);
      setState(() {
        _userData = userData;
      });
    } catch (error) {
      print('Error fetching user information: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF072923),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'User Profile',
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10.0),
              if (_userData != null) ...[
                Row(
                  children: [
                    Chip(
                      label: Text(_userData!['role']),
                      backgroundColor: Colors.blueAccent,
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    SizedBox(width: 5.0),
                    Chip(
                      label: Text(_userData!['status']),
                      backgroundColor: Colors.greenAccent,
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                ProfileInfoItem(
                  label: 'User ID',
                  value: _userData!['_id'],
                  icon: Icons.person_outline,
                ),
                ProfileDivider(),
                ProfileInfoItem(
                  label: 'Name',
                  value: '${_userData!['firstName']} ${_userData!['lastName']}',
                  icon: Icons.account_box_outlined,
                ),
                ProfileDivider(),
                ProfileInfoItem(
                  label: 'Email',
                  value: _userData!['email'],
                  icon: Icons.email_outlined,
                ),
                ProfileDivider(),
                ProfileInfoItem(
                  label: 'Commune',
                  value: AppGlobals().commun ?? 'Not available',
                  icon: Icons.location_city_outlined,
                ),
              ] else ...[
                Text(
                  'User information not available',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.red,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileInfoItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  ProfileInfoItem(
      {required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Colors.teal,
          ),
          SizedBox(width: 10.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 5.0),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProfileDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Colors.grey[400],
      thickness: 1.0,
      height: 20.0,
    );
  }
}
