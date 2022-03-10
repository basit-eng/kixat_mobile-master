import 'package:flutter/material.dart';
import 'package:kixat/views/customWidget/CustomAppBar.dart';

class DocumentsScreen extends StatelessWidget {
  const DocumentsScreen({Key key}) : super(key: key);

  static const routeName = '/documents';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text("Documents"),
      ),
      body: Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomDocTitle(title: "Certificates", icon: Icons.picture_as_pdf),
            CustomDocDiscribtion(
              leadingicon: Icons.picture_as_pdf,
              file: "doc.pdf",
              tralingicon: Icons.download,
            ),
            CustomDocTitle(title: "Marksheet", icon: Icons.picture_as_pdf),
            CustomDocDiscribtion(
              leadingicon: Icons.picture_as_pdf,
              file: "doc.pdf",
              tralingicon: Icons.download,
            ),
            CustomDocTitle(title: "Report Card", icon: Icons.picture_as_pdf),
            CustomDocDiscribtion(
              leadingicon: Icons.picture_as_pdf,
              file: "doc.pdf",
              tralingicon: Icons.download,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDocTitle extends StatelessWidget {
  const CustomDocTitle({
    Key key,
    this.icon,
    this.title,
  }) : super(key: key);
  final IconData icon;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Card(
        margin: EdgeInsets.all(0),
        color: Colors.grey[200],
        child: ListTile(
          leading: Icon(icon),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomDocDiscribtion extends StatelessWidget {
  const CustomDocDiscribtion({
    Key key,
    this.leadingicon,
    this.file,
    this.tralingicon,
  }) : super(key: key);
  final IconData leadingicon;
  final IconData tralingicon;
  final String file;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: ListTile(
        leading: Icon(leadingicon),
        title: Text(
          file,
        ),
        trailing: Icon(tralingicon),
      ),
    );
  }
}
