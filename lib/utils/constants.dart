import 'package:flutter/material.dart';

class AppConstants {
  // App Colors (Traditional Indian Theme)
  static const Color primaryColor = Color(0xFFD35400); // Saffron
  static const Color secondaryColor = Color(0xFF8B0000); // Maroon
  static const Color accentColor = Color(0xFFDAA520); // Gold
  static const Color backgroundColor = Color(0xFFF8F5F0);
  static const Color textColor = Color(0xFF333333);
  static const Color lightTextColor = Color(0xFF666666);

  // Font Sizes
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 14.0;
  static const double fontSizeLarge = 16.0;
  static const double fontSizeXLarge = 18.0;
  static const double fontSizeXXLarge = 24.0;

  // Spacing
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  // Border Radius
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 20.0;

  // App Strings
  static const String appName = 'Brahmin Vivah';
  static const String tagline = 'Find Your Perfect Match';

  // Education Options
  static const List<String> educationOptions = [
    'High School',
    'Bachelor\'s Degree',
    'Master\'s Degree',
    'PhD',
    'Diploma',
    'Professional Course',
  ];

  // Occupation Options
  static const List<String> occupationOptions = [
    'Student',
    'Engineer',
    'Doctor',
    'Teacher',
    'Business',
    'Government Service',
    'Private Service',
    'Self Employed',
  ];

  // Gotra List (Sample - Add more as needed)
  static const List<String> gotraList = [
    'Kashyap',
    'Vashistha',
    'Bharadwaj',
    'Atri',
    'Jamadagni',
    'Gautam',
    'Vishvamitra',
    'Agastya',
  ];

  // Sub-caste List (Sample - Add more as needed)
  static const List<String> subCasteList = [
    'Sarswat',
    'Kanyakubj',
    'Maithil',
    'Gaud',
    'Utkal',
    'Saryupareen',
  ];
}
