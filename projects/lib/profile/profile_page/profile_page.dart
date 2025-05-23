import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projects/profile/user_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../auth/login_screen.dart';
import '../../main.dart';
import '../profile_widget/options.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _bioController = TextEditingController();

  bool isEditing = false;

  void _showImagePickerOptions(UserModel userModel) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 150,
        child: Column(
          children: [
            const Text("Profile", style: TextStyle(fontSize: 18)),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Options(
                  onPressed: () {
                    Navigator.pop(context);
                    userModel.imageSelector(ImageSource.camera);
                  },
                  title: "Camera",
                  icon: Icons.camera_alt,
                ),
                Options(
                  onPressed: () {
                    Navigator.pop(context);
                    userModel.imageSelector(ImageSource.gallery);
                  },
                  title: "Gallery",
                  icon: Icons.image,
                ),
                if (userModel.user?.image != null)
                  Options(
                    onPressed: () {
                      if (mounted) {
                        setState(() {
                          userModel.user?.image = null;
                          userModel.notifyListeners();
                        });
                      }
                    },
                    title: "Delete",
                    icon: Icons.delete,
                    color: Colors.red,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
          (route) => false,
    );
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('name') ?? '';
      _dobController.text = prefs.getString('dob') ?? '';
      _bioController.text = prefs.getString('bio') ?? '';
    });
  }

  Future<void> _saveProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _nameController.text);
    await prefs.setString('dob', _dobController.text);
    await prefs.setString('bio', _bioController.text);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile updated")),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.close : Icons.edit),
            onPressed: () {
              setState(() {
                isEditing = !isEditing;
              });
            },
          ),
          IconButton(
            icon: Icon(Theme.of(context).brightness == Brightness.dark
                ? Icons.dark_mode
                : Icons.light_mode),
            onPressed: () {
              final brightness = Theme.of(context).brightness;
              final newBrightness =
              brightness == Brightness.dark ? ThemeMode.light : ThemeMode.dark;

              MyApp.of(context).changeTheme(newBrightness);
            },
          ),
        ],
      ),

      body: Consumer<UserModel>(
        builder: (context, userModel, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage: userModel.user?.image != null
                          ? FileImage(userModel.user!.image!)
                          : null,
                      child: userModel.user?.image == null
                          ? const Icon(Icons.person, size: 70, color: Colors.white38)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 4,
                      child: CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: 20,
                        child: IconButton(
                          onPressed: () => _showImagePickerOptions(userModel),
                          icon: const Icon(Icons.camera_alt, size: 18),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // NAME
                isEditing
                    ? TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                )
                    : ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Name'),
                  subtitle: Text(_nameController.text),
                ),

                // DATE OF BIRTH
                isEditing
                    ? TextField(
                  controller: _dobController,
                  decoration: const InputDecoration(labelText: 'Date of Birth'),
                )
                    : ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: const Text('Date of Birth'),
                  subtitle: Text(_dobController.text),
                ),

                // BIO
                isEditing
                    ? TextField(
                  controller: _bioController,
                  decoration: const InputDecoration(labelText: 'Bio'),
                )
                    : ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('Bio'),
                  subtitle: Text(_bioController.text),
                ),

                const SizedBox(height: 20),
                if (isEditing)
                  ElevatedButton(
                    onPressed: () async {
                      await _saveProfileData();
                      setState(() {
                        isEditing = false;
                      });
                    },
                    child: const Text("Save"),
                  ),

                const SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: _logout,
                  icon: const Icon(Icons.logout),
                  label: const Text("Log Out"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
