// age_calculator.dart

/// A professional Dart package for calculating age.
///
/// This package provides utilities to compute a person's age in years, months, and days
/// given their birthdate and an optional reference date (defaults to current date).
///
/// Example usage:
/// ```dart
/// final birthDate = DateTime(1990, 5, 15);
/// final age = calculateAge(birthDate);
/// print(age); // Outputs: X years, Y months, Z days
/// ```

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Age {
  /// The number of years.
  final int years;

  /// The number of months.
  final int months;

  /// The number of days.
  final int days;

  /// Creates an [Age] instance.
  const Age(this.years, this.months, this.days);

  @override
  String toString() => '$years years, $months months, $days days';

  /// Returns the total age in months.
  int get totalMonths => years * 12 + months;

  /// Returns the approximate total age in days (assuming 30 days per month).
  int get approximateTotalDays => totalMonths * 30 + days;

  /// Formats the age in a human-readable string with optional abbreviations.
  String formatted({bool abbreviate = false}) {
    if (abbreviate) {
      return '${years}y ${months}m ${days}d';
    } else {
      return toString();
    }
  }
}

/// Calculates the age based on the provided [birthDate] and an optional [referenceDate].
///
/// If [referenceDate] is not provided, the current date and time will be used.
///
/// Returns an [Age] object representing the calculated age.
///
/// Throws [ArgumentError] if [birthDate] is in the future relative to [referenceDate].
Age calculateAge(DateTime birthDate, [DateTime? referenceDate]) {
  referenceDate ??= DateTime.now();

  if (birthDate.isAfter(referenceDate)) {
    throw ArgumentError('Birthdate cannot be in the future.');
  }

  int years = referenceDate.year - birthDate.year;
  int months = referenceDate.month - birthDate.month;
  int days = referenceDate.day - birthDate.day;

  // Adjust if the day is before the birth day.
  if (days < 0) {
    months -= 1;
    days += DateTime(referenceDate.year, referenceDate.month, 0).day;
  }

  // Adjust if the month is before the birth month or if months are equal but days adjustment made it negative.
  if (months < 0) {
    years -= 1;
    months += 12;
  }

  return Age(years, months, days);
}

/// Calculates the age in years only, ignoring months and days.
int calculateAgeInYears(DateTime birthDate, [DateTime? referenceDate]) {
  return calculateAge(birthDate, referenceDate).years;
}

/// Checks if the person is a leap year baby.
bool isLeapYearBaby(DateTime birthDate) {
  return birthDate.month == 2 && birthDate.day == 29;
}

/// Estimates the next birthday date.
DateTime nextBirthday(DateTime birthDate, [DateTime? referenceDate]) {
  referenceDate ??= DateTime.now();
  var next = DateTime(referenceDate.year, birthDate.month, birthDate.day);
  if (next.isBefore(referenceDate) || next.isAtSameMomentAs(referenceDate)) {
    next = DateTime(referenceDate.year + 1, birthDate.month, birthDate.day);
  }
  // Handle leap year if birthDate is Feb 29
  if (isLeapYearBaby(birthDate) && !isLeapYear(next.year)) {
    next = DateTime(next.year, 3, 1);
  }
  return next;
}

/// Checks if a given year is a leap year.
bool isLeapYear(int year) {
  return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
}

/// Calculates the number of days until the next birthday.
int daysUntilNextBirthday(DateTime birthDate, [DateTime? referenceDate]) {
  final next = nextBirthday(birthDate, referenceDate);
  return next.difference(referenceDate ?? DateTime.now()).inDays;
}

