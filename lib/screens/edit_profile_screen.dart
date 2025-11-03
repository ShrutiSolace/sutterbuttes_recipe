import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sutterbuttes_recipe/screens/state/auth_provider.dart';
import '../repositories/profile_repository.dart';
import '../modal/update_profile_model.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _currentPwdController = TextEditingController();
  final TextEditingController _newPwdController = TextEditingController();
  final TextEditingController _confirmPwdController = TextEditingController();

  bool _isSaving = false;
  bool _isLoading = true;
  String? _profileImageUrl;
  File? _pickedImageFile;
  bool _isUploadingImage = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _bioController.dispose();
    _currentPwdController.dispose();
    _newPwdController.dispose();
    _confirmPwdController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final repo = UserRepository();
      final data = await repo.getUserProfileData();
      setState(() {
        _firstNameController.text = data.firstName ?? '';
        _lastNameController.text = data.lastName ?? '';
        _usernameController.text = data.username ?? '';
        _emailController.text = data.email ?? '';
        _phoneController.text = data.phone ?? '';
        _streetController.text = data.streetAddress ?? '';
        _cityController.text = data.city ?? '';
        _stateController.text = data.state ?? '';
        _zipController.text = data.zipcode ?? '';
        _bioController.text = data.bio ?? '';
        _profileImageUrl = (data.profileImage != null && data.profileImage!.isNotEmpty)
            ? data.profileImage
            : null;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      final messenger = ScaffoldMessenger.of(context);
      messenger.showSnackBar(
        SnackBar(content: Text('Failed to load profile: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Personal Information",
          style: TextStyle(color: Colors.white), // ✅ white title text
        ),
        backgroundColor: const Color(0xFF4A3D4D),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white), // ✅ makes back arrow white
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile avatar
            Center(
              child: Column(
                children: [
                  /*_pickedImageFile != null
                      ? CircleAvatar(
                          radius: 38,
                          backgroundColor: const Color(0xFF7B8B57),
                          backgroundImage: FileImage(_pickedImageFile!),
                        )
                      : _profileImageUrl != null && _profileImageUrl!.isNotEmpty
                      ? CircleAvatar(
                          radius: 38,
                          backgroundColor: const Color(0xFF7B8B57),
                          backgroundImage: NetworkImage(_profileImageUrl!),
                        )
                      :  CircleAvatar(
                          radius: 38,
                          backgroundColor: Color(0xFF7B8B57),
                          child: Icon(
                            Icons.person, // 👤 Person icon
                            color: Colors.white,
                            size: 40, // Adjust size as needed
                          ),
                        ),*/
                  _isUploadingImage
                      ? Stack(
                    alignment: Alignment.center,
                    children: [
                      _pickedImageFile != null
                          ? CircleAvatar(
                        radius: 38,
                        backgroundColor: const Color(0xFF7B8B57),
                        backgroundImage: FileImage(_pickedImageFile!),
                      )
                          : _profileImageUrl != null && _profileImageUrl!.isNotEmpty
                          ? CircleAvatar(
                        radius: 38,
                        backgroundColor: const Color(0xFF7B8B57),
                        backgroundImage: NetworkImage(_profileImageUrl!),
                      )
                          : CircleAvatar(
                        radius: 38,
                        backgroundColor: Color(0xFF7B8B57),
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ],
                  )
                      : _pickedImageFile != null
                      ? CircleAvatar(
                    radius: 38,
                    backgroundColor: const Color(0xFF7B8B57),
                    backgroundImage: FileImage(_pickedImageFile!),
                  )
                      : _profileImageUrl != null && _profileImageUrl!.isNotEmpty
                      ? CircleAvatar(
                    radius: 38,
                    backgroundColor: const Color(0xFF7B8B57),
                    backgroundImage: NetworkImage(_profileImageUrl!),
                  )
                      : CircleAvatar(
                    radius: 38,
                    backgroundColor: Color(0xFF7B8B57),
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),



                  TextButton.icon(
                    onPressed: _showImageSourceDialog,
                    icon: const Icon(Icons.camera_alt, size: 18),
                    label: const Text("Edit Photo"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            Text("Personal Information", style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),

            _buildTextField(label: "First Name", hint: "", controller: _firstNameController),
            _buildTextField(label: "Last Name", hint: "", controller: _lastNameController),
            _buildTextField(label: "Username", hint: '',controller: _usernameController,enabled : false),
            _buildTextField(label: "Email Address", hint: "", icon: Icons.email_outlined, controller: _emailController, enabled : false),
            _buildTextField(label: "Phone Number", hint: "", icon: Icons.phone_outlined, controller: _phoneController),

            const SizedBox(height: 10),
            Text("Address Information", style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),

            _buildTextField(label: "Street Address", hint: "", icon: Icons.location_on_outlined, controller: _streetController),
            Row(
              children: [
                Expanded(child: _buildTextField(label: "City", hint: "", controller: _cityController)),
                const SizedBox(width: 8),
                Expanded(child: _buildTextField(label: "State", hint: " ", controller: _stateController)),
                const SizedBox(width: 8),
                Expanded(child: _buildTextField(label: "ZIP Code", hint: "", controller: _zipController)),
              ],
            ),

            _buildTextField(label: "Bio", hint: "", maxLines: 2, controller: _bioController),

            /*const SizedBox(height: 10),
            Text("Change Password (Optional)", style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),

            _buildTextField(label: "Current Password", hint: "Enter current password", obscure: true, controller: _currentPwdController),
            _buildTextField(label: "New Password", hint: "Enter new password", obscure: true, controller: _newPwdController),
            _buildTextField(label: "Confirm Password", hint: "Confirm new password", obscure: true, controller: _confirmPwdController),

            const SizedBox(height: 16),*/
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.green,
                      side: const BorderSide(color: Color(0xFF7B8B57)), // ✅ green border
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                ),

                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7B8B57), // ✅ green background
                      foregroundColor: Colors.white, // ✅ white text
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: _isSaving ? null : _onSave,
                    child: _isSaving ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text("Save Changes"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    IconData? icon,
    bool obscure = false,
    int maxLines = 1,
    TextEditingController? controller,
    bool enabled = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        enabled: enabled,
        obscureText: obscure,
        maxLines: maxLines,
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: icon != null ? Icon(icon, size: 20) : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
      ),
    );
  }

  Future<void> _onSave() async {

    final messenger = ScaffoldMessenger.of(context);
    FocusScope.of(context).unfocus();

    // ✅ Validation before proceeding
    final errors = [
      _firstNameController.text.trim().isEmpty ? 'First Name is required' : null,
      _lastNameController.text.trim().isEmpty ? 'Last Name is required' : null,
      _usernameController.text.trim().isEmpty ? 'Username is required' : null,
      _phoneController.text.trim().isEmpty
          ? 'Phone number is required'
          : (!RegExp(r'^[0-9]{10}$').hasMatch(_phoneController.text.trim())
          ? 'Phone number must be 10 digits'
          : null),
      _streetController.text.trim().isEmpty ? 'Street Address is required' : null,
      _cityController.text.trim().isEmpty ? 'City is required' : null,
      _stateController.text.trim().isEmpty ? 'State is required' : null,
      _zipController.text.trim().isEmpty
          ? 'ZIP Code is required'
          : (!RegExp(r'^[0-9]{5}$').hasMatch(_zipController.text.trim())
          ? 'ZIP Code must be 5 digits'
          : null),
    ].where((e) => e != null).toList();

    if (errors.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errors.first!)));
      return; // Stop saving if validation fails
    }



    setState(() {
      _isSaving = true;
    });

    try {
      final userData = UserData(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        streetAddress: _streetController.text.trim(),
        city: _cityController.text.trim(),
        state: _stateController.text.trim(),
        zipcode: _zipController.text.trim(),
        bio: _bioController.text.trim(),
      );

      final repo = UserRepository();
      final result = await repo.updateUserProfile(userData: userData, profileImagePath: _pickedImageFile?.path,);

      // Show profile update success first
      // Check if the update was actually successful
      if (result.success == true) {
        messenger.showSnackBar(
          SnackBar(content: Text(result.message ?? 'Profile updated successfully')),
        );
        await context.read<AuthProvider>().fetchCurrentUser();
        // Navigate back to previous screen on success
        Navigator.pop(context);
      } else {
        messenger.showSnackBar(
          SnackBar(
            content: Text(result.message ?? 'Failed to update profile'),
            backgroundColor: Colors.red,
          ),
        );
      }

     /* // Change password flow if fields provided
      final currentPwd = _currentPwdController.text.trim();
      final newPwd = _newPwdController.text.trim();
      final confirmPwd = _confirmPwdController.text.trim();

      print("===== PAsswrod ");

      if (currentPwd.isNotEmpty || newPwd.isNotEmpty || confirmPwd.isNotEmpty) {
        // Validate and show user-friendly errors
        if (currentPwd.isEmpty) {
          print("===== currentPwd.isEmpty ");

          messenger.showSnackBar(
            const SnackBar(content: Text('Please enter current password')),
          );
          return;
        }
        if (newPwd.isEmpty) {
          print("===== newPwd.isEmpty ");

          messenger.showSnackBar(
            const SnackBar(content: Text('Please enter new password')),
          );
          return;
        }
        if (newPwd.length < 8) {
          print("===== newPwd.length ");

          messenger.showSnackBar(
            const SnackBar(content: Text('New password must be at least 8 characters')),
          );
          return;
        }
        if (confirmPwd.isEmpty) {
          print("===== confirmPwd.isEmpty ");

          messenger.showSnackBar(
            const SnackBar(content: Text('Please confirm new password')),
          );
          return;
        }
        print("===== confirmPwd ");
        if (newPwd != confirmPwd) {
          print("===== newPwd != confirmPwd ");

          messenger.showSnackBar(
            const SnackBar(content: Text('New password and confirm password do not match')),
          );
          return;
        }

        final message = await repo.changePassword(
          currentPassword: currentPwd,
          newPassword: newPwd,
          confirmPassword: confirmPwd,
        );

        messenger.showSnackBar(
          SnackBar(content: Text(message)),
        );
      }*/

    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }



  Future<void> _showImageSourceDialog() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Camera'),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }



 /* Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? picked = await picker.pickImage(source: source, maxWidth: 1200, imageQuality: 85);
      if (picked != null) {
        setState(() {
          _pickedImageFile = File(picked.path);
        });
      }
    } catch (e) {
      final messenger = ScaffoldMessenger.of(context);
      messenger.showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }
}*/

  Future<void> _pickImage(ImageSource source) async {
    print("Picking image from source: $source");
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? picked = await picker.pickImage(source: source, maxWidth: 1200, imageQuality: 85);
      if (picked != null) {
        setState(() {
          _pickedImageFile = File(picked.path);
          _isUploadingImage = true;
        });
        final repo = UserRepository();
        final uploadResult = await repo.uploadProfileImage(imagePath: picked.path);

        if (uploadResult.success == true && uploadResult.data?.profileImage?.full != null) {
          setState(() {
            _profileImageUrl = uploadResult.data!.profileImage!.full;
            _pickedImageFile = null;
            _isUploadingImage = false;
          });
          final messenger = ScaffoldMessenger.of(context);
          messenger.showSnackBar(
            SnackBar(
              content: Text(uploadResult.message ?? 'Profile image uploaded successfully'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          setState(() {
            _isUploadingImage = false;
          });
          final messenger = ScaffoldMessenger.of(context);
          messenger.showSnackBar(
            SnackBar(
              content: Text(uploadResult.message ?? 'Failed to upload image'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isUploadingImage = false;
      });
      final messenger = ScaffoldMessenger.of(context);
      messenger.showSnackBar(
        SnackBar(
          content: Text('Failed to upload image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }





String? nameValidator(String? value, String fieldName) {
  if (value == null || value.trim().isEmpty) return '$fieldName is required';
  if (value.trim().length < 2) return '$fieldName must be at least 2 characters';
  return null;
}

String? usernameValidator(String? value) {
  if (value == null || value.trim().isEmpty) return 'Username is required';
  if (value.trim().length < 3) return 'Username must be at least 3 characters';
  return null;
}

String? phoneValidator(String? value) {
  if (value == null || value.trim().isEmpty) return 'Phone number is required';
  if (!RegExp(r'^[0-9]{10,15}$').hasMatch(value.trim())) return 'Enter a valid phone number';
  return null;
}

String? addressValidator(String? value, String fieldName) {
  if (value == null || value.trim().isEmpty) return '$fieldName is required';
  return null;
}

String? zipValidator(String? value) {
  if (value == null || value.trim().isEmpty) return 'ZIP Code is required';
  if (!RegExp(r'^\d{4,10}$').hasMatch(value.trim())) return 'Enter a valid ZIP Code';
  return null;
}

String? bioValidator(String? value) {
  if (value != null && value.trim().length > 200) return 'Bio cannot exceed 200 characters';
  return null;
}
}
