import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:project_ngo/Messages.dart';
import 'package:project_ngo/components.dart';
import 'package:project_ngo/models/Calendar.dart';
import 'package:project_ngo/models/Certification.dart';
import 'package:project_ngo/models/Training.dart';
import 'package:project_ngo/models/TrainingDetails.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'Cards.dart';
import 'CertificationFetcher.dart';
import 'Event.dart';
import 'EventDetails.dart';
import 'EventFetcher.dart';
import 'Reward.dart';
import 'TrainingFetcher.dart';
import 'RewardFetcher.dart';

class HomeTabManager extends StatefulWidget {
  String state;
  String email;
  HomeTabManager({Key? key, required this.state, required this.email})
      : super(key: key);

  @override
  _HomeTabManagerState createState() => _HomeTabManagerState();
}

class _HomeTabManagerState extends State<HomeTabManager> {
  bool loading = true;
  List<Event> events = [];
  List<Training> trainings = [];
  List<Certification> certifications = [];
  List<Reward> rewards = [];
  @override
  void initState() {
    super.initState();
    var eventFetcher = EventFetcher(email: widget.email);
    var trainingFetcher = TrainingFetcher(email: widget.email);
    var rewardFetcher = RewardFetcher(email: widget.email);
    var certificationFetcher = CertificationFetcher();
    List<Future> futures = [
      eventFetcher.fetch().then((value) {
        setState(() {
          events = value;
        });
      }),
      trainingFetcher.fetch().then((value) {
        setState(() {
          trainings = value;
        });
      }),
      certificationFetcher.fetch().then((value) {
        log("Certificates processed");
        setState(() {
          certifications = value;
        });
      }),
      rewardFetcher.fetch().then((value) {
        log("Rewards processed");
        setState(() {
          rewards = value;
        });
      }),
    ];

    Future.wait(futures).whenComplete(() {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!loading) {
      if (widget.state == "events") {
        return Expanded(
            child: Container(
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16),
                child: Header3(text: "Events"),
              ),
              SizedBox(
                height: 16,
              ),
              if (events.isNotEmpty)
                ...events.map((e) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: e.renderAsRowExpandedCard(onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EventDetails(
                                    event: e,
                                  )));
                    }),
                  );
                }).toList()
              else
                Header3(
                  text: "No Events available",
                  align: TextAlign.center,
                )
            ],
          ),
        ));
      } else if (widget.state == "trainings") {
        return Expanded(
            child: Container(
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16),
                child: Header3(text: "Popular Trainings"),
              ),
              SizedBox(
                height: 16,
              ),
              if (trainings.isNotEmpty)
                ...trainings.map((e) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: 16,
                    ),
                    child: e.renderAsRowExpandedCard(onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TrainingDetails(
                                    training: e,
                                  )));
                    }),
                  );
                }).toList()
              else
                Header3(
                  text: "No Trainings available",
                  align: TextAlign.center,
                )
            ],
          ),
        ));
      } else if (widget.state == "certifications") {
        return Expanded(
            child: Container(
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16),
                child: Header3(text: "Accomplishments"),
              ),
              SizedBox(
                height: 16,
              ),
              if (certifications.isNotEmpty)
                ...certifications.map((e) {
                  return e.renderAsRowExpandedCard(onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                              color: Color(0xFF283F4D),
                              child: Column(
                                children: [
                                  Container(
                                    child: Image.network(
                                      width: 520,
                                      e.photo!,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    "Congratulations on completing this Training!",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    "You can download your certificate now.",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "Download",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ],
                              ));
                        });
                  });
                }).toList()
              else
                Header3(
                  text: "No Certificates available",
                  align: TextAlign.center,
                )
            ],
          ),
        ));
      } else if (widget.state == "calendar") {
        return Expanded(child: Calendar(trainings: trainings, events: events));
      } else if (widget.state == "messages") {
        return Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 16, left: 16),
              child:
                  Row(children: [Expanded(child: Header3(text: "Messages"))]),
            ),
            Messages()
          ],
        ));
      } else if (widget.state == "rewards") {
        return Expanded(
            child: Container(
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16),
                child: Header3(text: "Rewards"),
              ),
              SizedBox(
                height: 16,
              ),
              if (rewards.isNotEmpty)
                ...rewards.map((e) {
                  return e.renderAsRowExpandedCard(onPressed: () {});
                }).toList()
              else
                Header3(
                  text: "No Rewards available",
                  align: TextAlign.center,
                )
            ],
          ),
        ));
      }
    }
    return Expanded(
        child: Center(
      child: CircularProgressIndicator(),
    ));
  }
}
