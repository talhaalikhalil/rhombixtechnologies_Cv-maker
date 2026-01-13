import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app/resumer/bottom_nav.dart';
import 'package:my_app/resumer/providers.dart';

class ScreenOne extends ConsumerStatefulWidget {
  const ScreenOne({super.key});

  @override
  ConsumerState<ScreenOne> createState() => _ScreenOneState();
}

class _ScreenOneState extends ConsumerState<ScreenOne> {
  // Text Controllers for input fields
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: ref.read(fullnameProvider));
    _emailController = TextEditingController(text: ref.read(emailProvider));
    _phoneController = TextEditingController(text: ref.read(contactProvider));
    _addressController = TextEditingController(text: ref.read(addressProvider));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: const ResumeBottomNav(currentIndex: 0),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.indigo,
        title: const Text(
          "Personal Information",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ─── Profile Avatar ───
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                "https://www.w3schools.com/howto/img_avatar.png",
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "Let’s start building your CV!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 30),

            // ─── Input Card ───
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    _buildField(
                      label: "Full Name",
                      icon: Icons.person,
                      controller: _nameController,
                    ),
                    const SizedBox(height: 12),
                    _buildField(
                      label: "Email",
                      icon: Icons.email,
                      controller: _emailController,
                    ),
                    const SizedBox(height: 12),
                    _buildField(
                      label: "Phone Number",
                      icon: Icons.phone,
                      controller: _phoneController,
                    ),
                    const SizedBox(height: 12),
                    _buildField(
                      label: "Address",
                      icon: Icons.location_on,
                      controller: _addressController,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ─── Next Button (Save and Navigate) ───
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.arrow_forward, color: Colors.white),
                label: const Text(
                  "Next → Education",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // 1. UPDATE RIVERPOD STATE (Single data write to memory)
                  ref.read(fullnameProvider.notifier).state =
                      _nameController.text;
                  ref.read(emailProvider.notifier).state =
                      _emailController.text;
                  ref.read(contactProvider.notifier).state =
                      _phoneController.text;
                  ref.read(addressProvider.notifier).state =
                      _addressController.text;

                  // 2. SAVE TO DATABASE (saveDB reads the state updated in step 1,
                  // resulting in a single database write)
                  // saveDB(ref);

                  // 3. PROVIDE USER FEEDBACK (Snackbar)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Personal Info Saved!"),
                      backgroundColor: Colors.indigo,
                    ),
                  );

                  // 4. NAVIGATE to the next screen (index 2: Education)
                  Navigator.pushNamed(context, '/education');
                },
              ),
            ),
            const SizedBox(height: 20),

            // Progress text
            Text(
              "Step 1 of 4",
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  // ────────────────────────────────
  Widget _buildField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.indigo),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.indigo),
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.indigo, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
