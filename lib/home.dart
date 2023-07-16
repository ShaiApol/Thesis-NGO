import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_ngo/components.dart';
import 'package:project_ngo/models/HomeTabManager.dart';
import 'package:project_ngo/models/UserSingleton.dart';

import 'models/Calendar.dart';
import 'models/EventFetcher.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String state = "events";
  UserSingleton userSingleton = UserSingleton();
  EventFetcher eventFetcher = EventFetcher(email: UserSingleton().user!.email);

  void setCategoryState(String category) {
    setState(() {
      state = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SubTitleText(text: "VT Ready"),
              Expanded(child: SizedBox.shrink()),
              Icon(
                Icons.notifications,
                color: Colors.white,
              ),
              SizedBox(
                width: 24,
              ),
              Icon(
                Icons.rectangle,
                color: Colors.white,
              )
            ],
          ),
        ),
        body: SafeArea(
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 24,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SubTitleText(
                                    text:
                                        "Hello, ${userSingleton.user!.fName}!"),
                                SizedBox(
                                  height: 4,
                                ),
                                Body4(
                                    text:
                                        "Let's explore what's happening nearby")
                              ],
                            ),
                          ),
                          Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 48,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      DateWidget(),
                      SizedBox(
                        height: 24,
                      ),
                      Header3(
                        text: "What do you want to check today?",
                        align: TextAlign.center,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                    ],
                  ),
                ),
                CategoryFilter(setCategoryState: setCategoryState),
                HomeTabManager(state: state, email: userSingleton.user!.email),
                BottomBar()
              ],
            ),
          ),
        ));
  }
}

class CategoryFilter extends StatefulWidget {
  Function(String) setCategoryState;
  CategoryFilter({required this.setCategoryState});
  @override
  State<StatefulWidget> createState() => _CategoryFilterState();
}

class _CategoryFilterState extends State<CategoryFilter> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96,
      child: ListView(scrollDirection: Axis.horizontal, children: [
        InkWell(
          onTap: () {
            widget.setCategoryState("trainings");
          },
          child: Container(
            height: 36,
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.add_circle,
                  color: Colors.white,
                  size: 32,
                ),
                SizedBox(
                  height: 4,
                ),
                Text("Training"),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {
            widget.setCategoryState("certifications");
          },
          child: Container(
            height: 36,
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.school,
                  color: Colors.white,
                  size: 32,
                ),
                SizedBox(
                  height: 4,
                ),
                Text("Certification"),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {
            widget.setCategoryState("events");
          },
          child: Container(
            height: 36,
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.celebration,
                  color: Colors.white,
                  size: 32,
                ),
                SizedBox(
                  height: 4,
                ),
                Text("Events"),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {
            widget.setCategoryState("calendar");
          },
          child: Container(
            height: 36,
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.calendar_month,
                  color: Colors.white,
                  size: 32,
                ),
                SizedBox(
                  height: 4,
                ),
                Text("Calendar"),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {
            widget.setCategoryState("messages");
          },
          child: Container(
            height: 36,
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.message,
                  color: Colors.white,
                  size: 32,
                ),
                SizedBox(
                  height: 4,
                ),
                Text("Messages"),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {
            widget.setCategoryState("rewards");
          },
          child: Container(
            height: 36,
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.star,
                  color: Colors.white,
                  size: 32,
                ),
                SizedBox(
                  height: 4,
                ),
                Text("Rewards"),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

class DateWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DateWidgetState();
}

class _DateWidgetState extends State<DateWidget> {
  DateTime now = DateTime.now();

  List<Widget> getWeekDates(DateTime inputDate) {
    List<Widget> weekDates = [];
    List<String> weekDays = [
      'SUN',
      'MON',
      'TUE',
      'WED',
      'THU',
      'FRI',
      'SAT',
    ];

    // Calculate the start date of the week (Sunday)
    DateTime startDate =
        inputDate.subtract(Duration(days: inputDate.weekday % 7));

    // Generate the dates for the entire week
    for (int i = 0; i < 7; i++) {
      DateTime currentDate = startDate.add(Duration(days: i));
      if (currentDate.day == inputDate.day) {
        weekDates.add(Container(
          decoration: BoxDecoration(
              color: Color(0xFFFDCD01),
              borderRadius: BorderRadius.all(Radius.circular(8))),
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              Text(
                currentDate.day.toString(),
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                weekDays[i],
                style: TextStyle(color: Colors.black),
              )
            ],
          ),
        ));
      } else {
        weekDates.add(Container(
          padding: EdgeInsets.all(4),
          child: Column(
            children: [
              Text(currentDate.day.toString()),
              SizedBox(
                height: 12,
              ),
              Text(weekDays[i])
            ],
          ),
        ));
      }
    }

    return weekDates;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ...getWeekDates(now).map((e) {
          return e;
        }).toList()
      ],
    );
  }
}
