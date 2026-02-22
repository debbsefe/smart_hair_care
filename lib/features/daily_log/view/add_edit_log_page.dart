import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hair_care/core/database/database.dart';
import 'package:smart_hair_care/core/models/models.dart';
import 'package:smart_hair_care/features/daily_log/notifiers/notifiers.dart';
import 'package:smart_hair_care/features/daily_log/widgets/widgets.dart';
import 'package:smart_hair_care/features/shared/shared.dart';
import 'package:smart_hair_care/l10n/l10n.dart';

/// Weather options for daily logs
const weatherOptions = [
  'Sunny',
  'Cloudy',
  'Rainy',
  'Humid',
  'Dry',
  'Windy',
  'Cold',
  'Hot',
];

/// Page for adding or editing a daily log entry
class AddEditLogPage extends ConsumerStatefulWidget {
  const AddEditLogPage({
    this.log,
    this.initialDate,
    super.key,
  });

  final DailyLog? log;
  final DateTime? initialDate;

  bool get isEditing => log != null;

  /// Returns a [MaterialPageRoute] for Navigator 1.0 navigation
  static Route<void> getRoute({DailyLog? log, DateTime? initialDate}) {
    return MaterialPageRoute<void>(
      builder: (_) => AddEditLogPage(log: log, initialDate: initialDate),
      settings: RouteSettings(
        name: log != null ? '/daily-log/${log.id}/edit' : '/daily-log/add',
      ),
    );
  }

  @override
  ConsumerState<AddEditLogPage> createState() => _AddEditLogPageState();
}

class _AddEditLogPageState extends ConsumerState<AddEditLogPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _techniquesController;
  late final TextEditingController _notesController;

  late DateTime _selectedDate;
  late RoutineType _selectedRoutine;
  String? _selectedProductIds;
  int? _hairConditionRating;
  String? _selectedWeather;
  int? _humidityLevel;
  double? _hairLength;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final log = widget.log;
    _selectedProductIds = log?.productsUsed;
    _techniquesController = TextEditingController(text: log?.techniques);
    _notesController = TextEditingController(text: log?.notes);
    _selectedDate = log?.date ?? widget.initialDate ?? DateTime.now();
    _selectedRoutine = log != null
        ? RoutineType.fromValue(log.routineType)
        : RoutineType.washDay;
    _hairConditionRating = log?.hairConditionRating;
    _selectedWeather = log?.weather;
    _humidityLevel = log?.humidityLevel;
    _hairLength = log?.hairLength;
  }

  @override
  void dispose() {
    _techniquesController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final notifier = ref.read(dailyLogsProvider.notifier);

      if (widget.isEditing) {
        await notifier.updateLog(
          widget.log!.copyWith(
            date: _selectedDate,
            routineType: _selectedRoutine.value,
            productsUsed: Value(_selectedProductIds),
            techniques: Value(_techniquesController.text.trim().nullIfEmpty),
            hairConditionRating: Value(_hairConditionRating),
            weather: Value(_selectedWeather),
            humidityLevel: Value(_humidityLevel),
            hairLength: Value(_hairLength),
            notes: Value(_notesController.text.trim().nullIfEmpty),
          ),
        );
      } else {
        await notifier.addLog(
          date: _selectedDate,
          routineType: _selectedRoutine.value,
          productsUsed: _selectedProductIds,
          techniques: _techniquesController.text.trim().nullIfEmpty,
          hairConditionRating: _hairConditionRating,
          weather: _selectedWeather,
          humidityLevel: _humidityLevel,
          hairLength: _hairLength,
          notes: _notesController.text.trim().nullIfEmpty,
        );
      }

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
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );

    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEditing ? l10n.editLogTitle : l10n.addLogTitle,
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Date picker
            InkWell(
              onTap: _selectDate,
              borderRadius: BorderRadius.circular(8),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: l10n.logDateLabel,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.calendar_today),
                ),
                child: Text(DateFormatter.short(_selectedDate)),
              ),
            ),
            const SizedBox(height: 16),

            // Routine type
            DropdownButtonFormField<RoutineType>(
              initialValue: _selectedRoutine,
              decoration: InputDecoration(
                labelText: l10n.logRoutineTypeLabel,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.repeat),
              ),
              items: RoutineType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.label),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedRoutine = value);
                }
              },
            ),
            const SizedBox(height: 16),

            // Hair condition rating
            Text(l10n.logHairConditionLabel, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final rating = index + 1;
                return IconButton(
                  icon: Icon(
                    _hairConditionRating != null &&
                            rating <= _hairConditionRating!
                        ? Icons.star
                        : Icons.star_border,
                    size: 36,
                    color: Colors.amber.shade600,
                  ),
                  onPressed: () {
                    setState(() {
                      _hairConditionRating = _hairConditionRating == rating
                          ? null
                          : rating;
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 16),

            // Weather
            DropdownButtonFormField<String>(
              initialValue: _selectedWeather,
              decoration: InputDecoration(
                labelText: l10n.logWeatherLabel,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.cloud_outlined),
              ),
              items: [
                const DropdownMenuItem(
                  child: Text('Not specified'),
                ),
                ...weatherOptions.map((weather) {
                  return DropdownMenuItem(
                    value: weather,
                    child: Text(weather),
                  );
                }),
              ],
              onChanged: (value) => setState(() => _selectedWeather = value),
            ),
            const SizedBox(height: 16),

            // Humidity slider
            Text(
              '${l10n.logHumidityLabel}: '
              '${_humidityLevel ?? 'Not set'}'
              '${_humidityLevel != null ? '%' : ''}',
              style: theme.textTheme.bodyMedium,
            ),
            Slider(
              value: (_humidityLevel ?? 50).toDouble(),
              max: 100,
              divisions: 20,
              label: _humidityLevel?.toString(),
              onChanged: (value) {
                setState(() => _humidityLevel = value.round());
              },
            ),
            const SizedBox(height: 16),

            // Hair length slider
            HairLengthSlider(
              label: l10n.logHairLengthLabel,
              value: _hairLength,
              onChanged: (value) {
                setState(() => _hairLength = value);
              },
            ),
            const SizedBox(height: 16),

            // Products used
            ProductPicker(
              selectedProductIds: _selectedProductIds,
              onChanged: (ids) => setState(() => _selectedProductIds = ids),
            ),
            const SizedBox(height: 16),

            // Techniques
            TextFormField(
              controller: _techniquesController,
              decoration: InputDecoration(
                labelText: l10n.logTechniquesLabel,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.auto_fix_high),
                helperText: l10n.logTechniquesHint,
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),

            // Notes
            TextFormField(
              controller: _notesController,
              decoration: InputDecoration(
                labelText: l10n.logNotesLabel,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.notes_outlined),
              ),
              maxLines: 4,
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
                  : Text(widget.isEditing ? l10n.saveButton : l10n.addButton),
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
