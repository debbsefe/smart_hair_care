import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hair_care/core/models/models.dart';
import 'package:smart_hair_care/features/hair_profile/notifiers/notifiers.dart';
import 'package:smart_hair_care/l10n/l10n.dart';

/// Page for setting up or editing the hair profile
class HairProfileSetupPage extends ConsumerStatefulWidget {
  const HairProfileSetupPage({
    this.isEditing = false,
    super.key,
  });

  final bool isEditing;

  /// Returns a [MaterialPageRoute] for Navigator 1.0 navigation
  static Route<void> getRoute({bool isEditing = false}) {
    return MaterialPageRoute<void>(
      builder: (_) => HairProfileSetupPage(isEditing: isEditing),
      settings: RouteSettings(
        name: isEditing ? '/profile/edit' : '/profile/setup',
      ),
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

  // Form values
  late TextEditingController _nameController;
  HairType? _selectedHairType;
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

    // Pre-fill if editing
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profile = ref.read(hairProfileProvider).value;
      if (profile != null && widget.isEditing) {
        _nameController.text = profile.name ?? '';
        _selectedHairType = HairType.fromValue(profile.hairType);
        _selectedPorosity = Porosity.fromValue(profile.porosity);
        _selectedDensity = Density.fromValue(profile.density);
        _selectedThickness = Thickness.fromValue(profile.thickness);
        _selectedScalpType = ScalpType.fromValue(profile.scalpType);
        _hairLength = profile.hairLength;
        _selectedConcerns.addAll(
          profile.concerns?.split(',').where((s) => s.isNotEmpty) ?? [],
        );
        _selectedGoals.addAll(
          profile.goals?.split(',').where((s) => s.isNotEmpty) ?? [],
        );
        _isColorTreated = profile.isColorTreated;
        _isHeatDamaged = profile.isHeatDamaged;
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _nextStep() async {
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
            hairType: _selectedHairType?.value,
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
        title: Text(
          widget.isEditing ? l10n.editProfileTitle : l10n.profileSetupTitle,
        ),
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
                _HairTypeStep(
                  selectedType: _selectedHairType,
                  onTypeSelected: (type) =>
                      setState(() => _selectedHairType = type),
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

class _HairTypeStep extends StatelessWidget {
  const _HairTypeStep({
    required this.selectedType,
    required this.onTypeSelected,
  });

  final HairType? selectedType;
  final ValueChanged<HairType> onTypeSelected;

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
          ...HairType.values.map((type) {
            final isSelected = selectedType == type;
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              color: isSelected ? theme.colorScheme.primaryContainer : null,
              child: ListTile(
                title: Text(type.label),
                trailing: isSelected
                    ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
                    : null,
                onTap: () => onTypeSelected(type),
              ),
            );
          }),
        ],
      ),
    );
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
            ),
            items: Porosity.values
                .map((p) => DropdownMenuItem(value: p, child: Text(p.label)))
                .toList(),
            onChanged: onPorosityChanged,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<Density>(
            initialValue: density,
            decoration: InputDecoration(
              labelText: l10n.profileDensityLabel,
              border: const OutlineInputBorder(),
            ),
            items: Density.values
                .map((d) => DropdownMenuItem(value: d, child: Text(d.label)))
                .toList(),
            onChanged: onDensityChanged,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<Thickness>(
            initialValue: thickness,
            decoration: InputDecoration(
              labelText: l10n.profileThicknessLabel,
              border: const OutlineInputBorder(),
            ),
            items: Thickness.values
                .map((t) => DropdownMenuItem(value: t, child: Text(t.label)))
                .toList(),
            onChanged: onThicknessChanged,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<ScalpType>(
            initialValue: scalpType,
            decoration: InputDecoration(
              labelText: l10n.profileScalpLabel,
              border: const OutlineInputBorder(),
            ),
            items: ScalpType.values
                .map((s) => DropdownMenuItem(value: s, child: Text(s.label)))
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
