import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app/resumer/bottom_nav.dart';
import 'package:my_app/resumer/providers.dart';

class ScreenTwo extends ConsumerStatefulWidget {
  const ScreenTwo({super.key});

  @override
  ConsumerState<ScreenTwo> createState() => _ScreenTwoState();
}

class _ScreenTwoState extends ConsumerState<ScreenTwo> {
  // Text Controllers for input fields
  late final TextEditingController _degreeController;
  late final TextEditingController _universityController;
  late final TextEditingController _yearController;
  late final TextEditingController _gradeController;

  @override
  void initState() {
    super.initState();
    _degreeController = TextEditingController(text: ref.read(degreeProvider));
    _universityController = TextEditingController(text: ref.read(uniProvider));
    _yearController = TextEditingController(
      text: ref.read(passingYearProvider),
    );
    _gradeController = TextEditingController(text: ref.read(gradeProvider));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      bottomNavigationBar: const ResumeBottomNav(currentIndex: 0),
      appBar: AppBar(
        title: const Text(
          "Education Details",
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
            elevation: 6,
            shadowColor: Colors.indigo.withOpacity(0.15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const Text(
                    "Enter Your Education Information",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.indigo,
                    ),
                  ),
                  const SizedBox(height: 25),

                  _buildField("Degree", _degreeController, Icons.school),
                  _buildField(
                    "University",
                    _universityController,
                    Icons.domain,
                  ),
                  _buildField(
                    "Passing Year",
                    _yearController,
                    Icons.calendar_today,
                  ),
                  _buildField("Grade / GPA", _gradeController, Icons.grade),

                  const SizedBox(height: 25),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          // Navigation removed
                          Navigator.pushNamed(context, '/experience');
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
                          // 1. UPDATE RIVERPOD STATE (Single data write to memory)
                          ref.read(degreeProvider.notifier).state =
                              _degreeController.text;
                          ref.read(uniProvider.notifier).state =
                              _universityController.text;
                          ref.read(passingYearProvider.notifier).state =
                              _yearController.text;
                          ref.read(gradeProvider.notifier).state =
                              _gradeController.text;

                          // 2. SAVE TO DATABASE (saveDB reads the state updated in step 1)
                          // saveDB(ref);

                          // 3. PROVIDE USER FEEDBACK (Snackbar)
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Education Info Saved!"),
                              backgroundColor: Colors.indigo,
                            ),
                          );
                          Navigator.pushNamed(context, '/experience');
                        },
                        icon: const Icon(Icons.arrow_forward_ios, size: 16),
                        label: const Text("Next"),
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
                    "Step 2 of 4",
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
