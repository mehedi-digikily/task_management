import 'package:flutter/material.dart';
import 'package:task_managemnt/data/model/network_response.dart';
import 'package:task_managemnt/data/model/task_model.dart';
import 'package:task_managemnt/data/service/network_client.dart';
import 'package:task_managemnt/data/utils/urls.dart';
import 'package:task_managemnt/ui/widgets/centered_circular_progressIndicator.dart';
import 'package:task_managemnt/ui/widgets/snack_bar_message.dart';

enum TaskStatus { sNew, progress, completed, cancelled }

class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key,
    required this.taskStatus,
    required this.taskModel, required this.refreshList,
  });

  final TaskStatus taskStatus;
  final TaskModel taskModel;
  final VoidCallback refreshList;


  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool inProgress = false;
  bool editInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: inProgress == false,
      replacement: CenteredCircularProgressIndicator(),
      child: Card(
        color: Colors.white,
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.taskModel.title,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(widget.taskModel.description),
              Text('Date ${widget.taskModel.createdDate}'),
              Row(
                children: [
                  Chip(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    label: Text(
                      widget.taskModel.status,
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: _getStatusChipColor(),
                  ),
                  const Spacer(),
                  Visibility(
                    replacement: CenteredCircularProgressIndicator(),
                    visible: editInProgress == false,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: _showUpdateStatusDialog,
                          icon: Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            _onTapDelete(widget.taskModel.id);
                          },
                          icon: Icon(Icons.delete),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onTapDelete(id) async {
    setState(() {
      inProgress = true;
    });
    NetworkResponse response =
        await NetworkClient.getRequest(url: Urls.deleteTaskUrl(id));
    if (response.isSuccess) {
      if (mounted) {
        showSnackBarMessage(context, 'Deleted');
      }
    } else {
      if (mounted) {
        showSnackBarMessage(context, '${response.errorMessage}', true);
      }
    }
    setState(() {
      inProgress = false;
    });
  }

  void _showUpdateStatusDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: (){
                  _navigatePop();
                  if(isSelected('New')){
                    return;
                  }else{
                    _changeTaskStatus('New');
                    }
                },
                title: Text('New'),
                trailing:
                    widget.taskModel.status == 'New' ? Icon(Icons.done) : null,
              ),
              ListTile(
                onTap: (){
                  _navigatePop();
                  if(isSelected('Progress')){
                    return;
                  }else{
                    _changeTaskStatus('Progress');
                  }
                },
                title: Text('Progress'),
                trailing: isSelected('Progress')
                    ? Icon(Icons.done_outline_rounded)
                    : null,
              ),
              ListTile(
                onTap: (){
                  _navigatePop();
                  if(isSelected('Completed')){
                    return;
                  }else{
                    _changeTaskStatus('Completed');
                  }
                },
                title: Text('Completed'),
                trailing: isSelected('Completed')
                    ? Icon(Icons.done_outline_rounded)
                    : null,
              ),
              ListTile(
                onTap: (){
                  _navigatePop();
                  if(isSelected('Cancelled')){
                    return;
                  }else{
                    _changeTaskStatus('Cancelled');
                  }
                },
                title: Text('Cancelled'),
                trailing: isSelected('Cancelled')
                    ? Icon(Icons.done_outline_rounded)
                    : null,
              ),
            ],
          ),
        );
      },
    );
  }
  Future<void>_changeTaskStatus(String status)async {
    setState(() {
      editInProgress = true;
    });
    final NetworkResponse response = await NetworkClient.getRequest(url: Urls.updateTaskStatusUrl(widget.taskModel.id, status));
    setState(() {
      editInProgress = false;
    });
    if(response.isSuccess){
      widget.refreshList;
      setState(() {});
    }else{
      if(mounted){
      showSnackBarMessage(context, '${response.errorMessage}',true);
    }
      setState(() {
      });
    }
  }
  void _navigatePop(){
    Navigator.pop(context);
  }

  bool isSelected(String status) => widget.taskModel.status == status;

  Color _getStatusChipColor() {
    late Color color;
    switch (widget.taskStatus) {
      case TaskStatus.sNew:
        color = Colors.blue;
      case TaskStatus.progress:
        color = Colors.purple;
      case TaskStatus.completed:
        color = Colors.green;
      case TaskStatus.cancelled:
        color = Colors.red;
    }
    return color;
  }
}
