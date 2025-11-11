part of 'experience_bloc.dart';

@immutable
sealed class ExperienceEvent {}

final class FetchExperience extends ExperienceEvent {}