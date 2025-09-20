import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

/// Data model for managing text customization options.
/// It extends [ChangeNotifier] to notify listeners about state changes.
class TextCustomizationData extends ChangeNotifier {
  String _currentText = 'Welcome to GFG!';
  double _fontSize = 32.0;
  FontWeight _fontWeight = FontWeight.normal;
  FontStyle _fontStyle = FontStyle.normal;
  Color _textColor = Colors.indigo; // Initial text color
  String _selectedFontFamily = 'Pacifico'; // Initial font family

  /// A list of available font families for selection.
  /// These are chosen from Google Fonts for demonstration.
  final List<String> availableFontFamilies = const [
    'Pacifico',
    'Roboto',
    'Open Sans',
    'Lato',
    'Montserrat',
    'Playfair Display',
  ];

  /// A map of available colors for selection, with display names.
  final Map<String, Color> availableColors = const {
    'Black': Colors.black,
    'Indigo': Colors.indigo,
    'Green': Colors.green,
    'Blue': Colors.blue,
    'Red': Colors.red,
    'Purple': Colors.purple,
    'Orange': Colors.orange,
  };

  // Getters for properties
  String get currentText => _currentText;
  double get fontSize => _fontSize;
  FontWeight get fontWeight => _fontWeight;
  FontStyle get fontStyle => _fontStyle;
  Color get textColor => _textColor;
  String get selectedFontFamily => _selectedFontFamily;

  // Setters for properties, calling notifyListeners() on change
  set currentText(String newText) {
    if (_currentText != newText) {
      _currentText = newText;
      notifyListeners();
    }
  }

  set fontSize(double newSize) {
    if (_fontSize != newSize) {
      _fontSize = newSize;
      notifyListeners();
    }
  }

  set fontWeight(FontWeight newWeight) {
    if (_fontWeight != newWeight) {
      _fontWeight = newWeight;
      notifyListeners();
    }
  }

  set fontStyle(FontStyle newStyle) {
    if (_fontStyle != newStyle) {
      _fontStyle = newStyle;
      notifyListeners();
    }
  }

  set textColor(Color newColor) {
    if (_textColor != newColor) {
      _textColor = newColor;
      notifyListeners();
    }
  }

  set selectedFontFamily(String newFontFamily) {
    if (_selectedFontFamily != newFontFamily) {
      _selectedFontFamily = newFontFamily;
      notifyListeners();
    }
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TextCustomizationData>(
      create: (BuildContext context) => TextCustomizationData(),
      builder: (BuildContext context, Widget? child) => MaterialApp(
        title: 'Text Customizer App',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            foregroundColor: Colors.white,
            backgroundColor: Colors.indigo,
          ),
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo)
              .copyWith(secondary: Colors.amber),
          // We apply specific fonts dynamically, so no global fontFamily here.
        ),
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  /// Helper widget to display a title for each control section.
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Text Customizer')),
      body: SafeArea(
        child: Consumer<TextCustomizationData>(
          builder: (BuildContext context, TextCustomizationData data,
              Widget? child) {
            // Retrieve the TextStyle for the selected font family from GoogleFonts.
            // .copyWith is used to combine this base font style with dynamic properties.
            final TextStyle googleFontStyle =
                GoogleFonts.getFont(data.selectedFontFamily).copyWith(
              fontSize: data.fontSize,
              fontWeight: data.fontWeight,
              fontStyle: data.fontStyle,
              color: data.textColor,
            );

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Main display area for the customized text
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: Text(
                        data.currentText,
                        textAlign: TextAlign.center,
                        style: googleFontStyle,
                      ),
                    ),
                  ),
                  const Divider(),

                  // Text Content Editor
                  _buildSectionTitle('Text Content'),
                  TextField(
                    // Using TextEditingController with initial text set from data
                    // This allows editing and updates the data model on change
                    controller: TextEditingController(text: data.currentText),
                    decoration: const InputDecoration(
                      labelText: 'Edit Text',
                      border: OutlineInputBorder(),
                      hintText: 'Enter your custom text here',
                    ),
                    onChanged: (String value) {
                      data.currentText = value;
                    },
                  ),

                  // Font Size Slider
                  _buildSectionTitle('Font Size'),
                  Slider(
                    value: data.fontSize,
                    min: 10.0,
                    max: 80.0,
                    divisions: 70, // Steps of 1.0 between 10 and 80
                    label: data.fontSize.round().toString(),
                    onChanged: (double value) {
                      data.fontSize = value;
                    },
                  ),

                  // Font Family Dropdown
                  _buildSectionTitle('Font Family'),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: data.selectedFontFamily,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        data.selectedFontFamily = newValue;
                      }
                    },
                    items: data.availableFontFamilies
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        // Display the font name in its own style
                        child: Text(value, style: GoogleFonts.getFont(value)),
                      );
                    }).toList(),
                  ),

                  // Font Weight (Bold/Normal) Toggle
                  _buildSectionTitle('Font Weight'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text('Bold'),
                      Switch(
                        value: data.fontWeight == FontWeight.bold,
                        onChanged: (bool value) {
                          data.fontWeight =
                              value ? FontWeight.bold : FontWeight.normal;
                        },
                      ),
                    ],
                  ),

                  // Font Style (Italic/Normal) Toggle
                  _buildSectionTitle('Font Style'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text('Italic'),
                      Switch(
                        value: data.fontStyle == FontStyle.italic,
                        onChanged: (bool value) {
                          data.fontStyle =
                              value ? FontStyle.italic : FontStyle.normal;
                        },
                      ),
                    ],
                  ),

                  // Text Color Dropdown
                  _buildSectionTitle('Text Color'),
                  DropdownButton<Color>(
                    isExpanded: true,
                    value: data.textColor,
                    onChanged: (Color? newValue) {
                      if (newValue != null) {
                        data.textColor = newValue;
                      }
                    },
                    items: data.availableColors.entries
                        .map<DropdownMenuItem<Color>>(
                            (MapEntry<String, Color> entry) {
                          return DropdownMenuItem<Color>(
                            value: entry.value,
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 24,
                                  height: 24,
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    color: entry
                                        .value, // Moved color inside BoxDecoration
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                Text(entry.key),
                              ],
                            ),
                          );
                        }).toList(),
                  ),
                  const SizedBox(height: 16.0), // Padding at the bottom
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}