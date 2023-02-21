
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:once/repo/firebase_auth_repo.dart';

final selectedCountryProvider = Provider.autoDispose<CountryWithPhoneCode?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.maybeWhen(
    ready: (selectedCountry) => selectedCountry,
    orElse: () => null,
  );
});