class Appointment {
  String uid, requesterId, businessId, specialistEmail, details;
  DateTime date;

  Appointment({this.uid, this.requesterId, this.businessId, this.specialistEmail, this.details, this.date}){
    uid ??= '';
    requesterId ??= '';
    businessId ??= '';
    specialistEmail ??= '';
    details ??= '';
    date ??= DateTime.now().add(Duration(days: 1));
  }

  Appointment.fromJson(Map<String, dynamic> json)
      :uid = json['uid'],
      requesterId = json['requesterId'],
        businessId = json['businessId'],
        specialistEmail = json['specialistEmail'],
        details = json['details'],
        date = DateTime.parse(json['date']);

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'requesterId': requesterId,
    'businessId': businessId,
    'specialistEmail': specialistEmail,
    'details': details,
    'date': date.toIso8601String()
  };


}