import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hair_care/core/database/database.dart';
import 'package:smart_hair_care/core/models/models.dart';
import 'package:smart_hair_care/features/hair_profile/notifiers/notifiers.dart';
import 'package:smart_hair_care/features/hair_profile/view/hair_profile_setup_page.dart';
import 'package:smart_hair_care/features/shared/widgets/widgets.dart';
import 'package:smart_hair_care/l10n/l10n.dart';

/// Page displaying the user's hair profile
class HairProfilePage extends ConsumerWidget {
  const HairProfilePage({super.key});

  /// Returns a [MaterialPageRoute] for Navigator 1.0 navigation
  static Route<void> getRoute() {
    return MaterialPageRoute<void>(
      builder: (_) => const HairProfilePage(),
      settings: const RouteSettings(name: '/profile'),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(hairProfileProvider);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.hairProfileTitle),
        actions: [
          if (profileAsync.value != null)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => Navigator.push(
                context,
                HairProfileSetupPage.getRoute(isEditing: true),
              ),
            ),
        ],
      ),
      body: profileAsync.when(
        data: (profile) => profile != null
            ? _ProfileView(profile: profile)
            : _EmptyProfileView(),
        loading: () => const LoadingView(),
        error: (error, _) => ErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(hairProfileProvider),
        ),
      ),
    );
  }
}

class _EmptyProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_outline,
              size: 80,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: 24),
            Text(
              l10n.profileEmptyTitle,
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.profileEmptyMessage,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () => Navigator.push(
                context,
                HairProfileSetupPage.getRoute(),
              ),
              icon: const Icon(Icons.add),
              label: Text(l10n.profileSetupButton),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView({required this.profile});

  final HairProfile profile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    final bucket = HairPatternBucket.fromValue(profile.primaryType);
    final patterns = profile.specificPatterns;
    final porosity = Porosity.fromValue(profile.porosity);
    final density = Density.fromValue(profile.density);
    final thickness = Thickness.fromValue(profile.thickness);
    final scalpType = ScalpType.fromValue(profile.scalpType);
    final concerns =
        profile.concerns
            ?.split(',')
            .where((String s) => s.isNotEmpty)
            .toList() ??
        <String>[];
    final goals =
        profile.goals?.split(',').where((String s) => s.isNotEmpty).toList() ??
        <String>[];

    // Build hair type display string
    final hairTypeDisplay = _buildHairTypeDisplay(bucket, patterns);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile header
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: theme.colorScheme.primaryContainer,
                    child: Text(
                      (profile.name?.isNotEmpty ?? false)
                          ? profile.name![0].toUpperCase()
                          : '?',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.name ?? l10n.profileNoName,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (hairTypeDisplay != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            hairTypeDisplay,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Hair characteristics
          Text(
            l10n.profileCharacteristicsTitle,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (porosity != null)
                    _ProfileRow(
                      icon: Icons.water_drop_outlined,
                      label: l10n.profilePorosityLabel,
                      value: porosity.label,
                    ),
                  if (density != null)
                    _ProfileRow(
                      icon: Icons.density_medium,
                      label: l10n.profileDensityLabel,
                      value: density.label,
                    ),
                  if (thickness != null)
                    _ProfileRow(
                      icon: Icons.line_weight,
                      label: l10n.profileThicknessLabel,
                      value: thickness.label,
                    ),
                  if (scalpType != null)
                    _ProfileRow(
                      icon: Icons.spa_outlined,
                      label: l10n.profileScalpLabel,
                      value: scalpType.label,
                    ),
                  if (profile.hairLength != null)
                    _ProfileRow(
                      icon: Icons.straighten,
                      label: l10n.profileLengthLabel,
                      value: '${profile.hairLength!.toStringAsFixed(1)} cm',
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Treatment status
          if (profile.isColorTreated || profile.isHeatDamaged) ...[
            Text(
              l10n.profileTreatmentTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (profile.isColorTreated)
                  Chip(
                    avatar: const Icon(Icons.color_lens, size: 18),
                    label: Text(l10n.profileColorTreated),
                  ),
                if (profile.isHeatDamaged)
                  Chip(
                    avatar: const Icon(Icons.whatshot, size: 18),
                    label: Text(l10n.profileHeatDamaged),
                  ),
              ],
            ),
            const SizedBox(height: 16),
          ],

          // Concerns
          if (concerns.isNotEmpty) ...[
            Text(
              l10n.profileConcernsTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: concerns
                  .map(
                    (String concern) => Chip(
                      label: Text(concern),
                      backgroundColor: theme.colorScheme.errorContainer,
                      labelStyle: TextStyle(
                        color: theme.colorScheme.onErrorContainer,
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16),
          ],

          // Goals
          if (goals.isNotEmpty) ...[
            Text(
              l10n.profileGoalsTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: goals
                  .map(
                    (String goal) => Chip(
                      label: Text(goal),
                      backgroundColor: theme.colorScheme.primaryContainer,
                      labelStyle: TextStyle(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  /// Builds a display string from bucket and patterns
  String? _buildHairTypeDisplay(
    HairPatternBucket? bucket,
    List<String> patterns,
  ) {
    if (bucket == null) return null;

    if (patterns.isEmpty) {
      return bucket.label;
    }

    if (patterns.length == 1) {
      return '${bucket.label} (${patterns.first})';
    }

    return '${bucket.label} (${patterns.join(' / ')})';
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label, style: theme.textTheme.bodyMedium),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
