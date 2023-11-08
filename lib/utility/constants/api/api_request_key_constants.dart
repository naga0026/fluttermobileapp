/*
All the api parameter keys will be here as one constant file
so, in future if there is a need to change the name of key
we can only replace it here no need to find all the occurrences in the code
 */


class APIRequestKeyConstants {

  //region Login
  static const String usernameApiKey = 'username';
  static const String passwordApiKey = 'password';
  //endregion

  //region SGM
  static const String originApiKey = 'origin';
  static const String reasonApiKey = 'reason';
  static const String deptApiKey = 'department';
  static const String classApiKey = 'class';
  static const String uLineApiKey = 'uLine';
  static const String currentPriceApiKey = 'curr_price';
  static const String newPriceApiKey = 'new_price';
  static const String quantityApiKey = 'quantity';
  //endregion
}