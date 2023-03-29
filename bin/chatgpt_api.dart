import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<void> main(List<String> arg) async {
  stdout.writeln('What do you like to ask?');
  final prompt = stdin.readLineSync();
  if (prompt != null) print(await callChatGPT(prompt));
}

Future<String?> callChatGPT(String prompt) async {
  const apiKey = "<YOUR-OPEN-AI-API-KEY>";
  const apiUrl = "https://api.openai.com/v1/completions";

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $apiKey'
  };

  final body = jsonEncode(
    {
      "model": "text-davinci-003",
      'prompt': prompt,
      'max_tokens': 7, // Adjust as needed
    },
  );
  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: body,
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final result = jsonResponse['choices'][0]['text'];
      return result;
    } else {
      print(
        'Failed to call ChatGPT API: ${response.statusCode} ${response.body}',
      );
      return null;
    }
  } catch (e) {
    print("Error calling ChatGPT API: $e");
    return null;
  }
}
