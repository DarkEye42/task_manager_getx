import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ionicons/ionicons.dart';
import 'package:get/get.dart';
import 'package:task_manager_getx/utils/app_strings.dart';
import 'package:task_manager_getx/viewModels/dashboard_view_model.dart';
import 'package:task_manager_getx/viewModels/task_view_model.dart';
import 'package:task_manager_getx/viewModels/user_view_model.dart';
import 'package:task_manager_getx/views/widgets/app_snackbar.dart';

import '../../models/taskListModel/task_data.dart';
import '../../utils/app_color.dart';

class TaskListCard extends StatelessWidget {
  final double screenWidth;
  final List<TaskData> taskData;
  final String currentScreen;
  final Color chipColor;

  const TaskListCard({
    super.key,
    required this.screenWidth,
    required this.taskData,
    required this.chipColor,
    required this.currentScreen,
  });

  @override
  Widget build(BuildContext context) {
    final taskViewModel = Get.find<TaskViewModel>();
    final userViewModel = Get.find<UserViewModel>();
    final dashboardViewModel = Get.find<DashboardViewModel>();

    return Expanded(
      child: ListView.separated(
        itemBuilder: (context, index) {
          return SizedBox(
            width: screenWidth,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18.0,
                  vertical: 13.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ExpansionTile(
                      initiallyExpanded: taskData[index].isTileExpanded,
                      dense: false,
                      iconColor: chipColor,
                      leading: CircleAvatar(
                        radius: 15,
                        backgroundColor: chipColor,
                        child: Text(
                          textAlign: TextAlign.center,
                          "${index + 1}",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                      onExpansionChanged: (value) {
                        taskViewModel.setIsTileExpanded(
                          taskData[index].status.toString(),
                          index,
                          value,
                        );
                      },
                      subtitle: !taskData[index].isTileExpanded
                          ? Text(
                        textAlign: TextAlign.start,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        taskData[index].description.toString(),
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                          : null,
                      title: Text(
                        taskData[index].title.toString(),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      children: [
                        Wrap(
                          children: [
                            SizedBox(
                              width: screenWidth * 0.8,
                              child: Text(
                                textAlign: TextAlign.justify,
                                taskData[index].description.toString(),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Gap(10),
                    Text(
                      "Date: ${taskData[index].createdDate.toString().replaceAll("-", "/")}",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const Gap(5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Chip(
                          label: Text(taskData[index].status.toString()),
                          backgroundColor: chipColor,
                          labelPadding: const EdgeInsets.symmetric(
                            horizontal: 33,
                            vertical: 0,
                          ),
                          labelStyle: const TextStyle(
                            color: AppColor.newTaskChipTextColor,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            PopupMenuButton<String>(
                              onSelected: (value) async {
                                await updateItem(
                                  context,
                                  index,
                                  value,
                                  taskViewModel,
                                  userViewModel,
                                  dashboardViewModel,
                                );
                              },
                              child: const Icon(
                                Icons.edit_note_outlined,
                                color: AppColor.appPrimaryColor,
                              ),
                              itemBuilder: (context) {
                                return [
                                  const PopupMenuItem<String>(
                                    value: "Completed",
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.done_outline_rounded,
                                          color: AppColor.completedChipColor,
                                        ),
                                        Gap(8),
                                        Text("Completed"),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem<String>(
                                    value: "Progress",
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.watch_later_outlined,
                                          color: AppColor.progressChipColor,
                                        ),
                                        const Gap(8),
                                        const Text("Progress"),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem<String>(
                                    value: "Canceled",
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.cancel_outlined,
                                          color: AppColor.canceledChipColor,
                                        ),
                                        const Gap(8),
                                        const Text("Cancel"),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem<String>(
                                    value: "New",
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.add,
                                          color: AppColor.newTaskChipColor,
                                        ),
                                        const Gap(8),
                                        const Text("New"),
                                      ],
                                    ),
                                  ),
                                ];
                              },
                            ),
                            IconButton(
                              onPressed: () {
                                itemDeletion(
                                  context,
                                  index,
                                  taskViewModel,
                                  userViewModel,
                                );
                              },
                              icon: const Icon(
                                Ionicons.trash,
                                color: AppColor.deleteIconColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Obx(() {
                      if (taskViewModel.selectedIndex.containsKey(
                        taskData[index].status,
                      )) {
                        if (taskViewModel.selectedIndex.containsValue(index)) {
                          return const SizedBox(
                            height: 1,
                            child: LinearProgressIndicator(
                              color: AppColor.appPrimaryColor,
                            ),
                          );
                        }
                      }
                      return const SizedBox.shrink();
                    }),
                  ],
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => const Gap(5),
        itemCount: taskData.length,
      ),
    );
  }

  Future<void> updateItem(
      BuildContext context,
      int index,
      String value,
      TaskViewModel taskViewModel,
      UserViewModel userViewModel,
      DashboardViewModel dashboardViewModel,
      ) async {
    if (value != currentScreen) {
      bool status = await taskViewModel.updateTask(
        token: userViewModel.token,
        taskId: taskData[index].sId.toString(),
        taskStatus: value,
        currentScreenStatus: currentScreen,
        index: index,
        dashboardViewModel: dashboardViewModel,
      );
      if (status) {
        AppSnackBar().showSnackBar(
          title: AppStrings.taskStatusUpdateSuccessTitle,
          content: AppStrings.taskStatusUpdateSuccessMessage,
          contentType: ContentType.success,
          color: AppColor.snackBarSuccessColor,
          context: context,
        );
      } else {
        AppSnackBar().showSnackBar(
          title: AppStrings.taskStatusUpdateFailureTitle,
          content: AppStrings.taskStatusUpdateFailureMessage,
          contentType: ContentType.failure,
          color: AppColor.snackBarFailureColor,
          context: context,
        );
      }
    }
  }

  Future<void> itemDeletion(
      BuildContext context,
      int index,
      TaskViewModel taskViewModel,
      UserViewModel userViewModel,
      ) async {
    bool status = await taskViewModel.deleteTask(
      userViewModel.token,
      taskData[index].sId.toString(),
      taskData[index].status.toString(),
      index,
    );
    if (status) {
      AppSnackBar().showSnackBar(
        title: AppStrings.taskItemDeleteSuccessTitle,
        content: AppStrings.taskItemDeleteSuccessMessage,
        contentType: ContentType.success,
        color: AppColor.snackBarSuccessColor,
        context: context,
      );
    } else {
      AppSnackBar().showSnackBar(
        title: AppStrings.taskItemDeleteFailedTitle,
        content: AppStrings.taskItemDeleteFailureMessage,
        contentType: ContentType.failure,
        color: AppColor.snackBarFailureColor,
        context: context,
      );
    }
  }
}