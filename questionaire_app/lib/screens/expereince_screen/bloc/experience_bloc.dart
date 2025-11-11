import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:questionaire_app/models/experience.dart';
import 'package:questionaire_app/screens/expereince_screen/repo/expereince_repo.dart';

part 'experience_event.dart';
part 'experience_state.dart';

class ExperienceBloc extends Bloc<ExperienceEvent, ExperienceState> {
  final ExpereinceRepo expereinceRepo = ExpereinceRepo();
  ExperienceBloc() : super(ExperienceInitial()) {
    on<FetchExperience>((event, emit) async {
      emit(ExperienceLoading());
      try {
        final experiences = await expereinceRepo.fetchExperiences();
        emit(ExperienceLoaded(experiences.data.experiences));
      } catch (e) {
        emit(ExperienceError(e.toString()));
      }
    });
  }
}