/// Determines the zodiac sign based on the birth date with a brief description and icon.
Map<String, dynamic> getZodiacSign(DateTime birthDate) {
  int month = birthDate.month;
  int day = birthDate.day;

  if ((month == 3 && day >= 21) || (month == 4 && day <= 19))
    return {
      'sign': 'Aries',
      'description': 'Bold and ambitious',
      'icon': Icons.local_fire_department
    };
  if ((month == 4 && day >= 20) || (month == 5 && day <= 20))
    return {
      'sign': 'Taurus',
      'description': 'Reliable and patient',
      'icon': Icons.nature
    };
  if ((month == 5 && day >= 21) || (month == 6 && day <= 20))
    return {
      'sign': 'Gemini',
      'description': 'Versatile and curious',
      'icon': Icons.chat
    };
  if ((month == 6 && day >= 21) || (month == 7 && day <= 22))
    return {
      'sign': 'Cancer',
      'description': 'Intuitive and caring',
      'icon': Icons.home
    };
  if ((month == 7 && day >= 23) || (month == 8 && day <= 22))
    return {
      'sign': 'Leo',
      'description': 'Confident and charismatic',
      'icon': Icons.star
    };
  if ((month == 8 && day >= 23) || (month == 9 && day <= 22))
    return {
      'sign': 'Virgo',
      'description': 'Analytical and practical',
      'icon': Icons.build
    };
  if ((month == 9 && day >= 23) || (month == 10 && day <= 22))
    return {
      'sign': 'Libra',
      'description': 'Balanced and diplomatic',
      'icon': Icons.balance
    };
  if ((month == 10 && day >= 23) || (month == 11 && day <= 21))
    return {
      'sign': 'Scorpio',
      'description': 'Passionate and resourceful',
      'icon': Icons.bug_report
    };
  if ((month == 11 && day >= 22) || (month == 12 && day <= 21))
    return {
      'sign': 'Sagittarius',
      'description': 'Adventurous and optimistic',
      'icon': Icons.explore
    };
  if ((month == 12 && day >= 22) || (month == 1 && day <= 19))
    return {
      'sign': 'Capricorn',
      'description': 'Disciplined and ambitious',
      'icon': Icons.work
    };
  if ((month == 1 && day >= 20) || (month == 2 && day <= 18))
    return {
      'sign': 'Aquarius',
      'description': 'Innovative and independent',
      'icon': Icons.waves
    };
  return {
    'sign': 'Pisces',
    'description': 'Compassionate and imaginative',
    'icon': Icons.water
  };
}

/// A Flutter widget for a graphical age calculator UI.
class AgeCalculatorApp extends StatelessWidget {
  const AgeCalculatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Age Calculator',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.poppinsTextTheme(),
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.transparent,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.poppinsTextTheme().apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.transparent,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      home: const AgeCalculatorHome(),
    );
  }
}

class AgeCalculatorHome extends StatefulWidget {
  const AgeCalculatorHome({Key? key}) : super(key: key);

  @override
  _AgeCalculatorHomeState createState() => _AgeCalculatorHomeState();
}

