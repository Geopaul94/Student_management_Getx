import 'package:sqflite/sqflite.dart';
import '../screens/model.dart';

late Database _db;

Future<void> initializeDatabase() async {
  _db = await openDatabase(
    "student.db",
    version: 1,
    onCreate: (Database db, int version) async {
      await db.execute(
        "CREATE TABLE student (id INTEGER PRIMARY KEY,rollno INTEGER, name TEXT, age INTEGER ,department TEXT, phoneno REAL, imageurl);",
      );
    },
  );
}

Future<void> addStudent(StudentModel value) async {
  await _db.rawInsert(
    "INSERT INTO student (id, name,age, rollno, department, phoneno, imageurl) VALUES(?, ?,?, ?, ?, ?, ?)",
    [
      value.id,
      value.name,
     // value.age,
      value.rollno,
      value.department,
      value.phoneno,
      value.imageurl
    ],
  );
}

Future<List<Map<String, dynamic>>> getAllStudents() async {
  final values = await _db.rawQuery("SELECT * FROM student");
  return values;
}

Future<void> deleteStudent(int id) async {
  await _db.rawDelete('DELETE FROM student WHERE id = ?', [id]);
}

Future<void> updateStudent(StudentModel updateStudent) async {
  await _db.update(
    'student',
    {
      'rollno': updateStudent.rollno,
      'name': updateStudent.name,
    //  'age': updateStudent.age,
      'department': updateStudent.department,
      'phoneno': updateStudent.phoneno,
      'imageurl': updateStudent.imageurl,
    },
    where: 'id = ?',
    whereArgs: [updateStudent.id],
  );
}
