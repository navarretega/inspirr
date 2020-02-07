import 'package:meta/meta.dart';

class TextAI {
  final String category;
  final String text;
  final String formattedDate2;
  final DateTime formattedDate;

  TextAI(
      {@required this.category,
      @required this.text,
      @required this.formattedDate2,
      @required this.formattedDate});

  factory TextAI.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    } else {
      final String category = data['category'];
      final String text = data['text'];
      final String formattedDate2 = data['formattedDate2'];
      final DateTime formattedDate = data['formattedDate'].toDate();
      return TextAI(category: category, text: text, formattedDate2: formattedDate2, formattedDate: formattedDate);
    }
  }

  Map<String, dynamic> toMap() {
    return {'category': category, 'text': text, 'formattedDate2': formattedDate2, 'formattedDate': formattedDate};
  }
}
