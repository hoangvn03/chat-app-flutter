import 'package:intl/intl.dart';

String formatDateTime(String isoString) {
  // Parse chuỗi ISO
  final dateTime = DateTime.parse(isoString).toLocal();

  // Danh sách thứ bằng tiếng Việt
  const weekdays = [
    'CN', 'Th 2', 'Th 3', 'Th 4', 'Th 5', 'Th 6', 'Th 7'
  ];

  final weekday = weekdays[dateTime.weekday % 7];
  final time = DateFormat('HH:mm').format(dateTime);

  return '$weekday $time';
}
