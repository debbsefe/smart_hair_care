import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hair_care/core/models/models.dart';
import 'package:smart_hair_care/features/hair_profile/notifiers/notifiers.dart';
import 'package:smart_hair_care/l10n/l10n.dart';

/// Page for setting up the hair profile (one-time onboarding)
class HairProfileSetupPage extends ConsumerStatefulWidget {
  const HairProfileSetupPage({super.key});

  /// Returns a [MaterialPageRoute] for Navigator 1.0 navigation
  static Route<void> getRoute() {
    return MaterialPageRoute<void>(
      builder: (_) => const HairProfileSetupPage(),
      settings: const RouteSettings(name: '/profile/setup'),
    );
  }

  @override
  ConsumerState<HairProfileSetupPage> createState() =>
      _HairProfileSetupPageState();
}

class _HairProfileSetupPageState extends ConsumerState<HairProfileSetupPage> {
  final _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 5;
  bool _showValidationError = false;

  // Form values
  late TextEditingController _nameController;
  HairPatternBucket? _selectedBucket;
  Set<String> _selectedPatterns = {};
  Porosity? _selectedPorosity;
  Density? _selectedDensity;
  Thickness? _selectedThickness;
  ScalpType? _selectedScalpType;
  double? _hairLength;
  final Set<String> _selectedConcerns = {};
  final Set<String> _selectedGoals = {};
  bool _isColorTreated = false;
  bool _isHeatDamaged = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  bool _isCurrentStepValid() {
    switch (_currentStep) {
      case 0: // Basic Info — name required
        return _nameController.text.trim().isNotEmpty;
      case 1: // Hair Pattern — bucket required
        return _selectedBucket != null;
      case 2: // Characteristics — all four required
        return _selectedPorosity != null &&
            _selectedDensity != null &&
            _selectedThickness != null &&
            _selectedScalpType != null;
      case 3: // Concerns — at least one
        return _selectedConcerns.isNotEmpty;
      case 4: // Goals — at least one
        return _selectedGoals.isNotEmpty;
      default:
        return true;
    }
  }

  String _validationMessage(AppLocalizations l10n) {
    switch (_currentStep) {
      case 0:
        return l10n.profileNameRequired;
      case 1:
        return l10n.profileHairTypeRequired;
      case 2:
        return l10n.profileCharacteristicsRequired;
      case 3:
        return l10n.profileConcernsRequired;
      case 4:
        return l10n.profileGoalsRequired;
      default:
        return '';
    }
  }

