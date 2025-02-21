import 'package:flutter/material.dart';
import 'package:gpa_calculator/Model.dart';

class MyDialog extends StatefulWidget {
  final Course? initialCourse;

  const MyDialog({super.key, this.initialCourse});

  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> with TickerProviderStateMixin {
  int? _selectedOption;
  TextEditingController _courseNameController = TextEditingController();
  TextEditingController _obtainedMarksController = TextEditingController();
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.forward();
    if (widget.initialCourse != null) {
      _courseNameController.text = widget.initialCourse!.courseName;
      _obtainedMarksController.text =
          widget.initialCourse!.obtainedMarks.toString();
      _selectedOption = widget.initialCourse!.creditHours;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: ScaleTransition(
        scale: _animation,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Ad Details',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigoAccent),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _courseNameController,
                decoration: const InputDecoration(
                  labelText: 'Course Name',
                ),
              ),
              TextField(
                controller: _obtainedMarksController,
                decoration: const InputDecoration(
                  labelText: 'Obtained Marks',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              DropdownButton<int>(
                value: _selectedOption,
                onChanged: (value) {
                  setState(() {
                    _selectedOption = value;
                  });
                },
                items: const [
                  DropdownMenuItem(
                    value: 1,
                    child: Center(
                        child: Text(
                      '1 - Credit Hour',
                      style: TextStyle(fontSize: 16),
                    )),
                  ),
                  DropdownMenuItem(
                    value: 2,
                    child: Center(
                        child: Text('2 - Credits Hour',
                            style: TextStyle(fontSize: 16))),
                  ),
                  DropdownMenuItem(
                    value: 3,
                    child: Center(
                        child: Text('3 - Credit Hour',
                            style: TextStyle(fontSize: 16))),
                  ),
                  DropdownMenuItem(
                    value: 4,
                    child: Center(
                        child: Text('4 - Credit Hour',
                            style: TextStyle(fontSize: 16))),
                  ),
                ],
                hint: const Text('Select Credit Hours',
                    style: TextStyle(color: Colors.grey)),
                dropdownColor: Colors.white,
                icon: const Icon(Icons.arrow_drop_down,
                    color: Colors.indigoAccent),
                style: const TextStyle(color: Color.fromARGB(255, 24, 38, 117)),
                underline: Container(
                  height: 2,
                  color: Colors.indigoAccent,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_courseNameController.text.isEmpty ||
                      _obtainedMarksController.text.isEmpty ||
                      _selectedOption == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill all the fields'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else {
                    int creditHours = _selectedOption ?? 0;
                    Course updatedCourse = Course(
                      courseName: _courseNameController.text,
                      obtainedMarks: int.parse(_obtainedMarksController.text),
                      creditHours: creditHours,
                    );
                    Navigator.of(context).pop(updatedCourse);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigoAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
