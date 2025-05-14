import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfilePage2 extends StatefulWidget {
  const ProfilePage2({super.key});

  @override
  State<ProfilePage2> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage2> {
  final TextEditingController _firstNameController =
      TextEditingController(text: 'Olajide Olayinka');
  final TextEditingController _lastNameController =
      TextEditingController(text: 'Williams Olatunji');
  final TextEditingController _phoneController =
      TextEditingController(text: '08060552580');
  final TextEditingController _cityController =
      TextEditingController(text: 'Naga City');
  final TextEditingController _dobController = TextEditingController();

  String _selectedGender = 'Male';
  final List<String> _genders = ['Male', 'Female', 'Other'];

  @override
  void initState() {
    super.initState();
    _dobController.text = DateFormat.yMMMMd().format(DateTime(1981, 12, 12));
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(1981, 12, 12),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _dobController.text = DateFormat.yMMMMd().format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(155, 93, 229, 1),
        elevation: 0,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back, color: Color.fromARGB(255, 0, 0, 0)),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const CircleAvatar(
                radius: 45, backgroundImage: AssetImage('assets/ksi.jpg')),
            const SizedBox(height: 10),
            const Text(
              'Olajide Olayinka Williams Olatunji',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 20),
            _buildTextField(_firstNameController, 'First Name'),
            const SizedBox(height: 10),
            _buildTextField(_lastNameController, 'Last Name'),
            const SizedBox(height: 10),
            _buildTextField(_phoneController, 'Phone Number',
                prefixIcon: const Icon(Icons.phone)),
            const SizedBox(height: 10),
            _buildDropdown(),
            const SizedBox(height: 10),
            _buildTextField(_cityController, 'City'),
            const SizedBox(height: 10),
            _buildDateField(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(155, 93, 229, 1),
                padding:
                    const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Update',
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {Widget? prefixIcon}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF5F1F8),
        prefixIcon: prefixIcon,
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedGender,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF5F1F8),
        labelText: 'Gender',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      items: _genders
          .map((gender) => DropdownMenuItem(
                value: gender,
                child: Text(gender),
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedGender = value!;
        });
      },
    );
  }

  Widget _buildDateField() {
    return TextField(
      controller: _dobController,
      readOnly: true,
      onTap: _pickDate,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF5F1F8),
        labelText: 'Date of Birth',
        suffixIcon: const Icon(Icons.calendar_today, color: Colors.green),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
