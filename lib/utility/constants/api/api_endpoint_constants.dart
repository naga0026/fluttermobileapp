/*
All the constants related to api end points will be here
Always group constants in a region related to its functionality
for better readability and easy access
select all the code you want to include in a region and the hit the command
Command for creating a region: ctrl + alt + t
select second option and set the name for region
 */

class APIEndPointConstants {

  //region Login
  static const String loginEndPoint = '/auth/login';
  //endregion

  //region Markdown
  static const String markdownEndPoint = '/markdown/markdown';
  static const String initEndPoint = '/markdown/init';
  static const String subsEndPoint = '/markdown/subs';
  //endregion

  //region SGM
  static const String sgmEndPoint = '/markdown/sgm';
  static const String sgmReasonEndPoint = '/markdown/sgm/reason';
  static const String sgmOriginEndPoint = '/markdown/sgm/origin';
  //endregion
}