import 'package:flutter/material.dart';
import 'package:task_managemnt/data/model/network_response.dart';
import 'package:task_managemnt/data/service/network_client.dart';
import 'package:task_managemnt/ui/widgets/centered_circular_progressIndicator.dart';
import 'package:task_managemnt/ui/widgets/snack_bar_message.dart';

import '../../../data/utils/urls.dart';
import '../../widgets/screen_background.dart';
import '../../widgets/tm_app_bar.dart';
import 'main_bottom_nav_screen';

class AddNewTask extends StatefulWidget {
  const AddNewTask({super.key});

  @override
  State<AddNewTask> createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  final TextEditingController _tittleTEController = TextEditingController();
  final TextEditingController _descriptionTEController =
      TextEditingController();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  bool inProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(),
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _globalKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                Text(
                  'Add New Task',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  controller: _tittleTEController,
                  decoration: const InputDecoration(
                    hintText: 'Subject',
                  ),
                  validator: (String? value) {
                    if (value!.trim().isEmpty) {
                      return 'Enter tittle';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  controller: _descriptionTEController,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    hintText: 'Description',
                  ),
                  validator: (String? value) {
                    if (value!.trim().isEmpty) {
                      return 'Enter Description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Visibility(
                  visible: inProgress == false,
                  replacement: CenteredCircularProgressIndicator(),
                  child: ElevatedButton(
                    onPressed: () {
                      onTapNext();
                    },
                    child: const Icon(Icons.arrow_circle_right_outlined),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // AppBar _buildAppBar() {
  //   return AppBar(
  //     backgroundColor: Colors.green,
  //     title: Row(
  //       children: [
  //         CircleAvatar(
  //           backgroundColor: Colors.blueAccent,
  //           child: Image.network(
  //             'https://scontent.fdac24-2.fna.fbcdn.net/v/t39.30808-6/480590485_2746937219028780_7046687641455399451_n.jpg?_nc_cat=108&ccb=1-7&_nc_sid=6ee11a&_nc_eui2=AeHbYJuAl5sy_WJDKH0X5uOzhsu7AQ_CMwOGy7sBD8IzA58g4dT2NjuGmaX-r8lE7ln0ie7lfXuUfD31sq4VdlYD&_nc_ohc=4zJ2Ie5CxVUQ7kNvgEdJNt4&_nc_oc=Adi3AVTIx0Pc3pErhTi9SykPAV43HIsNa2ZEllazGEKaNq1RtaoVRG0caHEfY3RuoR4&_nc_zt=23&_nc_ht=scontent.fdac24-2.fna&_nc_gid=SuDLj-aw5CXBB0-IqY6r7w&oh=00_AYHIRIV0fMuS6FM71nFQxR6tQu2HyjNlFBFeIK_j6S3oJA&oe=67DD1BDE',
  //             fit: BoxFit.cover,
  //           ),
  //         ),
  //         SizedBox(
  //           width: 16,
  //         ),
  //         Column(
  //           children: [
  //             Text(
  //               'Mehedi Hasan',
  //               style: TextStyle(
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.bold,
  //                 color: Colors.white70,
  //               ),
  //             ),
  //             Text(
  //               'info.itsmehedi@gmail.com',
  //               style: TextStyle(fontSize: 10, color: Colors.white70),
  //             ),
  //           ],
  //         ),
  //         const Spacer(),
  //         TextButton(
  //           onPressed: () {},
  //           child: Icon(Icons.login_outlined),
  //         )
  //       ],
  //     ),
  //   );
  // }

  void onTapNext() {
    if (_globalKey.currentState!.validate()) {
      addTask();
    }
  }

  Future<void> addTask() async {
    setState(() {
      inProgress = true;
    });

    Map<String, dynamic> requestBody = {
      "title": _tittleTEController.text.trim(),
      "description": _descriptionTEController.text.trim(),
      "status": "New"
    };
    NetworkResponse response = await NetworkClient.postRequest(
        url: Urls.createTaskUrl, body: requestBody);
    setState(() {
      inProgress = false;
    });
    if (response.isSuccess) {
      if (mounted) {
        showSnackBarMessage(context, 'New Task Added');
        onTapNextScreen();
      }
    } else {
      if (mounted) {
        showSnackBarMessage(context, '${response.errorMessage}', false);
      }
    }
  }

  void onTapNextScreen() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => MainBottomNavScreen(),
        ),
            (predicate) => false);
  }

  @override
  void dispose() {
    _tittleTEController.dispose();
    _descriptionTEController.dispose();
    super.dispose();
  }
}
