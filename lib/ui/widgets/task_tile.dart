import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/task.dart';
import '../size_config.dart';

class TaskTile extends StatelessWidget {
  const TaskTile(this.task, {Key? key}) : super(key: key);
  final Task task;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(
              SizeConfig.orientation == Orientation.landscape ? 4 : 20)),
      width: SizeConfig.orientation == Orientation.landscape
          ? SizeConfig.screenWidth / 2
          : SizeConfig.screenWidth,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: EdgeInsets.only(bottom: getProportionateScreenHeight(12)),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: _getBGCol(task.color!)),
        child: Row(
          children: [
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title!,
                    style: GoogleFonts.lato(
                        textStyle: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[200],
                    )),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.access_time,
                        color: Colors.grey[200],
                        size: 18,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        '${task.startTime!} - ${task.endTime!}',
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[200],
                        )),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(task.note!,
                      style: GoogleFonts.lato(
                          textStyle: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[200],
                      )))
                ],
              ),
            )),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              height: 60,
              width: 0.5,
              color: Colors.grey[200]!.withOpacity(0.7),
            ),
            RotatedBox(
                quarterTurns: 3,
                child: Column(
                  children: [
                    Text(
                      task.isCompleted == 0 ? 'TODO' : 'Completed',
                      style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      )),
                    ),
                    /*const Divider(
                      color: Colors.grey,
                    )*/
                  ],
                ))
          ],
        ),
      ),
    );
  }

  Color _getBGCol(int i) {
    List<Color> myColors = [Colors.red, Colors.deepPurple, Colors.blue];
    return myColors[i];
  }
}
