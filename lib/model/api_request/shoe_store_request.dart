class ShoeStoreRequest {
  String divisionCode;

  ShoeStoreRequest({required this.divisionCode});

  Map<String, dynamic> toJson() => {"divisionCode": divisionCode};
}
