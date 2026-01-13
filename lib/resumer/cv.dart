import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:my_app/model/person.dart';
import 'package:my_app/resumer/bottom_nav.dart';
import 'package:my_app/resumer/db.dart';
import 'package:my_app/resumer/providers.dart';
import 'package:screenshot/screenshot.dart';
import 'package:gal/gal.dart';
import 'package:permission_handler/permission_handler.dart';

class MyCvScreen extends ConsumerStatefulWidget {
  const MyCvScreen({super.key});

  @override
  ConsumerState<MyCvScreen> createState() => _MyCvScreenState();
}

class _MyCvScreenState extends ConsumerState<MyCvScreen> {
  final Map<int, ScreenshotController> _screenshotControllers = {};
  bool _isCapturing = false;
  int? _capturingIndex;

  Future<void> _saveAsImage(
    BuildContext context,
    ScreenshotController controller,
    int index,
  ) async {
    try {
      // Request storage permission
      PermissionStatus status;
      if (await Permission.photos.isGranted) {
        status = PermissionStatus.granted;
      } else {
        status = await Permission.photos.request();
      }

      if (!status.isGranted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Storage permission is required to save images'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        }
        return;
      }

      setState(() {
        _isCapturing = true;
        _capturingIndex = index;
      });

      // Give a small delay for the UI to rebuild without the buttons
      await Future.delayed(const Duration(milliseconds: 100));

      final image = await controller.capture();

      setState(() {
        _isCapturing = false;
        _capturingIndex = null;
      });

      if (image != null) {
        await Gal.putImageBytes(image);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('CV saved to gallery!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to capture CV image'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isCapturing = false;
        _capturingIndex = null;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving CV: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Person>('cvDB');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3F51B5),
        foregroundColor: Colors.white,
        title: const Text('My CV'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              setState(() {
                deleteAllDB();
              });
            },
          ),
        ],
      ),
      bottomNavigationBar: const ResumeBottomNav(currentIndex: 1),
      body: ListView.builder(
        itemCount: box.length,
        itemBuilder: (context, index) {
          final actualIndex = box.length - 1 - index;
          final person = box.getAt(actualIndex);

          // Handle null case - skip if person is null
          if (person == null) {
            return const SizedBox.shrink();
          }

          final controller = _screenshotControllers.putIfAbsent(
            actualIndex,
            () => ScreenshotController(),
          );

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Screenshot(
              controller: controller,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 235, 235, 235),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 10.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // PROFILE CARD
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 36,
                                  backgroundColor: Colors.indigo.shade100,
                                  child: const Icon(Icons.person, size: 40),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        person.fullname,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        person.role,
                                        style: const TextStyle(
                                          color: Color(0xFF3F51B5),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.email,
                                            size: 16,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(width: 6),
                                          Expanded(child: Text(person.email)),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.phone,
                                            size: 16,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(person.phone),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.location_on,
                                            size: 16,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(width: 6),
                                          Expanded(child: Text(person.address)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            if (!(_isCapturing &&
                                _capturingIndex == actualIndex))
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.download_rounded,
                                        color: Colors.indigo,
                                      ),
                                      onPressed: () => _saveAsImage(
                                        context,
                                        controller,
                                        actualIndex,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.indigo,
                                      ),
                                      onPressed: () {
                                        // Populate providers
                                        ref
                                                .read(fullnameProvider.notifier)
                                                .state =
                                            person.fullname;
                                        ref.read(emailProvider.notifier).state =
                                            person.email;
                                        ref
                                                .read(contactProvider.notifier)
                                                .state =
                                            person.phone;
                                        ref
                                                .read(addressProvider.notifier)
                                                .state =
                                            person.address;
                                        ref
                                                .read(degreeProvider.notifier)
                                                .state =
                                            person.degree;
                                        ref.read(uniProvider.notifier).state =
                                            person.uni;
                                        ref
                                            .read(passingYearProvider.notifier)
                                            .state = person
                                            .year;
                                        ref.read(gradeProvider.notifier).state =
                                            person.grade;
                                        ref
                                                .read(companyProvider.notifier)
                                                .state =
                                            person.company;
                                        ref.read(roleProvider.notifier).state =
                                            person.role;
                                        ref
                                                .read(durationProvider.notifier)
                                                .state =
                                            person.experience;
                                        ref.read(skillProvider.notifier).state =
                                            person.skills;

                                        // Set editing index
                                        ref
                                                .read(
                                                  editingIndexProvider.notifier,
                                                )
                                                .state =
                                            actualIndex;

                                        // Navigate to personal information page
                                        Navigator.pushNamed(
                                          context,
                                          '/personal_info',
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        // Show confirmation dialog
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('Delete CV'),
                                              content: Text(
                                                'Are you sure you want to delete the CV for ${person.fullname}?',
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      deleteSingleCV(
                                                        actualIndex,
                                                      );
                                                    });
                                                    Navigator.of(context).pop();
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                          'CV deleted successfully!',
                                                        ),
                                                        backgroundColor:
                                                            Colors.green,
                                                      ),
                                                    );
                                                  },
                                                  child: const Text(
                                                    'Delete',
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // EDUCATION
                      const Text(
                        'Education',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3F51B5),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.school,
                              size: 30,
                              color: Color(0xFF3F51B5),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    person.degree,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(person.uni),
                                  const SizedBox(height: 2),
                                  Text('Passing Year: ${person.year}'),
                                  Text('Grade: ${person.grade}'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // WORK EXPERIENCE
                      const Text(
                        'Work Experience',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3F51B5),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.work,
                              size: 30,
                              color: Color(0xFF3F51B5),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    person.role,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text('Company: ${person.company}'),
                                  const SizedBox(height: 2),
                                  Text('Duration: ${person.experience}'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // SKILLS
                      const Text(
                        'Skills',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3F51B5),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: person.skills
                            .split(',')
                            .map((skill) => Chip(label: Text(skill.trim())))
                            .toList(),
                      ),
                      const Divider(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
