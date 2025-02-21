import 'package:flutter/material.dart';
import 'package:gpa_calculator/Floating_Window.dart';
import 'package:gpa_calculator/Model.dart';

class Calcluting_GPA extends StatefulWidget {
  const Calcluting_GPA({super.key});

  @override
  State<Calcluting_GPA> createState() => _Calcluting_GPAState();
}

class _Calcluting_GPAState extends State<Calcluting_GPA>
    with TickerProviderStateMixin {
  List<Course> courses = [];
  int _sumOfObtained = 0;
  int _sumOfCr = 0;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.forward();
  }

  //TODO ---------- All Functions --------------------
  void _calculateSums() {
    _sumOfObtained = 0;
    _sumOfCr = 0;
    for (var course in courses) {
      _sumOfObtained += course.obtainedMarks;
      _sumOfCr += getTotalMarks(course.creditHours);
    }
  }

  double _calculatePercentage() {
    if (_sumOfObtained == 0 || _sumOfCr == 0) {
      return 0.0;
    } else {
      return _sumOfObtained / _sumOfCr; // use double division
    }
  }

  double _calculateGPA() {
    double percentage = _calculatePercentage() * 100;
    if (percentage >= 80) {
      return 4.00;
    } else if (percentage >= 65) {
      return 3.00;
    } else if (percentage >= 50) {
      return 2.00;
    } else if (percentage >= 40) {
      return 1.00;
    } else {
      return 0.00;
    }
  }

  int getTotalMarks(int creditHours) {
    switch (creditHours) {
      case 1:
        return 20;
      case 2:
        return 40;
      case 3:
        return 60;
      case 4:
        return 80;
      default:
        return 0;
    }
  }

//TODO ---------- All Functions --------------------
  @override
  Widget build(BuildContext context) {
    _calculateSums();
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 60),
          child: Text(
            'GPA Calculator',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        backgroundColor: Colors.indigoAccent,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.indigoAccent,
              ),
              child: Padding(
                padding: EdgeInsets.all(28.0),
                child: Text(
                  'GPA Information',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
            ListTile(
              title: const Text('GPA Criteria'),
              trailing: const Icon(Icons.arrow_right),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => const AlertDialog(
                    backgroundColor: Colors.white,
                    title: Center(child: Text('GPA Criteria')),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('A+: 80 - 100%'),
                        Text('A: 65 - 79%'),
                        Text('B: 50 - 64%'),
                        Text('C: 40 - 49%'),
                        Text('D: 0 - 39%'),
                      ],
                    ),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('GPA Calculation Formula'),
              trailing: const Icon(Icons.arrow_right),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => const AlertDialog(
                    backgroundColor: Colors.white,
                    title: Text(
                      'GPA Calculation Formula',
                      style: TextStyle(fontSize: 20),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                            'GPA = (Total Obtained Marks of all subjects / Total Marks of all subject) * 100'),
                        SizedBox(height: 5),
                        Divider(),
                        SizedBox(height: 5),
                        Text(
                            'Percentage = (Total Obtained Marks / Total Marks) * 100'),
                      ],
                    ),
                  ),
                );
              },
            ),
            const Divider(),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              height: 165,
              decoration: const BoxDecoration(
                color: Color.fromARGB(90, 184, 179, 167),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 19.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'GPA:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Text(
                        '${_calculateGPA().toStringAsFixed(2)}/4.00',
                        style: const TextStyle(
                          fontSize: 18.0,
                        ),
                      ), // obtained GPA and total GPA
                      const Divider(),
                      const Text(
                        'Marks:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Text(
                        '$_sumOfObtained/$_sumOfCr',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  ScaleTransition(
                    scale: _animation,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: CircularProgressIndicator(
                            value: double.parse(
                                _calculatePercentage().toStringAsFixed(2)),
                            strokeWidth: 18.0,
                            backgroundColor: Colors.grey,
                            color: Colors.indigoAccent,
                          ),
                        ),
                        Text(
                          '${(_calculatePercentage() * 100).toStringAsFixed(1)}%',
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigoAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7),
              child: Stack(
                children: [
                  ListView.builder(
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      Course course = courses[index];
                      return buildCourseItem(course, index);
                    },
                  ),
                  if (courses.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 35.0),
                      child: Center(
                        child: Text(
                          'Start calculating your GPA by adding a course below.',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 128, 124, 112)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigoAccent,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          Course? newCourse = await showDialog<Course>(
            context: context,
            builder: (context) => const MyDialog(),
          );
          if (newCourse != null) {
            setState(() {
              courses.add(newCourse);
            });
          }
        },
      ),
    );
  }

  Widget buildCourseItem(Course course, int index) {
    int totalMarks = getTotalMarks(course.creditHours);
    double percentage = (course.obtainedMarks / totalMarks) * 100;

    return Padding(
      padding: const EdgeInsets.only(bottom: 1),
      child: Card(
        color: Colors.white,
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(9.0),
          child: ListTile(
            leading: null, // remove the leading property
            title: Text(
              course.courseName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Obtained Marks: ${course.obtainedMarks}',
                  style: const TextStyle(
                      fontSize: 16, color: Color.fromARGB(235, 107, 104, 95)),
                ),
                Text(
                  'Percentage: ${percentage.toStringAsFixed(2)}%',
                  style: const TextStyle(
                      fontSize: 16, color: Color.fromARGB(235, 107, 104, 95)),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  color: Colors.indigoAccent,
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    Course? updatedCourse = await showDialog<Course>(
                      context: context,
                      builder: (context) => MyDialog(
                        initialCourse: course,
                      ),
                    );
                    if (updatedCourse != null) {
                      setState(() {
                        courses[index] = updatedCourse;
                      });
                    }
                  },
                ),
                IconButton(
                  color: Colors.red,
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      courses.removeAt(index);
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
