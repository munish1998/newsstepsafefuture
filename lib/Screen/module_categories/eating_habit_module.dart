import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'dart:convert';
import 'package:html/parser.dart' as htmlParser;
import 'package:newsstepsafefuture/Screen/daily_life_categories/daily_life_art.dart';
import 'package:newsstepsafefuture/utils/colors.dart';

class EatingHabitModuleScreen extends StatefulWidget {
  final String slug;

  const EatingHabitModuleScreen({Key? key, required this.slug})
      : super(key: key);

  @override
  _EatingHabitModuleScreenState createState() =>
      _EatingHabitModuleScreenState();
}

class _EatingHabitModuleScreenState extends State<EatingHabitModuleScreen> {
  List<Map<String, String>> titleImageList = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchPageData();
  }

  

  Future<void> fetchPageData() async {
    try {
      String slugToUse = widget.slug;
      log('slug eating response ===>>>$slugToUse');
     
      if (widget.slug == "eating-habits-science") {
        slugToUse = "eating-habits-science-and-fb";
      }

      final response = await http.get(Uri.parse(
          'https://webpristine.com/nssf/wp-json/wp/v2/pages?slug=$slugToUse'));

      if (response.statusCode == 200) {
        List<dynamic> dataList = json.decode(response.body);
        if (dataList.isNotEmpty) {
          Map<String, dynamic> data = dataList[0];
          setState(() {
            titleImageList =
                extractTitleImagePairs(data['content']['rendered']);
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = 'No data found for the given slug.';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Failed to load page data (${response.statusCode})';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching data: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  List<Map<String, String>> extractTitleImagePairs(String htmlContent) {
    final document = htmlParser.parse(htmlContent);
    List<Map<String, String>> extractedList = [];

    final elements = document.querySelectorAll('li');

    for (var element in elements) {
      final imgTag = element.querySelector('img');
      final titleTag = element.querySelector('h3');

      if (imgTag != null && titleTag != null) {
        String imageUrl = imgTag.attributes['src'] ?? '';
        String title = titleTag.text.trim().toLowerCase().replaceAll(' ', '-');

        // Process image URL
        if (imageUrl.startsWith("/")) {
          
          if (widget.slug == 'water') {
            imageUrl = "https://webpristine.com/nssf" + imageUrl;
          } else {
            imageUrl = "https://webpristine.com/nssf" + imageUrl;
          }
        } else if (imageUrl.startsWith("//")) {
          imageUrl = "https:" + imageUrl;
        } else if (!imageUrl.startsWith("http")) {
          // Special case for 'water' slug - don't add 'nssf' to path
          if (widget.slug == 'water') {
            imageUrl = "https://webpristine.com/nssf" + imageUrl;
          } else {
            imageUrl = "https://webpristine.com/nssf/" + imageUrl;
          }
        }
        //      if (imageUrl.contains("wp-content")) {
        //   imageUrl = imageUrl.replaceFirst("wp-content", "nssf/wp-content");
        // }
        log("Extracted image URL: $imageUrl");
        extractedList.add({
          "title": titleTag.text.trim(),
          "slug": title, // Store the slugified title
          "imageUrl": imageUrl,
        });
      }
    }

    return extractedList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.drawer,
        title: Text(widget.slug.replaceAll('-', ' ').toTitleCase()),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return Center(
        child: SizedBox(
          width: 50,
          height: 50,
          child: Image.asset('assets/images/loading.gif'),
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Text(
          errorMessage!,
          style: TextStyle(color: Colors.red),
        ),
      );
    }

    if (titleImageList.isEmpty) {
      return Center(
        child: Text('No categories found'),
      );
    }

    return Padding(
      padding: EdgeInsets.all(10),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10.h,
          crossAxisSpacing: 10.w,
          childAspectRatio: 1.1,
        ),
        itemCount: titleImageList.length,
        itemBuilder: (context, index) {
          return _buildGridItem(titleImageList[index]);
        },
      ),
    );
  }

  Widget _buildGridItem(Map<String, String> item) {
    return GestureDetector(
      onTap: () {
       
        String nextScreenSlug = "${widget.slug}-${item['slug']}";

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DailyLifeArtScreen(
              slug: nextScreenSlug,
              name: item['title'] ?? '',
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: item['imageUrl']!,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  height: double.infinity,
                  color: Colors.grey[300],
                  child: Icon(Icons.broken_image, size: 50),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  item['title']!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


extension StringCasingExtension on String {
  String toTitleCase() {
    return split(' ')
        .map((word) => word.isNotEmpty
            ? word[0].toUpperCase() + word.substring(1).toLowerCase()
            : '')
        .join(' ');
  }
}
