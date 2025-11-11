part of 'experience_bloc.dart';

@immutable
sealed class ExperienceState {}

final class ExperienceInitial extends ExperienceState {}

final class ExperienceLoading extends ExperienceState {}

final class ExperienceLoaded extends ExperienceState {
  final List<Experience> experiences;

  ExperienceLoaded(this.experiences);
}

final class ExperienceError extends ExperienceState {
  final String message;

  ExperienceError(this.message);
}