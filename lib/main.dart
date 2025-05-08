import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iMetric Converter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
      ),
      home: const MyHomePage(title: 'iMetric Converter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //int _counter = 0;
  double value = 0;
  final Map<String, List<String>> conversionOptions = {
    'Kg': ['Lbs', 'Gms'],
    'Lbs': ['Kg', 'Gms'],
    'Gms': ['Kg', 'Lbs'],
    'Miles': ['Km', 'Meters', 'Feet'],
    'Km': ['Miles', 'Meters', 'Feet'],
    'Meters': ['Miles', 'Km', 'Feet'],
    'Feet': ['Miles', 'Km', 'Meters'],
  };

  final Map<String, Map<String, double>> conversionRates = {
    'Kg': {'Lbs': 2.20462, 'Gms': 1000.0},
    'Lbs': {'Kg': 0.453592, 'Gms': 453.592},
    'Gms': {'Kg': 0.001, 'Lbs': 0.00220462},
    'Meters': {'Km': 0.001, 'Feet': 3.28084, 'Miles': 0.000621371},
    'Km': {'Meters': 1000.0, 'Feet': 3280.84, 'Miles': 0.621371},
    'Feet': {'Meters': 0.3048, 'Km': 0.0003048, 'Miles': 0.000189394},
    'Miles': {'Meters': 1609.34, 'Km': 1.60934, 'Feet': 5280.0},
  };

  String selectedFrom = 'Kg';
  String selectedTo = 'Lbs';
  String resultText = '';
  dynamic result = '';

  void convertMetric() {
    setState(() {
      var temp = (value * conversionRates[selectedFrom]![selectedTo]!).toStringAsFixed(3);
      resultText = 'Super!! quick conversion from $selectedFrom to $selectedTo';
      result = '$temp $selectedTo';
    });
  }

  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // Padding(padding: EdgeInsets.all(16.0),child: Text('Fast Conversion!', style: Theme.of(context).textTheme.displayMedium),),
            Row(
              children: [
                PaddedExpanded(
                  child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Enter Value',
                      border: OutlineInputBorder(),
                    ),

                    onChanged:
                        (val) => setState(() {
                          value = double.tryParse(val) ?? 0;
                        }),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                PaddedExpanded(
                  child: DropdownButton<String>(
                    value: selectedFrom,
                    items:
                        conversionOptions.keys.map((unit) {
                          return DropdownMenuItem(
                            value: unit,
                            child: Text(unit),
                          );
                        }).toList(),
                    onChanged:
                        (value) => setState(() {
                          selectedFrom = value!;
                          selectedTo = conversionOptions[selectedFrom]!.first;
                        }),
                  ),
                ),
                PaddedExpanded(child: //add an icon
    Icon(Icons.arrow_forward, color: Theme.of(context).colorScheme.primary)),
                PaddedExpanded(
                  child: DropdownButton<String>(
                    value: selectedTo,
                    items:
                        conversionOptions[selectedFrom]!.map((unit) {
                          return DropdownMenuItem(
                            value: unit,
                            child: Text(unit),
                          );
                        }).toList(),
                    onChanged:
                        (value) => setState(() {
                          selectedTo = value!;
                        }),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PaddedExpanded(
                  child: ElevatedButton(
                    onPressed: convertMetric,
                    child: const Text('Convert ⚡️'),
                  ),
                ),

                PaddedExpanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedFrom = 'Kg';
                        selectedTo = 'Lbs';
                        result = '';
                        resultText = '';
                        _controller.clear();
                      });
                    },
                    child: const Text('Reset 🗑️️'),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    '$resultText',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    '$result',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaddedExpanded extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const PaddedExpanded({
    Key? key,
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Padding(padding: padding, child: child));
  }
}
