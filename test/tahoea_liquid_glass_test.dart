import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:tahoea_liquid_glass/tahoea_liquid_glass.dart';

void main() {
  testWidgets('TahoeaLiquidGlass renders', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: TahoeaLiquidGlass(width: 100, height: 100),
    ));
    expect(find.byType(TahoeaLiquidGlass), findsOneWidget);
  });
}
