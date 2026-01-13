import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:balloon_design_studio/src/core/app.dart';

void main() {
  runApp(
    const ProviderScope(
      child: BalloonDesignStudioApp(),
    ),
  );
}
