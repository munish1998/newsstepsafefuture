import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as htmlParser;

class PageRepository {
  final String baseUrl = "https://webpristine.com/nssf";

  Future<Map<String, dynamic>> fetchMainPageData() async {
    final response = await http.get(Uri.parse('$baseUrl/wp-json/wp/v2/pages/18'));
    
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to load page data');
  }

  Future<Map<String, dynamic>> fetchSubcategoryData(String slug) async {
    final response = await http.get(Uri.parse('$baseUrl/wp-json/wp/v2/pages?slug=$slug'));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.isNotEmpty) return data[0];
    }
    throw Exception('Failed to load subcategory data');
  }

  static Map<String, dynamic> parsePageData(Map<String, dynamic> data) {
    final document = htmlParser.parse(data['content']['rendered']);
    
    final h1Tag = document.querySelector('h1');
    String extractedTitle = "";
    if (h1Tag != null) {
      final pTag = h1Tag.querySelector('p');
      if (pTag != null) {
        extractedTitle = pTag.text.replaceAll("\n", " ").replaceAll("<br />", " ");
      }
    }
    if (extractedTitle.contains("STEPSSAFE")) {
      extractedTitle = extractedTitle.replaceAll("STEPSSAFE", "STEPS SAFE");
    }
    final introParagraph = document.querySelector('div > p');
    String introText = introParagraph?.text.trim() ?? "";
    List<Map<String, String>> fetchedList = [];
    final String baseUrl = "https://webpristine.com/nssf";
    final listItems = document.querySelectorAll('ul > li');
    for (var item in listItems) {
      final imgTag = item.querySelector('img');
      final titleTag = item.querySelector('h3');
      if (imgTag != null && titleTag != null) {
        String imageUrl = imgTag.attributes['src'] ?? '';
        if (imageUrl.startsWith("/")) imageUrl = "$baseUrl$imageUrl";
        
        fetchedList.add({
          "title": titleTag.text.trim(),
          "imageUrl": imageUrl,
        });
      }
    }
    fetchedList.sort((a, b) => a['title']!.compareTo(b['title']!));

    final webPortalTitle = document.querySelector('h4')?.text.trim() ?? "";
    final webPortalDescription = document.querySelectorAll('h4 + p');
    String webPortalText = webPortalDescription.isNotEmpty
        ? webPortalDescription.map((e) => e.text.trim()).join("\n\n")
        : "";

    return {
      'title': extractedTitle,
      'intro': introText,
      'items': fetchedList,
      'webPortalTitle': webPortalTitle,
      'webPortalContent': webPortalText,
    };
  }
}