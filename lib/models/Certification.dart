import 'package:flutter/material.dart';
import 'package:project_ngo/components.dart';
import 'package:project_ngo/utils.dart';

import 'Cards.dart';

class Certification extends Cards {
  final String name;
  final String activity_photo;
  final Map<String, dynamic> date;
  String? photo;

  Certification({
    required this.name,
    required this.date,
    required this.activity_photo,
    this.photo,
  });

  Widget renderAsRowExpandedCard({required Function() onPressed}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
              child: InkWell(
            onTap: onPressed,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color(0xFF283F4D)),
              clipBehavior: Clip.hardEdge,
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Header3(text: name),
                        SizedBox(height: 8),
                        Text("Certificate received on " +
                            retrieveStringFormattedDate(date)),
                        if (photo != null && photo!.isNotEmpty)
                          Text("Tap to view Certificate")
                        else
                          Text("Certificate not available")
                      ],
                    ),
                  ),
                  Expanded(child: SizedBox.shrink()),
                  Image.network(
                    activity_photo,
                    height: 96,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }
}
