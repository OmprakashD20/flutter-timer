part of 'timer_bloc.dart';

sealed class TimerState extends Equatable {
  final int duration;

  const TimerState({
    required this.duration,
  });

  @override
  List<Object> get props => [duration];
}

final class TimerInitial extends TimerState {
  const TimerInitial({
    required super.duration,
  });
}

final class TimerRunInProgress extends TimerState {
  const TimerRunInProgress({required super.duration});
}

final class TimerRunPause extends TimerState {
  const TimerRunPause({required super.duration});
}

final class TimerRunComplete extends TimerState {
  const TimerRunComplete() : super(duration: 0);
}
