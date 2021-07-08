import 'package:better_assignments/models/subject.dart';
import 'package:flutter/material.dart';

import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:hive/hive.dart';
import 'package:get/get.dart';

final subjBox = Hive.box("subjBox");
final _subjName = new TextEditingController();
final _profName = new TextEditingController();
var _color = Color(0xffAB47BC);
bool _isNew = true;
int? _index;
Widget newSubj(bool isNew, int? index) {
  if (isNew) {
  } else {
    _isNew = isNew;
    _index = index;
    _subjName.text = subjBox.getAt(index!).title;
    _profName.text = subjBox.getAt(index).name;
    _color = Color(subjBox.getAt(index).color);
  }
  return Container(
    padding: EdgeInsets.all(10),
    child: Card(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.arrow_back),
                ),
                Text(
                  "Create a new subject!",
                  style: Theme.of(Get.context!).textTheme.headline6,
                ),
              ],
            ),

            Container(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10)),
            // Subject name
            TextField(
              controller: _subjName,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.subject),
                labelText: "Subject Name",
              ),
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10)),

            // Professor/teacher name
            TextField(
              controller: _profName,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.grade),
                labelText: "Teacher name",
              ),
            ),

            // Color picker
            Center(
              child: ColorPicker(
                pickersEnabled: const <ColorPickerType, bool>{
                  ColorPickerType.accent: true,
                  ColorPickerType.primary: false,
                  ColorPickerType.wheel: true,
                },
                showColorCode: true,
                onColorChanged: (Color color) => _color = color,
              ),
            ),

            // Submit & Cancels
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _subjName.clear();
                    _profName.clear();
                    Get.back();
                  },
                  child: Text("Cancel"),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.red,
                    ),
                  ),
                ),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0)),
                ElevatedButton(
                  onPressed: () {
                    int _colorInt = _color.value;
                    if (_isNew) {
                      subjBox.add(
                        Subject(
                          title: _subjName.text,
                          name: _profName.text,
                          color: _colorInt,
                        ),
                      );
                    } else {
                      subjBox.putAt(
                        _index!,
                        Subject(
                          title: _subjName.text,
                          name: _profName.text,
                          color: _colorInt,
                        ),
                      );
                    }

                    _subjName.clear();
                    _profName.clear();
                    Get.back();
                  },
                  child: Text("Create"),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
