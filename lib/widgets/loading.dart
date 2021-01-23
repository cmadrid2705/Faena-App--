import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: MediaQuery.of(context).size.height,
      child: Center(
          child: SpinKitFadingCube(
            color: Colors.blue,
            size: 50,
          )),
    );
  }
}