  Future<void> _nextStep() async {
    if (!_isCurrentStepValid()) {
      setState(() => _showValidationError = true);
      return;
    }
    setState(() => _showValidationError = false);

    if (_currentStep < _totalSteps - 1) {
      await _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep++);
    } else {
      await _submit();
    }
  }

  Future<void> _previousStep() async {
    if (_currentStep > 0) {
      await _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep--);
    }
  }

  Future<void> _submit() async {
    setState(() => _isSubmitting = true);

    try {
      await ref
          .read(hairProfileProvider.notifier)
          .saveProfile(
            name: _nameController.text.trim().nullIfEmpty,
            primaryType: _selectedBucket?.value,
            specificPatterns: _selectedPatterns.toList(),
            porosity: _selectedPorosity?.value,
            density: _selectedDensity?.value,
            thickness: _selectedThickness?.value,
            scalpType: _selectedScalpType?.value,
            hairLength: _hairLength,
            concerns: _selectedConcerns.toList(),
            goals: _selectedGoals.toList(),
            isColorTreated: _isColorTreated,
            isHeatDamaged: _isHeatDamaged,
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

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profileSetupTitle),
      ),
      body: Column(
        children: [
          // Progress indicator
          LinearProgressIndicator(
            value: (_currentStep + 1) / _totalSteps,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Step ${_currentStep + 1} of $_totalSteps',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),

          // Page content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _BasicInfoStep(
                  nameController: _nameController,
                  isColorTreated: _isColorTreated,
                  isHeatDamaged: _isHeatDamaged,
                  onColorTreatedChanged: (v) =>
                      setState(() => _isColorTreated = v),
                  onHeatDamagedChanged: (v) =>
                      setState(() => _isHeatDamaged = v),
                ),
                _HairPatternStep(
                  selectedBucket: _selectedBucket,
                  selectedPatterns: _selectedPatterns,
                  onBucketSelected: (bucket) {
                    setState(() {
                      if (_selectedBucket != bucket) {
                        _selectedBucket = bucket;
                        _selectedPatterns = {};
                      }
                    });
                  },
                  onPatternToggled: (pattern) {
                    setState(() {
                      if (_selectedPatterns.contains(pattern)) {
                        _selectedPatterns.remove(pattern);
                      } else if (_selectedPatterns.length < 2) {
                        _selectedPatterns.add(pattern);
                      }
                    });
                  },
                ),
                _CharacteristicsStep(
                  porosity: _selectedPorosity,
                  density: _selectedDensity,
                  thickness: _selectedThickness,
                  scalpType: _selectedScalpType,
                  hairLength: _hairLength,
                  onPorosityChanged: (v) =>
                      setState(() => _selectedPorosity = v),
                  onDensityChanged: (v) => setState(() => _selectedDensity = v),
                  onThicknessChanged: (v) =>
                      setState(() => _selectedThickness = v),
                  onScalpTypeChanged: (v) =>
                      setState(() => _selectedScalpType = v),
                  onLengthChanged: (v) => setState(() => _hairLength = v),
                ),
                _ConcernsStep(
                  selectedConcerns: _selectedConcerns,
                  onConcernToggled: (concern) {
                    setState(() {
                      if (_selectedConcerns.contains(concern)) {
                        _selectedConcerns.remove(concern);
                      } else {
                        _selectedConcerns.add(concern);
                      }
                    });
                  },
                ),
                _GoalsStep(
                  selectedGoals: _selectedGoals,
                  onGoalToggled: (goal) {
                    setState(() {
                      if (_selectedGoals.contains(goal)) {
                        _selectedGoals.remove(goal);
                      } else {
                        _selectedGoals.add(goal);
                      }
                    });
                  },
                ),
              ],
            ),
          ),

          // Validation error message
          if (_showValidationError)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                _validationMessage(l10n),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),

          // Navigation buttons
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _previousStep,
                        child: Text(l10n.previousButton),
                      ),
                    ),
                  if (_currentStep > 0) const SizedBox(width: 16),
                  Expanded(
                    child: FilledButton(
                      onPressed: _isSubmitting ? null : _nextStep,
                      child: _isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              _currentStep == _totalSteps - 1
                                  ? l10n.saveButton
                                  : l10n.nextButton,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BasicInfoStep extends StatelessWidget {
  const _BasicInfoStep({
    required this.nameController,
    required this.isColorTreated,
    required this.isHeatDamaged,
    required this.onColorTreatedChanged,
    required this.onHeatDamagedChanged,
  });

  final TextEditingController nameController;
  final bool isColorTreated;
  final bool isHeatDamaged;
  final ValueChanged<bool> onColorTreatedChanged;
  final ValueChanged<bool> onHeatDamagedChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.profileBasicInfoTitle,
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.profileBasicInfoSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: l10n.profileNameLabel,
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.person_outline),
            ),
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 24),
          Text(
            l10n.profileTreatmentTitle,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            title: Text(l10n.profileColorTreated),
            subtitle: Text(l10n.profileColorTreatedHint),
            value: isColorTreated,
            onChanged: onColorTreatedChanged,
          ),
          SwitchListTile(
            title: Text(l10n.profileHeatDamaged),
            subtitle: Text(l10n.profileHeatDamagedHint),
            value: isHeatDamaged,
            onChanged: onHeatDamagedChanged,
          ),
        ],
      ),
    );
  }
}

class _HairPatternStep extends StatelessWidget {
  const _HairPatternStep({
    required this.selectedBucket,
    required this.selectedPatterns,
    required this.onBucketSelected,
    required this.onPatternToggled,
  });

