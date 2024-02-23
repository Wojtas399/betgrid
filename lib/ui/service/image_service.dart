import 'package:image_picker/image_picker.dart';

Future<String?> pickImage() async {
  final ImagePicker picker = ImagePicker();
  final XFile? imageFile = await picker.pickImage(
    source: ImageSource.gallery,
    imageQuality: 25,
  );
  return imageFile?.path;
}

Future<String?> capturePhoto() async {
  final ImagePicker picker = ImagePicker();
  final XFile? photoFile = await picker.pickImage(
    source: ImageSource.camera,
    imageQuality: 25,
  );
  return photoFile?.path;
}
