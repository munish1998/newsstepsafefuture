import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newsstepsafefuture/Screen/dashboard/dashboard.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  final PageController _pageController = PageController();
  Locale _locale = const Locale('en');
  int _currentPage = 0;
  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  final List<TutorialPage> _tutorialPages = [
    TutorialPage(
      title: "How NSSF App Works",
      subtitle: "Learn sustainable choices with STEAM approach",
      content:
          "The NSSF App helps you learn how to make smarter and more sustainable choices in your everyday life, using the STEAM approach (Science, Technology, Engineering, Arts, and Mathematics).",
      icon: Icons.school,
      color: Colors.blue,
    ),
    TutorialPage(
      title: "1. Start Learning",
      subtitle: "Begin your sustainability journey",
      content:
          "Tap the 'Start Learning' button to enter your personal dashboard where you can track your progress and access all learning materials.",
      icon: Icons.play_arrow,
      color: Colors.green,
    ),
    TutorialPage(
      title: "2. Choose a Topic",
      subtitle: "Six main sustainability topics",
      content:
          "You'll see six main topics:\n• Water\n• Waste\n• Transport\n• Energy\n• Eating Habits\n• Daily Life",
      icon: Icons.category,
      color: Colors.orange,
    ),
    TutorialPage(
      title: "3. Explore through STEAM",
      subtitle: "Comprehensive learning approach",
      content:
          "Each topic is divided into five sections, one for every STEAM area:\nScience, Technology, Engineering, Arts, and Mathematics.",
      icon: Icons.explore,
      color: Colors.purple,
    ),
    TutorialPage(
      title: "4. Learn and Play",
      subtitle: "Interactive learning activities",
      content:
          "Inside each section, you can find different types of content:\n• Essay: Short readings with real-life connections\n• Video: Engaging visual content\n• Quiz: Fun knowledge tests\n• Game: Interactive activities\n• Challenge: Classroom sustainability activities",
      icon: Icons.games,
      color: Colors.red,
    ),
    TutorialPage(
      title: "5. Keep Exploring",
      subtitle: "Learn at your own pace",
      content:
          "Move between topics and activities at your own pace, and discover how your daily actions can help create a more sustainable future.",
      icon: Icons.self_improvement,
      color: Colors.teal,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _tutorialPages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to main app
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(setLocale: setLocale),
        ),
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Progress Indicator
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Tutorial",
                    style: GoogleFonts.mulish(
                      fontSize: 24.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${_currentPage + 1}/${_tutorialPages.length}",
                    style: GoogleFonts.mulish(
                      fontSize: 16.sp,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            // Progress Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: LinearProgressIndicator(
                value: (_currentPage + 1) / _tutorialPages.length,
                backgroundColor: Colors.white24,
                color: _tutorialPages[_currentPage].color,
                minHeight: 4.h,
              ),
            ),

            SizedBox(height: 20.h),

            // Page View
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _tutorialPages.length,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  return _buildTutorialPage(_tutorialPages[index]);
                },
              ),
            ),

            // Navigation Buttons
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Previous Button
                  if (_currentPage > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _previousPage,
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 15.h),
                          side: const BorderSide(color: Colors.white54),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Text(
                          "Previous",
                          style: GoogleFonts.mulish(
                            fontSize: 16.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                  if (_currentPage > 0) SizedBox(width: 10.w),

                  // Next/Get Started Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        backgroundColor: _tutorialPages[_currentPage].color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 4,
                      ),
                      child: Text(
                        _currentPage == _tutorialPages.length - 1
                            ? "Get Started"
                            : "Next",
                        style: GoogleFonts.mulish(
                          fontSize: 16.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Dots Indicator
            Padding(
              padding: EdgeInsets.only(bottom: 20.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _tutorialPages.length,
                  (index) => Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    width: _currentPage == index ? 24.w : 8.w,
                    height: 8.h,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? _tutorialPages[index].color
                          : Colors.white54,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTutorialPage(TutorialPage page) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon Circle
          Container(
            width: 120.w,
            height: 120.w,
            decoration: BoxDecoration(
              color: page.color.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: page.color.withOpacity(0.5),
                width: 2,
              ),
            ),
            child: Icon(
              page.icon,
              size: 50.w,
              color: page.color,
            ),
          ),

          SizedBox(height: 40.h),

          // Title
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.mulish(
              fontSize: 28.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),

          SizedBox(height: 10.h),

          // Subtitle
          Text(
            page.subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.mulish(
              fontSize: 18.sp,
              color: page.color,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 30.h),

          // Content
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                page.content,
                textAlign: TextAlign.center,
                style: GoogleFonts.mulish(
                  fontSize: 16.sp,
                  color: Colors.white70,
                  height: 1.6,
                ),
              ),
            ),
          ),

          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}

class TutorialPage {
  final String title;
  final String subtitle;
  final String content;
  final IconData icon;
  final Color color;

  TutorialPage({
    required this.title,
    required this.subtitle,
    required this.content,
    required this.icon,
    required this.color,
  });
}

// Replace with your actual home page
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(child: Text('Welcome to NSSF App!')),
    );
  }
}
