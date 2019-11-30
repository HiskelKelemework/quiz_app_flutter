import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main(List<String> args) async {
  await File('./questions.json').readAsString().then((fileContent) {
    const url =
        'https://mobile-development-52de3.firebaseio.com/questions.json';
    http.post(url, body: fileContent).then((response) {
      print(json.decode(response.body));
    });
  });
}
