import 'package:faena/utils/constants.dart';

class Appointment {
  String uid,
      requesterId,
      businessId,
      specialistEmail,
      details,
      service,
      specialist,
      locationType,
      location;
  DateTime date;

  Appointment(
      {this.uid,
      this.requesterId,
      this.businessId,
      this.specialistEmail,
      this.details,
      this.date,
      this.service,
      this.specialist,
      this.locationType,
      this.location}) {
    uid ??= '';
    requesterId ??= '';
    businessId ??= '';
    specialistEmail ??= '';
    
    details = service = specialist = locationType = location ??= '';
    date ??= DateTime.now().add(Duration(days: 1));
  }

  Appointment.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        requesterId = json['requesterId'],
        businessId = json['businessId'],
        specialistEmail = json['specialistEmail'],
        details = json['details'],
        date = DateTime.parse(json['date']),
        service = json['service'] ?? '',
        specialist = json['specialist'] ?? '',
        locationType = json['locationType'] ?? Constants.LOCATION_TYPE_HOME,
        location = json['location'] ?? '';

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'requesterId': requesterId,
        'businessId': businessId,
        'specialistEmail': specialistEmail,
        'details': details,
        'date': date.toIso8601String(),
        'service': service,
        'specialist': specialist,
        'locationType': locationType,
        'location': location,
      };
}
