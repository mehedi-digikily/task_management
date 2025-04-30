
import 'package:task_managemnt/data/model/task_model.dart';

class TaskProgressListModel{
  late final String status;
  late final List<TaskModel> taskProgressList;

  TaskProgressListModel.fromJson(Map<String,dynamic> jsonData){
    status = jsonData['status'];
    if(jsonData['data'] != null){
      List<TaskModel> list = [];
      for(Map<String,dynamic> data in jsonData['data']){
        list.add(TaskModel.fromJson(data));
      }
      taskProgressList = list;
    }else{
      taskProgressList = [];
    }
  }
}