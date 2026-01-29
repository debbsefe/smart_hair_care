import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hair_care/features/experiments/providers/providers.dart';
import 'package:smart_hair_care/features/shared/utils/date_formatter.dart';
import 'package:smart_hair_care/l10n/l10n.dart';

/// Page for adding a new experiment
class AddExperimentPage extends ConsumerStatefulWidget {
  const AddExperimentPage({super.key});

  /// Returns a [MaterialPageRoute] for Navigator 1.0 navigation
  static Route<void> getRoute() {
    return MaterialPageRoute<void>(
      builder: (_) => const AddExperimentPage(),
      settings: const RouteSettings(name: '/experiments/add'),
    );
  }

  @override
  ConsumerState<AddExperimentPage> createState() => _AddExperimentPageState();
}

class _AddExperimentPageState extends ConsumerState<AddExperimentPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _hypothesisController = TextEditingController();
  final _methodController = TextEditingController();
  final _variablesController = TextEditingController();

  DateTime _startDate = DateTime.now();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _hypothesisController.dispose();
    _methodController.dispose();
    _variablesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      await ref
          .read(experimentsProvider.notifier)
          .addExperiment(
            name: _nameController.text.trim(),
            startDate: _startDate,
            hypothesis: _hypothesisController.text.trim().nullIfEmpty,
            method: _methodController.text.trim().nullIfEmpty,
            variables: _variablesController.text.trim().nullIfEmpty,
          );

      if (mounted) {
        Navigator.pop(context);
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );

    if (date != null) {
      setState(() => _startDate = date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.addExperimentTitle),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Info card
            Card(
              color: theme.colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.science_outlined,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l10n.experimentInfoText,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Name field
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.experimentNameLabel,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.label_outline),
              ),
              textCapitalization: TextCapitalization.sentences,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.experimentNameRequired;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Start date
            InkWell(
              onTap: _selectDate,
              borderRadius: BorderRadius.circular(8),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: l10n.experimentStartDateLabel,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.calendar_today),
                ),
                child: Text(DateFormatter.short(_startDate)),
              ),
            ),
            const SizedBox(height: 16),

            // Hypothesis
            TextFormField(
              controller: _hypothesisController,
              decoration: InputDecoration(
                labelText: l10n.experimentHypothesisLabel,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.lightbulb_outline),
                helperText: l10n.experimentHypothesisHint,
              ),
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),

            // Method
            TextFormField(
              controller: _methodController,
              decoration: InputDecoration(
                labelText: l10n.experimentMethodLabel,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.list_alt),
                helperText: l10n.experimentMethodHint,
              ),
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),

            // Variables
            TextFormField(
              controller: _variablesController,
              decoration: InputDecoration(
                labelText: l10n.experimentVariablesLabel,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.tune),
                helperText: l10n.experimentVariablesHint,
              ),
              maxLines: 2,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 32),

            // Submit button
            FilledButton(
              onPressed: _isSubmitting ? null : _submit,
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.startExperimentButton),
            ),
          ],
        ),
      ),
    );
  }
}

extension on String {
  String? get nullIfEmpty => isEmpty ? null : this;
}
