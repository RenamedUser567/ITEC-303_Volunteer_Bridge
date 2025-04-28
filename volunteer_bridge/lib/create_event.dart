// create_event.dart
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Form field controllers
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _startDateController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endDateController = TextEditingController();
  final _endTimeController = TextEditingController();
  final _locationController = TextEditingController();
  final _volunteersController = TextEditingController();
  
  // Image picker
  final ImagePicker _picker = ImagePicker();
  File? _bannerImage;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _startDateController.dispose();
    _startTimeController.dispose();
    _endDateController.dispose();
    _endTimeController.dispose();
    _locationController.dispose();
    _volunteersController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _bannerImage = File(image.path);
        });
      }
    } catch (e) {
      // Handle exception
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to pick image')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(155, 93, 229, 1),
        title: const Text('Create Event', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.black),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Save event logic here
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header section with icon
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: const Icon(Icons.handshake_outlined, size: 24),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Setup a Volunteer Event',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Event Title
                const Text('Event Title', style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'Event Title',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an event title';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Event Description
                const Text('Event Description', style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Event Description',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  maxLines: 4,
                ),
                
                const SizedBox(height: 16),
                
                // Start Time
                const Text('Start Time', style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _startDateController,
                        decoration: InputDecoration(
                          hintText: 'Start Date',
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: const Icon(Icons.calendar_today, size: 18),
                        ),
                        readOnly: true,
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (date != null) {
                            setState(() {
                              _startDateController.text = "${date.month}/${date.day}/${date.year}";
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _startTimeController,
                        decoration: InputDecoration(
                          hintText: 'Time',
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: const Icon(Icons.access_time, size: 18),
                        ),
                        readOnly: true,
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (time != null) {
                            setState(() {
                              _startTimeController.text = time.format(context);
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // End Time
                const Text('End Time', style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _endDateController,
                        decoration: InputDecoration(
                          hintText: 'End Date',
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: const Icon(Icons.calendar_today, size: 18),
                        ),
                        readOnly: true,
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (date != null) {
                            setState(() {
                              _endDateController.text = "${date.month}/${date.day}/${date.year}";
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _endTimeController,
                        decoration: InputDecoration(
                          hintText: 'Time',
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: const Icon(Icons.access_time, size: 18),
                        ),
                        readOnly: true,
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (time != null) {
                            setState(() {
                              _endTimeController.text = time.format(context);
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Location
                const Text('Location', style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    hintText: 'Location',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Number of Volunteers
                const Text('Number of Volunteers', style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _volunteersController,
                  decoration: InputDecoration(
                    hintText: 'Number',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                
                const SizedBox(height: 16),
                
                // Attach Banner
                const Text('Attach Banner:', style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.attach_file, size: 18, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          _bannerImage != null ? 'Banner attached' : 'Attach Banner',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ),
                
                if (_bannerImage != null) ...[
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      _bannerImage!,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
                
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}