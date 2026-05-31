import 'package:bid/state/session/session_notifier.dart';
import 'package:bid/state/session/session_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final sessionProvider =
    StateNotifierProvider<SessionNotifier, SessionState>((ref) {
  return SessionNotifier();
});
