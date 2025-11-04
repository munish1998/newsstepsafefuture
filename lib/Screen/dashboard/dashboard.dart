import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as htmlParser;
import 'package:newsstepsafefuture/Screen/module_categories/eating_habit_module.dart';
import 'package:newsstepsafefuture/common/widget/custom_top_widget.dart';
import 'package:newsstepsafefuture/dropdown_language/language.dart';
import 'package:newsstepsafefuture/providers/font_provider.dart';
import 'package:newsstepsafefuture/widgets/loading_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:newsstepsafefuture/utils/colors.dart';

class HomeScreen extends StatefulWidget {
  final Function(Locale) setLocale;
  const HomeScreen({super.key, required this.setLocale});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ValueNotifier<bool> _isLoading = ValueNotifier(true);
  final ValueNotifier<bool> _isTranslating = ValueNotifier(false);
  final ValueNotifier<Map<String, dynamic>> _pageData = ValueNotifier({});

  final String baseUrl = "https://webpristine.com/nssf";
  final String baseUrl1 = "https://webpristine.com/";
  final translator = GoogleTranslator();
  final String _cacheKey = "web_page_translations";

  Locale _currentLocale = const Locale("en");
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    _currentLocale = WidgetsBinding.instance.window.locale;
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _initSharedPreferences();
    await fetchPageData();
  }

  Future<void> _initSharedPreferences() async {
    try {
      _prefs = await SharedPreferences.getInstance();
    } on PlatformException catch (e) {
      log("SharedPreferences error: ${e.message}");
    }
  }

  String _formatTitle(String title) {
    return title
        .replaceAll("STEPSSAFE", "STEPS SAFE")
        .replaceAll("STEPSAFE", "STEPS SAFE")
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  Future<void> fetchPageData() async {
    _isLoading.value = true;
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/wp-json/wp/v2/pages/18'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final document = htmlParser.parse(data['content']['rendered']);

        final h1Tag = document.querySelector('h1');
        String extractedTitle = "NEW STEPS SAFE FUTURE";
        if (h1Tag != null) {
          final pTag = h1Tag.querySelector('p');
          if (pTag != null) extractedTitle = _formatTitle(pTag.text);
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
            if (imageUrl.startsWith("/")) imageUrl = "$baseUrl1$imageUrl";
            fetchedList.add({
              "title": titleTag.text.trim(),
              "imageUrl": imageUrl,
            });
            fetchedCategories.add({
              "title": titleTag.text.trim(),
              "image_url": imageUrl,
            });
          }
        }

        final webPortalTitle = document.querySelector('h4')?.text.trim() ?? "";
        final webPortalDescription = document.querySelectorAll('h4 + p');
        String webPortalText = webPortalDescription.isNotEmpty
            ? webPortalDescription.map((e) => e.text.trim()).join("\n\n")
            : "";

        _pageData.value = {
          "pageTitle": extractedTitle,
          "introDescription": introText,
          "titleImageList": fetchedList,
          "categories": fetchedCategories,
          "webPortalHeading": webPortalTitle,
          "webPortalContent": webPortalText,
        };
      }
    } catch (e) {
      log("Error fetching page data: $e");
    } finally {
      _isLoading.value = false;
    }
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _navigateToWebsite(String image) {
    String url = switch (image) {
      "assets/images/nsp.png" => "https://https://oveges.hu/",
      "assets/images/nsp2.png" => "https://sinnovations.org/",
      "assets/images/nsp3.png" => "https://gamarra.eus/",
      "assets/images/nsp4.png" => "https://start.stockholm/",
      "assets/images/nsp5.png" => "https://www.ulusofona.pt/",
      "assets/images/nsp6.png" => "https://mact.org.tr/",
      _ => "https://newstepssafefuture.eu/",
    };
    _launchURL(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<bool>(
        valueListenable: _isLoading,
        builder: (context, isLoading, _) {
          if (isLoading) return LoadingWidget(color: Colors.green);

          return ValueListenableBuilder<Map<String, dynamic>>(
            valueListenable: _pageData,
            builder: (context, data, _) {
              final title = data["pageTitle"] ?? "";
              final intro = data["introDescription"] ?? "";
              final webHeading = data["webPortalHeading"] ?? "";
              final webContent = data["webPortalContent"] ?? "";
              final list =
                  List<Map<String, String>>.from(data["titleImageList"] ?? []);
              final categories =
                  List<Map<String, dynamic>>.from(data["categories"] ?? []);

              return RefreshIndicator(
                onRefresh: fetchPageData,
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomTopBar(
                        currentLocale: _currentLocale,
                        onLocaleChange: (locale) {
                          widget.setLocale(locale);
                          _currentLocale = locale;
                        },
                      ),
                      SizedBox(height: 20),
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.montserrat(
                          textStyle: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontSize: 18),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        intro,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(height: 20),
                      list.isEmpty
                          ? LoadingWidget(color: Colors.green)
                          : GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemCount: list.length,
                              itemBuilder: (context, index) {
                                return _buildGridItem(
                                  list[index],
                                  categories[index],
                                );
                              },
                            ),
                      SizedBox(height: 20),
                      Text(
                        webHeading,
                        style: GoogleFonts.montserrat(
                          textStyle: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontSize: 18),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        webContent,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  fontSize: 15),
                        ),
                      ),
                      SizedBox(height: 30),
                      Text(
                        "Coordinator",
                        style: GoogleFonts.montserrat(
                          textStyle: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                        ),
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                          onTap: () {
                            _navigateToWebsite('assets/images/nsp.png');
                          },
                          child: Image.asset(
                            "assets/images/nsp.png",
                          )),
                      SizedBox(height: 20),
                      Text(
                        "Partners",
                        style: GoogleFonts.montserrat(
                          textStyle: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontSize: 18),
                        ),
                      ),
                      SizedBox(height: 10),
                      _buildImageRow([
                        "assets/images/nsp2.png",
                        "assets/images/nsp3.png",
                        "assets/images/nsp4.png"
                      ]),
                      _buildImageRow(
                          ["assets/images/nsp5.png", "assets/images/nsp6.png"]),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildGridItem(Map<String, String> item, Map category) {
    final String slug =
        (category['slug'] ?? item['title']!.toLowerCase().replaceAll(' ', '-'))
            .toString();

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EatingHabitModuleScreen(slug: slug),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: item["imageUrl"] ?? "",
                fit: BoxFit.cover,
                placeholder: (_, __) => LoadingWidget(color: Colors.green),
                errorWidget: (_, __, ___) =>
                    Icon(Icons.broken_image, color: Colors.grey),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black54,
                padding: EdgeInsets.all(8),
                child: Text(
                  item["title"] ?? "",
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageRow(List<String> images) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: images
          .map(
            (img) => GestureDetector(
              onTap: () => _navigateToWebsite(img),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Image.asset(img, width: 100, height: 100),
              ),
            ),
          )
          .toList(),
    );
  }
}
