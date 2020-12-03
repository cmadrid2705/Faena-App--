import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faena/src/home/UI/widgets/carrousel.dart';
import 'package:faena/src/home/bloc/bloc_home.dart';
import 'package:faena/src/home/models/category.dart';
import 'package:flutter/material.dart';
import 'package:faena/widgets/image_card.dart';
import 'package:faena/uidata.dart';
import 'package:faena/widgets/my_column.dart';
import 'package:faena/widgets/specialist_column.dart';


import 'package:faena/src/home/UI/widgets/icon_card.dart';
import 'package:faena/src/home/UI/widgets/images_cards.dart';




class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);
  static const route = "home";

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     final screen_size_width = MediaQuery.of(context).size.width;
    final screen_size_height = MediaQuery.of(context).size.height;


    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff0435d1),
            title: Row(children: <Widget>[
          Expanded(child: Text('FAENA')),
        ])),
        body: 
        
        SafeArea(
            child: 
            
            SingleChildScrollView(
                child: Column(children: <Widget>[
                  SizedBox(height: 10,),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left:8.0),
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(text: 'Hola, ', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: Color(0xff0435d1))),
                      TextSpan(text: 'Que te harás\nhoy?')
                    ], style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500, color: Colors.black)),
                  ),
                ),
              ),
              SizedBox(height: 50,),


              

          StreamBuilder(
              stream: homeBloc.getCategories(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  List<Category> category =
                      homeBloc.buildListCategory(snapshot.data.documents);
                  return Carrousel(categoryList: category);
                } else {
                  return Container();
                }
              }),
          Container(
            padding: EdgeInsets.all(20),
            alignment: Alignment.topLeft,
            child: 
            
           
            
             SingleChildScrollView(
          child: Column(
            children: <Widget>[
             

             
             



              SizedBox(height: 6),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                        child: Text("Estilistas Destacados",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600))),
                    FlatButton(
                        onPressed: () {},
                        child: Text("Ver todos",
                            style: TextStyle(color: Colors.black54)))

                        

                  ]),
              SizedBox(height: 6),
              Container(
                  height: 230,
                  width: screen_size_width,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      SpecialistColumn(
                          specImg: "assets/braid2.jpg", specName: "Jennifer Diaz"),
                      SizedBox(width: 12),
                      SpecialistColumn(
                          specImg: "assets/Mariela.jpg", specName: "Mariela Hernandez"),
                      SizedBox(width: 12),
                      SpecialistColumn(
                          specImg: "assets/Jennifer.jpg",
                          specName: "Patricia Guardado"),
                          SizedBox(width: 12),
                      SpecialistColumn(
                          specImg: "assets/braid3.jpg",
                          specName: "Scarleth Paredes"),
                          SizedBox(width: 12),
                          SpecialistColumn(
                          specImg: "assets/braid2.jpg", specName: "Jennifer Diaz"),
                      SizedBox(width: 12),
                       SpecialistColumn(
                          specImg: "assets/Mariela.jpg", specName: "Mariela Hernandez"),
                      SizedBox(width: 12),
                    ],
                  )
                  ),
                  

            
                   
              


              SizedBox(height: 6),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                        child: Text("Barberos Destacados",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600))),
                    FlatButton(
                        onPressed: () {},
                        child: Text("Ver todos",
                            style: TextStyle(color: Colors.black54)))
                  ]),




              SizedBox(height: 6),
              Container(
                  height: 230,
                  width: screen_size_width,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      SpecialistColumn(
                          specImg: "assets/barbero.jpg", specName: "Carlos Lopez"),
                      SizedBox(width: 12),
                      SpecialistColumn(
                          specImg: "assets/barbero.jpg", specName: "Jesus Madrid"),
                      SizedBox(width: 12),
                      SpecialistColumn(
                          specImg: "assets/barbero.jpg",
                          specName: "Patricia Guardado"),
                          SizedBox(width: 12),
                      SpecialistColumn(
                          specImg: "assets/barbero.jpg",
                          specName: "Scarleth Paredes"),
                          SizedBox(width: 12),
                          SpecialistColumn(
                          specImg: "assets/barbero.jpg", specName: "Hector Muñoz"),
                      SizedBox(width: 12),
                       SpecialistColumn(
                          specImg: "assets/barbero.jpg", specName: "Gabriel Diaz"),
                      SizedBox(width: 12),


                    ],
                  )
                  
                  ),
                  
                 
             




            ],
            
          ),
          
        ),
        
          ),
        ]
        )

      

        )));
  }
}
