import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';

import 'input_field.dart';

/// Input field for changing durations.
class DurationInputField extends StatelessWidget {
  /// The initial duration to show.
  final Duration initialDuration;

  /// Function to call when the duration is changed.
  final void Function(Duration)? onDurationChange;

  const DurationInputField({required this.initialDuration, this.onDurationChange});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: InputField(
            key: UniqueKey(),
            label: 'Time to Build',
            readonly: true,
            initialText: '${initialDuration.inDays} days',
          ),
        ),
        TextButton(
          child: Text('CHANGE TIME TO BUILD'),
          onPressed: () async {
            // This code was inspired from StackOverflow: https://stackoverflow.com/a/58145696/4891134
            Picker(
              adapter: NumberPickerAdapter(data: <NumberPickerColumn>[
                NumberPickerColumn(begin: 0, end: 999, suffix: Text(' days'), initValue: initialDuration.inDays),
              ]),
              hideHeader: true,
              cancelText: 'CANCEL',
              confirmText: 'OK',
              title: const Text('Time to Build'),
              selectedTextStyle: TextStyle(color: Colors.blue),
              onConfirm: (Picker picker, List<int> value) {
                var duration = Duration(days: picker.getSelectedValues()[0]);
                onDurationChange?.call(duration);
              },
            ).showDialog(context);
          },
        ),
      ],
    );
  }
}
