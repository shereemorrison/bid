import 'package:bid/core/providers/infrastructure_providers.dart';
import 'package:bid/models/user_model.dart';
import 'package:bid/state/auth/auth_notifier.dart';
import 'package:bid/state/auth/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'session_providers.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    userRepository: ref.watch(userRepositoryProvider),
    ref: ref,
  );
});

final isLoggedInProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isLoggedIn;
});

final userDataProvider = Provider<UserData?>((ref) {
  return ref.watch(authProvider).userData;
});

final authLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isLoading;
});

final currentUserIdProvider = Provider<String?>((ref) {
  final authState = ref.watch(authProvider);
  if (authState.isLoggedIn) {
    return authState.userData?.userId ?? authState.userId;
  }
  return ref.watch(sessionProvider).guestUserId;
});
