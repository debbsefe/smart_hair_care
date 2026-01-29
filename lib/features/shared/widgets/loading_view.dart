import 'package:flutter/material.dart';

/// A centered loading indicator widget
class LoadingView extends StatelessWidget {
  const LoadingView({
    this.message,
    super.key,
  });

  /// Optional message to display below the indicator
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }
}
