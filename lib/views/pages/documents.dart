import 'package:flutter/material.dart';
import 'package:softify/utils/sign_config.dart';
import 'package:softify/views/customWidget/CustomAppBar.dart';

class DocumentsScreen extends StatelessWidget {
  const DocumentsScreen({Key key}) : super(key: key);

  static const routeName = '/documents';

  @override
  Widget build(BuildContext context) {
    List doc_type = [
      "Charecter Certificate",
      "Hope Certificate",
      "Award Certificate",
    ];

    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          "Documents",
          style: Theme.of(context).appBarTheme.textTheme.headline6,
        ),
      ),
      body: ListView.builder(
        itemCount: doc_type.length,
        itemBuilder: ((context, index) {
          return Card(
            elevation: 02,
            margin: EdgeInsets.only(top: 08),
            child: ExpansionTile(
              title: Text(
                doc_type[index],
                style: TextStyle(
                  fontSize: 2.0 * SizeConfig.textMultiplier,
                  fontWeight: FontWeight.w600,
                ),
              ),
              children: [
                ListTile(
                  leading: Icon(Icons.picture_as_pdf),
                  title: Text(
                    "doc",
                  ),
                  trailing: Icon(Icons.file_download_outlined),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
