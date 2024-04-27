// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';

import '../../../../core/resources/color_res.dart';
import '../../../../core/utils/lang/app_localizations.dart';
import '../../../../core/utils/nums.dart';

// ignore: must_be_immutable
class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String subtitle;
  final bool isBackButton;
  final bool isActionButton;
  final String? previousRouteName;
  const AppBarWidget({
    super.key,
    required this.title,
    this.subtitle = '',
    this.isBackButton = false,
    this.isActionButton = false,
    this.previousRouteName,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      elevation: 0.0,
      toolbarHeight: 70,
      title: Padding(
          padding: const EdgeInsets.only(right: 0),
          child: Text(
            AppLocalizations.of(context).translate(title.toString()),
            style: TextStyle(color: Colors.white),
          )),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                spreadRadius: 1,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25)),
            color: Color(0xff042a49)),
      ),
      actions: [
        isActionButton
            ? PopupMenuButton<SortingOption>(
                icon: const Icon(
                  Icons.sort,
                  color: Colors.white,
                ),
                iconColor: Colors.white,
                onSelected: (option) {
                  
                },
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<SortingOption>>[
                  PopupMenuItem<SortingOption>(
                    value: SortingOption.byDateTime,
                    child: Text('Sort by Date/Time'),
                  ),
                  PopupMenuItem<SortingOption>(
                    value: SortingOption.byStarCount,
                    child: Text('Sort by Star Count'),
                  ),
                ],
              )
            : SizedBox(),
        // LanguagePickerWidget(),
      ],
      leading: Builder(
        builder: (BuildContext context) {
          return !isBackButton
              ? IconButton(
                  color: Colors.white,
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer())
              : IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: ColorRes.kWhiteColor,
                  ),
                );
        },
      ),
    );
  }
}
