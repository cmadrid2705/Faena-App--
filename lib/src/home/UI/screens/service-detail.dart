import 'dart:async';

import 'package:faena/src/home/bloc/bloc_home.dart';
import 'package:faena/src/home/models/services.dart';
import 'package:faena/src/utils/geolocator_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ServiceDetail extends StatefulWidget {
  final String uid;
  const ServiceDetail({Key key, this.uid}) : super(key: key);

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
    return StreamBuilder(
      stream: homeBloc.getServiceById(widget.uid),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          Service service = homeBloc.buildServiceDetail(snapshot.data);
          return _buildUI(service, context);
        } else {
          return Container();
        }
      },
    );
  }

  _buildUI(Service service, context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xff0435d1),
          title: Row(children: <Widget>[
        Expanded(child: Text(service.name)),
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
                        image: NetworkImage(service.logo), fit: BoxFit.fill)),
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  transform: Matrix4.translationValues(0, -30, 0),
                  child: Text('Horario: ${service.schedule}')),
              Container(
                  alignment: Alignment.centerLeft,
                  transform: Matrix4.translationValues(0, -20, 0),
                  child: Text('Teléfono: ${service.phone}')),
              // ((geolocatorService.getCurrentLocation.latitude == 0) &&
              //         (geolocatorService.getCurrentLocation.longitude == 0))
              //     ? FutureBuilder(
              //         future: getCurrentPos(),
              //         builder: (BuildContext context, AsyncSnapshot snapshot) {
              //           if (snapshot.hasData) {
              //             return Container(
              //               margin: EdgeInsets.all(15),
              //               height: MediaQuery.of(context).size.height / 2.6,
              //               child: _buildMap(
              //                   geolocatorService.getCurrentLocation, service),
              //             );
              //           } else {
              //             return Text("");
              //           }
              //         },
              //       )
              //     : Container(
              //         margin: EdgeInsets.all(15),
              //         height: MediaQuery.of(context).size.height / 2.6,
              //         child: _buildMap(
              //             geolocatorService.getCurrentLocation, service),
              //       ),
            ])),
      ]))),
    );
  }

  Widget _buildMap(LatLng latLng, Service service) {
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

  List<Marker> _buildMarkers(BuildContext context, Service service) {
    List<Marker> markers = [];
    markers.add(Marker(
        markerId: MarkerId('${service.name}' ?? ""),
        draggable: true,
        // icon: sourceIcon,
        onTap: () {
          // setState(() {
          //   currentlySelectPlace = place;
          //   pinPillPosition = 10;
          // });
        },
        position: LatLng(service.geoPos.latitude, service.geoPos.longitude)));
    return markers;
  }
}
