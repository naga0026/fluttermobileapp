Type typeOf<T>() => T;

// GenericClassMappingModel : to convert from and to map(key-value pairs)
abstract class ClassMappingModel<T> {
  T fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson();


  /// Add string with double quotes and wrap value with single quote
  /// If the string value is sbo then add it as "'sbo'"
  /// These will help parsing the json on native side as well as in sqlite
  Map<String, dynamic> toJsonForDB() {
    return {};
  }

}

