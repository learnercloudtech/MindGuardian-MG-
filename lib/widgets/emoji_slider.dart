import 'package:flutter/material.dart';

class EmojiSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const EmojiSlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final emojiLabels = {
      1: '😢',
      2: '😞',
      3: '😟',
      4: '😐',
      5: '🙂',
      6: '😊',
      7: '😁',
      8: '😄',
      9: '😃',
      10: '🤩',
    };

    return Column(
      children: [
        Text(
          emojiLabels[value.toInt()] ?? '🙂',
          style: const TextStyle(fontSize: 48),
        ),
        Slider(
          value: value,
          min: 1,
          max: 10,
          divisions: 9,
          label: emojiLabels[value.toInt()],
          onChanged: onChanged,
        ),
      ],
    );
  }
}
