import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:newsstepsafefuture/utils/colors.dart';

class LanguageDropdown extends StatefulWidget {
  final Locale currentLocale;
  final Function(Locale) onLocaleChange;

  const LanguageDropdown({
    Key? key,
    required this.currentLocale,
    required this.onLocaleChange,
  }) : super(key: key);

  @override
  State<LanguageDropdown> createState() => _LanguageDropdownState();
}

class _LanguageDropdownState extends State<LanguageDropdown> {
  late Locale _selectedLocale;

  @override
  void initState() {
    super.initState();
    _selectedLocale = widget.currentLocale;
  }

  @override
  void didUpdateWidget(covariant LanguageDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentLocale != widget.currentLocale) {
      setState(() {
        _selectedLocale = widget.currentLocale;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> languages = [
      {
        'locale': Locale('en'),
        'name': 'English',
        'flag': '🇬🇧',
      },
      {
        'locale': Locale('pt'),
        'name': 'Português',
        'flag': '🇵🇹',
      },
      {
        'locale': Locale('sv'),
        'name': 'Svenska',
        'flag': '🇸🇪',
      },
      {
        'locale': Locale('hu'),
        'name': 'Magyar',
        'flag': '🇭🇺',
      },
      {
        'locale': Locale('tr'),
        'name': 'Türkçe',
        'flag': '🇹🇷',
      },
      {
        'locale': Locale('es'),
        'name': 'Español',
        'flag': '🇪🇸',
      },
      {
        'locale': Locale('eu'),
        'name': 'Euskara',
        'flag': Image.asset(
          'assets/images/eu.png', // Ensure this image exists
          width: 24,
          height: 16,
          fit: BoxFit.contain,
        ),
      },
    ];

    return DropdownButtonHideUnderline(
      child: DropdownButton<Locale>(
        value: _selectedLocale,
        items: languages.map((lang) {
          return DropdownMenuItem<Locale>(
            
            value: lang['locale'],
            child: Row(
              children: [
                lang['flag'] is String
                    ? Text(lang['flag'], style: TextStyle(fontSize: 20))
                    : lang['flag'], // for image-based flag
                SizedBox(width: 5),
                Text(lang['name']),
              ],
            ),
          );
        }).toList(),
        onChanged: (Locale? newLocale) {
          if (newLocale != null) {
            setState(() {
              _selectedLocale = newLocale;
            });
            widget.onLocaleChange(newLocale);
          }
        },
      ),
    );
  }
}
