import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final bool isPassword;
  final bool isDate;
  final bool isDropdown;
  final String? initialValue;
  final bool readOnly;
  final void Function(String?)? onChanged;
  final TextEditingController? controller;

  const CustomTextField({
    Key? key,
    required this.label,
    this.isPassword = false,
    this.isDate = false,
    this.isDropdown = false,
    this.initialValue,
    this.readOnly = false,
    this.onChanged,
    this.controller,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  String? _selectedWilaya;
  String? _selectedCommune;
  List<String>? _communeNames;

  @override
  void initState() {
    super.initState();
    _loadCommunes();
  }

  Future<void> _loadCommunes() async {
    setState(() {
      _communeNames = [
        'Alger Centre',
        'Sidi Mhamed',
        'El Madania',
        'Belouizdad',
        'Bab El Oued',
        'Bologhine',
        'Casbah',
        'Oued Koriche',
        'Bir Mourad Rais',
        'El Biar',
        'Bouzareah',
        'Birkhadem',
        'El Harrach',
        'Baraki',
        'Oued Smar',
        'Bourouba',
        'Hussein Dey',
        'Kouba',
        'Bachedjerah',
        'Dar El Beida',
        'Bab Azzouar',
        'Ben Aknoun',
        'Dely Ibrahim',
        'El Hammamet',
        'Rais Hamidou',
        'Djasr Kasentina',
        'El Mouradia',
        'Hydra',
        'Mohammadia',
        'Bordj El Kiffan',
        'El Magharia',
        'Beni Messous',
        'Les Eucalyptus',
        'Birtouta',
        'Tassala El Merdja',
        'Ouled Chebel',
        'Sidi Moussa',
        'Ain Taya',
        'Bordj El Bahri',
        'Marsa',
        'Haraoua',
        'Rouiba',
        'Reghaia',
        'Ain Benian',
        'Staoueli',
        'Zeralda',
        'Mahelma',
        'Rahmania',
        'Souidania',
        'Cheraga',
        'Ouled Fayet',
        'El Achour',
        'Draria',
        'Douera',
        'Baba Hassen',
        'Khracia',
        'Saoula',
      ];
    });
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
        if (!widget.isDate && !widget.isDropdown)
          TextFormField(
            controller: widget.controller,
            obscureText: widget.isPassword,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        if (widget.isDate) _buildDateField(context),
        if (widget.isDropdown)
          DropdownButtonFormField<String>(
            hint: Text('Select ${widget.label}'),
            value: widget.initialValue,
            items: widget.label == "Wilaya"
                ? ['Alger'].map((String wilaya) {
                    return DropdownMenuItem<String>(
                      value: wilaya,
                      child: Text(wilaya),
                    );
                  }).toList()
                : _communeNames != null
                    ? _communeNames!
                        .map<DropdownMenuItem<String>>((String communeName) {
                        return DropdownMenuItem<String>(
                          value: communeName,
                          child: Text(communeName),
                        );
                      }).toList()
                    : [],
            onChanged: (newValue) {
              setState(() {
                if (widget.label == "Wilaya") {
                  _selectedWilaya = newValue;
                } else if (widget.label == "Commune") {
                  _selectedCommune = newValue;
                }
              });
              if (widget.onChanged != null) {
                widget.onChanged!(newValue);
              }
            },
          ),
      ],
    );
  }

  Widget _buildDateField(BuildContext context) {
    return TextFormField(
      readOnly: true,
      controller: widget.controller,
      onTap: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );

        if (selectedDate != null) {
          widget.controller?.text = selectedDate.toString();
        }
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.calendar_today),
      ),
    );
  }
}
