import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faena/src/home/UI/screens/service-detail.dart';
import 'package:faena/src/home/models/services.dart';
import 'package:flutter/material.dart';
import '../../bloc/bloc_home.dart';
import '../../models/category.dart';

class Services extends StatelessWidget {
  final String uid;
  const Services({Key key, this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: homeBloc.getCategoryByID(uid),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          Category category = homeBloc.buildCategoryDetail(snapshot.data);
          return _buildUI(category);
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildUI(Category category) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color(0xff0435d1),
            title: Row(children: <Widget>[
          Expanded(child: Text(category.name)),
        ])),
        body: SafeArea(
          
            child: SingleChildScrollView(
              
                child: Stack(children: <Widget>[
                  
          Container(
            
              width: double.infinity,
              decoration: BoxDecoration(color: Color(0xff0435d1)),
              child: Column(children: <Widget>[
                
                Container(
                  
                    margin: EdgeInsets.only(
                        top: 20, bottom: 100, left: 15, right: 15),
                    child: 
                    
                    Text(category.description,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white)))
              ])),
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
                StreamBuilder(
                    stream: homeBloc.getServices(category.uid),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data.documents.isEmpty) {
                          return Container(
                              margin: EdgeInsets.all(20),
                              child: Row(children: <Widget>[
                                Expanded(
                                    child: Text(
                                        'Aun no tenemos proveedores en esta categoría.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)))
                              ]));
                        } else {
                          List<Service> services = homeBloc
                              .buildListServices(snapshot.data.documents);
                          return Container(
                              child: Column(children: <Widget>[
                            ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: services.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context,
                                        int index) =>
                                    GestureDetector(
                                        child: Container(
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        width: 1,
                                                        color:
                                                            Colors.grey[300]))),
                                            child: _serviceUI(services[index])),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ServiceDetail(
                                                          uid: services[index]
                                                              .uid)));
                                        })),
                          ]));
                        }
                      } else {
                        return Container(
                            child: Row(children: <Widget>[
                          Expanded(
                              child: Text(
                                  'Aun no tenemos proveedores en esta categoría.',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold)))
                        ]));
                      }
                    })
              ]))
        ]))));
  }

  Widget _serviceUI(Service service) {
    return Row(children: <Widget>[
      Container(
          width: 60,
          height: 60,
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
              image: DecorationImage(image: NetworkImage(service.logo)))),
      Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
            Container(child: Text(service.name)),
            Container(
                margin: EdgeInsets.only(top: 5),
                child: Text(
                  'Horario: ' + service.schedule,
                  style: TextStyle(color: Colors.blue, fontSize: 12),
                ))
          ])),
      Icon(Icons.chevron_right, color: Colors.grey)
    ]);
  }
}
