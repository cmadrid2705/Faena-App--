import 'package:flutter/material.dart';

import 'package:faena/src/home/models/places.dart';

import 'image_card.dart';


class ImageCards extends StatefulWidget {
  @override
  _ImageCardsState createState() => _ImageCardsState();
}

class _ImageCardsState extends State<ImageCards> {
 List<Place> places = [
  Place(place: 'Manicura clásica', image: '1.jpg', days: 350),
   Place(place: 'LAVADO Y SECADO ', image: '2.jpg', days: 150),
   Place(place: 'Peinado recogido y rizos románticos', image: '3.jpg', days: 2500),
   Place(place: 'Maquillaje', image: '1.jpg', days: 500),
   Place(place: 'Peinado para el día de la boda', image: '2.jpg', days: 3000),
   Place(place: 'Pedicure', image: '3.jpg', days: 300),

 ];
  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: places.length,
            itemBuilder: (_, index) {
              return ImageCard(
                place: places[index],
                name: places[index].place,
                days: places[index].days,
                picture: places[index].image,
              );
            }));
  }
}


