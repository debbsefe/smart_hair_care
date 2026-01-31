import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hair_care/core/database/database.dart';
import 'package:smart_hair_care/core/models/hair_enums.dart';

/// State for hair pattern selection
///
/// Note: This notifier is used within the setup wizard flow.
/// For standalone editing of an existing profile, use `HairProfileNotifier`.
class HairPatternSelectionState {
  const HairPatternSelectionState({
    this.selectedBucket,
    this.selectedPatterns = const {},
  });

  final HairPatternBucket? selectedBucket;
  final Set<String> selectedPatterns;

  /// Whether a bucket has been selected
  bool get hasBucket => selectedBucket != null;

  /// Whether multiple patterns are selected (multi-textured)
  bool get isMultiTextured => selectedPatterns.length > 1;

  HairPatternSelectionState copyWith({
    HairPatternBucket? selectedBucket,
    bool clearBucket = false,
    Set<String>? selectedPatterns,
  }) {
    return HairPatternSelectionState(
      selectedBucket: clearBucket
          ? null
          : (selectedBucket ?? this.selectedBucket),
      selectedPatterns: selectedPatterns ?? this.selectedPatterns,
    );
  }
}

/// Notifier for managing hair pattern selection state
class HairPatternSelectionNotifier extends Notifier<HairPatternSelectionState> {
  static const int maxPatterns = 2;

  @override
  HairPatternSelectionState build() {
    return const HairPatternSelectionState();
  }

  /// Select a bucket (Straight, Wavy, Curly, Coily)
  /// Clears specific pattern selections when switching buckets
  void selectBucket(HairPatternBucket bucket) {
    if (state.selectedBucket != bucket) {
      state = HairPatternSelectionState(
        selectedBucket: bucket,
        selectedPatterns: {},
      );
    }
  }

  /// Toggle a specific pattern (e.g., "3A", "4C")
  /// Max 2 patterns can be selected
  void togglePattern(String pattern) {
    final patterns = Set<String>.from(state.selectedPatterns);

    if (patterns.contains(pattern)) {
      patterns.remove(pattern);
    } else {
      if (patterns.length < maxPatterns) {
        patterns.add(pattern);
      }
    }

    state = state.copyWith(selectedPatterns: patterns);
  }

  /// Save the selection to the database
  Future<void> saveSelection(int profileId) async {
    final dao = ref.read(hairProfilesDaoProvider);

    await dao.updateCurlPatterns(
      profileId: profileId,
      primaryType: state.selectedBucket?.value,
      specificPatterns: state.selectedPatterns.toList(),
    );
  }

  /// Load existing selection from profile
  void loadFromProfile(HairProfile? profile) {
    if (profile == null) {
      state = const HairPatternSelectionState();
      return;
    }

    final bucket = HairPatternBucket.fromValue(profile.primaryType);
    final patterns = Set<String>.from(profile.specificPatterns);

    state = HairPatternSelectionState(
      selectedBucket: bucket,
      selectedPatterns: patterns,
    );
  }

  /// Clear all selections
  void clear() {
    state = const HairPatternSelectionState();
  }
}

/// Provider for hair pattern selection notifier
final hairPatternSelectionProvider =
    NotifierProvider<HairPatternSelectionNotifier, HairPatternSelectionState>(
      HairPatternSelectionNotifier.new,
    );
