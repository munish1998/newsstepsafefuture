import 'package:html/parser.dart';

class PageModel {
  final int id;
  final String title;
  final String content;
  final String imageUrl;

  PageModel({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
  });

  factory PageModel.fromJson(Map<String, dynamic> json) {
    return PageModel(
      id: json['id'],
      title: json['title']['rendered'],
      content: json['content']['rendered'],
      imageUrl: _extractImageUrl(json['content']['rendered'], json['title']['rendered']),
    );
  }

  // Extract an image URL that matches the section title
  static String _extractImageUrl(String htmlContent, String title) {
    final document = parse(htmlContent);
    final images = document.querySelectorAll('img');

    // If no images are found, return a placeholder
    if (images.isEmpty) {
      return 'https://via.placeholder.com/200';
    }

    // Try to match an image close to the section title
    for (var img in images) {
      var parent = img.parent;
      while (parent != null) {
        if (parent.text.trim().toLowerCase().contains(title.toLowerCase())) {
          String extractedUrl = img.attributes['src'] ?? '';

          // Ensure full URL format
          return extractedUrl.startsWith('http')
              ? extractedUrl
              : 'https://webpristine.com/nssf/${extractedUrl.replaceFirst(RegExp(r'^/'), '')}';
        }
        parent = parent.parent;
      }
    }

    // If no specific match is found, return the first image
    String firstImageUrl = images.first.attributes['src'] ?? '';
    return firstImageUrl.startsWith('http')
        ? firstImageUrl
        : 'https://webpristine.com/nssf/${firstImageUrl.replaceFirst(RegExp(r'^/'), '')}';
  }
}
