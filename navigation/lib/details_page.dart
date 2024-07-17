import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'notifiers.dart';
import 'package:logger/logger.dart';

Logger logger = Logger();

class DetailsPage extends ConsumerStatefulWidget {
  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends ConsumerState<DetailsPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Handle back button press
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ModalRoute.of(context)?.addScopedWillPopCallback(() async {
        logger.d("User clicked the back button");
        return true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    logger.d("DetailsPage: build started");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Snippet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: 'Content'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final newSnippet = {
                  'title': _titleController.text,
                  'content': _contentController.text,
                };
                logger.d("Attempting to add new snippet: $newSnippet");
                ref.read(customProvider.notifier).add(newSnippet);
                logger.d('Added new snippet: $newSnippet');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Item saved')),
                );
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}
