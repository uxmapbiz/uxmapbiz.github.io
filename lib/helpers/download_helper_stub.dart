// download_helper_stub.dart
import 'package:flutter/material.dart';

Future<void> downloadExcel(BuildContext context, String url) async {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Download is only supported on web.')),
  );
}
