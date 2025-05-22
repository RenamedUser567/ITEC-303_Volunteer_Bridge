import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:volunteer_bridge/riverpod/volunteer_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage2 extends ConsumerStatefulWidget {
  const ProfilePage2({super.key});

  @override
  ConsumerState<ProfilePage2> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage2> {
  late final TextEditingController _firstNameController;
  //TextEditingController(text: 'Olajide Olayinka');
  late final TextEditingController _lastNameController;
  //TextEditingController(text: 'Williams Olatunji');
  late final TextEditingController _phoneController;
  //TextEditingController(text: '08060552580');
  late final TextEditingController _cityController;
  //TextEditingController(text: 'Naga City');
  late final TextEditingController _dobController;

  String _selectedGender = 'Male';
  final List<String> _genders = ['Male', 'Female', 'Other'];
  File? _pickedImage;

  @override
  void initState() {
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _phoneController = TextEditingController();
    _cityController = TextEditingController();
    _dobController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final volData = ref.read(volunteerProvider);
      if (volData != null) {
        _firstNameController.text = volData.firstName;
        _lastNameController.text = volData.lastName;
        _phoneController.text = volData.contactNumber;
        _dobController.text = DateFormat.yMMMMd().format(volData.birthDate);
        _cityController.text = volData.address;
        _selectedGender = volData.gender;
      }
    });

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
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final volData = ref.watch(volunteerProvider);

    ImageProvider profileImage;
    if (_pickedImage != null) {
      profileImage = FileImage(_pickedImage!);
    } else if (volData?.profileUrl != null && volData!.profileUrl.isNotEmpty) {
      if (volData.profileUrl.startsWith('http')) {
        profileImage = NetworkImage(volData.profileUrl);
      } else {
        profileImage = const AssetImage('assets/placeholder.jpg'); // fallback
      }
    } else {
      profileImage = const AssetImage('assets/placeholder.jpg');
    }

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
            GestureDetector(
              onTap: () async {
                File? image = await pickImage();
                if (image != null) {
                  setState(() {
                    _pickedImage = image;
                  });
                }
              },
              child: CircleAvatar(
                radius: 45,
                backgroundImage: profileImage,
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.white,
                  child:
                      Icon(Icons.camera_alt, size: 16, color: Colors.grey[700]),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${volData?.firstName} ${volData?.lastName}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
              onPressed: () async {
                final notifier = ref.read(volunteerProvider.notifier);
                final currentVol = ref.read(volunteerProvider);

                if (currentVol == null) return;

                //String? newProfileUrl;

                /*
                if (_pickedImage != null) {
                  newProfileUrl = await uploadImageToFirebase(_pickedImage!);
                }
                */

                final updatedVol = currentVol.copyWith(
                  firstName: _firstNameController.text.trim(),
                  lastName: _lastNameController.text.trim(),
                  contactNumber: _phoneController.text.trim(),
                  birthDate:
                      DateFormat.yMMMMd().parse(_dobController.text.trim()),
                  address: _cityController.text.trim(),
                  gender: _selectedGender,
                );

                await notifier.updateVolunteer(updatedVol);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile updated successfully')),
                );
              },
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

Future<File?> pickImage() async {
  final ImagePicker picker = ImagePicker();
  final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    return File(pickedFile.path);
  }
  return null;
}

Future<String> uploadImageToFirebase(File imageFile) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not logged in');

    final storageRef = FirebaseStorage.instance.ref();
    final imageRef = storageRef.child('profile_images/${user.uid}.jpg');

    // Upload image
    final uploadTask = imageRef.putFile(imageFile);
    final snapshot = await uploadTask.whenComplete(() {});

    // Get and return the download URL
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  } catch (e) {
    rethrow;
  }
}
