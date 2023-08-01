class Certificate {
  String activity_id;
  String? certificate_picture;
  String activity_type;
  final Map<String, dynamic> date;

  Certificate({
    required this.activity_id,
    required this.date,
    required this.activity_type,
    this.certificate_picture,
  });
}
