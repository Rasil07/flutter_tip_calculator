import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

enum TipType { percent, fixed }

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'Flutter layout demo',
      theme: CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: CupertinoColors.systemBlue,
      ),
      home: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: CupertinoColors.systemGrey,
          middle: Text('Tip Calculator'),
        ),
        child: Center(child: TipCalculator()),
      ),
    );
  }
}

class TipCalculator extends StatefulWidget {
  const TipCalculator({super.key});

  @override
  State<TipCalculator> createState() => _TipCalculatorState();
}

class _TipCalculatorState extends State<TipCalculator> {
  double _billAmount = 0.0;
  TipType _selectedTipType = TipType.fixed;
  double _tipValue = 0.0;

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Bill Amount'),
                const SizedBox(height: 8.0),
                CupertinoTextField(
                  placeholder: 'Enter number',
                  onChanged: (value) {
                    setState(() {
                      _billAmount = double.tryParse(value) ?? 0.0;
                    });
                  },
                  keyboardType: const TextInputType.numberWithOptions(
                    signed: false,
                    decimal: true,
                  ),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,2}'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 40),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Tip Type'),
                const SizedBox(height: 8.0),

                SizedBox(
                  width: double.infinity,
                  child: CupertinoSegmentedControl<TipType>(
                    children: const {
                      TipType.percent: _SegmentLabel('Percent'),
                      TipType.fixed: _SegmentLabel('Fixed'),
                    },

                    groupValue: _selectedTipType,
                    onValueChanged: (TipType value) {
                      setState(() {
                        _selectedTipType = value;
                      });
                    },
                  ),
                ),
              ],
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20.0),
                CupertinoTextField(
                  suffix: _selectedTipType == TipType.percent
                      ? Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: const Text(
                            '%',
                            style: TextStyle(fontSize: 14),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: const Text(
                            '\$',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                  placeholder: _selectedTipType == TipType.percent
                      ? 'Enter percentage'
                      : 'Enter amount',
                  onChanged: (value) {
                    setState(() {
                      _tipValue = double.tryParse(value) ?? 0.0;
                    });
                  },
                  keyboardType: const TextInputType.numberWithOptions(
                    signed: false,
                    decimal: true,
                  ),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,2}'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 40),

            Text(
              'Total Tip: \$${_selectedTipType == TipType.percent ? (_billAmount * _tipValue / 100).toStringAsFixed(2) : _tipValue.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SegmentLabel extends StatelessWidget {
  final String text;
  const _SegmentLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      // more vertical + horizontal breathing room
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.w500, // slightly heavier than default
        ),
      ),
    );
  }
}
