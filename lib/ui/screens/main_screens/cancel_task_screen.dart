import 'package:flutter/material.dart';
import 'package:task_managemnt/data/model/network_response.dart';
import 'package:task_managemnt/data/service/network_client.dart';
import 'package:task_managemnt/ui/widgets/centered_circular_progressIndicator.dart';
import 'package:task_managemnt/ui/widgets/snack_bar_message.dart';

import '../../../data/model/cancelled_model_list.dart';
import '../../../data/model/task_model.dart';
import '../../../data/utils/urls.dart';
import '../../widgets/task_card.dart';

class CancelTaskScreen extends StatefulWidget {
  const CancelTaskScreen({super.key});

  @override
  State<CancelTaskScreen> createState() => _CancelTaskScreenState();
}

class _CancelTaskScreenState extends State<CancelTaskScreen> {
  List<TaskModel> _cancelledList = [];
  bool _inProgress = false;

  @override
  void initState() {
    super.initState();
    _getCancelledTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Visibility(
      visible: _inProgress == false,
      replacement: CenteredCircularProgressIndicator(),
      child: ListView.separated(
        primary: false,
        shrinkWrap: true,
        itemBuilder: (context, index) => TaskCard(
          taskStatus: TaskStatus.cancelled,
          taskModel: _cancelledList[index], refreshList: _getCancelledTask,
        ),
        separatorBuilder: (context, index) => SizedBox(
          height: 8,
        ),
        itemCount: _cancelledList.length,
      ),
    ));
  }

  Future<void> _getCancelledTask() async {
    setState(() {
      _inProgress = true;
    });
    NetworkResponse response =
        await NetworkClient.getRequest(url: Urls.cancelledTaskListUrl);
    if (response.isSuccess) {
      CancelledListModel cancelledListModel =
          CancelledListModel.fromJson(response.data!);
      _cancelledList = cancelledListModel.taskCancelledList;
    } else {
      if(mounted){
        showSnackBarMessage(context, '${response.errorMessage}');
      }
    }
    setState(() {
      _inProgress = false;
    });
  }
}
