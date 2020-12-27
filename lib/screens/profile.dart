import 'dart:io';

import 'package:faena/models/category.dart';
import 'package:faena/models/service.dart';
import 'package:faena/services/firebase_service.dart';
import 'package:faena/services/state_management_service.dart';
import 'package:faena/utils/constants.dart';
import 'package:faena/widgets/carrousel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  const Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var myServices = List<Service>();
  Future uploadImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile == null) return;
    FirebaseStorage()
        .ref()
        .child('user_pics/${stateInstance.signUser.uid}.jpg')
        .putFile(File(pickedFile.path))
        .onComplete
        .then((value) async {
      var newPicUrl = await value.ref.getDownloadURL();
      firebaseInstance.updateField(
          stateInstance.signUser.uid, 'photoURL', newPicUrl);
      setState(() {
        stateInstance.signUser.photoURL = newPicUrl;
      });
    });
  }

  Future uploadBusinessImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile == null) return;
    var currentImages = Constants.stringToArray(stateInstance.signUser.images, Constants.SEPARATOR);
    FirebaseStorage()
        .ref()
        .child('business_images/${stateInstance.signUser.email}/image-${currentImages.length + 1}.jpg')
        .putFile(File(pickedFile.path))
        .onComplete
        .then((value) async {
      var newPicUrl = await value.ref.getDownloadURL();
      firebaseInstance.updateField(
          stateInstance.signUser.uid, FirebaseService.USER_IMAGES, Constants.arrayToString([...currentImages, newPicUrl], Constants.SEPARATOR));
      setState(() {
        stateInstance.signUser.images = Constants.arrayToString([...currentImages, newPicUrl], Constants.SEPARATOR);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    firebaseInstance.getServicesByBusiness(stateInstance.signUser.uid).then((value) {
      setState(() {
        myServices = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Color(0xff0435d1),
          title: Row(children: <Widget>[
            Expanded(child: Text(stateInstance.signUser.displayName)),
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
              GestureDetector(
                onLongPress: uploadImage,
                child: Container(
                  transform: Matrix4.translationValues(0, -50, 0),
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 1, color: Colors.grey[200]),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: NetworkImage(stateInstance.signUser.photoURL),
                          fit: BoxFit.fill)),
                ),
              ),
              Visibility(
                visible: stateInstance.signUser.role ==
                    Constants.ROLE_BEAUTY_SALON ||
                    stateInstance.signUser.role == Constants.ROLE_BARBERSHOP,
                child: GestureDetector(
                  onLongPress: uploadBusinessImage,
                  child: Carrousel(
                      isForImagesOnly: true,
                      categoryList: [
                        if(stateInstance.signUser.images.isNotEmpty)
                        ...stateInstance.signUser.images.split(Constants.SEPARATOR)
                        .map((e) => Category(
                            photoURL: e)),
                        if(stateInstance.signUser.images.isEmpty)
                        Category(photoURL: Constants.PLACEHOLDER_IMAGE_URL)
                  ]),
                ),
              ),
              SizedBox(height: 8,),
              Container(
                  padding: EdgeInsets.all(8),
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  transform: Matrix4.translationValues(0, -30, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Nombre: ${stateInstance.signUser.displayName}'),
                      GestureDetector(
                        child: Icon(Icons.edit),
                        onTap: () => _showBottomSheet(
                            label: 'Nombre',
                            fieldName: 'displayName',
                            value: stateInstance.signUser.displayName),
                      )
                    ],
                  )),
              Container(
                  padding: EdgeInsets.all(8),
                  alignment: Alignment.centerLeft,
                  transform: Matrix4.translationValues(0, -30, 0),
                  child: Text('Correo: ${stateInstance.signUser.email}')),
              Visibility(
                visible: stateInstance.signUser.role ==
                        Constants.ROLE_BEAUTY_SALON ||
                    stateInstance.signUser.role == Constants.ROLE_BARBERSHOP,
                child: Container(
                    padding: EdgeInsets.all(8),
                    width: double.infinity,
                    alignment: Alignment.centerLeft,
                    transform: Matrix4.translationValues(0, -30, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Horario: ${stateInstance.signUser.schedule}'),
                        GestureDetector(
                          child: Icon(Icons.edit),
                          onTap: () => _showBottomSheet(
                              label: 'Horario',
                              fieldName: 'schedule',
                              value: stateInstance.signUser.schedule),
                        )
                      ],
                    )),
              ),
              Visibility(
                visible:
                    stateInstance.signUser.role == Constants.ROLE_STYLIST ||
                        stateInstance.signUser.role == Constants.ROLE_BARBER,
                child: Container(
                    padding: EdgeInsets.all(8),
                    alignment: Alignment.centerLeft,
                    transform: Matrix4.translationValues(0, -20, 0),
                    child:
                        Text('Calificacion: ${stateInstance.signUser.rating}')),
              ),
              Container(
                  padding: EdgeInsets.all(8),
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  transform: Matrix4.translationValues(0, -30, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Telefono: ${stateInstance.signUser.phone}'),
                      GestureDetector(
                        child: Icon(Icons.edit),
                        onTap: () => _showBottomSheet(
                            label: 'Telefono',
                            fieldName: 'phone',
                            value: stateInstance.signUser.phone),
                      )
                    ],
                  )),
              Visibility(
                visible: stateInstance.signUser.role ==
                        Constants.ROLE_BEAUTY_SALON ||
                    stateInstance.signUser.role == Constants.ROLE_BARBERSHOP,
                child: Container(
                    padding: EdgeInsets.all(8),
                    width: double.infinity,
                    alignment: Alignment.centerLeft,
                    transform: Matrix4.translationValues(0, -30, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            'Descripcion: ${stateInstance.signUser.description}'),
                        GestureDetector(
                          child: Icon(Icons.edit),
                          onTap: () => _showBottomSheet(
                              label: 'Descripcion',
                              fieldName: 'description',
                              value: stateInstance.signUser.description),
                        )
                      ],
                    )),
              ),
              Visibility(
                visible: stateInstance.signUser.role ==
                        Constants.ROLE_BEAUTY_SALON ||
                    stateInstance.signUser.role == Constants.ROLE_BARBERSHOP,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('--Mis colaboradores--'),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        _showBottomSheet(
                            label: 'Agregar colaborador',
                            fieldName: 'collaborators',
                            value: 'ingresar correo');
                      },
                    )
                  ],
                ),
              ),
              if (stateInstance.signUser.role == Constants.ROLE_BEAUTY_SALON ||
                  stateInstance.signUser.role == Constants.ROLE_BARBERSHOP)
                ...stateInstance.signUser.collaborators.split(Constants.SEPARATOR).map(
                      (e) => ListTile(
                        title: Text(e),
                        trailing: IconButton(
                            icon: Icon(Icons.close_rounded),
                            onPressed: () async {
                              await firebaseInstance.removeCollaborator(
                                  stateInstance.signUser.uid,
                                  stateInstance.signUser.collaborators,
                                  e);
                              setState(() {
                                stateInstance.signUser.collaborators =
                                    stateInstance.signUser.collaborators
                                        .split(Constants.SEPARATOR)
                                        .where((r) => r != e)
                                        .join(Constants.SEPARATOR);
                              });
                            }),
                      ),
                    ),
              Visibility(
                visible: stateInstance.signUser.role ==
                        Constants.ROLE_BEAUTY_SALON ||
                    stateInstance.signUser.role == Constants.ROLE_BARBERSHOP,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('--Mis servicios--'),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        _showServiceBottomSheet();
                      },
                    )
                  ],
                ),
              ),
              if (stateInstance.signUser.role == Constants.ROLE_BEAUTY_SALON ||
                  stateInstance.signUser.role == Constants.ROLE_BARBERSHOP)
                ...myServices
                    .map((e) => ListTile(
                          title: Text(e.description +
                              '(L. ' +
                              e.price.toString() +
                              ')'),
                          trailing: IconButton(
                              icon: Icon(Icons.close_rounded),
                              onPressed: () {
                                firebaseInstance
                                    .removeService(e.uid)
                                    .then((value) {
                                  setState(() {
                                    myServices.remove(e);
                                  });
                                });
                              }),
                        ))
                    .toList()
            ])),
      ]))),
    );
  }

  void _showBottomSheet({String label, String fieldName, String value}) {
    var controller = new TextEditingController(text: value ?? '');
    Get.bottomSheet(
      Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                label,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Theme.of(context).primaryColorDark),
              ),
              TextField(
                controller: controller,
                keyboardType: label == 'Telefono'
                    ? TextInputType.number
                    : TextInputType.text,
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
                        if (label == 'Agregar colaborador') {
                          var serializedValue = [
                            ...stateInstance.signUser.collaborators
                                .split(Constants.SEPARATOR),
                            controller.text
                          ].join(Constants.SEPARATOR);
                          await firebaseInstance.updateField(
                              stateInstance.signUser.uid,
                              fieldName,
                              serializedValue);
                          setState(() {
                            stateInstance.signUser.collaborators =
                                serializedValue;
                          });
                          Navigator.of(context).pop();
                          return;
                        }
                        await firebaseInstance.updateField(
                            stateInstance.signUser.uid,
                            fieldName,
                            controller.text);
                        if (label == 'Nombre') {
                          setState(() {
                            stateInstance.signUser.displayName =
                                controller.text;
                          });
                        } else if (label == 'Horario') {
                          setState(() {
                            stateInstance.signUser.schedule = controller.text;
                          });
                        } else if (label == 'Telefono') {
                          setState(() {
                            stateInstance.signUser.phone = controller.text;
                          });
                        } else if (label == 'Descripcion') {
                          setState(() {
                            stateInstance.signUser.description =
                                controller.text;
                          });
                        }

                        Navigator.of(context).pop();
                      },
                      child: Text('Guardar'))
                ],
              )
            ],
          )),
      backgroundColor: Colors.white,
    );
  }

  void _showServiceBottomSheet() {
    var descController = new TextEditingController(text: '');
    var priceController = new TextEditingController(text: '');
    Get.bottomSheet(
      Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Descripcion del Servicio Servicio',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Theme.of(context).primaryColorDark),
              ),
              TextField(
                decoration:
                    InputDecoration(hintText: 'Ej. Corte de pelo de caballero'),
                controller: descController,
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                'Precio del Servicio Servicio',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Theme.of(context).primaryColorDark),
              ),
              TextField(
                  decoration: InputDecoration(hintText: 'Ej. 150'),
                  controller: priceController,
                  keyboardType: TextInputType.number),
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
                        if (priceController.text.isNotEmpty &&
                            descController.text.isNotEmpty) {
                          var newService = await firebaseInstance.addService(
                              Service(
                                  ownerId: stateInstance.signUser.uid,
                                  description: descController.text,
                                  price: int.parse(priceController.text)));

                          setState(() {
                            myServices.add(newService);
                          });
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text('Guardar'))
                ],
              )
            ],
          )),
      backgroundColor: Colors.white,
    );
  }
}
