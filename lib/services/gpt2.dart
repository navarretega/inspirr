import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class Gpt2 {
  String category;

  String text;
  String formattedDate1;
  String formattedDate2;
  DateTime formattedDate;

  var formatDate = DateFormat('dd/MM/yyyy HH:mm:ss');

  Gpt2({this.category});

  Future<void> getData() async {
    try {
      print('Calling API for $category - STARTING');
      Map bodyData = {'category': category};
      Response response = await post('http://10.0.2.2:8000/api/endpoint',
          headers: {'Content-Type': 'application/json'},
          body: json.encode(bodyData))
          .timeout(const Duration(seconds: 30));

      // print(response.statusCode);
      Map data = json.decode(utf8.decode(response.bodyBytes));
      text = data['text'];
      formattedDate1 = data['formatted_date_1'];
      formattedDate2 = data['formatted_date_2'];
      formattedDate = formatDate.parse(formattedDate1);

      print('Calling API for $category - COMPLETED');
    } catch (e) {
      print('Calling API for $category - FAILURE');
      rethrow;
    }
  }
}