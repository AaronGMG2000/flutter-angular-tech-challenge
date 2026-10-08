import 'package:intl/intl.dart';

abstract final class AppFormats {
  static const String _locale = 'es';

  static final NumberFormat _price = NumberFormat(r'$#,##0.00', _locale);
  static final NumberFormat _rating = NumberFormat('0.0#', _locale);

  static String price(double value) => _price.format(value);

  static String rating(double value) => _rating.format(value);
}
