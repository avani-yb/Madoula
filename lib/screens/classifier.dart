import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class Classifier {
  late Interpreter _interpreter;
  late Map<String, int> _classIndices;
  late Map<int, String> _indexToClass;
  bool _isLoaded = false;

  // ── Charger le modèle et le mapping ──────────────────────────────
  Future<void> charger() async {
    try {
      // Charger le modèle TFLite
      _interpreter = await Interpreter.fromAsset('assets/madoula_model.tflite');

      // Charger class_indices.json
      String jsonString = await rootBundle.loadString('assets/class_indices.json');
      _classIndices = Map<String, int>.from(jsonDecode(jsonString));

      // Inverser : index → nom de classe
      _indexToClass = _classIndices.map((k, v) => MapEntry(v, k));

      _isLoaded = true;
      print('Modèle Madoula chargé — ${_classIndices.length} classes');
    } catch (e) {
      print('Erreur chargement modèle : $e');
      _isLoaded = false;
    }
  }

  // ── Analyser une image et retourner la classe prédite ─────────────
  Future<String?> predire(File imageFile) async {
    if (!_isLoaded) await charger();

    try {
      // Lire et redimensionner l'image en 224x224
      Uint8List imageBytes = await imageFile.readAsBytes();
      img.Image? image = img.decodeImage(imageBytes);
      if (image == null) return null;

      img.Image resized = img.copyResize(image, width: 224, height: 224);

      // Convertir en tableau Float32 normalisé [0, 1]
      var input = List.generate(
        1,
        (_) => List.generate(
          224,
          (y) => List.generate(
            224,
            (x) {
              img.Pixel pixel = resized.getPixel(x, y);
              return [
                pixel.r / 255.0,
                pixel.g / 255.0,
                pixel.b / 255.0,
              ];
            },
          ),
        ),
      );

      // Préparer la sortie
      var output = List.filled(1 * _classIndices.length, 0.0)
          .reshape([1, _classIndices.length]);

      // Inférence
      _interpreter.run(input, output);

      // Trouver la classe avec la plus haute probabilité
      List<double> scores = List<double>.from(output[0]);
      int bestIndex = scores.indexOf(scores.reduce((a, b) => a > b ? a : b));
      double confidence = scores[bestIndex];

      String classePredi = _indexToClass[bestIndex] ?? 'inconnu';

      print('Prédiction : $classePredi (${(confidence * 100).toStringAsFixed(1)}%)');

      return classePredi;
    } catch (e) {
      print('Erreur prédiction : $e');
      return null;
    }
  }

  void dispose() {
    if (_isLoaded) _interpreter.close();
  }
}