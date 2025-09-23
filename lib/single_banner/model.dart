class SingleBanner {
  final String photo;
  final String url;

  SingleBanner({required this.photo, required this.url});

  factory SingleBanner.fromJson(Map<String, dynamic> json) {
    return SingleBanner(
      photo: json['photo'] ?? '', // Fallback to an empty string if null
      url: json['url'] ?? '', // Fallback to an empty string if null
    );
  }
}
