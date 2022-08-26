import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../controllers/task_controller.dart';
import '../../db/db_helper.dart';
import '../../models/task.dart';
import '../../services/notification_services.dart';
import '../../services/theme_services.dart';
import '../size_config.dart';
import '../theme.dart';
import '../widgets/button.dart';
import '../widgets/task_tile.dart';
import 'add_task_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TaskController _taskController = Get.put(TaskController());
  DateTime _SelectedDate = DateTime.now();
  late NotifyHelper _notifyhelper;
  getDB() async {
    bool isInit = await DBHelper().initDB();

    if (!isInit) {
      Get.snackbar('Error DB', 'Error in Initialized Database!',
          duration: const Duration(seconds: 30),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: pinkClr,
          icon: const Icon(
            Icons.warning,
            color: Colors.red,
          ));
    }
  }

  @override
  void initState() {
    super.initState();
    getDB();
    _notifyhelper = NotifyHelper();
    _notifyhelper.requestIOSPermissions();
    _notifyhelper.initializeNotification();
    _taskController.setTaskInList();
    print("initState");
    print(_SelectedDate);
    /*WidgetsBinding.instance.addPostFrameCallback((_) {
      print("WidgetsBinding");
    });
    SchedulerBinding.instance.addPostFrameCallback((_) {
      print("SchedulerBinding");
    });*/
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _myAppBar(),
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          const SizedBox(
            height: 6,
          ),
          _showTask(),
        ],
      ),
    );
  }

  AppBar _myAppBar() {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: IconButton(
        icon: Get.isDarkMode
            ? Icon(
                Icons.light_mode,
                size: 24,
                color: Get.isDarkMode ? Colors.white : Colors.black,
              )
            : Icon(
                Icons.dark_mode,
                size: 24,
                color: Get.isDarkMode ? Colors.white : Colors.black,
              ),
        onPressed: (() {
          ThemeServices().switchThemeMode();
/*
          _notifyhelper.displayNotification(
              title: 'Theme is changed!', body: 'WTF?');
          _notifyhelper.scheduledNotification();*/
          //Get.back();
        }),
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.delete,
            size: 30,
            color: Colors.red,
          ),
          onPressed: (() {
            _taskController.deleteAllTask();
            _notifyhelper.cancelAllNotification();
            _taskController.setTaskInList();
          }),
        ),
        const SizedBox(
          width: 20,
        ),
        const CircleAvatar(
          backgroundImage: AssetImage('images/person.jpeg'),
          radius: 15,
        ),
        const SizedBox(
          width: 15,
        ),
      ],
    );
  }

  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()).toString(),
                style: Themes.subHeadingStyle,
              ),
              Text(
                'Today',
                style: Themes.headingStyle,
              )
            ],
          ),
          MyButton(
              lable: '+ Add Task',
              onTap: () async {
                await Get.to(const AddTaskPage());
                _taskController.getTasks();
              })
          /*ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(primaryClr)),
              onPressed: () {},
              child: Row(
                children: const [
                  Icon(
                    Icons.add,
                    size: 12,
                  ),
                  Text('Add Task')
                ],
              ))*/
        ],
      ),
    );
  }

  _addDateBar() {
    var styleDate = GoogleFonts.lato(
        textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Colors.grey,
    ));

    return Container(
      margin: const EdgeInsets.only(right: 10, left: 20),
      child: DatePicker(
        DateTime.now(),
        initialSelectedDate: DateTime.now(),
        width: 70,
        height: 100,
        selectedTextColor: Colors.white,
        selectionColor: primaryClr,
        dayTextStyle: styleDate,
        dateTextStyle: styleDate,
        monthTextStyle: styleDate,
        onDateChange: (currentSelectedDate) {
          setState(() {
            _SelectedDate = currentSelectedDate;
          });
        },
      ),
    );
  }

  _showTask() {
    return Expanded(
      child: Obx(() {
        if (_taskController.listTask.isEmpty) {
          return _noTask();
        } else {
          return RefreshIndicator(
            onRefresh: () => _taskController.setTaskInList(),
            child: ListView.builder(
              scrollDirection: SizeConfig.orientation == Orientation.portrait
                  ? Axis.vertical
                  : Axis.horizontal,
              //shrinkWrap: true,
              itemCount: _taskController.listTask.length,
              itemBuilder: (BuildContext, index) {
                Task t = _taskController.listTask[index];

                var hour = int.parse(t.startTime.toString().split(':')[0]);
                var minutes = int.parse(
                    t.startTime.toString().split(':')[1].substring(0, 2));
                print('$hour | $minutes | ${t.title}');
                _notifyhelper.scheduledNotification(hour, minutes, t);
                if (t.repeat == 'Daily' ||
                    t.dates == DateFormat().add_yMd().format(_SelectedDate) ||
                    (t.repeat == 'Weekly' &&
                        _SelectedDate.difference(
                                        DateFormat.yMd().parse(t.dates!))
                                    .inDays %
                                7 ==
                            0) ||
                    (t.repeat == 'Monthly' &&
                        DateFormat.yMd().parse(t.dates!).day ==
                            _SelectedDate.day)) {
                  return AnimationConfiguration.staggeredList(
                    duration: const Duration(milliseconds: 500),
                    position: index,
                    child: SlideAnimation(
                      duration: const Duration(milliseconds: 500),
                      horizontalOffset: 300,
                      child: FadeInAnimation(
                        duration: const Duration(milliseconds: 500),
                        child: GestureDetector(
                            onTap: () {
                              _showBottomSheet(context, t);
                            },
                            child: TaskTile(t)),
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          );
        }
      }),
    );
  }

  _noTask() {
    return Stack(children: [
      AnimatedPositioned(
        duration: const Duration(seconds: 1),
        child: RefreshIndicator(
          onRefresh: () async {
            _taskController.setTaskInList();
          },
          child: ListView(children: [
            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                direction: SizeConfig.orientation == Orientation.portrait
                    ? Axis.vertical
                    : Axis.horizontal,
                children: [
                  SvgPicture.asset(
                    'images/task.svg',
                    height: 100,
                    semanticsLabel: 'Task',
                    color: primaryClr.withOpacity(0.5),
                  ),
                  SizeConfig.orientation == Orientation.portrait
                      ? const SizedBox(
                          height: 100,
                        )
                      : const SizedBox(
                          height: 6,
                        ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: Text(
                      'You don\'t have any task yet!',
                      style: Themes.subHeadingStyle,
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    ]);
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(top: 4),
        width: SizeConfig.screenWidth,
        height: (SizeConfig.orientation == Orientation.landscape)
            ? (task.isCompleted == 1
                ? SizeConfig.screenHeight * 0.6
                : SizeConfig.screenHeight * 0.8)
            : (task.isCompleted == 1
                ? SizeConfig.screenHeight * 0.30
                : SizeConfig.screenHeight * 0.39),
        color: Get.isDarkMode ? darkGreyClr : Colors.white,
        child: Column(children: [
          Flexible(
              child: Container(
            height: 6,
            width: 120,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300]),
          )),
          const SizedBox(
            height: 20,
          ),
          task.isCompleted == 1
              ? Container()
              : _bulidBottomSheet(
                  lable: 'Task Completed',
                  onTap: () {
                    _taskController.updateTask(task: task);
                    _taskController.setTaskInList();
                    Get.back();
                  },
                  clr: primaryClr),
          _bulidBottomSheet(
              lable: 'Delete Task',
              onTap: () {
                _taskController.deleteTask(task: task);
                _notifyhelper.cancelNotification(task);
                _taskController.setTaskInList();
                Get.back();
              },
              clr: Colors.red[300]!),
          const Divider(
            color: Colors.grey,
          ),
          _bulidBottomSheet(
              lable: 'Cancel',
              onTap: () {
                Get.back();
              },
              clr: primaryClr),
          const SizedBox(
            height: 20,
          )
        ]),
      ),
    ));
  }

  _bulidBottomSheet(
      {required String lable,
      required Function() onTap,
      required Color clr,
      bool isClose = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 65,
        width: SizeConfig.screenWidth * 0.9,
        decoration: BoxDecoration(
            color: primaryClr,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                width: 2,
                color: isClose
                    ? Get.isDarkMode
                        ? Colors.grey[600]!
                        : Colors.grey[300]!
                    : clr)),
        child: Center(
            child: Text(
          lable,
          style: titleStyle.copyWith(color: Colors.white),
        )),
      ),
    );
  }
}
