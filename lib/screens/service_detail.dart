import 'dart:async';

import 'package:faena/models/appointment.dart';
import 'package:faena/models/user.dart';
import 'package:faena/services/firebase_service.dart';
import 'package:faena/services/geolocator_service.dart';
import 'package:faena/services/state_management_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

  Future<DateTime> showDateTimePicker() {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now().add(Duration(days: 1)),
      lastDate: DateTime(DateTime.now().year + 1),
    );
  }

  void _showBottomSheet() {
    var controller =
        new TextEditingController(text: 'escribe tu detalle de lo que deseas');
    var cita = Appointment(
        requesterId: stateInstance.signUser.uid,
        businessId: widget.service.uid);
    var displayDate = cita.date.obs;
    Get.bottomSheet(Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Obx(
            () => Text(
                'Solicitar cita: ${displayDate.value.day}/${displayDate.value.month}/${displayDate.value.year}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Theme.of(context).primaryColorDark),
              ),
            ),
            TextField(
              controller: controller,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Tocar para seleccionar fecha'),
                IconButton(
                  onPressed: (){
                    showDateTimePicker().then((value) {
                      if(value != null){
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
              children: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancelar')),
                FlatButton(
                    onPressed: () async {
                      cita.details = controller.text;
                      await firebaseInstance.createAppointment(cita);
                      Navigator.of(context).pop();
                    },
                    child: Text('Guardar'))
              ],
            )
          ],
        )));
  }
}