  final HairPatternBucket? selectedBucket;
  final Set<String> selectedPatterns;
  final ValueChanged<HairPatternBucket> onBucketSelected;
  final ValueChanged<String> onPatternToggled;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.profileHairTypeTitle,
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.profileHairTypeSubtitle,
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
            childAspectRatio: 1.3,
            children: HairPatternBucket.values.map((bucket) {
              final isSelected = selectedBucket == bucket;
              return _BucketCard(
                bucket: bucket,
                isSelected: isSelected,
                onTap: () => onBucketSelected(bucket),
              );
            }).toList(),
          ),

          // Progressive disclosure: Refine section
          if (selectedBucket != null) ...[
            const SizedBox(height: 32),
            Text(
              'Refine your pattern (Optional)',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Select up to 2 patterns if you have multi-textured hair',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: selectedBucket!.subTypes.map((pattern) {
                final isSelected = selectedPatterns.contains(pattern);
                final canSelect = selectedPatterns.length < 2 || isSelected;

                return FilterChip(
                  label: Text(pattern),
                  selected: isSelected,
                  onSelected: canSelect
                      ? (_) => onPatternToggled(pattern)
                      : null,
                  selectedColor: theme.colorScheme.primaryContainer,
                );
              }).toList(),
            ),
          ],
        ],
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: isSelected ? 4 : 1,
      color: isSelected ? theme.colorScheme.primaryContainer : null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getIconForBucket(bucket),
                size: 32,
                color: isSelected
                    ? theme.colorScheme.onPrimaryContainer
                    : theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 8),
              Text(
                bucket.label,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: isSelected
                      ? theme.colorScheme.onPrimaryContainer
                      : null,
                  fontWeight: isSelected ? FontWeight.bold : null,
                ),
                textAlign: TextAlign.center,
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForBucket(HairPatternBucket bucket) {
    return switch (bucket) {
      HairPatternBucket.straight => Icons.horizontal_rule,
      HairPatternBucket.wavy => Icons.waves,
      HairPatternBucket.curly => Icons.gesture,
      HairPatternBucket.coily => Icons.all_inclusive,
    };
  }
}

class _CharacteristicsStep extends StatelessWidget {
  const _CharacteristicsStep({
    required this.porosity,
    required this.density,
    required this.thickness,
    required this.scalpType,
    required this.hairLength,
    required this.onPorosityChanged,
    required this.onDensityChanged,
    required this.onThicknessChanged,
    required this.onScalpTypeChanged,
    required this.onLengthChanged,
  });

