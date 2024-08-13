import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_getx/themes/theme_changer.dart';
import 'package:task_manager_getx/utils/app_routes.dart';
import 'package:task_manager_getx/viewModels/auth_view_model.dart';
import 'package:task_manager_getx/viewModels/user_view_model.dart';

import '../../utils/app_assets.dart';

AppBar getApplicationAppBar(
    {required BuildContext context, required bool disableNavigation}) {
  final userViewModel = Get.find<UserViewModel>();
  final themeChanger = Get.find<ThemeChanger>();

  return AppBar(
    automaticallyImplyLeading: false,
    title: Obx(() {
      return Row(
        children: [
          InkWell(
            onTap: () {
              if (!disableNavigation) {
                Get.toNamed(AppRoutes.updateProfileScreen)?.then((_) {
                  userViewModel.base64Image = "";
                  userViewModel.imageName = "";
                });
              }
            },
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              backgroundImage: (userViewModel.userData.photo!.isEmpty)
                  ? const AssetImage(AppAssets.userDefaultImage)
                  : MemoryImage(
                base64Decode(
                  userViewModel.userData.photo.toString(),
                ),
              ),
            ),
          ),
          const Gap(10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${userViewModel.userData.firstName} ${userViewModel.userData.lastName}",
                style: Theme.of(context).textTheme.labelMedium,
              ),
              Text(
                userViewModel.userData.email.toString(),
                style: Theme.of(context).textTheme.labelSmall,
              )
            ],
          )
        ],
      );
    }),
    actions: [
      Obx(() {
        return IconButton(
          onPressed: () async {
            final newThemeMode = themeChanger.getThemeMode(context) == ThemeMode.dark
                ? ThemeMode.light
                : ThemeMode.dark;
            themeChanger.setThemeMode = newThemeMode;
            await saveThemeData(newThemeMode == ThemeMode.dark ? "dark" : "light");
          },
          splashColor: Colors.transparent,
          icon: Icon(
            themeChanger.getThemeMode(context) == ThemeMode.dark
                ? Icons.light_mode_outlined
                : Icons.dark_mode_outlined,
          ),
        );
      }),
      IconButton(
        onPressed: () async {
          await Get.find<AuthViewModel>().signOut();
        },
        icon: const Icon(Icons.logout),
      ),
    ],
  );
}

Future<void> saveThemeData(String theme) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setString("themeMode", theme);
}
