import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as htmlParser;
import 'package:newsstepsafefuture/utils/colors.dart';
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

  ContentTab({
    required this.title,
    required this.type,
    this.embedUrl,
    this.textContent,
  });
}

class _DailyLifeArtScreenState extends State<DailyLifeArtScreen> {
  bool isLoading = false;
  String errorMessage = "";
  int selectedIndex = 0;
  List<ContentTab> tabs = [];

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
    super.dispose();
  }

  Future<void> fetchContent() async {
    setState(() {
      isLoading = true;
      errorMessage = "";
    });

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

              // Check for Wordwall game first
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
              }
              // Then check for Kahoot quiz or PDF
              else if (embed != null && embed.attributes['src'] != null) {
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

          setState(() {
            tabs = extractedTabs;
            isLoading = false;
          });
        } else {
          throw Exception('No data found.');
        }
      } else {
        throw Exception('Failed to load data.');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "Error fetching data: ${e.toString()}";
      });
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
        title: Text(widget.slug),
        centerTitle: true,
        backgroundColor: AppColors.drawer,
      ),
      body: RefreshIndicator(
        onRefresh: fetchContent,
        child: Column(
          children: [
            if (tabs.isNotEmpty)
              Container(
                padding: EdgeInsets.all(10),
                color: Colors.blue[50],
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(tabs.length, (index) {
                      return GestureDetector(
                        onTap: () => setState(() => selectedIndex = index),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color: selectedIndex == index
                                ? AppColors.drawer
                                : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: selectedIndex == index
                                ? [
                                    BoxShadow(
                                        color: Colors.blue.withOpacity(0.5),
                                        blurRadius: 5)
                                  ]
                                : [],
                          ),
                          child: Text(
                            tabs[index].title,
                            style: TextStyle(
                              color: selectedIndex == index
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : errorMessage.isNotEmpty
                      ? Center(
                          child: Text(errorMessage,
                              style: TextStyle(color: Colors.red)),
                        )
                      : tabs.isEmpty
                          ? Center(child: Text("No content available"))
                          : _buildDynamicTabContent(tabs[selectedIndex]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicTabContent(ContentTab tab) {
    // Special handling for Wordwall URLs
    if (tab.embedUrl != null && tab.embedUrl!.contains('wordwall.net')) {
      return _buildGameViewer(tab);
    }

    switch (tab.type) {
      case 'pdf':
        return _buildPdfViewer(tab);
      case 'quiz':
        return _buildQuizViewer(tab);
      case 'game':
        return _buildGameViewer(tab);
      case 'video':
        return _buildVideoTab();
      case 'text':
      default:
        return _buildTextView(tab);
    }
  }

  Widget _buildPdfViewer(ContentTab tab) {
    if (tab.embedUrl == null) return Center(child: Text("No PDF available"));
    
    String urlToLoad = _pdfViewerUrl(tab.embedUrl!);
    
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Card(
        elevation: 6,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.drawer,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Text(
                tab.title,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Expanded(
              child: WebViewWidget(
                controller: WebViewController()
                  ..setJavaScriptMode(JavaScriptMode.unrestricted)
                  ..loadRequest(Uri.parse(urlToLoad)),
            ),
        )],
        ),
      ),
    );
  }

  Widget _buildQuizViewer(ContentTab tab) {
    if (tab.embedUrl == null) return Center(child: Text("No quiz available"));
    
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Card(
        elevation: 6,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.drawer,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Text(
                tab.title,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              child: WebViewWidget(
                controller: WebViewController()
                  ..setJavaScriptMode(JavaScriptMode.unrestricted)
                  ..loadRequest(Uri.parse(tab.embedUrl!)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameViewer(ContentTab tab) {
    if (tab.embedUrl == null) return Center(child: Text("No game available"));
    
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Card(
        elevation: 6,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.drawer,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Text(
                tab.title,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Expanded(
              child: WebViewWidget(
                controller: WebViewController()
                  ..setJavaScriptMode(JavaScriptMode.unrestricted)
                  ..setBackgroundColor(Colors.transparent)
                  ..setNavigationDelegate(
                    NavigationDelegate(
                      onPageFinished: (String url) {
                        log('Wordwall game loaded: $url');
                      },
                    ),
                  )
                  ..loadRequest(Uri.parse(tab.embedUrl!)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoTab() {
    if (videoLinks.isEmpty) {
      return const Center(child: Text("No videos available."));
    }

    return ListView.builder(
      itemCount: videoLinks.length,
      itemBuilder: (context, index) {
        String? videoId = YoutubePlayer.convertUrlToId(videoLinks[index]);
        if (videoId == null) {
          return const SizedBox();
        }

        if (_videoControllers.length <= index) {
          _videoControllers.add(
            YoutubePlayerController(
              initialVideoId: videoId,
              flags: const YoutubePlayerFlags(
                autoPlay: false,
                mute: false,
                enableCaption: true,
                captionLanguage: 'en',
                hideControls: false,
                controlsVisibleAtStart: true,
                disableDragSeek: false,
                forceHD: true,
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: YoutubePlayer(
            key: ValueKey(videoId),
            controller: _videoControllers[index],
            showVideoProgressIndicator: true,
            progressColors: const ProgressBarColors(
              playedColor: Colors.red,
              handleColor: Colors.redAccent,
              bufferedColor: Colors.grey,
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextView(ContentTab tab) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              spreadRadius: 2,
              offset: Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (tab.title.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  tab.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
              ),
            ..._extractTextParagraphs(tab.textContent),
          ],
        ),
      ),
    );
  }

  List<Widget> _extractTextParagraphs(String? content) {
    if (content == null || content.trim().isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            "No content available",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        )
      ];
    }

    final lines = content.split('\n').where((line) => line.trim().isNotEmpty).toList();
    
    return lines.map((line) {
      TextStyle style = TextStyle(
        fontSize: 15,
        color: Colors.grey[800],
        height: 1.5,
      );

      if (line.toLowerCase().contains("round 1") ||
          line.toLowerCase().contains("round 2") ||
          line.toLowerCase().contains("round 3") ||
          line.toLowerCase().contains("round 4") ||
          line.toLowerCase().contains("final presentation") ||
          line.toLowerCase().contains("learning outcomes")) {
        style = style.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.teal[800],
        );
      } else if (line.trim().startsWith('📌') || 
                 line.trim().startsWith('✅') || 
                 line.trim().startsWith('🎯')) {
        style = style.copyWith(
          fontWeight: FontWeight.w600,
          color: Colors.blue[700],
        );
      } else if (line.trim().startsWith('💡') || 
                 line.trim().startsWith('🕹') || 
                 line.trim().startsWith('🔹')) {
        style = style.copyWith(
          fontWeight: FontWeight.w600,
          color: Colors.purple[700],
        );
      }

      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (line.trim().startsWith('•'))
              Padding(
                padding: const EdgeInsets.only(right: 8, top: 2),
                child: Text('•', style: style),
              ),
            Expanded(
              child: Text(
                line.trim().replaceAll('•', ''),
                style: style,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  String _pdfViewerUrl(String pdfUrl) {
    return "https://docs.google.com/viewer?url=$pdfUrl&embedded=true";
  }
}