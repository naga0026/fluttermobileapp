
extension ListExtension on List {

  Iterable<T> mapWithNextField<T, E>(T Function(E element, E? nextItem) transformation) {
    List<T> result = [];

    for (int i = 0; i < toList().length; i++) {
      var first = toList()[i];
      var next = i<toList().length-1 ? toList()[i+1] : null;
      result.add(transformation(first, next));
    }

    return result;
  }
}
