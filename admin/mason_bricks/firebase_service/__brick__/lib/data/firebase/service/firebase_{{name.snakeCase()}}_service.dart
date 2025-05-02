import 'package:injectable/injectable.dart';

import '../firebase_collections.dart';

@injectable
class Firebase{{name.pascalCase()}}Service {
  final FirebaseCollections _firebaseCollections;

  const Firebase{{name.pascalCase()}}Service(this._firebaseCollections);

  //TODO: Add methods
}