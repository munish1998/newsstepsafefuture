import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:newsstepsafefuture/Screen/daily_life_categories/daily_life_art.dart';
import 'package:newsstepsafefuture/widget/pdf_content.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../utils/colors.dart'; // adjust path as needed

class DynamicTabBuilder {
  static Widget buildDynamicTabContent(
    BuildContext context,
    ContentTab tab,
    List<String> videoLinks,
    List<YoutubePlayerController> videoControllers,
  ) {
    // Special handling for Wordwall URLs
    if (tab.embedUrl != null && tab.embedUrl!.contains('wordwall.net')) {
      return _buildGameViewer(context, tab);
    }

    switch (tab.type) {
      case 'pdf':
        return _buildPdfViewer(context, tab);
      case 'quiz':
        return _buildQuizViewer(context, tab);
      case 'game':
        return _buildGameViewer(context, tab);
      case 'video':
        return _buildVideoTab(videoLinks, videoControllers);
      case 'text':
      default:
        return _buildTextView(tab);
    }
  }

  static Widget _buildPdfViewer(BuildContext context, ContentTab tab) {
    log('tab tile pdf response====>>>fdvfddvdv55y  v>>${tab.title}');
    // Just call the separate static content widget
    return StaticPdfContent(title: tab.type);
  }

  static Widget _buildPdfViewer2(BuildContext context, ContentTab tab) {
    if (tab.embedUrl == null)
      return const Center(child: Text("No PDF available"));
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
              child:
                  Text(tab.title, style: const TextStyle(color: Colors.white,fontSize: 13)),
            ),
            Expanded(
              child: WebViewWidget(
                controller: WebViewController()
                  ..setJavaScriptMode(JavaScriptMode.unrestricted)
                  ..loadRequest(Uri.parse(urlToLoad)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildQuizViewer(BuildContext context, ContentTab tab) {
    if (tab.embedUrl == null)
      return const Center(child: Text("No quiz available"));

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
              child:
                  Text(tab.title, style: const TextStyle(color: Colors.white)),
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

  static Widget _buildGameViewer(BuildContext context, ContentTab tab) {
    if (tab.embedUrl == null)
      return const Center(child: Text("No game available"));

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
              child:
                  Text(tab.title, style: const TextStyle(color: Colors.white)),
            ),
            Expanded(
              child: WebViewWidget(
                controller: WebViewController()
                  ..setJavaScriptMode(JavaScriptMode.unrestricted)
                  ..setBackgroundColor(Colors.transparent)
                  ..setNavigationDelegate(
                    NavigationDelegate(
                      onPageFinished: (String url) =>
                          log('Wordwall game loaded: $url'),
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

  static Widget _buildVideoTab(
    List<String> videoLinks,
    List<YoutubePlayerController> _videoControllers,
  ) {
    if (videoLinks.isEmpty)
      return const Center(child: Text("No videos available."));

    return ListView.builder(
      itemCount: videoLinks.length,
      itemBuilder: (context, index) {
        String? videoId = YoutubePlayer.convertUrlToId(videoLinks[index]);
        if (videoId == null) return const SizedBox();

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

  static Widget _buildTextView(ContentTab tab) {
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
              offset: const Offset(0, 3),
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

  static List<Widget> _extractTextParagraphs(String? content) {
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
        ),
      ];
    }

    final lines =
        content.split('\n').where((line) => line.trim().isNotEmpty).toList();

    return lines.map((line) {
      TextStyle style =
          TextStyle(fontSize: 15, color: Colors.grey[800], height: 1.5);

      if (line.toLowerCase().contains("round 1") ||
          line.toLowerCase().contains("round 2") ||
          line.toLowerCase().contains("round 3") ||
          line.toLowerCase().contains("round 4") ||
          line.toLowerCase().contains("final presentation") ||
          line.toLowerCase().contains("learning outcomes")) {
        style = style.copyWith(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal[800]);
      } else if (line.trim().startsWith('📌') ||
          line.trim().startsWith('✅') ||
          line.trim().startsWith('🎯')) {
        style = style.copyWith(
            fontWeight: FontWeight.w600, color: Colors.blue[700]);
      } else if (line.trim().startsWith('💡') ||
          line.trim().startsWith('🕹') ||
          line.trim().startsWith('🔹')) {
        style = style.copyWith(
            fontWeight: FontWeight.w600, color: Colors.purple[700]);
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
              child: Text(line.trim().replaceAll('•', ''), style: style),
            ),
          ],
        ),
      );
    }).toList();
  }

  static String _pdfViewerUrl(String pdfUrl) {
    return "https://docs.google.com/viewer?url=$pdfUrl&embedded=true";
  }
}
