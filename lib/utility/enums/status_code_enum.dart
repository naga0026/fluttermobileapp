enum StatusCodeEnum{

  success(200),
  error(400);


  final int statusValue;
  const StatusCodeEnum(this.statusValue);

}