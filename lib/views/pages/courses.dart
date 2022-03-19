import 'package:flutter/material.dart';
import 'package:schoolapp/views/customWidget/CustomAppBar.dart';

class MyCoursesScreen extends StatelessWidget {
  const MyCoursesScreen({Key key}) : super(key: key);
  static const routeName = '/courses';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text("Courses",
            style: Theme.of(context).appBarTheme.textTheme.headline6),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomCoursesName(
              icon: Icons.book_rounded,
              subjects: 'Islamiyat',
            ),
            CustomCoursesTechers(
              profession: "Teacher",
              name: "Mr.Aslam ",
              outline: "sample.pdf",
            ),
            CustomCoursesName(
              icon: Icons.book_rounded,
              subjects: 'Computer Science',
            ),
            CustomCoursesTechers(
              profession: "Teacher",
              name: "Mr. Basit Ali Daroo",
              outline: "sample.pdf",
            ),
            CustomCoursesName(
              icon: Icons.book_rounded,
              subjects: 'Flutter Programming',
            ),
            CustomCoursesTechers(
              profession: "Teacher",
              name: "Ms. Angela ",
              outline: "sample.pdf",
            ),
            CustomCoursesName(
              icon: Icons.book_rounded,
              subjects: 'Mathematics',
            ),
            CustomCoursesTechers(
              profession: "Teacher",
              name: "Mr. Hussain",
              outline: "sample.pdf",
            ),
            CustomCoursesName(
              icon: Icons.book_rounded,
              subjects: 'Urdu',
            ),
            CustomCoursesTechers(
              profession: "Teacher",
              name: "Mr. M. BAsit",
              outline: "sample.pdf",
            ),
            CustomCoursesName(
              icon: Icons.book_rounded,
              subjects: 'Pak Studies',
            ),
            CustomCoursesTechers(
              profession: "Teacher",
              name: "Mr. Basit Ali Daroo",
              outline: "sample.pdf",
            ),
            CustomCoursesName(
              icon: Icons.book_rounded,
              subjects: 'English',
            ),
            CustomCoursesTechers(
              profession: "Teacher",
              name: "Mr. Basit Ali Daroo",
              outline: "sample.pdf",
            ),
          ],
        ),
      ),
    );
  }
}

class CustomCoursesName extends StatelessWidget {
  const CustomCoursesName({
    Key key,
    this.icon,
    this.subjects,
  }) : super(key: key);
  final IconData icon;
  final String subjects;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Card(
        margin: EdgeInsets.all(0),
        child: ListTile(
          leading: Icon(icon),
          title: Text(
            subjects,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
      ),
    );
  }
}

class CustomCoursesTechers extends StatelessWidget {
  const CustomCoursesTechers({
    Key key,
    this.profession,
    this.name,
    this.outline,
  }) : super(key: key);
  final String profession;
  final String name;
  final String outline;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            profession,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Text(
            name,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Text(
            outline,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
