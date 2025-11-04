import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newsstepsafefuture/dropdown_language/language.dart';
import 'package:newsstepsafefuture/providers/font_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomTopBar extends StatelessWidget {
  final Locale currentLocale;
  final Function(Locale) onLocaleChange;

  const CustomTopBar({
    super.key,
    required this.currentLocale,
    required this.onLocaleChange,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = constraints.maxWidth;
        bool isMobile = maxWidth < 480; // breakpoint for mobile

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            gradient: const LinearGradient(
              colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8.r,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// Left Logo
              ClipOval(
                child: Image.network(
                  "https://newstepssafefuture.eu/wp-content/themes/yootheme/cache/da/NSSF-Ultimate-logo-1-daee3d7e.webp",
                 // width: isMobile ? 40.w : 60.w,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),

              /// Font + Language (Flexible so they shrink on mobile)
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 8.w),

                    /// Language Dropdown
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6.r,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: LanguageDropdown(
                          currentLocale: currentLocale,
                          onLocaleChange: onLocaleChange,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// Right Social Icons
              Row(
                children: [
                  /// LinkedIn Button
                  IconButton(
                    icon: Image.asset(
                      "assets/images/linkedin.png",
                     // width: isMobile ? 28.w : 40.w,
                      height:30
                    ),
                    onPressed: () => _launchURL(
                      'https://www.linkedin.com/company/newstepssafefuture/',
                    ),
                  ),

              

                  /// Facebook Button
                  IconButton(
                    icon: Image.asset(
                      "assets/images/facebook.png",
                     // width: isMobile ? 28.w : 40.w,
                      height: 30
                    ),
                    onPressed: () => _launchURL(
                      'https://www.facebook.com/profile.php?id=61567329192286',
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw Exception("Could not launch $url");
    }
  }
}
