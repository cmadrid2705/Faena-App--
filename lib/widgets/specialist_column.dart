import 'package:faena/models/user.dart';
import 'package:faena/screens/employee_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SpecialistColumn extends StatefulWidget {
  final User employee;
  final Function refresh;
  const SpecialistColumn({Key key, this.employee, this.refresh})
      : super(key: key);

  @override
  _SpecialistColumnState createState() => _SpecialistColumnState();
}

class _SpecialistColumnState extends State<SpecialistColumn> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      image: DecorationImage(
                          image: NetworkImage(widget.employee.photoURL),
                          fit: BoxFit.cover))),
              Container(
                width: 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 10),
                    Text(widget.employee.displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    SizedBox(height: 4),
                    Row(children: <Widget>[
                      Text('${widget.employee.rating}'),
                      Icon(Icons.star, color: Colors.yellow[800]),
                    ]),
                    SizedBox(height: 4),
                    Row(
                      children: <Widget>[
                        Icon(Icons.phone, size: 15, color: Colors.grey[700]),
                        SizedBox(width: 2),
                        Expanded(
                            child: Text(widget.employee.phone,
                                style: TextStyle(
                                    color: Colors.grey[700], fontSize: 12)))
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        onTap: () {
          Get.to(EmployeeProfile(
              employee: widget.employee, refresh: widget.refresh));
        });
  }
}
