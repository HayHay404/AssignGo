import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:better_assignments/alt_screens/completed.dart';
import 'package:better_assignments/alt_screens/settings.dart';
import 'package:better_assignments/alt_screens/star.dart';
import 'package:better_assignments/home.dart';
import 'package:better_assignments/models/assignment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:nanoid/nanoid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_portal/flutter_portal.dart';

class TabView extends StatefulWidget {
  @override
  _TabViewState createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);
  var prefs;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    /* void _sharedPref() async {
      prefs = await SharedPreferences.getInstance();
      count = prefs.getInt("initScreen");
      print(prefs.getInt("initScreen"));
    }

    _sharedPref();

    // TODO: Implement Portal Screen (onboarding type thing) a little later.
     if (count >= 1) {
      print("Test");
      prefs.setInt("initScreen", 2);
      print(prefs.getInt("initScreen"));

      return Portal(
        child: _tabView(),
      );
    } else */
    return _tabView();
  }

  Widget _tabView() {
    return PersistentTabView(
      context,
      controller: _controller,
      navBarHeight: 60,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.black,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(30.0),
        colorBehindNavBar: Colors.transparent,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style7, // Choose the nav bar style with this property.
      onItemSelected: (index) {
        setState(() {});
      },
    );
  }

  List<Widget> _buildScreens() {
    return [
      Home(),
      Star(),
      Home(),
      Completed(),
      Settings(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: "Home",
        textStyle: TextStyle(color: Colors.white),
        activeColorSecondary: Colors.white,
        activeColorPrimary: Colors.purple,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.star),
        title: ("Prioritized"),
        textStyle: TextStyle(color: Colors.white),
        activeColorSecondary: Colors.white,
        activeColorPrimary: Colors.amber,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.add),
        title: ("Add"),
        textStyle: TextStyle(color: Colors.white),
        activeColorSecondary: Colors.white,
        activeColorPrimary: Colors.white,
        onPressed: (context) {
          _panel();
        },
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.check_box),
        title: ("Completed"),
        activeColorPrimary: Colors.green,
        textStyle: TextStyle(color: Colors.white),
        activeColorSecondary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.settings),
        title: ("Settings"),
        activeColorPrimary: Colors.blue,
        textStyle: TextStyle(color: Colors.blue),
        activeColorSecondary: Colors.white,
      ),
    ];
  }

  /*
 -----------------------------------------------------------------------------------------------------------------
 Panel
 -----------------------------------------------------------------------------------------------------------------
  */
  final TextEditingController _title = TextEditingController();
  final TextEditingController _desc = TextEditingController();
  final TextEditingController _date = TextEditingController();
  final assignBox = Hive.box('assignBox');
  /*
  void _notifID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _notifInt = prefs.getInt("_notifID")!;
    await prefs.setInt("_notifID", _notifInt++);
    print(_notifInt);
  }
  */

  dynamic _panel() {
    _title.clear();
    _desc.clear();
    _date.clear();

    final result = showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      context: context,
      builder: (context) {
        return Container(
          decoration: new BoxDecoration(
            color: Colors.black,
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(30.0),
              topRight: const Radius.circular(30.0),
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  children: [
                    // Title
                    Container(height: 20),
                    TextField(
                      controller: _title,
                      decoration: InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        prefixIcon: Icon(Icons.assignment),
                        labelText: "Assignment name",
                      ),
                    ),

                    // Description
                    Container(height: 20),
                    TextField(
                      controller: _desc,
                      autocorrect: true,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      textInputAction: TextInputAction.newline,
                      decoration: InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        prefixIcon: Icon(Icons.assignment),
                        labelText: "Description",
                      ),
                    ),

                    // Due date selection
                    Container(height: 20),
                    DateTimePicker(
                      type: DateTimePickerType.dateTime,
                      dateMask: 'dd / MM / yy - hh : mm',
                      use24HourFormat: false,
                      controller: _date,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2025),
                      icon: Icon(Icons.cloud_circle),
                      decoration: InputDecoration(
                        labelText: "Due Date & time",
                        prefixIcon: Icon(Icons.calendar_today),
                        border: new OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onChanged: (val) {
                        _date.text = val;
                      },
                    ),

                    // Subject selection
                    Container(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.subject),
                      label: Text("Subject"),
                    ),

                    // Submit button selection
                    Container(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (_date.text == "") {
                          Get.snackbar(
                            "Warning!",
                            "Date can't be empty.",
                            backgroundColor: Colors.red,
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        } else {
                          setState(
                            () {
                              // Generates a new number 9 digits long.
                              // Converts _date.text to DateTime to use for schedule notifications
                              DateTime _dateDue = DateTime.parse(_date.text);
                              final DateTime _longDur =
                                  _dateDue.subtract(Duration(hours: 24));

                              final DateTime _shortDur =
                                  _dateDue.subtract(Duration(minutes: 60));
                              int _id =
                                  int.parse(customAlphabet('1234567890', 9));
                              // Create first notification (12 hrs from deadline)
                              AwesomeNotifications().createNotification(
                                content: NotificationContent(
                                  id: _id,
                                  channelKey: '24hr',
                                  title: _title.text,
                                  body: _desc.text,
                                  displayOnBackground: true,
                                ),
                                schedule: NotificationCalendar(
                                  allowWhileIdle: true,
                                  year: _longDur.year,
                                  month: _longDur.month,
                                  hour: _longDur.hour,
                                  minute: _longDur.minute,
                                  day: _longDur.day,
                                ),
                              );

                              // TODO: Create notification 1hr before.
                              if (_title.text.isEmpty) {
                                Get.snackbar(
                                  "Warning!",
                                  "Title can't be empty.",
                                  backgroundColor: Colors.red,
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                              } else {
                                assignBox.add(
                                  AssignModel(
                                    title: _title.text,
                                    date: _date.text,
                                    desc: _desc.text,
                                    notifID: _id,
                                  ),
                                );
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              }
                            },
                          );
                        }
                      },
                      icon: Icon(Icons.add),
                      label: Text("Add assignment"),
                      style: ElevatedButton.styleFrom(
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        primary: Colors.green,
                      ),
                    ),
                    Container(height: 20),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    return result;
  }
}
