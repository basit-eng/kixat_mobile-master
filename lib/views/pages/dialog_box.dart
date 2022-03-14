import 'package:flutter/material.dart';

class DialogBoxScreen extends StatelessWidget {
  const DialogBoxScreen({Key key}) : super(key: key);
  static const routeName = '/popUpDialog';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      child: customDialogBox(context),
      // backgroundColor: Colors.transparent,
    );
  }

  customDialogBox(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.5,
      width: size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFEFEFEF),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            height: size.height * 0.16,
            width: size.width,
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: CircleAvatar(
                radius: 100,
                backgroundImage: NetworkImage(
                    'https://cdn.pixabay.com/photo/2018/01/15/07/52/woman-3083390_1280.jpg'),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Text("Confirmation",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline6),
          SizedBox(
            height: 04,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text("Are you sure you want to subscribe this offer?",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText1),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 08, horizontal: 12),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              margin: EdgeInsets.only(top: 16),
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Attendance',
                            style: Theme.of(context).textTheme.bodyText1),
                        Text('March',
                            style: Theme.of(context).textTheme.bodyText1),
                      ],
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 08),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('1 Month',
                            style: Theme.of(context).textTheme.bodyText1),
                        Text('Abs: 5 ',
                            style: Theme.of(context).textTheme.bodyText1),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 22.0, vertical: 12),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Subscribe Now'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // <-- Radius
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
