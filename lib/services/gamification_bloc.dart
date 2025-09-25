import 'package:flutter_bloc/flutter_bloc.dart';

/// A simple BLoC that tracks a score for gamification purposes.
///
/// Each time the user interacts with an instrument key, the score is
/// incremented.  Future phases could extend this with achievements,
/// persistence or reward logic.
class GamificationBloc extends Cubit<int> {
  GamificationBloc() : super(0);

  /// Add [delta] points to the current score.  Defaults to 1.
  void addPoints([int delta = 1]) => emit(state + delta);
}