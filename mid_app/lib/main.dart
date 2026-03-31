import 'package:flutter/material.dart';

void main() => runApp(UniversityApp());

// ============================================================
//  GLOBAL DATA STORAGE (Simple Lists)
// ============================================================
List<Map<String, String>> departments = [];
List<Map<String, String>> users = [];
List<Map<String, String>> students = [];
List<Map<String, String>> lecturers = [];
List<Map<String, String>> courses = [];
List<Map<String, String>> faculties = [];
List<Map<String, String>> roles = [];

// ============================================================
//  MAIN APP
// ============================================================
class UniversityApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'University System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF3F51B5)),
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}

// ============================================================
//  HOME SCREEN - Dashboard with Grid Menu
// ============================================================
class HomeScreen extends StatelessWidget {
  // Each item: title, icon, color, screen key
  final List<Map<String, dynamic>> items = [
    {'title': 'Departments', 'icon': Icons.business,              'color': 0xFF1565C0, 'key': 'dept'},
    {'title': 'Users',       'icon': Icons.person,                'color': 0xFF2E7D32, 'key': 'user'},
    {'title': 'Students',    'icon': Icons.school,                'color': 0xFFE65100, 'key': 'student'},
    {'title': 'Lecturers',   'icon': Icons.supervisor_account,    'color': 0xFF6A1B9A, 'key': 'lecturer'},
    {'title': 'Courses',     'icon': Icons.menu_book,             'color': 0xFFC62828, 'key': 'course'},
    {'title': 'Faculties',   'icon': Icons.account_balance,       'color': 0xFF00695C, 'key': 'faculty'},
    {'title': 'Roles',       'icon': Icons.admin_panel_settings,  'color': 0xFF4E342E, 'key': 'role'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F2FF),
      appBar: AppBar(
        title: Text(
          'University Management System',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Color(0xFF3F51B5),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1.05,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return GestureDetector(
              onTap: () => _navigate(context, item['key']),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Color(item['color']).withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(item['icon'], size: 38, color: Color(item['color'])),
                    ),
                    SizedBox(height: 10),
                    Text(
                      item['title'],
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _navigate(BuildContext context, String key) {
    Widget page;
    switch (key) {
      case 'dept':     page = DepartmentScreen(); break;
      case 'user':     page = UserScreen();       break;
      case 'student':  page = StudentScreen();    break;
      case 'lecturer': page = LecturerScreen();   break;
      case 'course':   page = CourseScreen();     break;
      case 'faculty':  page = FacultyScreen();    break;
      case 'role':     page = RoleScreen();       break;
      default: return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }
}


Widget buildField(TextEditingController ctrl, String label, {bool obscure = false}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 6),
    child: TextField(
      controller: ctrl,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    ),
  );
}


void showSnack(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}

// ============================================================
//  1. DEPARTMENT SCREEN
// ============================================================
class DepartmentScreen extends StatefulWidget {
  @override
  _DepartmentScreenState createState() => _DepartmentScreenState();
}

class _DepartmentScreenState extends State<DepartmentScreen> {
  final nameCtrl = TextEditingController();
  final descCtrl = TextEditingController();

  // Opens dialog to Add or Edit a department
  void _openDialog([int? editIndex]) {
    if (editIndex != null) {
      nameCtrl.text = departments[editIndex]['dept_name']!;
      descCtrl.text = departments[editIndex]['dept_desc']!;
    } else {
      nameCtrl.clear();
      descCtrl.clear();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(editIndex == null ? 'Add Department' : 'Edit Department'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildField(nameCtrl, 'Department Name'),
            buildField(descCtrl, 'Description'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.trim().isEmpty) {
                showSnack(context, 'Name cannot be empty!');
                return;
              }
              setState(() {
                final entry = {
                  'id': DateTime.now().millisecondsSinceEpoch.toString(),
                  'dept_name': nameCtrl.text.trim(),
                  'dept_desc': descCtrl.text.trim(),
                };
                if (editIndex == null) {
                  departments.add(entry);         // ADD
                } else {
                  departments[editIndex] = entry;  // EDIT
                }
              });
              Navigator.pop(context);
            },
            child: Text(editIndex == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Departments'),
        backgroundColor: Color(0xFF1565C0),
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openDialog(),
        backgroundColor: Color(0xFF1565C0),
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: departments.isEmpty
          ? Center(child: Text('No departments yet. Tap + to add one.', style: TextStyle(color: Colors.grey)))
          : ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: departments.length,
              itemBuilder: (_, i) {
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color(0xFF1565C0),
                      child: Text(departments[i]['dept_name']![0].toUpperCase(), style: TextStyle(color: Colors.white)),
                    ),
                    title: Text(departments[i]['dept_name']!, style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(departments[i]['dept_desc']!),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(icon: Icon(Icons.edit, color: Colors.blue), onPressed: () => _openDialog(i)),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => setState(() => departments.removeAt(i)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// ============================================================
//  2. USER SCREEN
// ============================================================
class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final unCtrl    = TextEditingController(); // username
  final fnCtrl    = TextEditingController(); // full name
  final cellCtrl  = TextEditingController();
  final emailCtrl = TextEditingController();
  final addrCtrl  = TextEditingController();
  final passCtrl  = TextEditingController();

  void _openDialog([int? editIndex]) {
    if (editIndex != null) {
      unCtrl.text    = users[editIndex]['user_name']!;
      fnCtrl.text    = users[editIndex]['full_name']!;
      cellCtrl.text  = users[editIndex]['cell']!;
      emailCtrl.text = users[editIndex]['email']!;
      addrCtrl.text  = users[editIndex]['address']!;
      passCtrl.text  = users[editIndex]['password']!;
    } else {
      unCtrl.clear(); fnCtrl.clear(); cellCtrl.clear();
      emailCtrl.clear(); addrCtrl.clear(); passCtrl.clear();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(editIndex == null ? 'Add User' : 'Edit User'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildField(unCtrl,    'Username'),
              buildField(fnCtrl,    'Full Name'),
              buildField(cellCtrl,  'Cell / Phone'),
              buildField(emailCtrl, 'Email'),
              buildField(addrCtrl,  'Address'),
              buildField(passCtrl,  'Password', obscure: true),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (unCtrl.text.trim().isEmpty || emailCtrl.text.trim().isEmpty) {
                showSnack(context, 'Username and Email are required!');
                return;
              }
              setState(() {
                final entry = {
                  'id':        DateTime.now().millisecondsSinceEpoch.toString(),
                  'user_name': unCtrl.text.trim(),
                  'full_name': fnCtrl.text.trim(),
                  'cell':      cellCtrl.text.trim(),
                  'email':     emailCtrl.text.trim(),
                  'address':   addrCtrl.text.trim(),
                  'password':  passCtrl.text.trim(),
                };
                if (editIndex == null) users.add(entry);
                else users[editIndex] = entry;
              });
              Navigator.pop(context);
            },
            child: Text(editIndex == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
        backgroundColor: Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openDialog(),
        backgroundColor: Color(0xFF2E7D32),
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: users.isEmpty
          ? Center(child: Text('No users yet. Tap + to add one.', style: TextStyle(color: Colors.grey)))
          : ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: users.length,
              itemBuilder: (_, i) => Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Color(0xFF2E7D32),
                    child: Text(users[i]['full_name']![0].toUpperCase(), style: TextStyle(color: Colors.white)),
                  ),
                  title: Text(users[i]['full_name']!, style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(users[i]['email']!),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: Icon(Icons.edit, color: Colors.blue), onPressed: () => _openDialog(i)),
                      IconButton(icon: Icon(Icons.delete, color: Colors.red), onPressed: () => setState(() => users.removeAt(i))),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

// ============================================================
//  3. STUDENT SCREEN
//     A Student is linked to a User (dropdown)
// ============================================================
class StudentScreen extends StatefulWidget {
  @override
  _StudentScreenState createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  final regCtrl = TextEditingController();
  String? selectedUserId;

  void _openDialog([int? editIndex]) {
    regCtrl.clear();
    selectedUserId = null;

    if (editIndex != null) {
      regCtrl.text   = students[editIndex]['reg_no']!;
      selectedUserId = students[editIndex]['user_id'];
    }

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          title: Text(editIndex == null ? 'Add Student' : 'Edit Student'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildField(regCtrl, 'Registration Number'),
              SizedBox(height: 8),
              // Dropdown: pick user
              users.isEmpty
                  ? Text('⚠ Add Users first!', style: TextStyle(color: Colors.red))
                  : DropdownButtonFormField<String>(
                      value: selectedUserId,
                      hint: Text('Select User'),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      items: users
                          .map((u) => DropdownMenuItem(value: u['id'], child: Text(u['full_name']!)))
                          .toList(),
                      onChanged: (val) => setS(() => selectedUserId = val),
                    ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (regCtrl.text.trim().isEmpty || selectedUserId == null) {
                  showSnack(context, 'Reg no. and User are required!');
                  return;
                }
                setState(() {
                  final entry = {
                    'id':           DateTime.now().millisecondsSinceEpoch.toString(),
                    'reg_no':       regCtrl.text.trim(),
                    'user_id':      selectedUserId!,
                    'programme_id': '',
                  };
                  if (editIndex == null) students.add(entry);
                  else students[editIndex] = entry;
                });
                Navigator.pop(ctx);
              },
              child: Text(editIndex == null ? 'Add' : 'Update'),
            ),
          ],
        ),
      ),
    );
  }

  // Helper: get user's full name from ID
  String _userName(String userId) {
    try {
      return users.firstWhere((u) => u['id'] == userId)['full_name']!;
    } catch (_) {
      return 'Unknown User';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Students'),
        backgroundColor: Color(0xFFE65100),
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openDialog(),
        backgroundColor: Color(0xFFE65100),
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: students.isEmpty
          ? Center(child: Text('No students yet. Tap + to add one.', style: TextStyle(color: Colors.grey)))
          : ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: students.length,
              itemBuilder: (_, i) => Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Color(0xFFE65100),
                    child: Icon(Icons.school, color: Colors.white, size: 20),
                  ),
                  title: Text(_userName(students[i]['user_id']!), style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Reg No: ${students[i]['reg_no']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: Icon(Icons.edit, color: Colors.blue), onPressed: () => _openDialog(i)),
                      IconButton(icon: Icon(Icons.delete, color: Colors.red), onPressed: () => setState(() => students.removeAt(i))),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

// ============================================================
//  4. LECTURER SCREEN
//     A Lecturer is linked to a User + Faculty (dropdowns)
// ============================================================
class LecturerScreen extends StatefulWidget {
  @override
  _LecturerScreenState createState() => _LecturerScreenState();
}

class _LecturerScreenState extends State<LecturerScreen> {
  String? selectedUserId;
  String? selectedFacultyId;

  void _openDialog([int? editIndex]) {
    selectedUserId    = editIndex != null ? lecturers[editIndex]['user_id']    : null;
    selectedFacultyId = editIndex != null ? lecturers[editIndex]['faculty_id'] : null;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          title: Text(editIndex == null ? 'Add Lecturer' : 'Edit Lecturer'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // User dropdown
              users.isEmpty
                  ? Text('⚠ Add Users first!', style: TextStyle(color: Colors.red))
                  : DropdownButtonFormField<String>(
                      value: selectedUserId,
                      hint: Text('Select User'),
                      decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                      items: users.map((u) => DropdownMenuItem(value: u['id'], child: Text(u['full_name']!))).toList(),
                      onChanged: (val) => setS(() => selectedUserId = val),
                    ),
              SizedBox(height: 10),
              // Faculty dropdown
              faculties.isEmpty
                  ? Text('⚠ Add Faculties first!', style: TextStyle(color: Colors.orange))
                  : DropdownButtonFormField<String>(
                      value: selectedFacultyId,
                      hint: Text('Select Faculty'),
                      decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                      items: faculties.map((f) => DropdownMenuItem(value: f['id'], child: Text(f['faculty_name']!))).toList(),
                      onChanged: (val) => setS(() => selectedFacultyId = val),
                    ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (selectedUserId == null) {
                  showSnack(context, 'Please select a User!');
                  return;
                }
                setState(() {
                  final entry = {
                    'id':         DateTime.now().millisecondsSinceEpoch.toString(),
                    'user_id':    selectedUserId!,
                    'faculty_id': selectedFacultyId ?? '',
                  };
                  if (editIndex == null) lecturers.add(entry);
                  else lecturers[editIndex] = entry;
                });
                Navigator.pop(ctx);
              },
              child: Text(editIndex == null ? 'Add' : 'Update'),
            ),
          ],
        ),
      ),
    );
  }

  String _userName(String userId) {
    try { return users.firstWhere((u) => u['id'] == userId)['full_name']!; }
    catch (_) { return 'Unknown User'; }
  }

  String _facultyName(String facultyId) {
    try { return faculties.firstWhere((f) => f['id'] == facultyId)['faculty_name']!; }
    catch (_) { return 'No Faculty'; }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lecturers'),
        backgroundColor: Color(0xFF6A1B9A),
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openDialog(),
        backgroundColor: Color(0xFF6A1B9A),
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: lecturers.isEmpty
          ? Center(child: Text('No lecturers yet. Tap + to add one.', style: TextStyle(color: Colors.grey)))
          : ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: lecturers.length,
              itemBuilder: (_, i) => Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Color(0xFF6A1B9A),
                    child: Icon(Icons.supervisor_account, color: Colors.white, size: 20),
                  ),
                  title: Text(_userName(lecturers[i]['user_id']!), style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Faculty: ${_facultyName(lecturers[i]['faculty_id']!)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: Icon(Icons.edit, color: Colors.blue), onPressed: () => _openDialog(i)),
                      IconButton(icon: Icon(Icons.delete, color: Colors.red), onPressed: () => setState(() => lecturers.removeAt(i))),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

// ============================================================
//  5. COURSE SCREEN
// ============================================================
class CourseScreen extends StatefulWidget {
  @override
  _CourseScreenState createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  final nameCtrl = TextEditingController();
  final descCtrl = TextEditingController();

  void _openDialog([int? editIndex]) {
    if (editIndex != null) {
      nameCtrl.text = courses[editIndex]['course_name']!;
      descCtrl.text = courses[editIndex]['course_desc']!;
    } else {
      nameCtrl.clear(); descCtrl.clear();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(editIndex == null ? 'Add Course' : 'Edit Course'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildField(nameCtrl, 'Course Name'),
            buildField(descCtrl, 'Description'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.trim().isEmpty) {
                showSnack(context, 'Course name cannot be empty!');
                return;
              }
              setState(() {
                final entry = {
                  'id':          DateTime.now().millisecondsSinceEpoch.toString(),
                  'course_name': nameCtrl.text.trim(),
                  'course_desc': descCtrl.text.trim(),
                };
                if (editIndex == null) courses.add(entry);
                else courses[editIndex] = entry;
              });
              Navigator.pop(context);
            },
            child: Text(editIndex == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Courses'),
        backgroundColor: Color(0xFFC62828),
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openDialog(),
        backgroundColor: Color(0xFFC62828),
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: courses.isEmpty
          ? Center(child: Text('No courses yet. Tap + to add one.', style: TextStyle(color: Colors.grey)))
          : ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: courses.length,
              itemBuilder: (_, i) => Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Color(0xFFC62828),
                    child: Text(courses[i]['course_name']![0].toUpperCase(), style: TextStyle(color: Colors.white)),
                  ),
                  title: Text(courses[i]['course_name']!, style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(courses[i]['course_desc']!),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: Icon(Icons.edit, color: Colors.blue), onPressed: () => _openDialog(i)),
                      IconButton(icon: Icon(Icons.delete, color: Colors.red), onPressed: () => setState(() => courses.removeAt(i))),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

// ============================================================
//  6. FACULTY SCREEN
// ============================================================
class FacultyScreen extends StatefulWidget {
  @override
  _FacultyScreenState createState() => _FacultyScreenState();
}

class _FacultyScreenState extends State<FacultyScreen> {
  final nameCtrl = TextEditingController();
  final descCtrl = TextEditingController();

  void _openDialog([int? editIndex]) {
    if (editIndex != null) {
      nameCtrl.text = faculties[editIndex]['faculty_name']!;
      descCtrl.text = faculties[editIndex]['faculty_desc']!;
    } else {
      nameCtrl.clear(); descCtrl.clear();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(editIndex == null ? 'Add Faculty' : 'Edit Faculty'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildField(nameCtrl, 'Faculty Name'),
            buildField(descCtrl, 'Description'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.trim().isEmpty) {
                showSnack(context, 'Faculty name cannot be empty!');
                return;
              }
              setState(() {
                final entry = {
                  'id':           DateTime.now().millisecondsSinceEpoch.toString(),
                  'faculty_name': nameCtrl.text.trim(),
                  'faculty_desc': descCtrl.text.trim(),
                };
                if (editIndex == null) faculties.add(entry);
                else faculties[editIndex] = entry;
              });
              Navigator.pop(context);
            },
            child: Text(editIndex == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Faculties'),
        backgroundColor: Color(0xFF00695C),
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openDialog(),
        backgroundColor: Color(0xFF00695C),
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: faculties.isEmpty
          ? Center(child: Text('No faculties yet. Tap + to add one.', style: TextStyle(color: Colors.grey)))
          : ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: faculties.length,
              itemBuilder: (_, i) => Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Color(0xFF00695C),
                    child: Text(faculties[i]['faculty_name']![0].toUpperCase(), style: TextStyle(color: Colors.white)),
                  ),
                  title: Text(faculties[i]['faculty_name']!, style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(faculties[i]['faculty_desc']!),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: Icon(Icons.edit, color: Colors.blue), onPressed: () => _openDialog(i)),
                      IconButton(icon: Icon(Icons.delete, color: Colors.red), onPressed: () => setState(() => faculties.removeAt(i))),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

// ============================================================
//  7. ROLE SCREEN
// ============================================================
class RoleScreen extends StatefulWidget {
  @override
  _RoleScreenState createState() => _RoleScreenState();
}

class _RoleScreenState extends State<RoleScreen> {
  final nameCtrl = TextEditingController();
  final descCtrl = TextEditingController();

  void _openDialog([int? editIndex]) {
    if (editIndex != null) {
      nameCtrl.text = roles[editIndex]['role_name']!;
      descCtrl.text = roles[editIndex]['role_desc']!;
    } else {
      nameCtrl.clear(); descCtrl.clear();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(editIndex == null ? 'Add Role' : 'Edit Role'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildField(nameCtrl, 'Role Name'),
            buildField(descCtrl, 'Description'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.trim().isEmpty) {
                showSnack(context, 'Role name cannot be empty!');
                return;
              }
              setState(() {
                final entry = {
                  'id':        DateTime.now().millisecondsSinceEpoch.toString(),
                  'role_name': nameCtrl.text.trim(),
                  'role_desc': descCtrl.text.trim(),
                };
                if (editIndex == null) roles.add(entry);
                else roles[editIndex] = entry;
              });
              Navigator.pop(context);
            },
            child: Text(editIndex == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Roles'),
        backgroundColor: Color(0xFF4E342E),
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openDialog(),
        backgroundColor: Color(0xFF4E342E),
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: roles.isEmpty
          ? Center(child: Text('No roles yet. Tap + to add one.', style: TextStyle(color: Colors.grey)))
          : ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: roles.length,
              itemBuilder: (_, i) => Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Color(0xFF4E342E),
                    child: Text(roles[i]['role_name']![0].toUpperCase(), style: TextStyle(color: Colors.white)),
                  ),
                  title: Text(roles[i]['role_name']!, style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(roles[i]['role_desc']!),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: Icon(Icons.edit, color: Colors.blue), onPressed: () => _openDialog(i)),
                      IconButton(icon: Icon(Icons.delete, color: Colors.red), onPressed: () => setState(() => roles.removeAt(i))),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
