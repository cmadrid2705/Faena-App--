import 'dart:async';

import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:faena/models/appointment.dart';
import 'package:faena/models/category.dart' as models;
import 'package:faena/models/user.dart';
import 'package:faena/services/firebase_service.dart';

import 'package:faena/services/state_management_service.dart';
import 'package:faena/utils/constants.dart';
import 'package:faena/widgets/carrousel.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:getwidget/getwidget.dart';

class ServiceDetail extends StatefulWidget {
  final User service;
  final Function refreshScreen;
  const ServiceDetail({Key key, this.service, @required this.refreshScreen})
      : super(key: key);

  @override
  _ServiceDetailState createState() => _ServiceDetailState();
}

class _ServiceDetailState extends State<ServiceDetail> {
  Completer<GoogleMapController> _controller = Completer();
  var businessAppointments = List<Appointment>();
  var ratingsList = List<dynamic>();
  var allRatingsList = List<dynamic>();
  int counterRating = 0;
  String refreshScreenVar;

  Position position;
  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firebaseInstance
        .getAppointmentsAsBusiness(widget.service.uid)
        .asStream()
        .asBroadcastStream()
        .listen((data) {
      businessAppointments = data;
    });
    firebaseInstance
        .getRatingsByStoreIdUserId(
            widget.service.uid, stateInstance.signUser.uid)
        .asStream()
        .asBroadcastStream()
        .listen((data) {
      ratingsList = data;
    });
    firebaseInstance
        .getRatingsByStoreId(widget.service.uid)
        .asStream()
        .asBroadcastStream()
        .listen((data) {
      allRatingsList = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildUI(widget.service, context);
  }

  _buildUI(User service, context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Color(0xff0435d1),
          title: Row(children: <Widget>[
            Expanded(child: Text(service.displayName)),
          ])),
      body: SafeArea(
          child: SingleChildScrollView(
              child: Stack(children: <Widget>[
        Container(
          width: double.infinity,
          height: 150,
          decoration: BoxDecoration(color: Color(0xff0435d1)),
        ),
        Container(
            width: double.infinity,
            alignment: Alignment.center,
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.only(top: 100),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            child: Column(children: <Widget>[
              Container(
                transform: Matrix4.translationValues(0, -50, 0),
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 1, color: Colors.grey[200]),
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage(service.photoURL),
                        fit: BoxFit.fill)),
              ),
              Carrousel(
                isForImagesOnly: true,
                categoryList: [
                  if (service.images.isNotEmpty)
                    ...Constants.stringToArray(
                            service.images, Constants.SEPARATOR)
                        .map((e) => models.Category(photoURL: e)),
                  if (service.images.isEmpty)
                    models.Category(photoURL: Constants.PLACEHOLDER_IMAGE_URL)
                ],
              ),
              SizedBox(height: 18),
              Container(
                  alignment: Alignment.centerLeft,
                  transform: Matrix4.translationValues(0, -20, 0),
                  child: Text('Descripcion: ${service.description}')),
              SizedBox(height: 8),
              Container(
                  alignment: Alignment.centerLeft,
                  transform: Matrix4.translationValues(0, -20, 0),
                  child: Row(children: [
                    Expanded(
                        child: Row(children: [
                      Text('Calificación: ${service.rating}'),
                      Icon(Icons.star, color: Colors.yellow[800]),
                    ])),
                    RaisedButton(
                        padding: EdgeInsets.only(left: 50, right: 50),
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.blue)),
                        onPressed: () {
                          if (allRatingsList.length > 0) {
                            for (var i = 0; i < allRatingsList.length; i++) {
                              setState(() {
                                counterRating =
                                    counterRating + allRatingsList[i]['rate'];
                              });
                            }
                          } else {
                            setState(() {
                              counterRating = 0;
                            });
                          }
                          buildDialog(context, updateScreen, ratingsList,
                              allRatingsList, counterRating);
                        },
                        child: new Text('Calificar',
                            style: TextStyle(color: Colors.white)))
                  ])),
              SizedBox(height: 8),
              Container(
                  alignment: Alignment.centerLeft,
                  transform: Matrix4.translationValues(0, -15, 0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Horario: '),
                        (service.schedule['monday'] == null)
                            ? Container()
                            : schedule('monday', 'Lunes', service),
                        (service.schedule['tuesday'] == null)
                            ? Container()
                            : schedule('tuesday', 'Martes', service),
                        (service.schedule['wednesday'] == null)
                            ? Container()
                            : schedule('wednesday', 'Miércoles', service),
                        (service.schedule['thursday'] == null)
                            ? Container()
                            : schedule('thursday', 'Jueves', service),
                        (service.schedule['friday'] == null)
                            ? Container()
                            : schedule('friday', 'Viernes', service),
                        (service.schedule['saturday'] == null)
                            ? Container()
                            : schedule('saturday', 'Sábado', service),
                        (service.schedule['sunday'] == null)
                            ? Container()
                            : schedule('sunday', 'Domingo', service)
                      ])),
              SizedBox(height: 8),
              Container(
                  alignment: Alignment.centerLeft,
                  transform: Matrix4.translationValues(0, -10, 0),
                  child: Text('Teléfono: ${service.phone}')),
              RaisedButton(
                padding: const EdgeInsets.all(15.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                child: Text('Solicitar cita',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w900)),
                colorBrightness: Brightness.dark,
                onPressed: () async {
                  _showBottomSheet(
                      service.schedule, businessAppointments, refreshScreen);
                },
                color: Color(0xff0435d1),
              )
            ])),
      ]))),
    );
  }

  void buildDialog(context, Function updateS, List<dynamic> myRating,
      List<dynamic> allRatings, int counter) {
    var rate = 1.obs;
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
              height: 230,
              color: Color(0xFF737373),
              child: Container(
                  padding:
                      EdgeInsets.only(bottom: 10, top: 10, left: 10, right: 10),
                  child: Obx(() => Column(children: [
                        Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: Icon(Icons.drag_handle)),
                        SizedBox(height: 5),
                        Container(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                              GestureDetector(
                                  child: Icon(Icons.star,
                                      color: (rate.value > 0)
                                          ? Colors.yellow[800]
                                          : Colors.grey,
                                      size: 40),
                                  onTap: () {
                                    rate.value = 1;
                                  }),
                              GestureDetector(
                                  child: Icon(Icons.star,
                                      color: (rate.value > 1)
                                          ? Colors.yellow[800]
                                          : Colors.grey,
                                      size: 40),
                                  onTap: () {
                                    rate.value = 2;
                                  }),
                              GestureDetector(
                                  child: Icon(Icons.star,
                                      color: (rate.value > 2)
                                          ? Colors.yellow[800]
                                          : Colors.grey,
                                      size: 40),
                                  onTap: () {
                                    rate.value = 3;
                                  }),
                              GestureDetector(
                                  child: Icon(Icons.star,
                                      color: (rate.value > 3)
                                          ? Colors.yellow[800]
                                          : Colors.grey,
                                      size: 40),
                                  onTap: () {
                                    rate.value = 4;
                                  }),
                              GestureDetector(
                                  child: Icon(Icons.star,
                                      color: (rate.value > 4)
                                          ? Colors.yellow[800]
                                          : Colors.grey,
                                      size: 40),
                                  onTap: () {
                                    rate.value = 5;
                                  }),
                            ])),
                        SizedBox(height: 15),
                        RaisedButton(
                            padding: EdgeInsets.only(left: 50, right: 50),
                            color: Colors.blue,
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.blue)),
                            onPressed: () {
                              if (myRating.length == 0) {
                                var totalRate = (counter + rate.value) /
                                    (allRatingsList.length + 1);
                                firebaseInstance.rateStore(
                                    widget.service.uid,
                                    stateInstance.signUser.uid,
                                    totalRate,
                                    rate.value);
                                Navigator.of(context).pop();
                                updateS('');
                              } else {
                                print(myRating[0]['uid']);
                                var newCounter = counter - myRating[0]['rate'];
                                var totalRate = (newCounter + rate.value) /
                                    allRatingsList.length;
                                firebaseInstance.updateRateStore(
                                    widget.service.uid,
                                    myRating[0]['uid'],
                                    totalRate,
                                    rate.value);
                                Navigator.of(context).pop();
                                updateS('');
                              }
                            },
                            child: new Text('Calificar',
                                style: TextStyle(color: Colors.white)))
                      ])),
                  decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(25),
                          topRight: const Radius.circular(25)))));
        });
  }

  Widget schedule(type, day, service) {
    return Text(
        '$day: Desde ${service.schedule[type]['from']}:00 - Hasta ${service.schedule[type]['to']}:00',
        style: TextStyle(color: Colors.grey[600]));
  }

  LatLng setPosition() {
    LatLng latLng = LatLng(0, 0);
    if (position != null) {
      latLng = LatLng(position.latitude, position.longitude);
    }
    return latLng;
  }

  List<Marker> _buildMarkers(BuildContext context, User service) {
    List<Marker> markers = [];
    // markers.add(Marker(
    //     markerId: MarkerId('${service.displayName}' ?? ""),
    //     draggable: true,
    //     // icon: sourceIcon,
    //     onTap: () {
    //       // setState(() {
    //       //   currentlySelectPlace = place;
    //       //   pinPillPosition = 10;
    //       // });
    //     },
    //     position: LatLng(service.geoPos.latitude, service.geoPos.longitude)));
    return markers;
  }

  Future<DateTime> _showDatePicker() {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now().add(Duration(days: 1)),
      lastDate: DateTime(DateTime.now().year + 1),
    );
  }

  Future<TimeOfDay> _showTimePicker() {
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child,
        );
      },
    );
  }

  void _showBottomSheet(
      schedule, List<Appointment> bussinessApt, Function refreshS) async {
    var scheduleList = [].obs;
    var appointment = [].obs;
    var itemActive = ''.obs;
    var detailsCtl = TextEditingController(text: '');
    var addressCtl = TextEditingController(text: '');
    var neighborhoodCtl = TextEditingController(text: '');
    var cityCtl = TextEditingController(text: '');
    var departmentCtl = TextEditingController(text: '');

    var cardNumCtl = TextEditingController(text: '');
    var cardExpCtl = TextEditingController(text: '');
    var cardCvvCtl = TextEditingController(text: '');

    var cita = Appointment(
        requesterId: stateInstance.signUser.uid,
        businessId: widget.service.uid);
    var displayDate = cita.date.obs;

    var services =
        await firebaseInstance.getServicesByBusiness(widget.service.uid);
    var choices =
        services.map((e) => '${e.description} (L. ${e.price})').toList();
    var amountToPay = 0.obs;

    if (choices.isEmpty) {
      choices.add('No hay servicios aun...');
    } else {
      amountToPay.value = services.first.price;
    }

    var selectedChoice = choices.first.obs;

    var specs = (widget.service.role == Constants.ROLE_BARBERSHOP
        ? await firebaseInstance.getBarbersByEmail(Constants.stringToArray(
            widget.service.collaborators, Constants.SEPARATOR))
        : await firebaseInstance.getStylistsByEmail(Constants.stringToArray(
            widget.service.collaborators, Constants.SEPARATOR)));

    specs = specs.isEmpty
        ? [User(displayName: 'No hay especialistas aqui')]
        : [...specs];
    var selectedSpec = specs.first.email.obs;

    var locationOptions = ['En establecimiento', 'A domicilio'];
    var selectedOption = locationOptions.first.obs;
    var showAddressInput =
        (selectedOption.value == locationOptions.reversed.first).obs;

    Get.bottomSheet(
        SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Obx(() => Text(
                        'Solicitar cita: ${displayDate.value.day}/${displayDate.value.month}/${displayDate.value.year} a las ${(displayDate.value.hour < 10) ? '0' : ''}${displayDate.value.hour}:${(displayDate.value.minute < 10) ? '0' : ''}${displayDate.value.minute}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Theme.of(context).primaryColorDark))),
                    TextField(
                        decoration: InputDecoration(
                            hintText: 'Escribe el detalle de lo que deseas'),
                        controller: detailsCtl),
                    DropdownButtonHideUnderline(
                        child: Obx(() => DropdownButton(
                            value: selectedChoice.value,
                            items: [
                              ...choices.map((e) =>
                                  DropdownMenuItem(child: Text(e), value: e))
                            ],
                            onChanged: (String value) {
                              selectedChoice.value = value;
                              cita.service = value;
                              amountToPay.value = services
                                  .firstWhere(
                                      (e) => value.contains(e.description))
                                  .price;
                            }))),
                    DropdownButtonHideUnderline(
                        child: Obx(() => DropdownButton(
                            value: selectedSpec.value,
                            items: [
                              ...specs.map((e) => DropdownMenuItem(
                                  child: Text(e.displayName), value: e.email))
                            ],
                            onChanged: (String selectedEmail) {
                              selectedSpec.value = selectedEmail;
                              cita.specialistEmail = selectedEmail;
                              cita.specialist = specs
                                  .firstWhere(
                                      (spec) => spec.email == selectedEmail)
                                  .displayName;
                            }))),
                    DropdownButtonHideUnderline(
                        child: Obx(() => DropdownButton(
                            value: selectedOption.value,
                            items: [
                              ...locationOptions.map((e) =>
                                  DropdownMenuItem(child: Text(e), value: e))
                            ],
                            onChanged: (value) {
                              selectedOption.value = value;
                              showAddressInput.value =
                                  value == locationOptions.reversed.first;
                              cita.locationType = value;
                            }))),
                    Obx(() => Visibility(
                        visible: showAddressInput.value,
                        child: Column(children: [
                          TextField(
                              decoration: InputDecoration(
                                  hintText: 'Direccion y numero de casa'),
                              controller: addressCtl),
                          TextField(
                              decoration:
                                  InputDecoration(hintText: 'Barrio o Colonia'),
                              controller: neighborhoodCtl),
                          Row(children: [
                            Flexible(
                                child: TextField(
                                    decoration:
                                        InputDecoration(hintText: 'Cuidad'),
                                    controller: cityCtl)),
                            SizedBox(width: 4),
                            Flexible(
                                child: TextField(
                                    decoration: InputDecoration(
                                        hintText: 'Departamento'),
                                    controller: departmentCtl))
                          ])
                        ]))),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          DatePicker(DateTime.now().add(Duration(days: 1)),
                              initialSelectedDate:
                                  DateTime.now().add(Duration(days: 1)),
                              selectionColor: Colors.black,
                              selectedTextColor: Colors.white,
                              onDateChange: (date) {
                            scheduleList.clear();
                            if (bussinessApt.length > 0) {
                              for (var item in bussinessApt) {
                                if (item.dateOrder.toString().contains(
                                    '${date.year}${date.month}${date.day}')) {
                                  appointment.add(item.dateOrder);
                                }
                              }
                            }
                            if (date != null) {
                              displayDate.value = cita.date = date;
                            }
                            if (date.weekday == 1) {
                              if (schedule['monday'] != null) {
                                for (var i =
                                        int.parse(schedule['monday']['from']);
                                    i < int.parse(schedule['monday']['to']);
                                    i++) {
                                  scheduleList.add(i);
                                }
                              }
                            } else if (date.weekday == 2) {
                              if (schedule['tuesday'] != null) {
                                for (var i =
                                        int.parse(schedule['tuesday']['from']);
                                    i < int.parse(schedule['tuesday']['to']);
                                    i++) {
                                  scheduleList.add(i);
                                }
                              }
                            } else if (date.weekday == 3) {
                              if (schedule['wednesday'] != null) {
                                for (var i = int.parse(
                                        schedule['wednesday']['from']);
                                    i < int.parse(schedule['wednesday']['to']);
                                    i++) {
                                  scheduleList.add(i);
                                }
                              }
                            } else if (date.weekday == 4) {
                              if (schedule['thursday'] != null) {
                                for (var i =
                                        int.parse(schedule['thursday']['from']);
                                    i < int.parse(schedule['thursday']['to']);
                                    i++) {
                                  scheduleList.add(i);
                                }
                              }
                            } else if (date.weekday == 5) {
                              if (schedule['friday'] != null) {
                                for (var i =
                                        int.parse(schedule['friday']['from']);
                                    i < int.parse(schedule['friday']['to']);
                                    i++) {
                                  scheduleList.add(i);
                                }
                              }
                            } else if (date.weekday == 6) {
                              if (schedule['saturday'] != null) {
                                for (var i =
                                        int.parse(schedule['saturday']['from']);
                                    i < int.parse(schedule['saturday']['to']);
                                    i++) {
                                  scheduleList.add(i);
                                }
                              }
                            } else if (date.weekday == 7) {
                              if (schedule['sunday'] != null) {
                                for (var i =
                                        int.parse(schedule['sunday']['from']);
                                    i < int.parse(schedule['sunday']['to']);
                                    i++) {
                                  scheduleList.add(i);
                                }
                              }
                            }
                          })
                        ]),
                    Container(
                        margin: EdgeInsets.all(10),
                        height: 30,
                        child: Obx(
                          () => ListView.builder(
                              itemCount: scheduleList.length,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return Obx(
                                  () => (appointment.where((e) => '$e' == '${cita.date.year}${cita.date.month}${cita.date.day}${scheduleList[index]}').length ==
                                          0)
                                      ? GestureDetector(
                                          child: Obx(() => Container(
                                              margin: EdgeInsets.only(
                                                  left: 5, right: 5),
                                              padding: EdgeInsets.only(
                                                  top: 5,
                                                  bottom: 5,
                                                  left: 10,
                                                  right: 10),
                                              decoration: BoxDecoration(
                                                  color: (itemActive.value ==
                                                          '${scheduleList[index]}')
                                                      ? Colors.green
                                                      : Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  border: Border.all(
                                                      width: 1,
                                                      color: Colors.blue)),
                                              child: Text('${scheduleList[index]}:00',
                                                  style: TextStyle(
                                                      color: (itemActive.value == '${scheduleList[index]}') ? Colors.white : Colors.black)))),
                                          onTap: () {
                                            itemActive.value =
                                                '${scheduleList[index]}';
                                            displayDate.value = cita.date =
                                                DateTime(
                                                    cita.date.year,
                                                    cita.date.month,
                                                    cita.date.day,
                                                    scheduleList[index]);
                                            cita.dateOrder = int.parse(
                                                '${cita.date.year}${cita.date.month}${cita.date.day}${cita.date.hour}');
                                          })
                                      : Container(margin: EdgeInsets.only(left: 5, right: 5), padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10), decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(15), border: Border.all(width: 1, color: Colors.blue)), child: Text('${scheduleList[index]}:00', style: TextStyle(color: Colors.white))),
                                );
                              }),
                        )),
                    GFAccordion(
                      title: 'Pago con tarjeta',
                      contentChild: Column(
                        children: [
                          Obx(() =>
                              Text('Total a pagar L. ${amountToPay.value}')),
                          TextField(
                            decoration: InputDecoration(
                                hintText: 'xxxx xxxx xxxx xxxx'),
                            controller: cardNumCtl,
                            keyboardType: TextInputType.number,
                            maxLength: 16,
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: TextField(
                                  decoration:
                                      InputDecoration(hintText: 'xx / xx'),
                                  controller: cardExpCtl,
                                  onChanged: (String val) {
                                    if (val.length == 2) {
                                      cardExpCtl.text = val + '/';
                                      cardExpCtl.selection =
                                          TextSelection.fromPosition(
                                              TextPosition(
                                                  offset:
                                                      cardExpCtl.text.length));
                                    }
                                  },
                                  keyboardType: TextInputType.datetime,
                                  maxLength: 5,
                                ),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Flexible(
                                child: TextField(
                                  decoration: InputDecoration(hintText: 'xxx'),
                                  controller: cardCvvCtl,
                                  keyboardType: TextInputType.number,
                                  maxLength: 3,
                                ),
                              )
                            ],
                          ),
                          Obx(
                            () => RaisedButton(
                              onPressed: amountToPay.value == 0
                                  ? null
                                  : () async {
                                      if (cardNumCtl.text.isNotEmpty &&
                                          cardExpCtl.text.isNotEmpty &&
                                          cardCvvCtl.text.isNotEmpty &&
                                          amountToPay.value != 0) {
                                        await firebaseInstance.payService(
                                            widget.service.uid,
                                            widget.service.earnings +
                                                amountToPay.value);
                                        setState(() {
                                          amountToPay.value = 0;
                                        });
                                      }
                                    },
                              color: Colors.green,
                              textColor: Colors.white,
                              child: Text('Pagar'),
                            ),
                          )
                        ],
                      ),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Cancelar',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                          FlatButton(
                              onPressed: () async {
                                if (detailsCtl.text.isEmpty ||
                                    (showAddressInput.value &&
                                        addressCtl.text.isEmpty &&
                                        neighborhoodCtl.text.isEmpty &&
                                        cityCtl.text.isEmpty &&
                                        departmentCtl.text.isEmpty)) {
                                  Get.snackbar('Falta informacion',
                                      'Porfavor llena todos los campos',
                                      backgroundColor: Colors.white);
                                  return;
                                }
                                cita.details = detailsCtl.text;
                                cita.location =
                                    '${addressCtl.text}, ${neighborhoodCtl.text}, ${cityCtl.text}, ${departmentCtl.text}';
                                await firebaseInstance
                                    .createAppointment(cita)
                                    .then((value) async {
                                  await refreshS('');
                                  Navigator.of(context).pop();
                                });
                              },
                              child: Text(
                                'Guardar',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ))
                        ])
                  ])),
        ),
        backgroundColor: Colors.white,
        isScrollControlled: true);
  }

  refreshScreen(text) {
    firebaseInstance
        .getAppointmentsAsBusiness(widget.service.uid)
        .asStream()
        .asBroadcastStream()
        .listen((data) {
      data.length;
      businessAppointments = data;
    });
  }

  updateScreen(text) {
    widget.refreshScreen('');
    Navigator.of(context).pop();
  }
}
