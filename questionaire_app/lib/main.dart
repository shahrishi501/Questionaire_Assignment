import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Local Imports
import 'package:questionaire_app/constants/app_colors.dart';
import 'package:questionaire_app/screens/expereince_screen/bloc/experience_bloc.dart';
import 'package:questionaire_app/screens/expereince_screen/experience_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ExperienceBloc>(
          create: (context) => ExperienceBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryAccent),
        ),
        home: const ExperienceScreen(),
      ),
    );
  }
}
