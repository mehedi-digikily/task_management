import 'package:flutter/material.dart';
import 'package:task_managemnt/data/model/task_list_model.dart';
import 'package:task_managemnt/data/model/task_model.dart';

import '../../../data/model/network_response.dart';
import '../../../data/model/task_status_count_list_model.dart';
import '../../../data/model/task_status_count_model.dart';
import '../../../data/service/network_client.dart';
import '../../../data/utils/urls.dart';
import '../../widgets/centered_circular_progressIndicator.dart';
import '../../widgets/snack_bar_message.dart';
import '../../widgets/summary_card.dart';
import '../../widgets/task_card.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  List<TaskStatusCountModel> _taskStatusCountList = [];
  bool _getStatusCountInProgress = true;
  List<TaskModel> _newTaskList = [];
  bool _getNewTasksInProgress = true;

  @override
  void initState() {
    super.initState();
    _getAllTaskStatusCount();
    _getAllNewTaskList();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSummarySection(),
            Visibility(
              visible: _getNewTasksInProgress == false,
              replacement: SizedBox(
                  height: 500,
                  child: CenteredCircularProgressIndicator()),
              child: ListView.separated(
                primary: false,
                shrinkWrap: true,
                itemBuilder: (context, index) => TaskCard(
                  refreshList: _getAllNewTaskList,
                  taskModel: _newTaskList[index], taskStatus: TaskStatus.sNew,
                  
                ),
                separatorBuilder: (context, index) => SizedBox(
                  height: 8,
                ),
                itemCount: _newTaskList.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummarySection() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: SizedBox(
        height: 100,
        child: Visibility(
          visible: _getStatusCountInProgress == false,
          replacement: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _taskStatusCountList.length,
            itemBuilder: (context, index) => SummaryCard(
              tittle: _taskStatusCountList[index].status,
              count: _taskStatusCountList[index].count,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _getAllTaskStatusCount() async {
    _getStatusCountInProgress = true;
    setState(() {});
    final NetworkResponse response =
        await NetworkClient.getRequest(url: Urls.taskStatusCountUrl);

    if (response.isSuccess) {
      TaskStatusCountListModel taskStatusCountListModel =
          TaskStatusCountListModel.fromJson(response.data ?? {});
      _taskStatusCountList = taskStatusCountListModel.statusCountList;
setState(() {

});
    } else {
      if(mounted){
        showSnackBarMessage(context, '${response.errorMessage}', true);
      }
    }

    _getStatusCountInProgress = false;
    setState(() {});
  }

  Future<void> _getAllNewTaskList() async {
    _getNewTasksInProgress = true;
    setState(() {});
    NetworkResponse response =
        await NetworkClient.getRequest(url: Urls.listTaskByStatusNewUrl);
    if (response.isSuccess) {
      TaskListModel taskModel = TaskListModel.fromJson(response.data ?? {});
      _newTaskList = taskModel.taskList;
    } else {
      showSnackBarMessage(context, '${response.errorMessage}', true);
    }
    _getNewTasksInProgress = false;
    setState(() {});
  }
}
