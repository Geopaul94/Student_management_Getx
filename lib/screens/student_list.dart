// ignore_for_file: file_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_management/screens/addStudent.dart';
import '../functions/functions.dart';
import 'model.dart';

class StudentInfo extends StatefulWidget {
  const StudentInfo({super.key});

  @override
  State<StudentInfo> createState() => _StudentInfoState();
}

class _StudentInfoState extends State<StudentInfo> {
  late List<Map<String, dynamic>> _studentsData = [];
  TextEditingController searchController = TextEditingController();
  File? _editedImage;
  @override
  void initState() {
    super.initState();
    _fetchStudentsData();
  }

  Future<void> _fetchStudentsData() async {
    List<Map<String, dynamic>> students = await getAllStudents();
    if (searchController.text.isNotEmpty) {
      students = students
          .where((student) => student['name']
              .toString()
              .toLowerCase()
              .contains(searchController.text.toLowerCase()))
          .toList();
    }
    setState(() {
      _studentsData = students;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue[300],
        title: const Text(
          'STUDENT LIST',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(80),
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {
                      _fetchStudentsData();
                    });
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    labelText: "Search",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            )),
      ),
      body: _studentsData.isEmpty
          ? const Center(child: Text("No Student Available"))
          : ListView.separated(
              itemBuilder: (context, index) {
                final student = _studentsData[index];
                final id = student['id'];
                final imageUrl = student['imageurl'];
                return ListTile(
                  onTap: () {},
                  leading: GestureDetector(
                    onTap: () {
                      if (imageUrl != null) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.file(File(imageUrl)),
                                ],
                              ),
                            );
                          },
                        );
                      }
                    },
                    child: CircleAvatar(
                      backgroundImage:
                          imageUrl != null ? FileImage(File(imageUrl)) : null,
                      child: imageUrl == null ? const Icon(Icons.person) : null,
                    ),
                  ),
                  title: Text(student['name']),
                  subtitle: Text(student['department']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          _showEditDialog(index);
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.red,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext) => AlertDialog(
                                    title: const Text("Delete Student"),
                                    content: const Text(
                                        "Are you sure you want to delete"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                          onPressed: () async {
                                            await deleteStudent(id);
                                            _fetchStudentsData();
                                            Navigator.of(context).pop();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                backgroundColor: Colors.red,
                                                content:
                                                    Text('Delete successfully'),
                                              ),
                                            );
                                          },
                                          child: const Text("Ok"))
                                    ],
                                  ));
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
              itemCount: _studentsData.length,
            ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Push DetailsScreen onto the navigation stack
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddStudent()),
            );
          },
          child: const Icon(Icons.add)),
    ));
  }

  Future _showEditDialog(int index) async {
    final student = _studentsData[index];
    final TextEditingController nameController =
        TextEditingController(text: student['name']);
    final TextEditingController rollnoController =
        TextEditingController(text: student['rollno'].toString());
    final TextEditingController departmentController =
        TextEditingController(text: student['department']);
    final TextEditingController phonenoController =
        TextEditingController(text: student['phoneno'].toString());

    showDialog(
      context: context,
     
      builder: (BuildContext) => AlertDialog(
        title: const Text('Edit Student'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: Colors.purple,
                maxRadius: 60,
                child: GestureDetector(
                  onTap: () async {
                    File? pickedImage = await _pickImageFromGallery();
                    setState(() {
                      _editedImage = pickedImage;
                    });
                  },
                  child: _editedImage != null
                      ? ClipOval(
                          child: Image.file(
                            _editedImage!,
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
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextFormField(
                controller: rollnoController,
                decoration: const InputDecoration(labelText: "Roll No"),
              ),
              TextFormField(
                controller: departmentController,
                decoration: const InputDecoration(labelText: "Department"),
              ),
              TextFormField(
                controller: phonenoController,
                decoration: const InputDecoration(labelText: "Phone No"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await updateStudent(
                StudentModel(
                  id: student['id'],
                  name: nameController.text,
                  department: departmentController.text,
                  rollno: rollnoController.text,
                  phoneno: phonenoController.text,
                  imageurl: _editedImage != null
                      ? _editedImage!.path
                      : student['imageurl'],
                ),
              );

              _fetchStudentsData();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.green,
                  content: Text("Changes Upgrade"),
                ),
              );
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Future<File?> _pickImageFromGallery() async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        return File(pickedImage.path);
      }
      return null;
    } catch (e) {
      print("Image picker error: $e");
      return null;
    }
  }
}
