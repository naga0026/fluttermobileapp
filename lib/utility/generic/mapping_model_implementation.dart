import 'package:flutter/foundation.dart';

import 'key_value_model.dart';
import 'mapping_model.dart';

class ClassMappingModelFactory {
  // A map where key is class name's string and value in class constructor
  static final Map<String, ClassMappingModel> _processorMap = {
    // TODO: Add key and value here
  };

  // Gives the class that is extending our GenericClassMappingModel model
  static ClassMappingModel get(String type) {
    if (_processorMap[type] == null) {
      throw Exception(
          "FromJsonModelFactory: $type is not a valid FromJsonModel type!");
    }
    return _processorMap[type]!;
  }

  static KeyValueModel getDBInsertColumnAndValues<T extends ClassMappingModel>(
      List<ClassMappingModel> list) {

    /* Step 1: Create a variable that holds the values string
    Create a variable that holds all the column names in a string

    Get the last element of the array and convert it to the map(key-value),
    Then get only the keys from that map and join it with comma. It will result
    into all the column names separated by comma.
    Wrap that string with parenthesis and this will give us the string that needs to
    be added in insert query after the table name
     */
    String values = '';
    var lastElement = list.last;
    String columns = '(${lastElement.toJsonForDB().keys.join(',')})';

    /*
    Step 2: Use dart's map function on array of generic class objects
    Add one boolean to check for the last element because, for the last bunch of values
    we need to append the semi colon at the end
    Now, for each element convert to the map and extracts values from it (same way we did for the keys)
     */
    var r = list.map((genericObj) {
      bool isLastElement = lastElement == genericObj;
      var objectMap = genericObj.toJsonForDB();
      var commaSeparatedValues = objectMap.values.join(',');
      var finalRowString = '($commaSeparatedValues)';

      /* Step 3: Once we get value string for one item,
      append it to the final string which holds all the row values
      if the element is the last append semi column at last else comma
       */
      values = '$values$finalRowString' '${isLastElement ? ';' : ','} ';
    });
    debugPrint(r.toString());

    /* Step 4: Return an object of model class which holds the string of columns
    in one variable and the string of values in another variable and finally use
    it where you need to create a query
     */
    return KeyValueModel(keys: columns, values: values);
  }


  static KeyValueModel? convertQuery<T extends ClassMappingModel>(List<ClassMappingModel> list) {

    if (list.isEmpty) return null;
    final columns = '(${list.first.toJsonForDB().keys.join(",")})';

    var valuesBuffer = StringBuffer();
    for (var task in list) {
      if (valuesBuffer.isNotEmpty) valuesBuffer.write(",\n");
      valuesBuffer.write("(");

      int ix = 0;

      task.toJsonForDB().forEach((key, value) {
        if (ix++ != 0) valuesBuffer.write(',');

        valuesBuffer.write(value);
      });

      valuesBuffer.write(")");
    }
    return KeyValueModel(keys: columns, values: valuesBuffer.toString());
  }
}