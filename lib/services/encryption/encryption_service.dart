class EncryptionService {
  String atableSet =
      "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
  String etableSet =
      "NzEF8K9HcJjLiMa2BrD4QeST6XlUgZ5AImCd3fy0hRwGkOnVoWqp7stPuv1xYb";
  String polishCharacters = "ĄąĆćĘęŁłŃńÓóŚśŹźŻż";
  String specialCharacters = ":.!#\$%&'()*+-/;<=>?@[\\]^_{|}~\"`, ";

  String _atable = '';
  String _etable = '';
  int _eLen = 0;
  final int _key = 7;

  void setTables() {
    _atable = atableSet;
    _etable = etableSet;
    _eLen = _etable.length;
  }

  String encryptUserPassword(String raw) {
    if (raw.isEmpty) {
      return '';
    }

    setTables();

    int lastj = 0;
    var len = raw.length;
    var buffer = StringBuffer();
    buffer.write(' ');

    for (var i = 0; i < len; i++) {
      var rawOne = raw[i];
      var r = _atable.indexOf(rawOne);

      if (r < 0) return '';
      var j = r + _key + i + lastj + len;

      buffer.write(_etable[j % _eLen]);
      lastj = j % _eLen;
    }

    String bufferResult = buffer.toString();
    String result =
        '${bufferResult[bufferResult.length - 1]}${bufferResult.substring(1, bufferResult.length - 1)}';

    return result;
  }
}
