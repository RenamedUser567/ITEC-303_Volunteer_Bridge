import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volunteer_bridge/ScreensOrganizer/profile_organizer3.dart';
import 'package:volunteer_bridge/riverpod/organizer_provider.dart';

class CompanyGeneralInfo extends ConsumerStatefulWidget {
  const CompanyGeneralInfo({super.key});

  @override
  ConsumerState<CompanyGeneralInfo> createState() => _CompanyGeneralInfoState();
}

class _CompanyGeneralInfoState extends ConsumerState<CompanyGeneralInfo> {
  late final TextEditingController _orgNameController = TextEditingController();
  late final TextEditingController _phoneController = TextEditingController();
  late final TextEditingController _cityController = TextEditingController();
  late final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final orgData = ref.read(organizerProvider);
      if (orgData != null) {
        _orgNameController.text = orgData.orgName;
        _phoneController.text = orgData.phoneNumber;
        _cityController.text = orgData.companyAddress;
        _emailController.text = orgData.email;
      }
    });
  }

  @override
  void dispose() {
    _orgNameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(155, 93, 229, 1),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 45,
              backgroundImage: AssetImage('assets/mercedes-benz.jpg'),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(155, 93, 229, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text("General Information"),
                ),
                const SizedBox(width: 10),
                OutlinedButton(
                  onPressed: () {
                    // Navigate to profile_organizer3.dart
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CompanyDescription(),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Color.fromRGBO(155, 93, 229, 1),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text("Description"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Company Name
            _buildTextField(_orgNameController, 'Company Name',
                prefixIcon: const Icon(Icons.business)),
            const SizedBox(height: 10),
            _buildTextField(_phoneController, 'Company Number',
                prefixIcon: const Icon(Icons.phone)),
            const SizedBox(height: 10),
            _buildTextField(_cityController, 'Company Address',
                prefixIcon: const Icon(Icons.location_city)),
            const SizedBox(height: 10),
            _buildTextField(_emailController, 'Email',
                readOnly: true, prefixIcon: const Icon(Icons.email)),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                final notifier = ref.read(organizerProvider.notifier);
                final currentOrg = ref.read(organizerProvider);

                if (currentOrg == null) return;

                final updatedOrg = currentOrg.copyWith(
                  orgName: _orgNameController.text.trim(),
                  phoneNumber: _phoneController.text.trim(),
                  companyAddress: _cityController.text.trim(),
                );

                await notifier.updateOrganizer(updatedOrg);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile updated successfully')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(155, 93, 229, 1),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Update",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    Widget? prefixIcon,
    bool? readOnly,
  }) {
    final isReadOnly = readOnly ?? controller.text.isNotEmpty;

    return TextField(
      controller: controller,
      readOnly: isReadOnly,
      enabled: !isReadOnly,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF5F1F8),
        prefixIcon: prefixIcon,
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
