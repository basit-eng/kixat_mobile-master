import 'package:flutter/material.dart';
import 'package:kixat/utils/sign_config.dart';
import 'package:kixat/utils/utility.dart';
import 'package:kixat/views/customWidget/CustomAppBar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key key}) : super(key: key);

  static const routeName = '/profile-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          "Profile",
          style: Theme.of(context).appBarTheme.textTheme.headline6,
        ),
      ),
      body: Container(
        color: !isDarkThemeEnabled(context) ? Colors.grey[200] : Colors.black38,
        child: ListView(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          children: [
            Card(
              // margin: EdgeInsets.symmetric(horizontal: 12, vertical: 05),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 08, vertical: 02),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    backgroundImage: AssetImage('assets/user.png'),
                    radius: 34,
                  ),
                  title: Text(
                    'Muhammad Ali',
                    style: Theme.of(context).textTheme.headline6.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 2.2 * SizeConfig.textMultiplier),
                  ),
                  subtitle: Text('Class 9th A'),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              child: Text(
                "Personal Information",
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.headline6.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 2.2 * SizeConfig.textMultiplier),
              ),
            ),
            Card(
              elevation: 0,
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              child: Column(
                children: [
                  CustomProfile(
                    attr: "Name",
                    iconsPath: Icons.person,
                    value: "Emma_ema",
                  ),
                  CustomProfile(
                    attr: "F.Name",
                    iconsPath: Icons.person_add_alt_1,
                    value: "Hassan",
                  ),
                  CustomProfile(
                    attr: "Roll No.",
                    iconsPath: Icons.confirmation_number_outlined,
                    value: "123",
                  ),
                  CustomProfile(
                    attr: "Reg. No.",
                    iconsPath: Icons.app_registration,
                    value: "1656356",
                  ),
                  CustomProfile(
                    attr: "Gender",
                    iconsPath: Icons.female,
                    value: "Female",
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              child: Text(
                "Degree Information",
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.headline6.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 2.2 * SizeConfig.textMultiplier),
              ),
            ),
            Card(
              elevation: 0,
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              child: Column(
                children: [
                  CustomProfile(
                    attr: "Class",
                    iconsPath: Icons.class__outlined,
                    value: "10th",
                  ),
                  CustomProfile(
                    attr: "Section",
                    iconsPath: Icons.subject_outlined,
                    value: "A",
                  ),
                  CustomProfile(
                    attr: "Session",
                    iconsPath: Icons.settings_applications_rounded,
                    value: "2022 - 2024",
                  ),
                  CustomProfile(
                    attr: "Major",
                    iconsPath: Icons.rotate_90_degrees_ccw,
                    value: "Science",
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              child: Text(
                "Contact Information",
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.headline6.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 2.2 * SizeConfig.textMultiplier),
              ),
            ),
            Card(
              elevation: 0,
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              child: Column(
                children: [
                  CustomProfile(
                    attr: "Mobile No.",
                    iconsPath: Icons.call,
                    value: "034459504493",
                  ),
                  CustomProfile(
                    attr: "Email",
                    iconsPath: Icons.email,
                    value: "abcd@gmail.com",
                  ),
                  CustomProfile(
                    attr: "Adress",
                    iconsPath: Icons.rotate_90_degrees_ccw,
                    value: "Rawalpindi",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomProfile extends StatelessWidget {
  CustomProfile({Key key, this.attr, this.iconsPath, this.value})
      : super(key: key);
  final IconData iconsPath;
  final String attr;
  final String value;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      // contentPadding: EdgeInsets.all(0),
      leading: Padding(
        padding: EdgeInsets.only(left: 08),
        child: Icon(
          iconsPath,
          size: 24,
        ),
      ),
      title: Text(attr,
          style: Theme.of(context).textTheme.bodyText1.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: 2.0 * SizeConfig.textMultiplier),
          textAlign: TextAlign.left),
      trailing: Padding(
        padding: EdgeInsets.only(right: 10),
        child: Text(
          value,
          style: Theme.of(context).textTheme.bodyText1.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: 1.9 * SizeConfig.textMultiplier),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
