import 'package:base_project/controller/login/login_view_controller.dart';
import 'package:base_project/model/api_request/login_request.dart';
import 'package:base_project/model/api_response/login_response.dart';
import 'package:base_project/services/network/api_repository.dart';
import 'package:base_project/utility/enums/login_status.dart';
import 'package:base_project/utility/enums/status_code_enum.dart';
import 'package:mockito/mockito.dart';

class UserNameAndPassword {
  String userName;
  String passWord;

  UserNameAndPassword(this.userName, this.passWord);
}

class MockLoginViewController with Mock implements LoginViewController {

  @override
  final repository = APIRepository();

  @override
  LoginData? loginResponse;


  @override
  Future<LoginResponse> apiCallLogin(
      {required String username,required String encryptedPassword}) async {
    LoginRequest loginRequest =
    LoginRequest(userId: username, password: encryptedPassword);
    LoginResponse response = await repository.login(request: loginRequest);
    if (response.status == StatusCodeEnum.success.statusValue) {
      logger.i("authenticating user[$username] | CHECKING STATUS-CODE-200");
      return response;
    } else {
      logger.e(
          "Error while authenticating the user from method authenticateUser() and Responded code is ${response.status} and the ERROR is ${response.message}");
      return response;
    }
  }


  checkLogin(String username,String password) async {
    if (checkCredential()) {
      String encryptedPass =
      encryptionService.encryptUserPassword(password);
      loginResponse = await apiCallLogin(username: username,encryptedPassword: encryptedPass).then((value) {
        if (value.status == StatusCodeEnum.success.statusValue) {
          loginStatus.value = getStatus(value);
          if (loginStatus.value == LoginStatus.success) {

          }
      }});}
  }
}
