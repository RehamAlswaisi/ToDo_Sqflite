import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/task_controller.dart';
import '../../models/task.dart';
import '../theme.dart';
import '../widgets/button.dart';
import '../widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  DateTime _selectedDate = DateTime.now();

  late String _startTime =
      DateFormat('hh:mm a').format(DateTime.now()).toString();
  late String _endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(minutes: 15)))
      .toString();

  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];

  String _selectedRepeat = 'None';
  List<String> repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];

  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _myAppBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
            child: Column(
          children: [
            Text('Add Task', style: Themes.headingStyle),
            InputField(
              title: 'Title',
              hint: 'Enter title here',
              controller: _titleController,
            ),
            InputField(
              title: 'Note',
              hint: 'Enter note here',
              controller: _noteController,
            ),
            InputField(
              title: 'Date',
              hint: DateFormat().add_yMd().format(_selectedDate),
              widget: IconButton(
                  icon: const Icon(Icons.calendar_today, color: Colors.grey),
                  onPressed: () {
                    _getDateFromUser();
                  }),
            ),
            Row(
              children: [
                Expanded(
                    child: InputField(
                  title: 'Start Time',
                  hint: _startTime,
                  widget: IconButton(
                      icon: const Icon(Icons.access_time, color: Colors.grey),
                      onPressed: () {
                        _getTimeFromUser(isStartDate: true);
                      }),
                )),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: InputField(
                  title: 'End Time',
                  hint: _endTime,
                  widget: IconButton(
                      icon: const Icon(Icons.access_time, color: Colors.grey),
                      onPressed: () {
                        _getTimeFromUser(isStartDate: false);
                      }),
                ))
              ],
            ),
            InputField(
              title: 'Remind',
              hint: '$_selectedRemind minutes early',
              widget: Row(
                children: [
                  DropdownButton(
                    dropdownColor: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(10),
                    items: remindList.map((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Text('$e'),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedRemind = int.parse(newValue.toString());
                      });
                    },
                    style: Themes.subTitleStyle,
                    underline: Container(
                      height: 0,
                    ),
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                ],
              ),
            ),
            InputField(
              title: 'Repeat',
              hint: _selectedRepeat,
              widget: Row(
                children: [
                  DropdownButton(
                    dropdownColor: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(10),
                    items: repeatList.map((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedRepeat = newValue.toString();
                      });
                    },
                    style: Themes.subTitleStyle,
                    underline: Container(
                      height: 0,
                    ),
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                myColorPalette(1),
                MyButton(
                    lable: 'Create Task',
                    onTap: () {
                      //Get.back();
                      _validateDate();
                    })
              ],
            ),
          ],
        )),
      ),
    );
  }

  AppBar _myAppBar() {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          size: 24,
          color: primaryClr,
        ),
        onPressed: (() {
          _taskController.setTaskInList();
          Get.back();
        }),
      ),
      actions: const [
        CircleAvatar(
          backgroundImage: AssetImage('images/person.jpeg'),
          radius: 15,
        ),
        SizedBox(
          width: 15,
        )
      ],
    );
  }

  Column myColorPalette(int selectedCurrentColor) {
    return Column(
      children: [
        Text(
          'Colors',
          style: titleStyle,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            myCircleAvatar(0, Colors.red),
            myCircleAvatar(1, Colors.purple),
            myCircleAvatar(2, Colors.blue),
          ],
        )
      ],
    );
  }

  GestureDetector myCircleAvatar(int selectedCurrentColor, Color c) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedColor = selectedCurrentColor;
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: CircleAvatar(
          backgroundColor: c,
          radius: 16, //for size
          child: _selectedColor == selectedCurrentColor
              ? const Icon(
                  Icons.done,
                  size: 16,
                  color: Colors.white,
                )
              : null,
        ),
      ),
    );
  }

  _addNewTaskTODO() async {
    Task t = Task(
        title: _titleController.text,
        note: _noteController.text,
        dates: DateFormat.yMd().format(_selectedDate),
        startTime: _startTime,
        endTime: _endTime,
        color: _selectedColor,
        isCompleted: 0,
        remind: _selectedRemind,
        repeat: _selectedRepeat);
    print('Create Task :::::::::::::::::::::::::::: $t');
    var val = await _taskController.addTask(task: t);
    print('ID IN DB IS: $val');
    _taskController.setTaskInList();
    Get.back();
  }

  _validateDate() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addNewTaskTODO();
    } else {
      Get.snackbar('Error', 'Enter Title and Note',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: pinkClr,
          icon: const Icon(Icons.warning));
    }
  }

  void _getDateFromUser() async {
    DateTime? _pikDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2080));
    if (_pikDate != null) {
      setState(() {
        _selectedDate = _pikDate;
      });
    }
  }

  void _getTimeFromUser({required bool isStartDate}) async {
    TimeOfDay? _tod = await showTimePicker(
        context: context,
        initialTime: isStartDate
            ? TimeOfDay.fromDateTime(DateTime.now())
            : TimeOfDay.fromDateTime(
                DateTime.now().add(const Duration(minutes: 30))));
    if (_tod != null) {
      setState(() {
        if (isStartDate) {
          _startTime = _tod.format(context);
        } else {
          _endTime = _tod.format(context);
        }
      });
    }
  }
}
