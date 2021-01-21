import 'package:faena/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:faena/services/state_management_service.dart';

class ProfileUpdateSchedule extends StatefulWidget {
  final Function refreshScreen;
  ProfileUpdateSchedule({Key key, @required this.refreshScreen})
      : super(key: key);

  @override
  _ProfileUpdateScheduleState createState() => _ProfileUpdateScheduleState();
}

class _ProfileUpdateScheduleState extends State<ProfileUpdateSchedule> {
  Map<String, dynamic> mapSchedule = {};
  TextEditingController ctrlInputDesde = new TextEditingController();
  TextEditingController ctrlInputHasta = new TextEditingController();

  @override
  void initState() {
    super.initState();
    if (stateInstance.signUser.schedule != null) {
      mapSchedule = stateInstance.signUser.schedule;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: Text('Editar Horario'), backgroundColor: Color(0xff0435d1)),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(children: <Widget>[
          Container(
              margin: EdgeInsets.all(10),
              child: Text('Días',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          Container(
              margin: EdgeInsets.all(10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                        child: days(mapSchedule['monday'], 'Lunes'),
                        onTap: () {
                          setDay(mapSchedule, 'monday', '8', '17');
                        }),
                    GestureDetector(
                        child: days(mapSchedule['tuesday'], 'Martes'),
                        onTap: () {
                          setDay(mapSchedule, 'tuesday', '8', '17');
                        }),
                    GestureDetector(
                        child: days(mapSchedule['wednesday'], 'Miércoles'),
                        onTap: () {
                          setDay(mapSchedule, 'wednesday', '8', '17');
                        }),
                    GestureDetector(
                        child: days(mapSchedule['thursday'], 'Jueves'),
                        onTap: () {
                          setDay(mapSchedule, 'thursday', '8', '17');
                        }),
                  ])),
          Container(
              margin: EdgeInsets.all(10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                        child: days(mapSchedule['friday'], 'Viernes'),
                        onTap: () {
                          setDay(mapSchedule, 'friday', '8', '17');
                        }),
                    GestureDetector(
                        child: days(mapSchedule['saturday'], 'Sábado'),
                        onTap: () {
                          setDay(mapSchedule, 'saturday', '8', '17');
                        }),
                    GestureDetector(
                        child: days(mapSchedule['sunday'], 'Domingo'),
                        onTap: () {
                          setDay(mapSchedule, 'sunday', '8', '17');
                        }),
                  ])),
          // ================================= Horario =====================================
          Container(
              margin: EdgeInsets.all(10),
              child: Text('Horario',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          (mapSchedule['monday'] == null)
              ? Container()
              : GestureDetector(
                  child: schedule('monday', 'Lunes'),
                  onTap: () {
                    ctrlInputDesde = new TextEditingController(
                        text: mapSchedule['monday']['from']);
                    ctrlInputHasta = new TextEditingController(
                        text: mapSchedule['monday']['to']);
                    buildDialog(
                        context, mapSchedule, 'monday', 'Lunes', setDay);
                  }),
          (mapSchedule['tuesday'] == null)
              ? Container()
              : GestureDetector(
                  child: schedule('tuesday', 'Martes'),
                  onTap: () {
                    ctrlInputDesde = new TextEditingController(
                        text: mapSchedule['tuesday']['from']);
                    ctrlInputHasta = new TextEditingController(
                        text: mapSchedule['tuesday']['to']);
                    buildDialog(
                        context, mapSchedule, 'tuesday', 'Martes', setDay);
                  }),
          (mapSchedule['wednesday'] == null)
              ? Container()
              : GestureDetector(
                  child: schedule('wednesday', 'Miércoles'),
                  onTap: () {
                    ctrlInputDesde = new TextEditingController(
                        text: mapSchedule['wednesday']['from']);
                    ctrlInputHasta = new TextEditingController(
                        text: mapSchedule['wednesday']['to']);
                    buildDialog(
                        context, mapSchedule, 'wednesday', 'Miércoles', setDay);
                  }),
          (mapSchedule['thursday'] == null)
              ? Container()
              : GestureDetector(
                  child: schedule('thursday', 'Jueves'),
                  onTap: () {
                    ctrlInputDesde = new TextEditingController(
                        text: mapSchedule['thursday']['from']);
                    ctrlInputHasta = new TextEditingController(
                        text: mapSchedule['thursday']['to']);
                    buildDialog(
                        context, mapSchedule, 'thursday', 'Jueves', setDay);
                  }),
          (mapSchedule['friday'] == null)
              ? Container()
              : GestureDetector(
                  child: schedule('friday', 'Viernes'),
                  onTap: () {
                    ctrlInputDesde = new TextEditingController(
                        text: mapSchedule['friday']['from']);
                    ctrlInputHasta = new TextEditingController(
                        text: mapSchedule['friday']['to']);
                    buildDialog(
                        context, mapSchedule, 'friday', 'Viernes', setDay);
                  }),
          (mapSchedule['saturday'] == null)
              ? Container()
              : GestureDetector(
                  child: schedule('saturday', 'Sábado'),
                  onTap: () {
                    ctrlInputDesde = new TextEditingController(
                        text: mapSchedule['saturday']['from']);
                    ctrlInputHasta = new TextEditingController(
                        text: mapSchedule['saturday']['to']);
                    buildDialog(
                        context, mapSchedule, 'saturday', 'Sábado', setDay);
                  }),
          (mapSchedule['sunday'] == null)
              ? Container()
              : GestureDetector(
                  child: schedule('sunday', 'Domingo'),
                  onTap: () {
                    ctrlInputDesde = new TextEditingController(
                        text: mapSchedule['sunday']['from']);
                    ctrlInputHasta = new TextEditingController(
                        text: mapSchedule['sunday']['to']);
                    buildDialog(
                        context, mapSchedule, 'sunday', 'Domingo', setDay);
                  }),
          SizedBox(height: 15),
          RaisedButton(
              padding: EdgeInsets.only(left: 50, right: 50),
              color: Colors.blue,
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.blue)),
              onPressed: () async {
                await firebaseInstance.updateField(
                    stateInstance.signUser.uid, 'schedule', mapSchedule);
                widget.refreshScreen(mapSchedule);
                setState(() {
                  stateInstance.signUser.schedule = mapSchedule;
                });
                Navigator.of(context).pop();
              },
              child: new Text('Actualizar Horario',
                  style: TextStyle(color: Colors.white)))
        ]))));
  }

  Widget days(type, day) {
    return Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: (type == null) ? Colors.white : Colors.blue,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(width: 1, color: Colors.blue)),
        child: Text(day,
            style: TextStyle(
                color: (type == null) ? Colors.black87 : Colors.white)));
  }

  Widget schedule(type, day) {
    return Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(color: Colors.black87, width: 1))),
        child: Column(children: [
          Row(children: [
            Expanded(child: Text(day)),
            Container(
                margin: EdgeInsets.only(left: 5, right: 5),
                child: Text('Desde: ${mapSchedule[type]['from']}:00')),
            Container(
                margin: EdgeInsets.only(left: 5, right: 5),
                child: Text('Hasta: ${mapSchedule[type]['to']}:00')),
            GestureDetector(
                child: Icon(Icons.close, color: Colors.red),
                onTap: () {
                  setState(() {
                    mapSchedule.remove(type);
                  });
                })
          ]),
        ]));
  }

  void buildDialog(context, map, type, day, Function setData) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
              height: 350,
              color: Color(0xFF737373),
              child: Container(
                  padding:
                      EdgeInsets.only(bottom: 10, top: 10, left: 10, right: 10),
                  child: Column(children: [
                    Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Icon(Icons.drag_handle)),
                    SizedBox(height: 5),
                    Container(
                        child: Text(day,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold))),
                    SizedBox(height: 5),
                    Container(
                        padding: EdgeInsets.only(
                            top: 3, left: 5, bottom: 3, right: 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  offset: Offset(0, 5),
                                  blurRadius: 5),
                            ]),
                        child: TextField(
                            controller: ctrlInputDesde,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.date_range),
                                focusedBorder: InputBorder.none,
                                border: InputBorder.none,
                                hintText: '* Desde'))),
                    SizedBox(height: 15),
                    Container(
                        padding: EdgeInsets.only(
                            top: 3, left: 5, bottom: 3, right: 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  offset: Offset(0, 5),
                                  blurRadius: 5),
                            ]),
                        child: TextField(
                            controller: ctrlInputHasta,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.date_range),
                                focusedBorder: InputBorder.none,
                                border: InputBorder.none,
                                hintText: '* Hasta'))),
                    SizedBox(height: 15),
                    RaisedButton(
                        padding: EdgeInsets.only(left: 50, right: 50),
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.blue)),
                        onPressed: () {
                          ctrlInputDesde = (int.parse(ctrlInputDesde.text) > 24)
                              ? new TextEditingController(text: '24')
                              : new TextEditingController(
                                  text: ctrlInputDesde.text);
                          ctrlInputHasta = (int.parse(ctrlInputHasta.text) > 24)
                              ? new TextEditingController(text: '24')
                              : new TextEditingController(
                                  text: ctrlInputHasta.text);

                          if (int.parse(ctrlInputDesde.text) >
                              int.parse(ctrlInputHasta.text)) {
                            setData(map, type, ctrlInputHasta.text,
                                ctrlInputDesde.text);
                          } else if (int.parse(ctrlInputDesde.text) ==
                              int.parse(ctrlInputHasta.text)) {
                            int from = int.parse(ctrlInputDesde.text) - 1;
                            setData(map, type, '$from', ctrlInputHasta.text);
                          } else {
                            setData(map, type, ctrlInputDesde.text,
                                ctrlInputHasta.text);
                          }
                          Navigator.pop(context);
                        },
                        child: new Text('Definir Horario',
                            style: TextStyle(color: Colors.white)))
                  ]),
                  decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(25),
                          topRight: const Radius.circular(25)))));
        });
  }

  setDay(map, type, from, to) {
    Map<String, dynamic> dayMap = map;
    Map<String, String> scheduleMap = {};
    var fromMap = Map<String, String>();
    fromMap['from'] = from;
    var toMap = Map<String, String>();
    toMap['to'] = to;
    scheduleMap.addAll(fromMap);
    scheduleMap.addAll(toMap);
    var joinMap = Map<String, dynamic>();
    joinMap[type] = scheduleMap;
    dayMap.addAll(joinMap);
    setState(() {
      mapSchedule.addAll(dayMap);
    });
  }
}
