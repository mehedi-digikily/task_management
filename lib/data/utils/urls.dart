class Urls {
  static const String _baseUrl = 'http://35.73.30.144:2005/api/v1';

  // 🔐 Authentication
  static const String registerUrl = '$_baseUrl/Registration';
  static const String loginUrl = '$_baseUrl/Login';

  // 👤 Profile
  static const String profileUpdateUrl = '$_baseUrl/ProfileUpdate';

  // ✅ Task Management
  static const String createTaskUrl = '$_baseUrl/createTask';
  static String deleteTaskUrl(String id) => '$_baseUrl/deleteTask/$id';
  static String updateTaskStatusUrl(String id, String status) =>
      '$_baseUrl/updateTaskStatus/$id/$status';

  // 📊 Task Status
  static const String taskStatusCountUrl = '$_baseUrl/taskStatusCount';
  static const String listTaskByStatusNewUrl = '$_baseUrl/listTaskByStatus/New';
  static const String progressTaskListUrl = '$_baseUrl/listTaskByStatus/Progress';
  static const String completedTaskListUrl = '$_baseUrl/listTaskByStatus/Completed';
  static const String cancelledTaskListUrl = '$_baseUrl/listTaskByStatus/Cancelled';

  // 🔄 Password Recovery
  static String recoverVerifyEmailUrl(String email) => '$_baseUrl/RecoverVerifyEmail/$email';
  static String recoverVerifyEmailOtpUrl(String email, String otp) =>
      '$_baseUrl/RecoverVerifyOtp/$email/$otp';
  static String recoverResetPasswordUrl = '$_baseUrl/RecoverResetPassword';
}
