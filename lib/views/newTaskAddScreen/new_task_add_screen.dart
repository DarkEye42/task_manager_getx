import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:task_manager_getx/services/connectivity_checker.dart';
import 'package:task_manager_getx/utils/app_color.dart';
import 'package:task_manager_getx/utils/app_routes.dart';
import 'package:task_manager_getx/utils/app_strings.dart';
import 'package:task_manager_getx/views/widgets/fallback_widget.dart';
import 'package:task_manager_getx/views/widgets/loading_layout.dart';
import 'package:task_manager_getx/views/widgets/task_list_card.dart';
import 'package:task_manager_getx/views/widgets/task_status_card.dart';

import '../../utils/app_assets.dart';
import '../../viewModels/task_view_model.dart';
import '../../viewModels/user_view_model.dart';

class NewTaskAddScreen extends StatefulWidget {
  const NewTaskAddScreen({super.key});

  @override
  State<NewTaskAddScreen> createState() => _NewTaskAddScreenState();
}

class _NewTaskAddScreenState extends State<NewTaskAddScreen> {
  AppLifecycleState appLifecycleState = AppLifecycleState.detached;

  @override
  void initState() {
    super.initState();
    fetchTasksData();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final connectivityChecker = Get.find<ConnectivityChecker>();
    final taskViewModel = Get.find<TaskViewModel>();
    final userViewModel = Get.find<UserViewModel>();

    return Scaffold(
      body: Container(
        height: screenHeight,
        margin: const EdgeInsets.all(8.0),
        child: RefreshIndicator(
          color: AppColor.appPrimaryColor,
          onRefresh: () async {
            await fetchTasksData();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Obx(() {
                  if (connectivityChecker.isDeviceConnected) {
                    if (taskViewModel.taskDataByStatus[AppStrings.taskStatusNew] ==
                        null) {
                      fetchTasksData();
                    }
                    if (taskViewModel.taskStatusCount.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return Row(
                      children: [
                        TaskStatusCard(
                            screenWidth: screenWidth,
                            titleText: (taskViewModel.taskStatusCount[
                            AppStrings.taskStatusCanceled] !=
                                "0")
                                ? taskViewModel.taskStatusCount[
                            AppStrings.taskStatusCanceled]
                                ?.padLeft(2, "0") ??
                                "0"
                                : "0",
                            subtitleText: "Canceled"),
                        TaskStatusCard(
                            screenWidth: screenWidth,
                            titleText: (taskViewModel.taskStatusCount[
                            AppStrings.taskStatusCompleted] !=
                                "0")
                                ? taskViewModel.taskStatusCount[
                            AppStrings.taskStatusCompleted]
                                ?.padLeft(2, "0") ??
                                "0"
                                : "0",
                            subtitleText: AppStrings.taskStatusCompleted),
                        TaskStatusCard(
                            screenWidth: screenWidth,
                            titleText: (taskViewModel.taskStatusCount[
                            AppStrings.taskStatusProgress] !=
                                "0")
                                ? taskViewModel.taskStatusCount[
                            AppStrings.taskStatusProgress]
                                ?.padLeft(2, "0") ??
                                "0"
                                : "0",
                            subtitleText: AppStrings.taskStatusProgress),
                        TaskStatusCard(
                            screenWidth: screenWidth,
                            titleText: (taskViewModel.taskStatusCount[
                            AppStrings.taskStatusNew] !=
                                "0")
                                ? taskViewModel.taskStatusCount[
                            AppStrings.taskStatusNew]
                                ?.padLeft(2, "0") ??
                                "0"
                                : "0",
                            subtitleText: AppStrings.taskStatusNew),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                }),
              ),
              const Gap(5),
              Obx(() {
                if (taskViewModel.taskDataByStatus[AppStrings.taskStatusNew] ==
                    null) {
                  return const LoadingLayout();
                }
                if (taskViewModel
                    .taskDataByStatus[AppStrings.taskStatusNew]!.isEmpty) {
                  return const FallbackWidget(
                      noDataMessage: AppStrings.noNewTaskData,
                      asset: AppAssets.emptyList);
                }
                return TaskListCard(
                  screenWidth: screenWidth,
                  taskData:
                  taskViewModel.taskDataByStatus[AppStrings.taskStatusNew]!,
                  chipColor: AppColor.newTaskChipColor,
                  currentScreen: AppStrings.taskStatusNew,
                );
              }),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(AppRoutes.addTaskScreen);
        },
        backgroundColor: AppColor.appPrimaryColor,
        child: const Icon(Icons.add, size: 27),
      ),
    );
  }

  Future<void> fetchTasksData() async {
    final taskViewModel = Get.find<TaskViewModel>();
    final userViewModel = Get.find<UserViewModel>();

    await taskViewModel.fetchTaskStatusData(userViewModel.token);
    await taskViewModel.fetchTaskList(userViewModel.token);
  }
}