import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_getx/themes/theme_changer.dart';
import 'package:task_manager_getx/wrappers/svg_image_loader.dart';

class BackgroundWidget extends StatelessWidget {
  final Widget childWidget;

  const BackgroundWidget({super.key, required this.childWidget});

  @override
  Widget build(BuildContext context) {
    // Ensure you are using GetX to obtain the ThemeChanger instance.
    final themeChanger = Get.find<ThemeChanger>();

    return SafeArea(
      child: Stack(
        children: [
          Obx(() {
            return SizedBox(
              width: double.infinity,
              child: SVGImageLoader(
                asset: themeChanger.getBackgroundImage(context),
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.height,
              ),
            );
          }),
          childWidget,
        ],
      ),
    );
  }
}
