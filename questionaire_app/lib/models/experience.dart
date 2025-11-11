class ExperienceResponse {
  final String message;
  final ExperienceData data;

  ExperienceResponse({
    required this.message,
    required this.data,
  });

  factory ExperienceResponse.fromJson(Map<String, dynamic> json) {
    return ExperienceResponse(
      message: json['message'] ?? '',
      data: ExperienceData.fromJson(json['data'] ?? {}),
    );
  }
}

class ExperienceData {
  final List<Experience> experiences;

  ExperienceData({required this.experiences});

  factory ExperienceData.fromJson(Map<String, dynamic> json) {
    final expList = json['experiences'] as List<dynamic>? ?? [];
    return ExperienceData(
      experiences: expList.map((e) => Experience.fromJson(e)).toList(),
    );
  }
}

class Experience {
  final int id;
  final String name;
  final String tagline;
  final String description;
  final String imageUrl;
  final String iconUrl;
  final int? order;

  Experience({
    required this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.imageUrl,
    required this.iconUrl,
    this.order,
  });

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      tagline: json['tagline'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? '',
      iconUrl: json['icon_url'] ?? '',
      order: json['order'],
    );
  }
}
