import 'package:faena/utils/ui_data.dart';
import 'package:flutter/material.dart';

class SpecialistColumn extends StatelessWidget {
  final String specImg, specName, specNumber;
  final rate;

  const SpecialistColumn({Key key, this.specImg, this.specName, this.rate = 0, this.specNumber = ''}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                image: DecorationImage(
                    image: NetworkImage(specImg), fit: BoxFit.cover)),
          ),
          Container(
            width: 120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 10),
                Text(specName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                SizedBox(height: 4),
                Row(children: <Widget>[
                  Icon(Icons.star, color: rate >= 1 ? UIData.mainColor : UIData.lightColor, size: 14),
                  SizedBox(width: 1),
                  Icon(Icons.star, color: rate >= 2 ? UIData.mainColor : UIData.lightColor, size: 14),
                  SizedBox(width: 1),
                  Icon(Icons.star, color: rate >= 3 ? UIData.mainColor : UIData.lightColor, size: 14),
                  SizedBox(width: 1),
                  Icon(Icons.star, color: rate >= 4 ? UIData.mainColor : UIData.lightColor, size: 14),
                  SizedBox(width: 1),
                  Icon(Icons.star, color: rate >= 5 ? UIData.mainColor : UIData.lightColor, size: 14),
                ]),
                SizedBox(height: 4),
                Row(children: <Widget>[
                  Icon(Icons.phone, size: 15, color: Colors.grey[700]),
                  SizedBox(width:2),
                  Expanded(child: Text(specNumber, style: TextStyle(
                      color: Colors.grey[700], fontSize: 12
                  )))
                ],)
              ],
            ),
          )
        ],
      ),
    );
  }
}