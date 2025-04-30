import 'package:flutter/material.dart';
import 'package:task_managemnt/data/model/complete_list_model.dart';
import 'package:task_managemnt/data/model/network_response.dart';
import 'package:task_managemnt/data/service/network_client.dart';
import 'package:task_managemnt/data/utils/urls.dart';
import 'package:task_managemnt/ui/widgets/centered_circular_progressIndicator.dart';
import 'package:task_managemnt/ui/widgets/snack_bar_message.dart';

import '../../../data/model/task_model.dart';
import '../../widgets/task_card.dart';

class CompleteTaskScreen extends StatefulWidget {
  const CompleteTaskScreen({super.key});

  @override
  State<CompleteTaskScreen> createState() => _CompleteTaskScreenState();
}

class _CompleteTaskScreenState extends State<CompleteTaskScreen> {

  List<TaskModel> _completeList = [];
  bool _inProgress = false;

  @override
  void initState() {
    super.initState();
    _getAllCompleteTaskList();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Visibility(
        visible: _inProgress == false,
        replacement: const CenteredCircularProgressIndicator(),
        child: ListView.separated(
          itemBuilder:(context, index) {
            return TaskCard(
              taskStatus: TaskStatus.completed,
              taskModel: _completeList[index],
              refreshList: _getAllCompleteTaskList,
            );
          },
          separatorBuilder: (context, index) => SizedBox(
            height: 8,
          ),
          itemCount: _completeList.length,
        ),
      ),
    );
  }

  Future<void>_getAllCompleteTaskList()async{
    setState(() {
      _inProgress = true;
    });
    NetworkResponse response = await NetworkClient.getRequest(url: Urls.completedTaskListUrl);
    setState(() {
      _inProgress = false;
    });
    if(response.isSuccess){
      CompleteListModel completeListModel = CompleteListModel.fromJson(response.data!);
      _completeList = completeListModel.taskCompleteList;
    }else{
      if(mounted){
        showSnackBarMessage(context, '${response.errorMessage}',true);
      }
    }
  }
}
