import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hair_care/core/database/database.dart';
import 'package:smart_hair_care/core/models/hair_enums.dart';
import 'package:smart_hair_care/features/hair_profile/notifiers/hair_pattern_selection_notifier.dart';

/// Page for selecting hair pattern with bucket + progressive disclosure
class HairPatternSelectionPage extends ConsumerStatefulWidget {
  const HairPatternSelectionPage({
    required this.profileId,
    this.onSaved,
    super.key,
  });

  final int profileId;
  final VoidCallback? onSaved;

  static Route<void> getRoute({
    required int profileId,
    VoidCallback? onSaved,
  }) {
    return MaterialPageRoute(
      builder: (_) => HairPatternSelectionPage(
        profileId: profileId,
        onSaved: onSaved,
      ),
      settings: const RouteSettings(name: '/hair-pattern-selection'),
    );
  }

  @override
  ConsumerState<HairPatternSelectionPage> createState() =>
      _HairPatternSelectionPageState();
}

class _HairPatternSelectionPageState
    extends ConsumerState<HairPatternSelectionPage> {
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Load existing profile data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dao = ref.read(hairProfilesDaoProvider);
      unawaited(
        dao.getProfile().then((profile) {
          if (profile != null && mounted) {
            ref
                .read(hairPatternSelectionProvider.notifier)
                .loadFromProfile(profile);
          }
        }),
      );
    });
  }

  Future<void> _saveSelection() async {
    setState(() => _isSaving = true);

    try {
      await ref
          .read(hairPatternSelectionProvider.notifier)
          .saveSelection(widget.profileId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hair pattern saved successfully')),
        );
        widget.onSaved?.call();
        Navigator.of(context).pop();
      }
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(hairPatternSelectionProvider);
    final notifier = ref.read(hairPatternSelectionProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Hair Pattern'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'What describes your hair?',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Select the category that best matches your hair texture',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),

            // Bucket cards (2x2 grid)
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.2,
              children: HairPatternBucket.values.map((bucket) {
                final isSelected = state.selectedBucket == bucket;
                return _BucketCard(
                  bucket: bucket,
                  isSelected: isSelected,
                  onTap: () => notifier.selectBucket(bucket),
                );
              }).toList(),
            ),

            // Progressive disclosure: Refine section
            if (state.selectedBucket != null) ...[
              const SizedBox(height: 32),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Refine your pattern (Optional)',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Select up to 2 specific patterns if you have '
                      'multi-textured hair',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: state.selectedBucket!.subTypes.map((pattern) {
                        final isSelected = state.selectedPatterns.contains(
                          pattern,
                        );
                        final canSelect =
                            state.selectedPatterns.length <
                                HairPatternSelectionNotifier.maxPatterns ||
                            isSelected;

                        return FilterChip(
                          label: Text(pattern),
                          selected: isSelected,
                          onSelected: canSelect
                              ? (_) => notifier.togglePattern(pattern)
                              : null,
                          selectedColor: theme.colorScheme.primaryContainer,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 32),

            // Save button
            FilledButton(
              onPressed: state.selectedBucket != null && !_isSaving
                  ? _saveSelection
                  : null,
              child: _isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save Selection'),
            ),
          ],
        ),
      ),
    );
  }
}

class _BucketCard extends StatelessWidget {
  const _BucketCard({
    required this.bucket,
    required this.isSelected,
    required this.onTap,
  });

  final HairPatternBucket bucket;
  final bool isSelected;
  final VoidCallback onTap;

  IconData _getIconForBucket() {
    switch (bucket) {
      case HairPatternBucket.straight:
        return Icons.line_weight;
      case HairPatternBucket.wavy:
        return Icons.waves;
      case HairPatternBucket.curly:
        return Icons.autorenew;
      case HairPatternBucket.coily:
        return Icons.all_inclusive;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: isSelected ? 8 : 2,
      color: isSelected
          ? theme.colorScheme.primaryContainer
          : theme.colorScheme.surface,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getIconForBucket(),
                size: 48,
                color: isSelected
                    ? theme.colorScheme.onPrimaryContainer
                    : theme.colorScheme.onSurface,
              ),
              const SizedBox(height: 12),
              Text(
                bucket.label,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: isSelected
                      ? theme.colorScheme.onPrimaryContainer
                      : theme.colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
              if (isSelected)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Icon(
                    Icons.check_circle,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
