import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as htmlParser;
import 'package:newsstepsafefuture/utils/colors.dart';
import 'package:newsstepsafefuture/widget/tabcontent.dart';
import 'package:newsstepsafefuture/widgets/loading_widget.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DailyLifeArtScreen extends StatefulWidget {
  final String slug;
  final String name;

  const DailyLifeArtScreen({
    Key? key,
    required this.slug,
    required this.name,
  }) : super(key: key);

  @override
  _DailyLifeArtScreenState createState() => _DailyLifeArtScreenState();
}

class ContentTab {
  final String title;
  final String type; // 'pdf', 'video', 'quiz', 'game', 'text'
  final String? embedUrl;
  final String? textContent;
  final String? slug;

  ContentTab({
    required this.title,
    required this.type,
    this.embedUrl,
    this.textContent,
    this.slug
  });
}

class _DailyLifeArtScreenState extends State<DailyLifeArtScreen> {
  // Replacing with ValueNotifiers
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final ValueNotifier<String> errorMessage = ValueNotifier("");
  final ValueNotifier<int> selectedIndex = ValueNotifier(0);
  final ValueNotifier<List<ContentTab>> tabs = ValueNotifier([]);

  List<String> videoLinks = [];
  List<YoutubePlayerController> _videoControllers = [];

  @override
  void initState() {
    super.initState();
    fetchContent();
  }

  @override
  void dispose() {
    for (var controller in _videoControllers) {
      controller.dispose();
    }
    isLoading.dispose();
    errorMessage.dispose();
    selectedIndex.dispose();
    tabs.dispose();
    super.dispose();
  }

  Future<void> fetchContent() async {
    isLoading.value = true;
    errorMessage.value = "";

    try {
      final response = await http.get(Uri.parse(
          'https://webpristine.com/nssf/wp-json/wp/v2/posts?slug=${widget.slug}&_embed'));

      if (response.statusCode == 200) {
        List<dynamic> dataList = json.decode(response.body);
        log('datalist response ===>>>>$dataList');
        log('slug response ===>>>>${widget.slug}');
        log('name response ===>>>>${widget.name}');

        if (dataList.isNotEmpty) {
          String rawHtml = dataList[0]['content']['rendered'];
          final document = htmlParser.parse(rawHtml);
          final liItems = document.querySelectorAll('ul > li');

          List<ContentTab> extractedTabs = [];
          videoLinks.clear();
          _videoControllers.clear();

          for (var li in liItems) {
            final h3 = li.querySelector('h3');
            final iframe = li.querySelector('iframe');
            final embed = li.querySelector('embed');
            final text = li.querySelector('div')?.text.trim();

            if (h3 != null) {
              String title = h3.text.trim();
              String type = "text";
              String? contentUrl;
              String? contentText = text;

              if (iframe != null && iframe.attributes['src'] != null) {
                contentUrl = iframe.attributes['src'];
                if (contentUrl!.contains('wordwall.net')) {
                  type = "game";
                } else if (contentUrl.contains('youtube') ||
                    contentUrl.contains('youtu.be') ||
                    contentUrl.contains('vimeo')) {
                  type = "video";
                  videoLinks.add(contentUrl);
                }
              } else if (embed != null && embed.attributes['src'] != null) {
                contentUrl = _completePdfUrl(embed.attributes['src'] ?? '');
                if (contentUrl.contains('kahoot.it')) {
                  type = "quiz";
                } else if (contentUrl.toLowerCase().endsWith('.pdf')) {
                  type = "pdf";
                }
              }

              extractedTabs.add(ContentTab(
                title: title,
                type: type,
                embedUrl: contentUrl,
                textContent: contentText,
              ));
            }
          }

          tabs.value = extractedTabs;
          isLoading.value = false;
        } else {
          throw Exception('No data found.');
        }
      } else {
        throw Exception('Failed to load data.');
      }
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = "Error fetching data: ${e.toString()}";
    }
  }

  String _completePdfUrl(String partialUrl) {
    if (partialUrl.startsWith('http')) return partialUrl;
    return 'https://webpristine.com/nssf${partialUrl.startsWith('/') ? '' : '/'}$partialUrl';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.slug,
          style: GoogleFonts.montserrat(
            textStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.drawer,
      ),
      body: RefreshIndicator(
        onRefresh: fetchContent,
        child: ValueListenableBuilder<bool>(
          valueListenable: isLoading,
          builder: (context, loading, _) {
            return ValueListenableBuilder<String>(
              valueListenable: errorMessage,
              builder: (context, error, _) {
                return ValueListenableBuilder<List<ContentTab>>(
                  valueListenable: tabs,
                  builder: (context, tabList, _) {
                    return ValueListenableBuilder<int>(
                      valueListenable: selectedIndex,
                      builder: (context, index, _) {
                        return Column(
                          children: [
                            if (tabList.isNotEmpty)
                              Container(
                                padding: EdgeInsets.all(10),
                                color: Colors.blue[50],
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: List.generate(tabList.length,
                                        (tabIndex) {
                                      return GestureDetector(
                                        onTap: () =>
                                            selectedIndex.value = tabIndex,
                                        child: AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 300),
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 4),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 16),
                                          decoration: BoxDecoration(
                                            color: index == tabIndex
                                                ? AppColors.drawer
                                                : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            boxShadow: index == tabIndex
                                                ? [
                                                    BoxShadow(
                                                      color: Colors.blue
                                                          .withOpacity(0.5),
                                                      blurRadius: 5,
                                                    )
                                                  ]
                                                : [],
                                          ),
                                          child: Text(
                                            tabList[tabIndex].title,
                                            style: GoogleFonts.montserrat(
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall
                                                  ?.copyWith(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: index == tabIndex
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                              ),
                            Expanded(
                              child: loading
                                  ? LoadingWidget(color: Colors.green,)
                                  : error.isNotEmpty
                                      ? Center(
                                          child: Text(
                                            error,
                                            style:
                                                const TextStyle(color: Colors.red),
                                          ),
                                        )
                                      : tabList.isEmpty
                                          ? const Center(
                                              child:
                                                  Text("No content available"))
                                          : DynamicTabBuilder.buildDynamicTabContent(
                                              context,
                                              tabList[index],
                                              videoLinks,
                                              _videoControllers,
                                            ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
