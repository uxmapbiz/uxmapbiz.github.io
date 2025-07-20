import 'dart:convert';
import 'dart:js_util' as js_util;
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<void> downloadExcel(BuildContext context, String websiteUrl) async {
  final response = await http.post(
    Uri.parse('https://uxmap-backend.onrender.com/download_clickables'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'url': websiteUrl}),
  );
  if (response.statusCode == 200) {
    final jsArray = js_util.jsify([response.bodyBytes]);
    final blob = html.Blob(jsArray);
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..download = "clickable_elements.xlsx"
      ..click();
    html.Url.revokeObjectUrl(url);
  } else {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Download failed: ${response.statusCode}')),
      );
    }
  }
}
