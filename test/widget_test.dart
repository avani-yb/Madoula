import 'package:flutter_test/flutter_test.dart';
import 'package:madoula_project/main.dart';

void main() {
  testWidgets('MadoulaApp se lance et affiche l\'écran Accueil', (
    WidgetTester tester,
  ) async {
    // Lancer l'application
    await tester.pumpWidget(const MadoulaApp());

    // Vérifier que le titre "Madoula" est affiché sur l'écran d'accueil
    expect(find.text('Madoula'), findsOneWidget);

    // Vérifier que les boutons principaux sont présents
    expect(find.text('Prendre une photo'), findsOneWidget);
    expect(find.text('Choisir depuis la galerie'), findsOneWidget);

    // Vérifier que les boutons de langue sont présents
    expect(find.text('Français'), findsOneWidget);
    expect(find.text('Ewondo'), findsOneWidget);
    expect(find.text('Fulfulde'), findsOneWidget);
  });
}
