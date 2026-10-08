import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:catalog/app.dart';
import 'package:catalog/core/error/retry_policy.dart';

void main() {
  runApp(const ProviderScope(retry: retryPolicy, child: App()));
}
