import 'package:questionaire_app/models/experience.dart';
import 'package:questionaire_app/utility/api_service.dart';

class ExpereinceRepo {
  Future<ExperienceResponse> fetchExperiences() async {
    final response = await ApiConstant.get(
      url: ApiConstant.apiURL,
      sendToken: false,
    );

    if (response.statusCode == 200) {
      print("Experience Data: ${response.data}");
      return ExperienceResponse.fromJson(response.data);
    } else {
      throw Exception('Failed to load experiences');
    }
  }
}