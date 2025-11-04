import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:html/parser.dart' as htmlParser;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';
import 'package:flutter/material.dart';

class HomeController {
  final String baseUrl = "https://webpristine.com/nssf";
  final String baseUrl1 = "https://webpristine.com/";
  final translator = GoogleTranslator();
  final String _cacheKey = "web_page_translations";

  Locale? currentLocale;
  SharedPreferences? _prefs;

  String pageTitle = "NEW STEPS SAFE FUTURE";
  String introDescription = "";
  String webPortalHeading = "";
  String webPortalContent = "";
  List<Map<String, String>> titleImageList = [];
  List categories = [];

  Future<void> init() async {
    currentLocale ??= WidgetsBinding.instance.window.locale;
    await _initSharedPreferences();
  }

  Future<void> _initSharedPreferences() async {
    try {
      _prefs = await SharedPreferences.getInstance();
    } on PlatformException catch (e) {
      log("SharedPreferences init failed: ${e.message}");
      _prefs = null;
    } catch (e, stack) {
      log("Error initializing SharedPreferences: $e\n$stack");
      _prefs = null;
    }
  }

  String _formatTitle(String title) {
    return title
        .replaceAll("STEPSSAFE", "STEPS SAFE")
        .replaceAll("STEPSAFE", "STEPS SAFE")
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  Future<bool> _loadCachedTranslations() async {
    if (_prefs == null) return false;
    try {
      final langCode = currentLocale?.languageCode ?? 'en';
      final cachedData = _prefs!.getString('$_cacheKey-$langCode');

      if (cachedData != null) {
        final data = json.decode(cachedData);
        pageTitle = _formatTitle(data['pageTitle'] ?? pageTitle);
        introDescription = data['introDescription'] ?? introDescription;
        webPortalHeading = data['webPortalHeading'] ?? webPortalHeading;
        webPortalContent = data['webPortalContent'] ?? webPortalContent;
        titleImageList =
            List<Map<String, String>>.from(json.decode(data['titleImageList'] ?? '[]'));
        return true;
      }
    } catch (e, stack) {
      log("Error loading cache: $e\n$stack");
    }
    return false;
  }

  Future<void> _saveTranslationsToCache(
      String langCode, Map<String, String> data) async {
    if (_prefs == null) return;
    try {
      await _prefs!.setString('$_cacheKey-$langCode', json.encode(data));
    } catch (e) {
      log("Error saving translations: $e");
    }
  }

  Future<void> fetchPageData(BuildContext context) async {
    if (await _loadCachedTranslations()) return;

    try {
      final response = await http.get(Uri.parse('$baseUrl/wp-json/wp/v2/pages/18'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final document = htmlParser.parse(data['content']['rendered']);

        final h1Tag = document.querySelector('h1');
        String extractedTitle = "NEW STEPS SAFE FUTURE";
        if (h1Tag != null) {
          final pTag = h1Tag.querySelector('p');
          if (pTag != null) {
            extractedTitle = _formatTitle(pTag.text);
          }
        }

        final introParagraph = document.querySelector('div > p');
        String introText = introParagraph?.text.trim() ?? "";

        List<Map<String, String>> fetchedList = [];
        List<Map<String, dynamic>> fetchedCategories = [];
        final listItems = document.querySelectorAll('ul > li');
        for (var item in listItems) {
          final imgTag = item.querySelector('img');
          final titleTag = item.querySelector('h3');
          if (imgTag != null && titleTag != null) {
            String imageUrl = imgTag.attributes['src'] ?? '';
            if (imageUrl.startsWith("/")) {
              imageUrl = "$baseUrl1$imageUrl";
            }
            fetchedList.add({"title": titleTag.text.trim(), "imageUrl": imageUrl});
            fetchedCategories.add({"title": titleTag.text.trim(), "image_url": imageUrl});
          }
        }

        final webPortalTitle = document.querySelector('h4')?.text.trim() ?? "";
        final webPortalDescription = document.querySelectorAll('h4 + p');
        String webPortalText = webPortalDescription.isNotEmpty
            ? webPortalDescription.map((e) => e.text.trim()).join("\n\n")
            : "";

        pageTitle = extractedTitle;
        introDescription = introText;
        titleImageList = fetchedList;
        categories = fetchedCategories;
        webPortalHeading = webPortalTitle;
        webPortalContent = webPortalText;

        await _saveTranslationsToCache('en', {
          'pageTitle': extractedTitle,
          'introDescription': introText,
          'webPortalHeading': webPortalTitle,
          'webPortalContent': webPortalText,
          'titleImageList': json.encode(fetchedList),
        });
      }
    } catch (e, stack) {
      log("Error fetching page data: $e\n$stack");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load data. Please try again.')));
    }
  }

  Future<String> translateText(String text, String toLanguageCode) async {
    try {
      if (text.trim().isEmpty ||
          RegExp(r'^\d+$').hasMatch(text) ||
          text.length < 3) {
        return text;
      }
      var translated = await translator.translate(text, to: toLanguageCode);
      return translated.text;
    } catch (e) {
      log("Translation failed: $e");
      return text;
    }
  }
}
