import 'package:flutter/material.dart';
import 'package:project_ngo/components.dart';
import 'package:project_ngo/utils.dart';

import 'Cards.dart';

class Announcement {
  final String id;
  final String name;
  final String description;
  final String content;
  final Map<String, dynamic>? date;
  final String? location;
  final String photo;

  Announcement({
    required this.id,
    required this.name,
    required this.description,
    required this.content,
    this.date,
    this.location = "",
    required this.photo,
  });
}
