import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../utils/app_assets.dart';
import '../../utils/app_color.dart';
import '../../utils/app_strings.dart';
import '../../viewModels/task_view_model.dart';
import '../../viewModels/user_view_model.dart';
import '../widgets/fallback_widget.dart';
import '../widgets/loading_layout.dart';
import '../widgets/task_list_card.dart';

class TaskCompletedScreen extends StatelessWidget {
  const TaskCompletedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TaskViewModel taskViewModel = Get.find<TaskViewModel>();
    final UserViewModel userViewModel = Get.find<UserViewModel>();
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(8),
        child: RefreshIndicator(
          color: AppColor.appPrimaryColor,
          onRefresh: () async {
            await fetchListData(taskViewModel, userViewModel);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(5),
              Obx(() {
                if (taskViewModel.taskDataByStatus[AppStrings.taskStatusCompleted] == null) {
                  return const LoadingLayout();
                }
                if (taskViewModel.taskDataByStatus[AppStrings.taskStatusCompleted]!.isEmpty) {
                  return const FallbackWidget(
                    noDataMessage: AppStrings.noCompletedTaskData,
                    asset: AppAssets.emptyList,
                  );
                }
                return TaskListCard(
                  screenWidth: screenWidth,
                  taskData: taskViewModel.taskDataByStatus[AppStrings.taskStatusCompleted]!,
                  chipColor: AppColor.completedChipColor,
                  currentScreen: AppStrings.taskStatusCompleted,
                );
              })
            ],
          ),
        ),
      ),
    );
  }

  Future<void> fetchListData(TaskViewModel taskViewModel, UserViewModel userViewModel) async {
    await taskViewModel.fetchTaskList(userViewModel.token);
  }
}
