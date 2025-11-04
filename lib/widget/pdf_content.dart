import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newsstepsafefuture/utils/text.dart';

class StaticPdfContent extends StatelessWidget {
  final String title;
  const StaticPdfContent({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final linkStyle = GoogleFonts.montserrat(
      color: Colors.blue,
      decoration: TextDecoration.underline,
      fontSize: 13,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFC8E6C9),
      body: SafeArea(
        child: Center(
          child: Container(
            width: 600,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.green.shade700, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: const Offset(2, 3),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Top Logos
                  Image.asset(
                    'assets/images/logo.png',
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                   Text(
                    "Science",
                    style: GoogleFonts.montserrat(
                      fontSize: 35,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "New Steps, Safe Future",
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Project Reference: 2023-2-HU01-KA220-SCH-000178668",
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Title
                  Text(
                    "How does WATER feature in science education?",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.teal.shade800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "by Marian Sinkáné Farkas",
                    style: GoogleFonts.montserrat(
                      fontStyle: FontStyle.italic,
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Main Text
                  Text(
                    AppTexts.heraclitusFullText,
                    textAlign: TextAlign.justify,
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      height: 1.5,
                     // letterSpacing: 2,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Divider
                  Divider(color: Colors.green.shade300, thickness: 1),

                  // Clickable links
                  const SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.montserrat(fontSize: 13, color: Colors.black),
                      children: [
                        const TextSpan(text: "Resources:\n"),
                        TextSpan(
                          text:
                              "https://www.usgs.gov/special-topics/water-science-school - Lesson plans\n",
                          style: linkStyle,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _launchUrl("https://www.usgs.gov/special-topics/water-science-school");
                            },
                        ),
                        TextSpan(
                          text:
                              "https://minnesota.agclassroom.org/matrix/lesson/821/ - Lesson plans\n",
                          style: linkStyle,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _launchUrl("https://minnesota.agclassroom.org/matrix/lesson/821/");
                            },
                        ),
                        TextSpan(
                          text: "https://youtu.be/w4NRThvgJJo - Formation of water molecules",
                          style: linkStyle,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _launchUrl("https://youtu.be/w4NRThvgJJo");
                            },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Bottom Logos
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/nsp.png', height: 50),
                      const SizedBox(width: 5),
                      Image.asset('assets/images/nsp3.png', height: 50),
                      const SizedBox(width: 5),
                      Image.asset('assets/images/nsp4.png', height: 50),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _launchUrl(String url) {
    // Implement using url_launcher
    // Example:
    // launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }
}
