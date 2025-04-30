
import 'package:flutter/material.dart';

import '../../../data/model/network_response.dart';
import '../../../data/model/task_list_model.dart';
import '../../../data/model/task_model.dart';
import '../../../data/service/network_client.dart';
import '../../../data/utils/urls.dart';
import '../../widgets/centered_circular_progressIndicator.dart';
import '../../widgets/snack_bar_message.dart';
import '../../widgets/task_card.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {
  bool _getProgressTasksInProgress = false;
  List<TaskModel> _progressTaskList = [];

  @override
  void initState() {
    super.initState();
    _getAllProgressTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Visibility(
        visible: _getProgressTasksInProgress == false,
        replacement: const CenteredCircularProgressIndicator(),
        child: ListView.separated(
          itemCount: _progressTaskList.length,
          itemBuilder: (context, index) {
            return TaskCard(
              taskStatus: TaskStatus.progress,
              taskModel: _progressTaskList[index],
              refreshList: _getAllProgressTaskList,
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: 8),
        ),
      ),
    );
  }

  Future<void> _getAllProgressTaskList() async {
    _getProgressTasksInProgress = true;
    setState(() {});
    final NetworkResponse response =
    await NetworkClient.getRequest(url: Urls.progressTaskListUrl);
    if (response.isSuccess) {
      TaskListModel taskListModel = TaskListModel.fromJson(response.data ?? {});
      _progressTaskList = taskListModel.taskList;
    } else {
      if(mounted){
        showSnackBarMessage(context, '${response.errorMessage}', true);
      }
    }

    _getProgressTasksInProgress = false;
    setState(() {});
  }
}