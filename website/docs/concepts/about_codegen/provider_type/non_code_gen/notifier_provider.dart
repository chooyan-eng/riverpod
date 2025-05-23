import 'package:flutter_riverpod/flutter_riverpod.dart';

/* SNIPPET START */
final exampleProvider = NotifierProvider.autoDispose<ExampleNotifier, String>(
  ExampleNotifier.new,
);

class ExampleNotifier extends Notifier<String> {
  @override
  String build() {
    return 'foo';
  }

  // Add methods to mutate the state
}
