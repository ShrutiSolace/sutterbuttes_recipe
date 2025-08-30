import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

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

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile avatar
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 38,
                    backgroundColor: const Color(0xFF7B8B57),
                    child: const Icon(
                      Icons.person,   // 👤 Person icon
                      color: Colors.white,
                      size: 40,       // Adjust size as needed
                    ),
                  ),

                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.camera_alt, size: 18),
                    label: const Text("Edit Photo"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            Text("Personal Information", style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),

            _buildTextField(label: "First Name", hint: ""),
            _buildTextField(label: "Last Name", hint: ""),
            _buildTextField(label: "Email Address", hint: "", icon: Icons.email_outlined),
            _buildTextField(label: "Phone Number", hint: "", icon: Icons.phone_outlined),

            const SizedBox(height: 10),
            Text("Address Information", style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),

            _buildTextField(label: "Street Address", hint: "", icon: Icons.location_on_outlined),
            Row(
              children: [
                Expanded(child: _buildTextField(label: "City", hint: "")),
                const SizedBox(width: 8),
                Expanded(child: _buildTextField(label: "State", hint:" ")),
                const SizedBox(width: 8),
                Expanded(child: _buildTextField(label: "ZIP Code", hint: "")),
              ],
            ),

            _buildTextField(label: "Bio", hint: "", maxLines: 2),

            const SizedBox(height: 10),
            Text("Change Password (Optional)", style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),

            _buildTextField(label: "Current Password", hint: "Enter current password", obscure: true),
            _buildTextField(label: "New Password", hint: "Enter new password", obscure: true),
            _buildTextField(label: "Confirm Password", hint: "Confirm new password", obscure: true),

            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
    foregroundColor: Colors.green, // ✅ green text
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
                      foregroundColor: Colors.white,             // ✅ white text
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () {},
                    child: const Text("Save Changes"),
                  ),

                ),
              ],
            ),
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
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        obscureText: obscure,
        maxLines: maxLines,
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
}
