import 'dart:io';
import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';

class UserImageProvider extends StateNotifier<File?> {
  UserImageProvider() : super(null);
  Future<File?> pickedImage() async {
    final XFile? pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 150,
      imageQuality: 50,
    );
    if (pickedImage == null) {
      return null;
    }

    state = File(pickedImage.path);
    return state;

    // widget.onPickImage(_pickedImageFile!);
  }
}

final imageProvider = StateNotifierProvider((ref) => UserImageProvider());
