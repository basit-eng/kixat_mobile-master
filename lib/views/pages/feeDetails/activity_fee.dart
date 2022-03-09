import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_ui_toolkit/school_ui_toolkit.dart';

class ActivityFee extends StatelessWidget {
  const ActivityFee({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.indigo),
        ),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildText(context),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildImage() => Image.network(
      'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=934&q=80',
      fit: BoxFit.cover,
      width: double.infinity,
      height: 400,
    );

Widget buildText(BuildContext context) => Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: Card(
        child: ExpansionTile(
          childrenPadding: EdgeInsets.all(16).copyWith(top: 0),
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'School fee for January',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Rs 5,000',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20.0,
                    ),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(04)))),
                      onPressed: () {
                        // Respond to button press
                      },
                      child: Text('Paid'),
                    ),
                  ),
                ],
              ),
            ],
          ),
          children: [
            Text(
              'My name is Sarah and I am a New York City based Flutter developer. I help entrepreneurs & businesses figure out how to build scalable applications.\n\nWith over 7 years experience spanning across many industries from B2B to B2C, I live and breath Flutter.',
              style: TextStyle(fontSize: 18, height: 1.4),
            ),
          ],
        ),
      ),
    );
