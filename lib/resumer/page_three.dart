import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app/resumer/bottom_nav.dart';
import 'package:my_app/resumer/db.dart';
import 'package:my_app/resumer/providers.dart';

class ScreenThree extends ConsumerStatefulWidget {
  const ScreenThree({super.key});

  @override
  ConsumerState<ScreenThree> createState() => _ScreenThreeState();
}

class _ScreenThreeState extends ConsumerState<ScreenThree> {
  late final TextEditingController _companyController;
  late final TextEditingController _roleController;
  late final TextEditingController _durationController;
  late final TextEditingController _skillsController;

  @override
  void initState() {
    super.initState();
    _companyController = TextEditingController(text: ref.read(companyProvider));
    _roleController = TextEditingController(text: ref.read(roleProvider));
    _durationController = TextEditingController(
      text: ref.read(durationProvider),
    );
    _skillsController = TextEditingController(text: ref.read(skillProvider));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      bottomNavigationBar: const ResumeBottomNav(currentIndex: 0),
      appBar: AppBar(
        title: const Text(
          "Work Experience",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.indigo,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Card(
            elevation: 5,
            shadowColor: Colors.indigo.withOpacity(0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const Text(
                    "Enter Your Work Experience",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.indigo,
                    ),
                  ),
                  const SizedBox(height: 25),

                  _buildField(
                    "Company Name",
                    _companyController,
                    Icons.business,
                  ),
                  _buildField("Job Role", _roleController, Icons.work),
                  _buildField(
                    "Experience (Years)",
                    _durationController,
                    Icons.access_time,
                  ),
                  _buildField("Skills", _skillsController, Icons.star),

                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          // Navigation removed
                        },
                        icon: const Icon(Icons.arrow_back_ios_new, size: 16),
                        label: const Text("Back"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.indigo,
                          side: const BorderSide(color: Colors.indigo),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          // 1. UPDATE RIVERPOD STATE
                          ref.read(companyProvider.notifier).state =
                              _companyController.text;
                          ref.read(roleProvider.notifier).state =
                              _roleController.text;
                          ref.read(durationProvider.notifier).state =
                              _durationController.text;
                          ref.read(skillProvider.notifier).state =
                              _skillsController.text;

                          // 2. SAVE OR UPDATE DATABASE
                          final editingIndex = ref.read(editingIndexProvider);
                          if (editingIndex != null) {
                            updateDB(ref, editingIndex);
                          } else {
                            saveDB(ref);
                          }

                          // 3. PROVIDE USER FEEDBACK (Snackbar)
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                editingIndex != null
                                    ? "CV Updated!"
                                    : "Work Experience Saved!",
                              ),
                              backgroundColor: Colors.indigo,
                            ),
                          );

                          // 4. CLEAR PROVIDERS
                          clearProviders(ref);

                          // 5. NAVIGATE to the CV screen tab in FillForm removed
                          // ref.read(pageIndexProvider.notifier).state = 4;
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/cv',
                            (route) => false,
                          );
                        },
                        icon: const Icon(Icons.arrow_forward_ios, size: 16),
                        label: const Text("Finish"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    "Step 3 of 4",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.indigo),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.indigo),
          filled: true,
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.indigo, width: 1.5),
            borderRadius: BorderRadius.circular(14),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}
