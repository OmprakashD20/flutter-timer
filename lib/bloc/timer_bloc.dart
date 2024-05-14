import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timer_app/ticker.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  static const int _duration = 60;
  final Ticker _ticker;

  //stream subscription to listen to the ticks from the ticker
  StreamSubscription<int>? _tickerSubscription;

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  TimerBloc({
    required Ticker ticker,
  })  : _ticker = ticker,
        super(
          const TimerInitial(duration: _duration),
        ) {
    on<TimerStarted>(_onTimerStarted);
    on<TimerTicked>(_onTimerTicked);
    on<TimerPaused>(_onTimerPaused);
    on<TimerResumed>(_onTimerResumed);
    on<TimerReset>(_onTimerReset);
  }

  void _onTimerStarted(TimerStarted event, Emitter<TimerState> emit) {
    emit(TimerRunInProgress(duration: event.duration));
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker
        .tick(ticks: event.duration)
        .listen((duration) => add(TimerTicked(duration: duration)));
  }

  void _onTimerTicked(TimerTicked event, Emitter<TimerState> emit) {
    emit(
      event.duration > 0
          ? TimerRunInProgress(duration: event.duration)
          : const TimerRunComplete(),
    );
  }

  void _onTimerPaused(TimerPaused event, Emitter<TimerState> emit) {
    if (state is TimerRunInProgress) {
      _tickerSubscription?.pause();
      emit(TimerRunPause(duration: state.duration));
    }
  }

  void _onTimerResumed(TimerResumed event, Emitter<TimerState> emit) {
    if (state is TimerRunPause) {
      _tickerSubscription?.resume();
      emit(TimerRunInProgress(duration: state.duration));
    }
  }

  void _onTimerReset(TimerReset event, Emitter<TimerState> emit) {
    _tickerSubscription?.cancel();
    emit(const TimerInitial(duration: _duration));
  }
}
