import 'package:collection/collection.dart';

extension ListStreamExtensions<T> on Stream<List<T>> {
  Stream<List<T>> distinctList() => distinct((prevResults, currentResults) {
    Function eq = const ListEquality().equals;
    return eq(prevResults, currentResults);
  });
}