  final Porosity? porosity;
  final Density? density;
  final Thickness? thickness;
  final ScalpType? scalpType;
  final double? hairLength;
  final ValueChanged<Porosity?> onPorosityChanged;
  final ValueChanged<Density?> onDensityChanged;
  final ValueChanged<Thickness?> onThicknessChanged;
  final ValueChanged<ScalpType?> onScalpTypeChanged;
  final ValueChanged<double?> onLengthChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.profileCharacteristicsTitle,
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.profileCharacteristicsSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          DropdownButtonFormField<Porosity>(
            initialValue: porosity,
            decoration: InputDecoration(
              labelText: l10n.profilePorosityLabel,
              border: const OutlineInputBorder(),
              prefixIcon: Tooltip(
                triggerMode: TooltipTriggerMode.tap,
                showDuration: const Duration(seconds: 4),
                message: Porosity.values
                    .map(
                      (p) =>
                          '${p.readableLabel(l10n)}: '
                          '${p.symptomLabel(l10n)}',
                    )
                    .join('\n'),
                child: const Icon(Icons.info_outline, size: 20),
              ),
            ),
            items: Porosity.values
                .map(
                  (p) => DropdownMenuItem(
                    value: p,
                    child: Text(p.readableLabel(l10n)),
                  ),
                )
                .toList(),
            onChanged: onPorosityChanged,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<Density>(
            initialValue: density,
            decoration: InputDecoration(
              labelText: l10n.profileDensityLabel,
              border: const OutlineInputBorder(),
              prefixIcon: Tooltip(
                triggerMode: TooltipTriggerMode.tap,
                showDuration: const Duration(seconds: 4),
                message: Density.values
                    .map(
                      (d) =>
                          '${d.readableLabel(l10n)}: '
                          '${d.symptomLabel(l10n)}',
                    )
                    .join('\n'),
                child: const Icon(Icons.info_outline, size: 20),
              ),
            ),
            items: Density.values
                .map(
                  (d) => DropdownMenuItem(
                    value: d,
                    child: Text(d.readableLabel(l10n)),
                  ),
                )
                .toList(),
            onChanged: onDensityChanged,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<Thickness>(
            initialValue: thickness,
            decoration: InputDecoration(
              labelText: l10n.profileThicknessLabel,
              border: const OutlineInputBorder(),
              prefixIcon: Tooltip(
                triggerMode: TooltipTriggerMode.tap,
                showDuration: const Duration(seconds: 4),
                message: Thickness.values
                    .map(
                      (t) =>
                          '${t.readableLabel(l10n)}: '
                          '${t.symptomLabel(l10n)}',
                    )
                    .join('\n'),
                child: const Icon(Icons.info_outline, size: 20),
              ),
            ),
            items: Thickness.values
                .map(
                  (t) => DropdownMenuItem(
                    value: t,
                    child: Text(t.readableLabel(l10n)),
                  ),
                )
                .toList(),
            onChanged: onThicknessChanged,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<ScalpType>(
            initialValue: scalpType,
            decoration: InputDecoration(
              labelText: l10n.profileScalpLabel,
              border: const OutlineInputBorder(),
              prefixIcon: Tooltip(
                triggerMode: TooltipTriggerMode.tap,
                showDuration: const Duration(seconds: 4),
                message: ScalpType.values
                    .map(
                      (s) =>
                          '${s.readableLabel(l10n)}: '
                          '${s.symptomLabel(l10n)}',
                    )
                    .join('\n'),
                child: const Icon(Icons.info_outline, size: 20),
              ),
            ),
            items: ScalpType.values
                .map(
                  (s) => DropdownMenuItem(
                    value: s,
                    child: Text(s.readableLabel(l10n)),
                  ),
                )
                .toList(),
            onChanged: onScalpTypeChanged,
          ),
          const SizedBox(height: 16),
          Text(
            '${l10n.profileLengthLabel}: '
            '${hairLength?.toStringAsFixed(0) ?? 'Not set'} cm',
            style: theme.textTheme.bodyMedium,
          ),
          Slider(
            value: hairLength ?? 20,
            max: 100,
            divisions: 100,
            label: '${(hairLength ?? 20).toStringAsFixed(0)} cm',
            onChanged: onLengthChanged,
          ),
        ],
      ),
    );
  }
}

class _ConcernsStep extends StatelessWidget {
  const _ConcernsStep({
    required this.selectedConcerns,
    required this.onConcernToggled,
  });

  final Set<String> selectedConcerns;
  final ValueChanged<String> onConcernToggled;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.profileConcernsTitle,
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.profileConcernsSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: hairConcerns.map((concern) {
              final isSelected = selectedConcerns.contains(concern);
              return FilterChip(
                label: Text(concern),
                selected: isSelected,
                onSelected: (_) => onConcernToggled(concern),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _GoalsStep extends StatelessWidget {
  const _GoalsStep({
    required this.selectedGoals,
    required this.onGoalToggled,
  });

  final Set<String> selectedGoals;
  final ValueChanged<String> onGoalToggled;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.profileGoalsTitle,
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.profileGoalsSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: hairGoals.map((goal) {
              final isSelected = selectedGoals.contains(goal);
              return FilterChip(
                label: Text(goal),
                selected: isSelected,
                onSelected: (_) => onGoalToggled(goal),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

extension on String {
  String? get nullIfEmpty => isEmpty ? null : this;
}
