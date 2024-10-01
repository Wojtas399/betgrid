import 'package:betgrid/data/firebase/service/firebase_avatar_service.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAvatarService extends Mock implements FirebaseAvatarService {
  void mockFetchAvatarUrlForUser({String? avatarUrl}) {
    when(
      () => fetchAvatarUrlForUser(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) => Future.value(avatarUrl));
  }

  void mockAddAvatarForUser({String? addedAvatarUrl}) {
    when(
      () => addAvatarForUser(
        userId: any(named: 'userId'),
        avatarImgPath: any(named: 'avatarImgPath'),
      ),
    ).thenAnswer((_) => Future.value(addedAvatarUrl));
  }

  void mockRemoveAvatarForUser() {
    when(
      () => removeAvatarForUser(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) => Future.value());
  }
}
