import 'package:flutter/material.dart';
import 'package:tahoea_liquid_glass/tahoea_liquid_glass.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
              fit: BoxFit.cover,
            ),
            const Center(
              child: TahoeaLiquidGlass(
                width: 300,
                height: 160,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Tahoea Liquid Glass',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600)),
                    SizedBox(height: 8),
                    Text('Frosted + Liquid Wave Effect',
                        style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
