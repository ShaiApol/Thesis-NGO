import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_ngo/Message.dart';
import 'package:project_ngo/models/UserSingleton.dart';

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  UserSingleton userSingleton = UserSingleton();
  List<Widget> messages = [];
  bool ready = false;
  int dummy = 0;

  void refresh() {}

  Future<List<Widget>> getMessages(int dummy) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    var msgs = await firestore
        .collection("users")
        .doc(userSingleton.user!.email)
        .get();

    var messages = msgs.data()!["messages"];
    List<Widget> new_msg_widgets = [];
    for (var message in messages) {
      var future = await firestore.collection("messages").doc(message).get();
      var users = (future.data() as Map)["users"] as List;
      var index =
          users.indexWhere((element) => element != userSingleton.user!.email);
      var receipient_data =
          await firestore.collection("users").doc(users[index]).get();
      var receipient = receipient_data.data() as Map;
      new_msg_widgets.add(Row(
        children: [
          Expanded(
              child: Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: GestureDetector(
              onTap: () async {
                await Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  return Message(
                      refresh: refresh,
                      receipient: receipient['email'],
                      fName: receipient['first_name'],
                      profile_picture: receipient['profile_picture'] ?? "",
                      lName: receipient['last_name']);
                }));
                setState(() {
                  dummy++;
                });
              },
              child: Container(
                color: Color(0xFF283F4D),
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    if (userSingleton.user!.profilePicture != null)
                      Container(
                        height: 50,
                        width: 50,
                        padding: EdgeInsets.all(2),
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Color(0xFFFCCD00), width: 2),
                            borderRadius: BorderRadius.circular(24)),
                        child: Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24)),
                          child: Image.network(
                            receipient['profile_picture'],
                            fit: BoxFit.contain,
                          ),
                        ),
                      )
                    else
                      Icon(
                        Icons.person,
                        size: 48,
                        color: Colors.white,
                      ),
                    SizedBox(
                      width: 16,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          receipient['first_name'] +
                              " " +
                              receipient['last_name'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          children: [
                            Container(
                              constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.75),
                              child: Text(
                                ((future.data() as Map)['last_sender'] ==
                                            userSingleton.user!.email
                                        ? "You: "
                                        : "") +
                                    (future.data() as Map)['last_message'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ))
        ],
      ));
    }
    return new_msg_widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
            child: FutureBuilder(
                future: getMessages(dummy),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView(
                      children: [
                        ...snapshot.data as List<Widget>,
                      ],
                    );
                  }

                  return SizedBox.shrink();
                })));
  }
}
