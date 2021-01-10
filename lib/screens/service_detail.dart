import 'dart:async';

import 'package:faena/models/appointment.dart';
import 'package:faena/models/category.dart' as models;
import 'package:faena/models/user.dart';
import 'package:faena/services/firebase_service.dart';
import 'package:faena/services/geolocator_service.dart';
import 'package:faena/services/state_management_service.dart';
import 'package:faena/utils/constants.dart';
import 'package:faena/widgets/carrousel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:getwidget/getwidget.dart';

class ServiceDetail extends StatefulWidget {
  final User service;
  const ServiceDetail({Key key, this.service}) : super(key: key);

  @override
  _ServiceDetailState createState() => _ServiceDetailState();
}

class _ServiceDetailState extends State<ServiceDetail> {
  Completer<GoogleMapController> _controller = Completer();

  Position position;
  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
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
                    ...Constants.stringToArray(service.images, Constants.SEPARATOR)
                        .map((e) => models.Category(photoURL: e)),
                  if (service.images.isEmpty)
                    models.Category(photoURL: Constants.PLACEHOLDER_IMAGE_URL)
                ],
              ),
              SizedBox(
                height: 18,
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  transform: Matrix4.translationValues(0, -30, 0),
                  child: Text('Descripcion: ${service.description}')),
              SizedBox(
                height: 8,
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  transform: Matrix4.translationValues(0, -30, 0),
                  child: Text('Horario: ${service.schedule}')),
              SizedBox(
                height: 8,
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  transform: Matrix4.translationValues(0, -20, 0),
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
                onPressed: () {
                  _showBottomSheet();
                },
                color: Color(0xff0435d1),
              )
            ])),
      ]))),
    );
  }

  Widget _buildMap(LatLng latLng, User service) {
    return Stack(children: [
      Container(
        child: GoogleMap(
            mapType: MapType.normal,
            // zoomGesturesEnabled: true,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            // scrollGesturesEnabled: true,
            zoomControlsEnabled: false,
            markers: Set.from(_buildMarkers(context, service)),
            onTap: (LatLng location) {
              // setState(() {
              //   pinPillPosition = -250;
              // });
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(latLng.latitude, latLng.longitude),
              zoom: 16.0,
            ),
            onMapCreated: _onMapCreated,
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
              new Factory<OneSequenceGestureRecognizer>(
                () => new EagerGestureRecognizer(),
              ),
            ].toSet()),
      ),
      Positioned(
          bottom: 25,
          left: -10,
          child: RawMaterialButton(
              onPressed: getCurrentPosition,
              elevation: 10,
              fillColor: Colors.blue,
              child: Icon(Icons.location_searching, color: Colors.white),
              padding: EdgeInsets.all(15),
              shape: CircleBorder()))
    ]);
  }

  getCurrentPos() async {
    try {
      Position position = await geolocatorService.getCurrentPosition();
      geolocatorService
          .setCurrentLocation(LatLng(position.latitude, position.longitude));
      return LatLng(position.latitude, position.longitude);
    } catch (e) {}
  }

  getCurrentPosition() async {
    final GoogleMapController controller = await _controller.future;
    position = await geolocatorService.getCurrentPosition();
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      bearing: 0,
      target: LatLng(position.latitude, position.longitude),
      zoom: 14.0,
    )));
    geolocatorService
        .setCurrentLocation(LatLng(position.latitude, position.longitude));
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

  void _showBottomSheet() async {
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
        ? await firebaseInstance
            .getBarbersByEmail(Constants.stringToArray(widget.service.collaborators, Constants.SEPARATOR))
        : await firebaseInstance
        .getStylistsByEmail(Constants.stringToArray(widget.service.collaborators, Constants.SEPARATOR)));

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
                  Obx(
                    () => Text(
                      'Solicitar cita: ${displayDate.value.day}/${displayDate.value.month}/${displayDate.value.year} alas ${displayDate.value.hour}:${displayDate.value.minute}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Theme.of(context).primaryColorDark),
                    ),
                  ),
                  TextField(
                    decoration: InputDecoration(
                        hintText: 'Escribe el detalle de lo que deseas'),
                    controller: detailsCtl,
                  ),
                  DropdownButtonHideUnderline(
                      child: Obx(
                    () => DropdownButton(
                        value: selectedChoice.value,
                        items: [
                          ...choices.map(
                              (e) => DropdownMenuItem(child: Text(e), value: e))
                        ],
                        onChanged: (String value) {
                          selectedChoice.value = value;
                          cita.service = value;
                          amountToPay.value = services
                              .firstWhere((e) => value.contains(e.description))
                              .price;
                        }),
                  )),
                  DropdownButtonHideUnderline(
                      child: Obx(
                    () => DropdownButton(
                        value: selectedSpec.value,
                        items: [
                          ...specs.map(
                              (e) => DropdownMenuItem(child: Text(e.displayName), value: e.email))
                        ],
                        onChanged: (String selectedEmail) {
                          selectedSpec.value = selectedEmail;
                          cita.specialistEmail = selectedEmail;
                          cita.specialist = specs.firstWhere((spec) => spec.email == selectedEmail).displayName;
                        }),
                  )),
                  DropdownButtonHideUnderline(
                      child: Obx(
                    () => DropdownButton(
                        value: selectedOption.value,
                        items: [
                          ...locationOptions.map(
                              (e) => DropdownMenuItem(child: Text(e), value: e))
                        ],
                        onChanged: (value) {
                          selectedOption.value = value;
                          showAddressInput.value =
                              value == locationOptions.reversed.first;
                          cita.locationType = value;
                        }),
                  )),
                  Obx(
                    () => Visibility(
                      visible: showAddressInput.value,
                      child: Column(
                        children: [
                          TextField(
                            decoration: InputDecoration(
                                hintText: 'Direccion y numero de casa'),
                            controller: addressCtl,
                          ),
                          TextField(
                            decoration:
                                InputDecoration(hintText: 'Barrio o Colonia'),
                            controller: neighborhoodCtl,
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: TextField(
                                  decoration:
                                      InputDecoration(hintText: 'Cuidad'),
                                  controller: cityCtl,
                                ),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Flexible(
                                child: TextField(
                                  decoration:
                                      InputDecoration(hintText: 'Departamento'),
                                  controller: departmentCtl,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Tocar para seleccionar fecha'),
                      IconButton(
                        onPressed: () {
                          _showDatePicker().then((value) {
                            if (value != null) {
                              displayDate.value = cita.date = value;
                            }
                          });
                        },
                        icon: Icon(Icons.date_range),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Tocar para seleccionar hora'),
                      IconButton(
                        onPressed: () {
                          _showTimePicker().then((value) {
                            if (value != null) {
                              displayDate.value = cita.date = DateTime(
                                  cita.date.year,
                                  cita.date.month,
                                  cita.date.day,
                                  value.hour,
                                  value.minute);
                            }
                          });
                        },
                        icon: Icon(Icons.watch_later_outlined),
                      ),
                    ],
                  ),
                  GFAccordion(
                    title: 'Pago con tarjeta',
                    contentChild: Column(
                      children: [
                        Obx(() =>
                            Text('Total a pagar L. ${amountToPay.value}')),
                        TextField(
                          decoration:
                              InputDecoration(hintText: 'xxxx xxxx xxxx xxxx'),
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
                                        TextSelection.fromPosition(TextPosition(
                                            offset: cardExpCtl.text.length));
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
                                  'Porfavor llena todos los campos');
                              return;
                            }
                            cita.details = detailsCtl.text;
                            cita.location =
                                '${addressCtl.text}, ${neighborhoodCtl.text}, ${cityCtl.text}, ${departmentCtl.text}';
                            await firebaseInstance.createAppointment(cita);
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Guardar',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ))
                    ],
                  )
                ],
              )),
        ),
        backgroundColor: Colors.white,
        isScrollControlled: true);
  }
}
