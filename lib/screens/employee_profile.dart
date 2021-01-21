import 'package:faena/models/user.dart';
import 'package:faena/services/firebase_service.dart';
import 'package:faena/services/state_management_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmployeeProfile extends StatefulWidget {
  final User employee;
  final Function refresh;
  EmployeeProfile({Key key, this.employee, this.refresh}) : super(key: key);

  @override
  _EmployeeProfileState createState() => _EmployeeProfileState();
}

class _EmployeeProfileState extends State<EmployeeProfile> {
  var ratingsList = List<dynamic>();
  var allRatingsList = List<dynamic>();
  int counterRating = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firebaseInstance
        .getRatingsByStoreIdUserId(
            widget.employee.uid, stateInstance.signUser.uid)
        .asStream()
        .asBroadcastStream()
        .listen((data) {
      ratingsList = data;
    });
    firebaseInstance
        .getRatingsByStoreId(widget.employee.uid)
        .asStream()
        .asBroadcastStream()
        .listen((data) {
      allRatingsList = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Color(0xff0435d1),
            title: Row(children: <Widget>[
              Expanded(child: Text(widget.employee.displayName)),
            ])),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Container(
                    margin: EdgeInsets.all(10),
                    child: Column(children: [
                      Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              image: DecorationImage(
                                  image: NetworkImage(widget.employee.photoURL),
                                  fit: BoxFit.cover))),
                      SizedBox(height: 30),
                      Container(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                            Text('Calificación: '),
                            Text('${widget.employee.rating}'),
                            Icon(Icons.star, color: Colors.yellow[800])
                          ])),
                      SizedBox(height: 5),
                      Container(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                            Text('Teléfono: '),
                            Text('${widget.employee.phone}'),
                          ])),
                      SizedBox(height: 30),
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
                            buildDialog(context, widget.refresh, ratingsList,
                                allRatingsList, counterRating);
                          },
                          child: new Text('Calificar',
                              style: TextStyle(color: Colors.white)))
                    ])))));
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
                                    (allRatings.length + 1);
                                firebaseInstance.rateStore(
                                    widget.employee.uid,
                                    stateInstance.signUser.uid,
                                    totalRate,
                                    rate.value);
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                updateS();
                              } else {
                                var newCounter = counter - myRating[0]['rate'];
                                var totalRate = (newCounter + rate.value) /
                                    allRatings.length;
                                firebaseInstance.updateRateStore(
                                    widget.employee.uid,
                                    myRating[0]['uid'],
                                    totalRate,
                                    rate.value);
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                updateS();
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
}
