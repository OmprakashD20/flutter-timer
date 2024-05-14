import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:timer_app/bloc/timer_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const TimerText(),
            const SizedBox(height: 16),
            BlocConsumer<TimerBloc, TimerState>(
              buildWhen: (previous, current) =>
                  previous.runtimeType != current.runtimeType,
              listenWhen: (previous, current) =>
                  previous.runtimeType != current.runtimeType,
              listener: (context, state) {
                if (state is TimerRunComplete) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Timer is complete!'),
                    ),
                  );
                }
                if (state is TimerRunPause) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Timer is paused!'),
                    ),
                  );
                }
                if (state is TimerRunInProgress || state is TimerInitial) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                }
              },
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ...switch (state) {
                      TimerInitial() => [
                          ElevatedButton(
                            onPressed: () => context
                                .read<TimerBloc>()
                                .add(TimerStarted(duration: state.duration)),
                            child: const Text('Start'),
                          ),
                        ],
                      TimerRunInProgress() => [
                          ElevatedButton(
                            onPressed: () => context
                                .read<TimerBloc>()
                                .add(const TimerPaused()),
                            child: const Text('Pause'),
                          ),
                          ElevatedButton(
                            onPressed: () => context
                                .read<TimerBloc>()
                                .add(const TimerReset()),
                            child: const Text('Reset'),
                          ),
                        ],
                      TimerRunPause() => [
                          ElevatedButton(
                            onPressed: () => context
                                .read<TimerBloc>()
                                .add(const TimerResumed()),
                            child: const Text('Resume'),
                          ),
                          ElevatedButton(
                            onPressed: () => context
                                .read<TimerBloc>()
                                .add(const TimerReset()),
                            child: const Text('Reset'),
                          ),
                        ],
                      TimerRunComplete() => [
                          ElevatedButton(
                            onPressed: () => context
                                .read<TimerBloc>()
                                .add(const TimerReset()),
                            child: const Text('Reset'),
                          ),
                        ]
                    }
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TimerText extends StatelessWidget {
  const TimerText({super.key});

  @override
  Widget build(BuildContext context) {
    final duration = context.select((TimerBloc bloc) => bloc.state.duration);

    final minutesStr =
        ((duration / 60) % 60).floor().toString().padLeft(2, '0');
    final secondsStr = (duration % 60).floor().toString().padLeft(2, '0');

    return Text(
      '$minutesStr:$secondsStr',
      style: const TextStyle(
        fontSize: 55,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
