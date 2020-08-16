import 'package:flutter/material.dart';

class OtherPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final Map arguments = ModalRoute.of(context).settings.arguments as Map;

    if (arguments != null) print(arguments['rawText']);

    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
      ),
      body: Center(child: Text(arguments['rawText'])),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );

  }

}