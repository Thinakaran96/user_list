import 'package:assesment1/app/app_styles/style.dart';
import 'package:flutter/material.dart';

class UserWidget extends StatelessWidget {
  final String? firstName;
  final String? lastName;
  final String? profileLink;
  final String? email;
  final Function? onTap;

  const UserWidget({
    super.key,
    this.firstName,
    this.lastName,
    this.profileLink,
    this.email,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap!(),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
            color: Colors.black12, borderRadius: BorderRadius.circular(16)),
        child: Center(
          child: ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(profileLink!),
            ),
            title: Text(
              '$firstName $lastName',
              style: Style.nameTextStyle,
            ),
            subtitle: Text(email!, style: Style.emailStyle),
          ),
        ),
      ),
    );
  }
}
