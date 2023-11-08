import 'package:base_project/utility/constants/colors/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/initial_view_controller.dart';


class AppErrorWidget extends StatelessWidget {
  final FlutterErrorDetails? errorDetails;
  final bool? isDev;

   AppErrorWidget({
    required Key? key,
    required this.errorDetails,
    this.isDev = false,
  }) : super(key: key);

  final initialController = Get.find<InitialController>();


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorConstants.primaryRedColor,
          title: const Text('App Error'),
        ),
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: <Widget>[
                const Text(
                  'An error occurred:',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  isDev! ? errorDetails.toString() : 'Sorry, something went wrong.',
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstants.primaryRedColor
                  ),
                  onPressed: (){
                    initialController.restartApp();
                  },
                  child: const Text('Restart App'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}