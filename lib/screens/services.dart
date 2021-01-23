import 'package:faena/models/user.dart';
import 'package:faena/screens/service_detail.dart';
import 'package:faena/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class Services extends StatefulWidget {
  final String name;
  const Services({Key key, this.name}) : super(key: key);

  @override
  _ServicesState createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  String refresh;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: firebaseInstance
            .getServices(widget.name)
            .asStream()
            .asBroadcastStream(),
        builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
          if (snapshot.hasData) {
            return _buildUI(snapshot.data);
          } else {
            return Container();
          }
        });
  }

  Widget _buildUI(List<User> services) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Color(0xff0435d1),
            title: Row(children: <Widget>[
              Expanded(child: Text(widget.name)),
            ])),
        body: SafeArea(
            child: Stack(children: <Widget>[
          Container(
              width: double.infinity,
              decoration: BoxDecoration(color: Color(0xff0435d1)),
              child: Column(children: <Widget>[])),
          Container(
              width: double.infinity,
              alignment: Alignment.topCenter,
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.only(top: 50),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: services.isNotEmpty
                  ? ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: services.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) =>
                          GestureDetector(
                              child: Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              width: 1,
                                              color: Colors.grey[300]))),
                                  child: _serviceUI(services[index])),
                              onTap: () {
                                Get.to(ServiceDetail(
                                    service: services[index],
                                    refreshScreen: refreshScreen));
                              }))
                  : Container(
                      child: Row(children: <Widget>[
                      Expanded(
                          child: Text(
                              'Aún no tenemos proveedores en esta categoría.',
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold)))
                    ])))
        ])));
  }

  refreshScreen(text) {
    setState(() {
      refresh = text;
    });
  }

  Widget _serviceUI(User service) {
    return Row(children: <Widget>[
      Container(
          width: 60,
          height: 60,
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
              image: DecorationImage(image: NetworkImage(service.photoURL)))),
      Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
            Container(child: Text(service.displayName)),
          ])),
      Text('${service.rating}'),
      Icon(Icons.star, color: Colors.yellow[800]),
      Icon(Icons.chevron_right, color: Colors.grey)
    ]);
  }
}
