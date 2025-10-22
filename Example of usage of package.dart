import 'dart:io';
import 'package:age_calculator/age_calculator.dart';
import 'package:intl/intl.dart';

/// Demonstrates the usage of the age_calculator package with interactive input,
/// comprehensive age calculations, and formatted output.
void main() {
  print('=== Age Calculator Demo ===');
  print('Enter a birthdate in YYYY-MM-DD format (e.g., 1990-05-15) or "exit" to quit.');

  // Interactive loop for multiple calculations
  while (true) {
    stdout.write('Birthdate: ');
    final input = stdin.readLineSync()?.trim();

    // Exit condition
    if (input == null || input.toLowerCase() == 'exit') {
      print('Thank you for using Age Calculator!');
      break;
    }

    try {
      // Parse the birthdate
      final birthDate = DateTime.parse(input);

      // Optional: Ask for a custom reference date
      stdout.write('Enter reference date (YYYY-MM-DD) or press Enter for today: ');
      final refInput = stdin.readLineSync()?.trim();
      DateTime? referenceDate = refInput != null && refInput.isNotEmpty
          ? DateTime.parse(refInput)
          : null;

      // Calculate age
      final age = calculateAge(birthDate, referenceDate);
      final ageInYears = calculateAgeInYears(birthDate, referenceDate);
      final isLeapYear = isLeapYearBaby(birthDate);
      final nextBday = nextBirthday(birthDate, referenceDate);
      final daysToNext = daysUntilNextBirthday(birthDate, referenceDate);
      final zodiac = getZodiacSign(birthDate);

      // Formatted output
      print('\n' + '=' * 40);
      print('Age Calculation Results');
      print('=' * 40);
      print('Birthdate: ${DateFormat.yMMMd().format(birthDate)}');
      if (referenceDate != null) {
        print('Reference Date: ${DateFormat.yMMMd().format(referenceDate)}');
      } else {
        print('Reference Date: Today (${DateFormat.yMMMd().format(DateTime.now())})');
      }
      print('-' * 40);
      print('Age: ${age.formatted()}');
      print('Abbreviated: ${age.formatted(abbreviate: true)}');
      print('Age (Years only): $ageInYears years');
      print('Total Months: ${age.totalMonths}');
      print('Approximate Total Days: ${age.approximateTotalDays}');
      print('Leap Year Baby: ${isLeapYear ? 'Yes' : 'No'}');
      print('Next Birthday: ${DateFormat.yMMMd().format(nextBday)}');
      print('Days Until Next Birthday: $daysToNext');
      print('Zodiac Sign: ${zodiac['sign']} (${zodiac['description']})');
      print('Zodiac Icon: ${describeIcon(zodiac['icon'] as IconData)}');
      print('=' * 40 + '\n');
    } catch (e) {
      print('Error: Invalid date format. Please use YYYY-MM-DD (e.g., 1990-05-15).');
    }

    // Prompt for another calculation
    stdout.write('Calculate another? (y/n): ');
    final continueInput = stdin.readLineSync()?.trim().toLowerCase();
    if (continueInput != 'y') {
      print('Thank you for using Age Calculator!');
      break;
    }
  }
}

/// Converts an IconData to a human-readable description for command-line output.
String describeIcon(IconData icon) {
  // Map IconData to descriptive strings (simplified for common icons)
  switch (icon.toString()) {
    case 'IconData(U+0F06D6)': // local_fire_department
      return 'Fire';
    case 'IconData(U+0E8B6)': // nature
      return 'Leaf';
    case 'IconData(U+0E158)': // chat
      return 'Speech Bubble';
    case 'IconData(U+0E88A)': // home
      return 'Home';
    case 'IconData(U+0E838)': // star
      return 'Star';
    case 'IconData(U+0E8F1)': // build
      return 'Tools';
    case 'IconData(U+0F05A4)': // balance
      return 'Scales';
    case 'IconData(U+0E1B3)': // bug_report
      return 'Scorpion';
    case 'IconData(U+0E8B8)': // explore
      return 'Compass';
    case 'IconData(U+0E8F9)': // work
      return 'Briefcase';
    case 'IconData(U+0F0709)': // waves
      return 'Waves';
    case 'IconData(U+0E9C7)': // water
      return 'Water Droplet';
    default:
      return 'Unknown Icon';
  }
}