class _AgeCalculatorHomeState extends State<AgeCalculatorHome>
    with SingleTickerProviderStateMixin {
  DateTime? _selectedDate;
  String _result = '';
  bool _abbreviate = false;
  bool _isDarkMode = false;
  bool _isCalculating = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 20)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.teal,
              backgroundColor: _isDarkMode ? Colors.grey[850] : Colors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.teal,
                textStyle: GoogleFonts.poppins(),
              ),
            ),
            dialogBackgroundColor: _isDarkMode ? Colors.grey[850] : Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _isCalculating = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Birthdate selected successfully!')),
      );
      await Future.delayed(const Duration(milliseconds: 300));
      _calculateAge();
    }
  }

  void _calculateAge() {
    if (_selectedDate == null) {
      setState(() {
        _result = 'Please select a birthdate.';
        _isCalculating = false;
      });
      return;
    }
    try {
      final age = calculateAge(_selectedDate!);
      final nextBday = nextBirthday(_selectedDate!);
      final daysToNext = daysUntilNextBirthday(_selectedDate!);
      final zodiac = getZodiacSign(_selectedDate!);
      setState(() {
        _result = '''
Age: ${age.formatted(abbreviate: _abbreviate)}
Total months: ${age.totalMonths}
Approximate total days: ${age.approximateTotalDays}
${isLeapYearBaby(_selectedDate!) ? 'You are a leap year baby!' : ''}
Next birthday: ${DateFormat.yMMMd().format(nextBday)}
Days until next birthday: $daysToNext
''';
        _isCalculating = false;
      });
      _animationController.forward(from: 0.0);
    } catch (e) {
      setState(() {
        _result = 'Error: Invalid birthdate. Please ensure the date is in the past.';
        _isCalculating = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  void _clearSelection() {
    setState(() {
      _selectedDate = null;
      _result = '';
      _abbreviate = false;
      _isCalculating = false;
    });
    _animationController.reset();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Selection cleared.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _isDarkMode
                ? [Colors.teal[900]!, Colors.teal[700]!]
                : [Colors.teal[50]!, Colors.teal[200]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Age Calculator',
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Switch(
                          value: _isDarkMode,
                          onChanged: (value) {
                            setState(() {
                              _isDarkMode = value;
                              // Update the app's theme mode
                              final newTheme = value ? ThemeMode.dark : ThemeMode.light;
                              // Note: ThemeMode is not directly modifiable here.
                              // In a real app, use a provider or similar to change ThemeMode.
                            });
                          },
                          activeColor: Colors.teal,
                          activeTrackColor: Colors.teal[200],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    AnimatedScale(
                      scale: _selectedDate == null ? 1.0 : 1.05,
                      duration: const Duration(milliseconds: 200),
                      child: ElevatedButton.icon(
                        onPressed: () => _selectDate(context),
                        icon: const Icon(Icons.calendar_today, size: 24),
                        label: Text(
                          _selectedDate == null
                              ? 'Select Birthdate'
                              : 'Birthdate: ${DateFormat.yMMMd().format(_selectedDate!)}',
                          style: GoogleFonts.poppins(fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(
                          value: _abbreviate,
                          onChanged: (value) {
                            setState(() {
                              _abbreviate = value!;
                              _calculateAge();
                            });
                          },
                          activeColor: Colors.teal,
                        ),
                        Text(
                          'Use abbreviated format',
                          style: GoogleFonts.poppins(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    AnimatedOpacity(
                      opacity: _selectedDate == null ? 0.5 : 1.0,
                      duration: const Duration(milliseconds: 300),
                      child: ElevatedButton.icon(
                        onPressed: _selectedDate == null ? null : _clearSelection,
                        icon: const Icon(Icons.clear, size: 24),
                        label: Text(
                          'Clear',
                          style: GoogleFonts.poppins(fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[400],
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Container(
                          decoration: BoxDecoration(
                            color: _isDarkMode
                                ? Colors.grey[850]!.withOpacity(0.9)
                                : Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: _isCalculating
                                ? const Center(child: CircularProgressIndicator())
                                : SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if (_selectedDate != null)
                                          CircleAvatar(
                                            radius: 30,
                                            backgroundColor: Colors.teal[100],
                                            child: Icon(
                                              getZodiacSign(_selectedDate!)['icon'] as IconData,
                                              color: Colors.teal[800],
                                              size: 30,
                                            ),
                                          ),
                                        const SizedBox(height: 8),
                                        Text(
                                          _result.isEmpty
                                              ? 'Select a birthdate to see results.'
                                              : _result,
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            height: 1.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A simple command-line UI for calculating age.
void runCommandLineUI(List<String> arguments) {
  print('Welcome to Age Calculator!');
  print('Enter your birthdate in YYYY-MM-DD format:');
  final input = stdin.readLineSync();
  if (input == null || input.isEmpty) {
    print('No input provided. Please enter a valid date in YYYY-MM-DD format.');
    return;
  }
  try {
    final birthDate = DateTime.parse(input);
    final age = calculateAge(birthDate);
    print('Your age is: ${age.formatted()}');
    print('Abbreviated: ${age.formatted(abbreviate: true)}');
    print('Total months: ${age.totalMonths}');
    print('Approximate total days: ${age.approximateTotalDays}');
    if (isLeapYearBaby(birthDate)) {
      print('You are a leap year baby!');
    }
    final nextBday = nextBirthday(birthDate);
    print('Your next birthday is on: ${DateFormat.yMMMd().format(nextBday)}');
    final daysToNext = daysUntilNextBirthday(birthDate);
    print('Days until next birthday: $daysToNext');
    final zodiac = getZodiacSign(birthDate);
    print('Zodiac sign: ${zodiac['sign']} (${zodiac['description']})');
  } catch (e) {
    print('Invalid date format. Please use YYYY-MM-DD (e.g., 1990-05-15).');
  }

  // Note: For proper testing, create a separate test file using the 'test' package.
  if (arguments.contains('--test')) {
    print('\nTesting should be done in a separate test file using the test package.');
    print('Example: Create test/age_calculator_test.dart with the test package.');
  }
}

void main(List<String> arguments) {
  if (arguments.contains('--flutter')) {
    runApp(const AgeCalculatorApp());
  } else {
    runCommandLineUI(arguments);
  }
}#