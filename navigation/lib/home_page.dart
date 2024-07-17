import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'notifiers.dart';

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snippets = ref.watch(customProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: ListView.builder(
        itemCount: snippets.length,
        itemBuilder: (context, index) {
          final snippet = snippets[index];
          return ListTile(
            title: Text(snippet['title']),
            subtitle: Text(snippet['content']),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/details'),
        child: Icon(Icons.add),
      ),
    );
  }
}
