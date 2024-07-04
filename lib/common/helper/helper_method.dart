import 'package:intl/intl.dart';

String formatDate(String createdAtString) {
  // Chuyển đổi chuỗi thành đối tượng DateTime
  DateTime dateTime =
      DateTime.parse(createdAtString); // hoặc sử dụng DateFormat nếu cần thiết

  DateTime nowOnly = DateTime.now();
  DateTime dateOnly = DateTime(dateTime.year, dateTime.month, dateTime.day);

  // Định dạng lại ngày thành chuỗi theo định dạng "dd/MM/yyyy"
  String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);

  // Tính số ngày giữa ngày hiện tại và ngày 'createdAt'
  int daysDifference = nowOnly.difference(dateOnly).inDays;

  // Trả về chuỗi theo yêu cầu
  return daysDifference > 30
      ? formattedDate
      : daysDifference == 0
          ? "Hôm nay"
          : daysDifference == 1
              ? "Hôm qua"
              : "$daysDifference ngày trước";
}

int daysBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return to.difference(from).inDays;
}
