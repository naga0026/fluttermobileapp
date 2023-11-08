import 'package:flutter/material.dart';

extension SizeBox on double {
  Widget get heightBox {
    return SizedBox(height: this);
  }

  Widget get widthBox {
    return SizedBox(width: this);
  }
}