import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class FiltreClassifier {
  late Interpreter _interpreter;
  late Map<String, int> _classIndices;
  bool _isLoaded = false;

  Future<void> charger() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/filtre_model.tflite');
      String json = await rootBundle.loadString('assets/filtre_indices.json');
      _classIndices = Map<String, int>.from(jsonDecode(json));
      _isLoaded = true;
      print('Filtre chargé — classes : $_classIndices');
    } catch (e) {
      print('Erreur chargement filtre : $e');
      _isLoaded = false;
    }
  }

  // Retourne true si c'est une plante, false sinon
  Future<bool> estUnePlante(File imageFile) async {
    if (!_isLoaded) await charger();

    try {
      Uint8List imageBytes = await imageFile.readAsBytes();
      img.Image? image = img.decodeImage(imageBytes);
      if (image == null) return false;

      img.Image resized = img.copyResize(image, width: 224, height: 224);

      var input = List.generate(
        1,
        (_) => List.generate(
          224,
          (y) => List.generate(224, (x) {
            img.Pixel pixel = resized.getPixel(x, y);
            return [pixel.r / 255.0, pixel.g / 255.0, pixel.b / 255.0];
          }),
        ),
      );

      // Sortie sigmoid : 1 valeur entre 0 et 1
      var output = List.filled(1, 0.0).reshape([1, 1]);
      _interpreter.run(input, output);

      double score = output[0][0];
      print('Filtre score : $score');

      // Identifier quelle classe est "plante"
      int planteIndex = _classIndices['plante'] ?? 1;

      // Si planteIndex=1 : score > 0.5 = plante
      // Si planteIndex=0 : score < 0.5 = plante
      bool estPlante = planteIndex == 1 ? score > 0.5 : score < 0.5;
      print('Est une plante : $estPlante');

      return estPlante;
    } catch (e) {
      print('Erreur filtre : $e');
      return true; // en cas d'erreur on laisse passer
    }
  }

  void dispose() {
    if (_isLoaded) _interpreter.close();
  }
}
