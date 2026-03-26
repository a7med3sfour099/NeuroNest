import 'package:flutter/material.dart';

class TestMe extends StatelessWidget {
  const TestMe({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    // if (args != null) {
    // final intValue = int.parse(args);
    // intValue.toInt();
    // }

    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            print(args);
          },
          child: Text('Result'),
        ),
      ),
    );
  }
}
