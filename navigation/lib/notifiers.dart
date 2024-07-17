import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for managing the state of message snippets.
final customProvider = StateNotifierProvider<CustomNotifier, List<Map<String, dynamic>>>((ref) {
  return CustomNotifier();
});

/// Notifier for message snippets.
class CustomNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  CustomNotifier() : super([]);

  void setter(List<Map<String, dynamic>> snippets) {
    state = snippets;
  }

  void add(Map<String, dynamic> snippet) {
    state = [...state, snippet];
  }

  void clear() {
    state = [];
  }
}
