import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onboarding/onboarding.dart';
import '/main.dart';

class FirstOnboard extends StatefulWidget {
  const FirstOnboard({super.key});

  @override
  State<FirstOnboard> createState() => _FirstOnboardState();
}

class _FirstOnboardState extends State<FirstOnboard> {
  int index = 0;

  List<Map<String, String>> pages = [
    {
      "title": "Start Learning",
      "desc": "Tap the 'Start Learning' button to enter your dashboard.",
    },
    {
      "title": "Choose a Topic",
      "desc": "Water, Waste, Transport, Energy, Eating & Daily Life.",
    },
    {
      "title": "Explore STEAM",
      "desc":
          "Every topic includes Science, Technology, Engineering, Arts & Math.",
    },
    {
      "title": "Activities & Games",
      "desc": "Learn through Essay, Video, Quiz, Game & Challenge.",
    },
    {
      "title": "Keep Exploring",
      "desc": "Go at your own pace and discover sustainability in daily life.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/gradient.png"),
            alignment: Alignment.bottomCenter,
            fit: BoxFit.fitWidth,
          ),
        ),
        child: Onboarding(
          startIndex: index,
          swipeableBody:
              pages.map((p) => _buildPage(p["title"]!, p["desc"]!)).toList(),
          onPageChanges: (double dragPercent, int pageIndex, int pagesLength,
              SlideDirection dir) {
            setState(() => index = pageIndex);
          },
          buildFooter: (context, drag, pageIndex, total, setIndex, dir) {
            return Padding(
              padding: EdgeInsets.only(bottom: 50.h, left: 20.w, right: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _DotsIndicator(
                    pageIndex: pageIndex,
                    pagesLength: total,
                  ),
                  InkWell(
                  onTap: () {
  final totalPages = total;
  final newIndex = pageIndex + 1;

  if (newIndex < totalPages) {
    setState(() => index = newIndex);
    setIndex(newIndex);
  } else {
    /// ✅ Last page reached → Navigate without login
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (_) => const MyHomePage()), // <-- your next screen
    // );
  }
},

                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Text(
                        pageIndex == total - 1 ? "Get Started" : "Next",
                        style: GoogleFonts.mulish(
                          fontSize: 16.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPage(String title, String desc) {
    return Padding(
      padding: EdgeInsets.only(top: 120.h, left: 20.w, right: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: "BankGothic",
              fontSize: 34.sp,
              color: Colors.yellow,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            desc,
            style: TextStyle(
              fontSize: 18.sp,
              height: 1.4,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

/// ✅ Dots Indicator
class _DotsIndicator extends StatelessWidget {
  final int pageIndex;
  final int pagesLength;

  const _DotsIndicator({
    super.key,
    required this.pageIndex,
    required this.pagesLength,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(pagesLength, (i) {
        bool active = (i == pageIndex);
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          height: 8.h,
          width: active ? 28.w : 10.w,
          decoration: BoxDecoration(
            color: active ? Colors.yellow : Colors.white.withOpacity(0.4),
            borderRadius: BorderRadius.circular(8),
          ),
        );
      }),
    );
  }
}
