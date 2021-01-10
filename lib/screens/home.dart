import 'package:faena/models/appointment.dart';
import 'package:faena/models/category.dart';
import 'package:faena/models/user.dart';
import 'package:faena/screens/login.dart';
import 'package:faena/screens/profile.dart';
import 'package:faena/services/firebase_service.dart';
import 'package:faena/services/state_management_service.dart';
import 'package:faena/utils/constants.dart';
import 'package:faena/widgets/carrousel.dart';
import 'package:faena/widgets/specialist_column.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/route_manager.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screen_size_width = MediaQuery.of(context).size.width;
    final screen_size_height = MediaQuery.of(context).size.height;

    var barbers = Rx<List<User>>(List<User>());
    firebaseInstance.getBarbers().asStream().asBroadcastStream().listen((data) {
      barbers.value = data;
    });

    var stylists = Rx<List<User>>(List<User>());
    firebaseInstance
        .getStylists()
        .asStream()
        .asBroadcastStream()
        .listen((data) {
      stylists.value = data;
    });

    var userAppointments = Rx<List<Appointment>>(List<Appointment>());
    firebaseInstance
        .getAppointmentsAsConsumer(stateInstance.signUser.uid)
        .asStream()
        .asBroadcastStream()
        .listen((data) {
      userAppointments.value = data;
    });

    var businessAppointments = Rx<List<Appointment>>(List<Appointment>());
    firebaseInstance
        .getAppointmentsAsBusiness(stateInstance.signUser.uid)
        .asStream()
        .asBroadcastStream()
        .listen((data) {
      businessAppointments.value = data;
    });

    var specAppointments = Rx<List<Appointment>>(List<Appointment>());
    firebaseInstance
        .getAppointmentsAsSpec(stateInstance.signUser.email)
        .asStream()
        .asBroadcastStream()
        .listen((data) {
      specAppointments.value = data;
    });

    return Scaffold(
        appBar: AppBar(
            backgroundColor: Color(0xff0435d1),
            title: Row(children: <Widget>[
              Expanded(child: Text('FAENA')),
            ])),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Obx(() => Column(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage(stateInstance.signUser.photoURL),
                        ),
                        Text(stateInstance.displayName.value)
                      ],
                    )),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                title: Text('Mi Perfil'),
                onTap: () => Get.to(Profile()),
              ),
              SizedBox(
                height: 20,
              ),
              ListTile(
                title: Text('Cerrar session'),
                onTap: () {
                  firebaseInstance.signOut();
                  Get.offAll(Login());
                },
              ),
            ],
          ),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Visibility(
            visible: stateInstance.signUser.role == Constants.ROLE_CONSUMER,
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: RichText(
                  text: TextSpan(
                      children: [
                        TextSpan(
                            text: 'Hola, ',
                            style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff0435d1))),
                        TextSpan(text: 'Que te harás\nhoy?')
                      ],
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w500,
                          color: Colors.black)),
                ),
              ),
            ),
          ),
          Visibility(
            visible: stateInstance.signUser.role == Constants.ROLE_CONSUMER,
            child: SizedBox(
              height: 50,
            ),
          ),
          Visibility(
            visible: stateInstance.signUser.role == Constants.ROLE_CONSUMER,
            child: Carrousel(categoryList: [
              Category(
                  description:
                      'Corte base, Corte formal, Corte y barba, Limpieza de barba.',
                  name: 'Peluquería',
                  photoURL: 'https://img1.wsimg.com/isteam/stock/15229/:/'),
              Category(
                  description: 'Uñas, Estilista, Maquillaje, Peluquería.',
                  name: 'Estética',
                  photoURL:
                      'https://utensiliospara.com/wp-content/uploads/2018/08/estetica-portada_opt.png')
            ]),
          ),
          Container(
            padding: EdgeInsets.all(20),
            alignment: Alignment.topLeft,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 6),
                  Visibility(
                    visible:
                        stateInstance.signUser.role == Constants.ROLE_CONSUMER,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                              child: Text("Estilistas Destacados",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600))),
                          FlatButton(
                              onPressed: () {},
                              child: Text("Ver todos",
                                  style: TextStyle(color: Colors.black54)))
                        ]),
                  ),
                  Visibility(
                      visible: stateInstance.signUser.role ==
                          Constants.ROLE_CONSUMER,
                      child: SizedBox(height: 6)),
                  Container(
                      height: 230,
                      width: screen_size_width,
                      child: Obx(
                        () => ListView(
                          scrollDirection: Axis.horizontal,
                          children: stylists.value
                              .map((e) => SpecialistColumn(
                                  specImg: e.photoURL,
                                  specNumber: e.phone,
                                  specName: e.displayName))
                              .toList(growable: true),
                        ),
                      )),
                  Visibility(
                      visible: stateInstance.signUser.role ==
                          Constants.ROLE_CONSUMER,
                      child: SizedBox(height: 6)),
                  Visibility(
                    visible:
                        stateInstance.signUser.role == Constants.ROLE_CONSUMER,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                              child: Text("Barberos Destacados",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600))),
                          FlatButton(
                              onPressed: () {},
                              child: Text("Ver todos",
                                  style: TextStyle(color: Colors.black54)))
                        ]),
                  ),
                  Visibility(
                      visible: stateInstance.signUser.role ==
                          Constants.ROLE_CONSUMER,
                      child: SizedBox(height: 6)),
                  Visibility(
                    visible:
                        stateInstance.signUser.role != Constants.ROLE_STYLIST,
                    child: Container(
                        height: 230,
                        width: screen_size_width,
                        child: Obx(
                          () => ListView(
                            scrollDirection: Axis.horizontal,
                            children: barbers.value
                                .map((e) => SpecialistColumn(
                                    specImg: e.photoURL,
                                    specNumber: e.phone,
                                    specName: e.displayName))
                                .toList(growable: true),
                          ),
                        )),
                  ),
                  Text("Citas",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  Visibility(
                    visible:
                        stateInstance.signUser.role == Constants.ROLE_CONSUMER,
                    child: Container(
                        height: 230,
                        width: screen_size_width,
                        child: Obx(
                          () => ListView(
                            scrollDirection: Axis.vertical,
                            children: userAppointments.value
                                .map((e) => ListTile(
                                      title: Text(e.details),
                                      subtitle: Text(e.date.toString() +
                                          ' (' +
                                          (e.specialist) +
                                          ')'),
                                    ))
                                .toList(growable: true),
                          ),
                        )),
                  ),
                  Visibility(
                    visible: stateInstance.signUser.role ==
                            Constants.ROLE_BEAUTY_SALON ||
                        stateInstance.signUser.role ==
                            Constants.ROLE_BARBERSHOP,
                    child: Container(
                        height: 230,
                        width: screen_size_width,
                        child: Obx(
                          () => ListView(
                            scrollDirection: Axis.vertical,
                            children: businessAppointments.value
                                .map((app) => ListTile(
                                      leading: app.locationType ==
                                              Constants.LOCATION_TYPE_HOME
                                          ? Icon(Icons.home)
                                          : Icon(Icons.apartment),
                                      title: Text(app.details),
                                      subtitle: Text(app.date.toString() +
                                          ' (' +
                                          (app.specialist +
                                              ')\n' +
                                              (app.locationType ==
                                                      Constants
                                                          .LOCATION_TYPE_HOME
                                                  ? 'Lugar: ' + app.location
                                                  : ''))+'\nServicio: ' + app.service),
                                      //trailing: Text(app.service),
                                    ))
                                .toList(growable: true),
                          ),
                        )),
                  ),
                  Visibility(
                    visible: stateInstance.signUser.role ==
                            Constants.ROLE_BARBER ||
                        stateInstance.signUser.role == Constants.ROLE_STYLIST,
                    child: Container(
                        height: 230,
                        width: screen_size_width,
                        child: Obx(
                          () => ListView(
                            scrollDirection: Axis.vertical,
                            children: specAppointments.value
                                .map((e) => ListTile(
                                      title: Text(e.details),
                                      subtitle: Text(e.date.toString()),
                                    ))
                                .toList(growable: true),
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ]))));
  }
}
