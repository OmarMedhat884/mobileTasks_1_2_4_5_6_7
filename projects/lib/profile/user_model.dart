import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projects/profile/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel extends ChangeNotifier {
  final ImagePicker imagePicker = ImagePicker();

  User? _user;
  User? get user => _user;

  UserModel() {
    _loadUserData(); // تحميل البيانات عند بدء التطبيق
  }

  Future<void> imageSelector(ImageSource source) async {
    final XFile? image = await imagePicker.pickImage(source: source);
    if (image != null) {
      final File imageFile = File(image.path);

      if (_user != null) {
        _user?.image = imageFile;
      } else {
        _user = User(
          name: "Omar",
          bio: "Code Sleep Eat Repeat",
          image: imageFile,
        );
      }

      await _saveImagePath(image.path); // حفظ المسار
      notifyListeners();
    }
  }

  Future<void> _saveImagePath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image', path);
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('profile_image');

    if (imagePath != null && File(imagePath).existsSync()) {
      _user = User(
        name: "Omar",
        bio: "Code Sleep Eat Repeat",
        image: File(imagePath),
      );
      notifyListeners();
    }
  }
}
