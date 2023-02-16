import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../helper/shared_prefs.dart';

final onboardingProvider = StateProvider<bool>((ref) {
  final prefs = ref.read(sharedPrefsProvider);
  return prefs.getFinishedOnboarding() ?? false;
});