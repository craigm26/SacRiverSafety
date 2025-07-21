import 'package:flutter/material.dart';
import 'package:sacriversafety/presentation/themes/app_theme.dart';
import 'package:sacriversafety/core/constants/language_constants.dart';

/// Language selector widget for the app bar
class LanguageSelector extends StatefulWidget {
  final Function(String) onLanguageChanged;
  final String currentLanguage;

  const LanguageSelector({
    super.key,
    required this.onLanguageChanged,
    this.currentLanguage = 'en',
  });

  @override
  State<LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  late String _selectedLanguage;



  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.currentLanguage;
  }

  @override
  Widget build(BuildContext context) {
    final currentLang = LanguageConstants.getLanguageInfo(_selectedLanguage);
    
    return PopupMenuButton<String>(
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            currentLang?['flag'] ?? '🌐',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.arrow_drop_down,
            color: Colors.white,
            size: 20,
          ),
        ],
      ),
      onSelected: (String languageCode) {
        setState(() {
          _selectedLanguage = languageCode;
        });
        widget.onLanguageChanged(languageCode);
      },
      itemBuilder: (BuildContext context) {
        return LanguageConstants.supportedLanguages.entries.map((entry) {
          final languageCode = entry.key;
          final language = entry.value;
          final isSelected = languageCode == _selectedLanguage;
          
          return PopupMenuItem<String>(
            value: languageCode,
            child: Row(
              children: [
                Text(
                  language['flag']!,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        language['native']!,
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? AppTheme.primaryBlue : null,
                        ),
                      ),
                      Text(
                        language['name']!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check,
                    color: AppTheme.primaryBlue,
                    size: 16,
                  ),
              ],
            ),
          );
        }).toList();
      },
    );
  }
}

/// Language selector for the drawer (more compact version)
class DrawerLanguageSelector extends StatelessWidget {
  final String currentLanguage;
  final Function(String) onLanguageChanged;

  const DrawerLanguageSelector({
    super.key,
    required this.currentLanguage,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final currentLang = LanguageConstants.getLanguageInfo(currentLanguage);
    
    return ExpansionTile(
      leading: const Icon(Icons.language, color: AppTheme.primaryBlue),
      title: const Text('Language'),
      subtitle: Text(currentLang?['native'] ?? 'English'),
      children: [
        ...LanguageConstants.supportedLanguages.entries.map((entry) {
          final languageCode = entry.key;
          final language = entry.value;
          final isSelected = languageCode == currentLanguage;
          
          return ListTile(
            leading: Text(
              language['flag']!,
              style: const TextStyle(fontSize: 16),
            ),
            title: Text(
              language['native']!,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppTheme.primaryBlue : null,
              ),
            ),
            subtitle: Text(language['name']!),
            trailing: isSelected
                ? Icon(Icons.check, color: AppTheme.primaryBlue)
                : null,
            onTap: () {
              onLanguageChanged(languageCode);
              Navigator.pop(context);
            },
          );
        }).toList(),
      ],
    );
  }
} 