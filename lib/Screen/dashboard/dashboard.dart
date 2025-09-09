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
import 'package:newsstepsafefuture/dropdown_language/language.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:newsstepsafefuture/utils/colors.dart';

class WebPageScreen extends StatefulWidget {
  final Function(Locale) setLocale;
  const WebPageScreen({super.key, required this.setLocale});
  @override
  _WebPageScreenState createState() => _WebPageScreenState();
}

class _WebPageScreenState extends State<WebPageScreen> {
  List<Map<String, String>> titleImageList = [];
  List categories = [];
  bool isLoading = true;
  bool isTranslating = false;

  String pageTitle = "NEW STEPS SAFE FUTURE";
  String introDescription = "";
  String webPortalHeading = "";
  String webPortalContent = "";

  final String baseUrl = "https://webpristine.com/nssf";
  final String baseUrl1 = "https://webpristine.com/";
  final translator = GoogleTranslator();
  final String _cacheKey = "web_page_translations";

  Locale? _currentLocale;
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    _currentLocale = WidgetsBinding.instance.window.locale;
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      await _initSharedPreferences();
      await fetchPageData();
    } catch (e, stack) {
      log("Initialization error: $e\n$stack");
      await fetchPageData();
    }
  }

  Future<void> _initSharedPreferences() async {
    try {
      _prefs = await SharedPreferences.getInstance();
    } on PlatformException catch (e) {
      log("SharedPreferences initialization failed: ${e.message}");
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
      final langCode = _currentLocale?.languageCode ?? 'en';
      final cachedData = _prefs!.getString('$_cacheKey-$langCode');

      if (cachedData != null) {
        final data = json.decode(cachedData);
        setState(() {
          pageTitle =
              _formatTitle(data['pageTitle'] ?? "NEW STEPS SAFE FUTURE");
          introDescription = data['introDescription'] ?? introDescription;
          webPortalHeading = data['webPortalHeading'] ?? webPortalHeading;
          webPortalContent = data['webPortalContent'] ?? webPortalContent;
          titleImageList = List<Map<String, String>>.from(
              json.decode(data['titleImageList'] ?? '[]'));
        });
        return true;
      }
    } on PlatformException catch (e) {
      log("Failed to load cached translations: ${e.message}");
    } catch (e, stack) {
      log("Error loading cached translations: $e\n$stack");
    }
    return false;
  }

  Future<void> _saveTranslationsToCache(
      String langCode, Map<String, String> data) async {
    if (_prefs == null) return;

    try {
      await _prefs!.setString('$_cacheKey-$langCode', json.encode(data));
    } on PlatformException catch (e) {
      log("Failed to save translations: ${e.message}");
    } catch (e, stack) {
      log("Error saving translations: $e\n$stack");
    }
  }

  Future<void> fetchPageData() async {
    setState(() => isLoading = true);

    try {
      if (await _loadCachedTranslations()) {
        setState(() => isLoading = false);
        return;
      }

      final response =
          await http.get(Uri.parse('$baseUrl/wp-json/wp/v2/pages/18'));
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

        setState(() {
          pageTitle = extractedTitle;
          introDescription = introText;
          titleImageList = fetchedList;
          categories = fetchedCategories;
          webPortalHeading = webPortalTitle;
          webPortalContent = webPortalText;
        });

        await _saveTranslationsToCache('en', {
          'pageTitle': extractedTitle,
          'introDescription': introText,
          'webPortalHeading': webPortalTitle,
          'webPortalContent': webPortalText,
          'titleImageList': json.encode(fetchedList),
        });

        if (_currentLocale?.languageCode != 'en') {
          await translateAllData(_currentLocale?.languageCode ?? 'en');
        }
      } else {
        throw Exception('Failed to load page data');
      }
    } catch (e, stack) {
      log("Error fetching page data: $e\n$stack");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load data. Please try again.')));
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> translateAllData(String langCode) async {
    if (await _loadCachedTranslations()) return;

    setState(() => isTranslating = true);

    try {
      // Explicitly declare the types for each future
      final List<Future<String>> translationFutures = [
        translateText(pageTitle, langCode),
        translateText(introDescription, langCode),
        translateText(webPortalHeading, langCode),
        translateText(webPortalContent, langCode),
      ];

      // Wait for all string translations first
      final List<String> translations = await Future.wait(translationFutures);

      // Then translate the titleImageList separately
      final List<Map<String, String>> translatedList =
          await _translateTitleImageList(langCode);

      setState(() {
        pageTitle = translations[0];
        introDescription = translations[1];
        webPortalHeading = translations[2];
        webPortalContent = translations[3];
        titleImageList = translatedList;
      });

      await _saveTranslationsToCache(langCode, {
        'pageTitle': translations[0],
        'introDescription': translations[1],
        'webPortalHeading': translations[2],
        'webPortalContent': translations[3],
        'titleImageList': json.encode(translatedList),
      });
    } catch (e, stack) {
      log("Translation error: $e\n$stack");
    } finally {
      if (mounted) {
        setState(() => isTranslating = false);
      }
    }
  }

  Future<List<Map<String, String>>> _translateTitleImageList(
      String langCode) async {
    List<Map<String, String>> translatedList = [];
    for (var item in titleImageList) {
      translatedList.add({
        'title': await translateText(item['title']!, langCode),
        'imageUrl': item['imageUrl']!,
      });
    }
    return translatedList;
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
      log("Translation failed for: $text\nError: $e");
      return text;
    }
  }

  void onCategoryTap(String slug) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EatingHabitModuleScreen(slug: slug),
      ),
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _navigateToWebsite(String image) {
    String url = switch (image) {
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
    final currentLocale = Localizations.localeOf(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.drawer,
        elevation: 0,
        leadingWidth: 60.w, // consistent space for logo
        leading: Padding(
            padding: EdgeInsets.only(left: 8.w),
            child: CircleAvatar(
              // radius: 90.w,
              backgroundColor: Colors.transparent,
              child: ClipOval(
                child: Image.network(
                  "https://newstepssafefuture.eu/wp-content/themes/yootheme/cache/da/NSSF-Ultimate-logo-1-daee3d7e.webp",
                  width: 70.w,
                  height: 70.w,
                  //fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return Container(
                      width: 100.w,
                      height: 100.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[200],
                      ),
                      child: Icon(Icons.error, color: Colors.grey),
                    );
                  },
                ),
              ),
            )),
        titleSpacing: 0,

        centerTitle: true, // centers title between leading & actions
        actions: [
          Padding(
            padding: EdgeInsets.only(left: 9.w),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 90.w,
                  child: LanguageDropdown(
                    currentLocale: currentLocale,
                    onLocaleChange: (locale) {
                      widget.setLocale(locale);
                      _currentLocale = locale;
                      translateAllData(locale.languageCode);
                      log('Selected language: ${locale.languageCode}');
                    },
                  ),
                ),
                SizedBox(width: 6.w),
                IconButton(
                  icon: Image.asset("assets/images/linkedin.png", width: 24.w),
                  onPressed: () => _launchURL('https://www.linkedin.com/'),
                  padding: EdgeInsets.zero,
                ),
                IconButton(
                  icon: Image.asset("assets/images/facebook.png", width: 24.w),
                  onPressed: () => _launchURL('https://www.facebook.com/'),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
        ],
      ),
      body: isLoading || isTranslating
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: fetchPageData,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(10.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        pageTitle,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 22.54,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        introDescription,
                        style: GoogleFonts.montserrat(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF6C6D74),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20.h),
                      titleImageList.isEmpty
                          ? Center(
                              child: SizedBox(
                                width: 50,
                                height: 50,
                                child: Image.asset('assets/images/loading.gif'),
                              ),
                            )
                          : GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 10.h,
                                crossAxisSpacing: 10.w,
                                childAspectRatio: 1.1,
                              ),
                              itemCount: titleImageList.length,
                              itemBuilder: (context, index) {
                                return _buildGridItem(
                                    titleImageList[index], categories[index]);
                              },
                            ),
                      SizedBox(height: 20.h),
                      Text(
                        webPortalHeading,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 26.54,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        webPortalContent,
                        style: GoogleFonts.montserrat(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF6C6D74),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 30.h),
                      Text("Coordinator",
                          style: TextStyle(
                              fontSize: 18.sp, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10.h),
                      Image.asset(
                        'assets/images/nsp.png',
                        width: 105.w,
                        height: 105.h,
                      ),
                      // _buildImageRow(["assets/images/nsp.png"]),
                      SizedBox(height: 20.h),
                      Text("Partners",
                          style: TextStyle(
                              fontSize: 18.sp, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10.h),
                      _buildImageRow([
                        "assets/images/nsp2.png",
                        "assets/images/nsp3.png",
                        "assets/images/nsp4.png"
                      ]),
                      _buildImageRoww(
                          ["assets/images/nsp5.png", "assets/images/nsp6.png"]),
                      SizedBox(height: 30.h),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildGridItem(Map<String, String> item, Map category) {
    final dynamic categorySlug = category['slug'];
    final String slug = categorySlug is String
        ? categorySlug
        : item['title']!.toLowerCase().replaceAll(' ', '-');

    String imageUrl = item['imageUrl'] ?? '';
    if (imageUrl.startsWith('//')) imageUrl = 'https:$imageUrl';
    if (imageUrl.startsWith('/')) imageUrl = 'https://webpristine.com$imageUrl';

    return GestureDetector(
      onTap: () => onCategoryTap(slug),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 2)
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator(strokeWidth: 2)),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[200],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.broken_image, size: 40, color: Colors.grey),
                      SizedBox(height: 8),
                      Text('Image not available',
                          style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                margin: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  item['title']!,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageRow(
    List<String> imagePaths,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: imagePaths.map((image) {
        return GestureDetector(
          onTap: () => _navigateToWebsite(image),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Image.asset(image, width: 105.w, height: 105.h),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildImageRoww(List<String> imagePaths) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: imagePaths.map((image) {
        return GestureDetector(
          onTap: () => _navigateToWebsite(image),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Image.asset(image, width: 105.w, height: 105.h),
          ),
        );
      }).toList(),
    );
  }
}
