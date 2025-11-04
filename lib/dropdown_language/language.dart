import 'dart:developer';
import 'package:flutter/material.dart';

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
      {'locale': const Locale('en'), 'flag': '🇬🇧', 'name': 'English'},
      {'locale': const Locale('pt'), 'flag': '🇵🇹', 'name': 'Português'},
      {'locale': const Locale('sv'), 'flag': '🇸🇪', 'name': 'Svenska'},
      {'locale': const Locale('hu'), 'flag': '🇭🇺', 'name': 'Magyar'},
      {'locale': const Locale('tr'), 'flag': '🇹🇷', 'name': 'Türkçe'},
      {'locale': const Locale('es'), 'flag': '🇪🇸', 'name': 'Español'},
    ];

    // Ensure dropdown value exists in items
    Locale selectedValue = languages
        .firstWhere(
          (lang) => lang['locale'].languageCode == _selectedLocale.languageCode,
          orElse: () => languages[0],
        )['locale'];

    return DropdownButtonHideUnderline(
      child: DropdownButton<Locale>(
        value: selectedValue,
        dropdownColor: Colors.white,

        /// 👇 This controls how the selected item is displayed
        selectedItemBuilder: (BuildContext context) {
          return languages.map((lang) {
            return Center(
              child: Text(
                lang['flag'],
                style: const TextStyle(fontSize: 22),
              ),
            );
          }).toList();
        },

        /// 👇 Dropdown menu items (flag + text)
        items: languages.map((lang) {
          return
         DropdownMenuItem<Locale>(
  value: lang['locale'],
  child: Row(
    children: [
      Text(lang['flag'], style: const TextStyle(fontSize: 20)),
      const SizedBox(width: 8),
      Flexible(
        child: Text(
          lang['name'],
          style: const TextStyle(fontSize: 16),
          overflow: TextOverflow.ellipsis, // ✅ prevent overflow
          maxLines: 1,
        ),
      ),
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
            log('Selected language: ${newLocale.languageCode}');
          }
        },
      ),
    );
  }
}
