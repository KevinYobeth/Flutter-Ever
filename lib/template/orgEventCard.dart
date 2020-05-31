import 'package:flutter/material.dart';
import 'package:Ever/template/colors.dart';
import 'package:Ever/template/orgAddEventDetail.dart';

class addEvent extends StatefulWidget {
  final Function refresh;

  const addEvent({Key key, this.refresh}) : super(key: key);

  @override
  _addEventState createState() => _addEventState(refresh);
}

class _addEventState extends State<addEvent> {
  final Function refresh;

  _addEventState(this.refresh);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  '+',
                  style: TextStyle(
                    color: darkBackgroundColor,
                    fontSize: 50,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Add',
                  style: TextStyle(
                    color: darkBackgroundColor,
                    fontSize: 20,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          FlatButton(
            child: Container(
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: 85.0,
                    top: 65.0,
                    child: Text(
                      "Add Event",
                      style: TextStyle(
                        color: darkBackgroundColor,
                        fontSize: 22,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              width: 300,
              height: 170,
              decoration: BoxDecoration(
                color: Colors.blueGrey[100],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              widget.refresh();

              var eventDetailController = showBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return addEventDetail();
                  });

              eventDetailController.closed.then((value) {
                setState(() {
                  widget.refresh();
                });
              });
            },
          ),
        ],
      ),
    );
  }
}

class orgEventCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  '7',
                  style: TextStyle(
                    color: darkBackgroundColor,
                    fontSize: 40,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Des',
                  style: TextStyle(
                    color: darkBackgroundColor,
                    fontSize: 20,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 300,
            height: 170,
            decoration: BoxDecoration(
              color: Colors.blueGrey[100],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }
}