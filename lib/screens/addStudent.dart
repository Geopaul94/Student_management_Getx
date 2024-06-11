import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_management/screens/model.dart';
import 'package:student_management/screens/student_list.dart';
import '../functions/functions.dart';

class AddStudent extends StatefulWidget {
  const AddStudent({super.key});

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final _formkey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _rollnoController = TextEditingController();
  final _departmentController = TextEditingController();
  final _phonenoController = TextEditingController();
  File? _selectedImage;
  void clearControllers() {
    _rollnoController.text = '';
    _nameController.text = '';
    _departmentController.text = '';
    _phonenoController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'STUDENT INFORMATION',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blueAccent,
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const StudentInfo()));
              },
              icon: const Icon(
                Icons.person_search,
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Form(
              key: _formkey,
              child: Column(children: [
                CircleAvatar(
                  backgroundColor: Colors.green[200],
                  maxRadius: 60,
                  child: GestureDetector(
                    onTap: () async {
                      File? pickimage = await _pickImageFromCamer();
                      setState(() {
                        _selectedImage = pickimage;
                      });
                    },
                    child: _selectedImage != null
                        ? ClipOval(
                            child: Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                              width: 140,
                              height: 140,
                            ),
                          )
                        : const Icon(
                            Icons.add_a_photo_rounded,
                            color: Colors.black,
                          ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  keyboardType: TextInputType.name,
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Student Name",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Name is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _rollnoController,
                  decoration: const InputDecoration(
                    labelText: "Roll Number",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Roll Number is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  keyboardType: TextInputType.name,
                  controller: _departmentController,
                  decoration: const InputDecoration(
                    labelText: "Department",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Department is Required";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _phonenoController,
                  decoration: const InputDecoration(
                    labelText: "Phone Number",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Phone Number is required";
                    }
                    final phonRegExp = RegExp(r'^[0-9]{10}$');
                    if (!phonRegExp.hasMatch(value)) {
                      return 'Invalid phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 45,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (_formkey.currentState!.validate()) {
                          if (_selectedImage == null) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(
                                'You Must select an image',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ));
                            return;
                          }
                          final student = StudentModel(
                            name: _nameController.text,
                            department: _departmentController.text,
                            rollno: _rollnoController.text,
                            phoneno: _phonenoController.text,
                            imageurl: _selectedImage != null
                                ? _selectedImage!.path
                                : null,
                          );
                          await addStudent(student);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.blue,
                              content: Text(
                                'Student Details Added Successfully',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                          _rollnoController.clear();
                          _nameController.clear();
                          _departmentController.clear();
                          _phonenoController.clear();
                          setState(() {
                            _selectedImage = null;
                          });
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const StudentInfo()),
                          );
                        }
                      },
                      child: const Text(
                        "Save",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 45, vertical: 10),
                          backgroundColor: Colors.green),
                    ),
                    ElevatedButton(
                      onPressed: clearControllers,
                      child: const Text(
                        'Clear',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 45, vertical: 10),
                          backgroundColor: Colors.red),
                    ),
                  ],
                ),
              ])),
        ),
      ),
    );
  }

  Future<File?> _pickImageFromCamer() async {
    final pickedimage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedimage != null) {
      return File(pickedimage.path);
    }
    return null;
  }
}
