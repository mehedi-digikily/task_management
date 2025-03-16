class Urls{
  static final String _baseUrl = 'https://task.teamrabbil.com/api/v1';
  static final String registration = '$_baseUrl/registration';
  static final String login = '$_baseUrl/login';
  static final String profileUpdate = '$_baseUrl/profileUpdate';
  static final String createTask = '$_baseUrl/createTask';
  static final String recoverResetPass = '$_baseUrl/RecoverResetPass';
  static final String listTaskByStatus = '$_baseUrl/listTaskByStatus';
  static String updateTaskStatus (String iD)=> '$_baseUrl/updateTaskStatus$iD';
  static String deleteTask (String iD)=> '$_baseUrl/deleteTask$iD';
  static String taskStatusCount (String iD)=> '$_baseUrl/taskStatusCount$iD';
  static String recoverVerifyEmail (String email)=> '$_baseUrl/RecoverVerifyEmail$email';
  static String recoverVerifyOTP (String email, int otp)=> '$_baseUrl/RecoverVerifyEmail$email/$otp';
}