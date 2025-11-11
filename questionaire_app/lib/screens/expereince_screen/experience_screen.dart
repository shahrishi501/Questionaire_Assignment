import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:questionaire_app/constants/app_colors.dart';
import 'package:questionaire_app/models/experience.dart';
import 'package:questionaire_app/screens/expereince_screen/bloc/experience_bloc.dart';
import 'package:questionaire_app/screens/onboarding_questions_screens/onboarding_questions_screen.dart';
import 'package:questionaire_app/widgets/gradient_button_widget.dart';
import 'package:questionaire_app/widgets/textfield_widget.dart';
import 'package:questionaire_app/widgets/waveform_progress_widget.dart';

class ExperienceScreen extends StatefulWidget {
  const ExperienceScreen({super.key});

  @override
  State<ExperienceScreen> createState() => _ExperienceScreenState();
}

class _ExperienceScreenState extends State<ExperienceScreen> {
  final TextEditingController textController = TextEditingController();
  Set<int> selectedExperienceId = {};
  List<Experience> experiences = [];

  @override
  void initState() {
    super.initState();
    context.read<ExperienceBloc>().add(FetchExperience());
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.base1,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceWhite1,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
          child: SizedBox(
            width: 300,
            child: Center(
              child: WaveProgressIndicator(
                progress: 0.45, // show 25% completed
                activeColor: AppColors.primaryAccent,
                inactiveColor: AppColors.border2,
              ),
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.text1),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.clear, color: AppColors.text1),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background.png'),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                spreadRadius: 0,
                blurRadius: 4,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: SizedBox(
              height:
                  MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  kToolbarHeight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '01',
                          style: TextStyle(
                            color: AppColors.text5,
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            fontFamily: "spaceGrotesk",
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'What kind of hotspots do you want to host?',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: AppColors.text1,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: "spaceGrotesk",
                            letterSpacing: -0.48,
                            height: 1.33,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      height: 120,
                      child: BlocBuilder<ExperienceBloc, ExperienceState>(
                        builder: (context, state) {
                          if (state is ExperienceLoading) {
                            return Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primaryAccent,
                                ),
                              ),
                            );
                          } else if (state is ExperienceLoaded) {
                            if (experiences.isEmpty) {
                              experiences = List.from(state.experiences);
                            }

                            return AnimatedSwitcher(
                              duration: const Duration(milliseconds: 500),
                              switchInCurve: Curves.easeInOut,
                              switchOutCurve: Curves.easeInOut,
                              transitionBuilder: (Widget child, Animation<double> animation) {
                                return SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(1.0, 0.0), // from right to left
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: child,
                                );
                              },
                              child: ListView.builder(
                                key: ValueKey('${experiences.map((e) => e.id).join(',')}_${DateTime.now().millisecondsSinceEpoch}'),
                                itemCount: experiences.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final experience = experiences[index];
                                  final isSelected = selectedExperienceId
                                      .contains(experience.id);
                              
                                  // For rotation of container
                                  final rotationPattern = [-3.0, 3.0, 0.0];
                                  final rotationDegrees =
                                      rotationPattern[index % 3];
                                  final rotationAngle =
                                      rotationDegrees * (math.pi / 180);
                              
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      right: 20.0,
                                      // bottom: 12.0,
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          experiences.removeAt(index);
                                          experiences.insert(0, experience);
                                          if (isSelected == true) {
                                            selectedExperienceId.remove(
                                              experience.id,
                                            );
                                          } else {
                                            selectedExperienceId.add(
                                              experience.id,
                                            );
                                          }
                                        });
                                      },
                                      child: Transform.rotate(
                                        angle: rotationAngle,
                                        child: AnimatedContainer(
                                          duration: const Duration(
                                            milliseconds: 300,
                                          ),
                                          curve: Curves.easeOut,
                                          height: 50,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                experience.imageUrl,
                                              ),
                                              fit: BoxFit.contain,
                                              colorFilter: isSelected
                                                  ? null
                                                  : ColorFilter.mode(
                                                      Colors.grey,
                                                      BlendMode.saturation,
                                                    ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          } else if (state is ExperienceError) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.error,
                                    color: Colors.red,
                                    size: 48,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Error: ${state.message}',
                                    style: TextStyle(color: Colors.red),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: () {
                                      context.read<ExperienceBloc>().add(
                                        FetchExperience(),
                                      );
                                    },
                                    child: Text('Retry'),
                                  ),
                                ],
                              ),
                            );
                          }
                          return Container();
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                    TextfieldWidget(
                      hintText: '/ Describe you perfect hotspot',
                      textController: textController,
                      maxLength: 250,
                    ),
                    SizedBox(height: 20),
                    GradientButtonWidget(
                      isActive: selectedExperienceId.isNotEmpty,
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        print('Selected Experience IDs: $selectedExperienceId');
                        print('Description: ${textController.text}');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OnboardingQuestionsScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
