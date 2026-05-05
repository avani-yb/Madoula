# Analyse Détaillée du Projet Madoula

## Table des Matières

1. [Vue d'Ensemble](#1-vue-densemble)
2. [Structure du Projet](#2-structure-du-projet)
3. [Architecture Globale](#3-architecture-globale)
4. [Analyse Détaillée de Chaque Fichier](#4-analyse-détaillée-de-chaque-fichier)
   - [4.1 main.dart](#41-maindart)
   - [4.2 accueil_screen.dart](#42-accueil_screendart)
   - [4.3 apercu_screen.dart](#43-apercu_screendart)
   - [4.4 classifier.dart](#44-classifierdart)
   - [4.5 filter_classifier.dart](#45-filter_classifierdart)
   - [4.6 resultat_screen.dart](#46-resultat_screendart)
   - [4.7 feedback_service.dart](#47-feedback_servicedart)
5. [Fichiers Assets](#5-fichiers-assets)
   - [5.1 class_indices.json](#51-class_indicesjson)
   - [5.2 filtre_indices.json](#52-filtre_indicesjson)
   - [5.3 maladies_madoula.json](#53-maladies_madoulajson)
   - [5.4 madoula_compat.tflite](#54-madoula_compattflite)
   - [5.5 filtre_model.tflite](#55-filtre_modeltflite)
6. [Flux de l'Application](#6-flux-de-lapplication)
   - [6.1 Navigation entre Écrans](#61-navigation-between-écrans)
   - [6.2 Flux de Données](#62-flux-de-données)
   - [6.3 Pipeline de Classification IA](#63-pipeline-de-classification-ia)
   - [6.4 Diagramme de Séquence](#64-diagramme-de-séquence)
7. [Dépendances Croisées](#7-dépendances-croisées)
8. [Configuration du Projet](#8-configuration-du-projet)
9. [Observations et Problèmes Potentiels](#9-observations-et-problèmes-potentiels)

---

## 1. Vue d'Ensemble

**Madoula** est une application mobile Flutter de détection de maladies agricoles développée par Ndzana Christophe pour IAI Cameroun 2025-2026.

### Objectif
Permettre aux agriculteurs de photographier les feuilles de leurs plantes et d'obtenir un diagnostic instantané des maladies potentielles, avec des symptômes détaillés et des traitements recommandés (solutions locales accessibles).

### Fonctionnalités Clés
- **Capture photo** : Via caméra ou galerie
- **Classification IA** : Modèle TensorFlow Lite embarqué (22 classes de maladies)
- **Filtre plante/non-plante** : Vérification préalable que l'image contient bien une plante
- **Multilingue** : Support de 3 langues (Français, Ewondo, Fulfulde)
- **Synthèse vocale** : Lecture des résultats à voix haute
- **Feedback utilisateur** : Système de like/dislike pour améliorer le modèle
- **Base de données locale** : 22 maladies avec symptômes, traitements, gravité, transmission

### Plantes Couvertes
- Maïs (Corn) - 5 classes (4 maladies + sain)
- Agrumes/Orange - 2 classes (1 maladie + sain)
- Poivron/Piment - 3 classes (2 maladies + sain)
- Pomme de terre - 4 classes (3 maladies + sain)
- Soja - 1 classe (sain)
- Fraise - 1 classe (sain)
- Tomate - 11 classes (10 maladies + sain)

---

## 2. Structure du Projet

```
Madoula/
├── .dart_tool/                              # Outils internes Flutter/Dart
├── .flutter-plugins-dependencies            # Dépendances de plugins Flutter
├── .git/                                    # Repository Git
├── .gitignore                               # Fichiers ignorés par Git
├── .metadata                                # Métadonnées Flutter
├── .vscode/
│   └── easycode.ignore                      # Patterns ignorés par EasyCode
├── analysis_options.yaml                    # Configuration du linter Dart
├── android/                                 # Projet Android natif
├── assets/
│   ├── class_indices.json                   # Mapping classe -> index (modèle principal)
│   ├── filtre_indices.json                  # Mapping classe -> index (filtre plante/non-plante)
│   ├── filtre_model.tflite                  # Modèle TFLite binaire (plante vs non-plante)
│   ├── madoula_compat.tflite                # Modèle TFLite de classification (22 maladies)
│   └── maladies_madoula.json                # Base de données des maladies (22 entrées)
├── build/                                   # Artefacts de build
├── ios/                                     # Projet iOS natif
├── lib/
│   ├── main.dart                            # Point d'entrée de l'application
│   ├── screens/
│   │   ├── accueil_screen.dart              # Écran 1: Accueil + capture photo
│   │   ├── apercu_screen.dart               # Écran 2: Vérification de la photo
│   │   ├── classifier.dart                  # Classeur IA principal (maladies)
│   │   ├── filter_classifier.dart           # Classeur IA filtre (plante/non-plante)
│   │   └── resultat_screen.dart             # Écran 3: Résultat du diagnostic
│   └── services/
│       └── feedback_service.dart            # Service de stockage des feedbacks
├── linux/                                   # Projet Linux natif
├── macos/                                   # Projet macOS natif
├── pubspec.lock                             # Versions exactes des dépendances
├── pubspec.yaml                             # Configuration du projet Flutter
├── README.md                                # Documentation
├── test/
│   └── widget_test.dart                     # Test unitaire (template par défaut)
├── web/                                     # Projet Web natif
└── windows/                                 # Projet Windows natif
```

---

## 3. Architecture Globale

Le projet suit une architecture simple en 3 couches :

### Couche Présentation (UI)
- `main.dart` - Racine de l'app, configuration du thème Material 3
- `accueil_screen.dart` - Écran 1 : Capture photo et sélection de langue
- `apercu_screen.dart` - Écran 2 : Vérification de la qualité de la photo
- `resultat_screen.dart` - Écran 3 : Affichage du résultat + feedback

### Couche Logique Métier (IA)
- `classifier.dart` - Classeur de maladies (22 classes, modèle TFLite)
- `filter_classifier.dart` - Filtre binaire plante/non-plante (modèle TFLite)

### Couche Services
- `feedback_service.dart` - Stockage local des retours utilisateur (SharedPreferences)

### Couche Données (Assets)
- `madoula_compat.tflite` - Modèle TensorFlow Lite de classification des maladies
- `filtre_model.tflite` - Modèle TensorFlow Lite de filtrage binaire
- `class_indices.json` - Mapping des classes du modèle principal (index ↔ nom)
- `filtre_indices.json` - Mapping du filtre binaire (plante/pas_plante)
- `maladies_madoula.json` - Base de données complète des maladies

---

## 4. Analyse Détaillée de Chaque Fichier

### 4.1 main.dart

**Chemin :** `lib/main.dart`  
**Lignes :** 29

#### Rôle
Point d'entrée principal de l'application Flutter. Configure le thème global et lance le premier écran.

#### Structure

```dart
void main() {
  runApp(const MadoulaApp());
}
```

**Fonction `main()`** : Fonction d'exécution qui appelle `runApp()` avec l'instance de `MadoulaApp`. C'est le point de démarrage de l'application.

#### Classe `MadoulaApp`

**Type :** `StatelessWidget` (aucun état interne modifiable)

**Propriétés :**
- `title: 'Madoula'` - Titre de l'application
- `debugShowCheckedModeBanner: false` - Masque le bandeau DEBUG en haut à droite

**Thème Global :**
```dart
theme: ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF2E7D32)),
  fontFamily: 'Roboto',
  useMaterial3: true,
)
```

- **`seedColor: Color(0xFF2E7D32)`** : Vert foncé (#2E7D32) utilisé comme couleur de base pour générer toute la palette de couleurs de l'application via `ColorScheme.fromSeed()`
- **`fontFamily: 'Roboto'`** : Police de caractères par défaut
- **`useMaterial3: true`** : Utilise Material Design 3 (dernière version du design system de Google)

**Écran de Démarrage :**
```dart
home: const AccueilScreen(),
```
Lance directement l'écran d'accueil (`AccueilScreen`) comme premier écran visible.

#### Dépendances
- Importe uniquement : `screens/accueil_screen.dart`

#### Importance dans le Flux
C'est le fichier qui initialise toute l'application. Sans lui, aucun écran ne peut être affiché. Il définit l'apparence visuelle globale via le thème et spécifie quel écran montrer au lancement.

---

### 4.2 accueil_screen.dart

**Chemin :** `lib/screens/accueil_screen.dart`  
**Lignes :** 255

#### Rôle
Écran d'accueil de l'application. Permet à l'utilisateur de :
1. Capturer une photo via la caméra
2. Choisir une photo depuis la galerie
3. Sélectionner une langue (Français, Ewondo, Fulfulde)
4. Naviguer vers l'écran d'aperçu

#### Structure

**Classe Publique :** `AccueilScreen` (StatelessWidget)  
**Classe d'État :** `_AccueilScreenState` (State<AccueilScreen>)

C'est un `StatefulWidget` car l'état change dynamiquement avec la sélection de langue par l'utilisateur.

#### Variables d'État

| Variable | Type | Valeur par défaut | Description |
|----------|------|-------------------|-------------|
| `langueChoisie` | `String` | `'FR'` | Langue sélectionnée par l'utilisateur (FR, EWO, FUL) |
| `_picker` | `ImagePicker` | `ImagePicker()` | Instance de l'outil pour accéder à la caméra et la galerie |

#### Méthodes Clés

##### `prendrePhoto()`
```dart
Future<void> prendrePhoto() async {
  final XFile? photo = await _picker.pickImage(
    source: ImageSource.camera,
    imageQuality: 85,
  );
  if (photo != null) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ApercuScreen(
          imageFile: File(photo.path),
          langue: langueChoisie,
        ),
      ),
    );
  }
}
```

**Fonctionnement :**
1. Ouvre l'application caméra du téléphone via `_picker.pickImage()`
2. `source: ImageSource.camera` spécifie que c'est la caméra (pas la galerie)
3. `imageQuality: 85` compresse l'image à 85% de qualité originale (équilibre qualité/taille)
4. Si une photo est prise (`photo != null`) :
   - Crée un objet `File` à partir du chemin de la photo
   - Navigue vers `ApercuScreen` en passant le fichier et la langue choisie
   - Utilise `Navigator.push()` pour empiler le nouvel écran

##### `choisirDepuisGalerie()`
```dart
Future<void> choisirDepuisGalerie() async {
  final XFile? image = await _picker.pickImage(
    source: ImageSource.gallery,
    imageQuality: 85,
  );
  if (image != null) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ApercuScreen(
          imageFile: File(image.path),
          langue: langueChoisie,
        ),
      ),
    );
  }
}
```

**Fonctionnement :** Identique à `prendrePhoto()` sauf :
- `source: ImageSource.gallery` ouvre la galerie photo au lieu de la caméra

##### `_boutonLangue(String code, String label)`
```dart
Widget _boutonLangue(String code, String label) {
  final estSelectionne = langueChoisie == code;
  return GestureDetector(
    onTap: () => setState(() => langueChoisie = code),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: estSelectionne ? const Color(0xFF2E7D32) : Colors.white,
        border: Border.all(color: const Color(0xFF2E7D32)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: estSelectionne ? Colors.white : const Color(0xFF1B5E20),
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}
```

**Fonctionnement :**
- Widget réutilisable pour créer les boutons de sélection de langue
- `estSelectionne` vérifie si cette langue est la langue choisie
- `GestureDetector` détecte le tap et met à jour `langueChoisie` via `setState()`
- Le bouton sélectionné a un fond vert (#2E7D32) avec texte blanc
- Le bouton non sélectionné a un fond blanc avec bordure verte et texte vert foncé

#### Interface Utilitaire (UI)

**Structure Visuelle :**
```
┌─────────────────────────────────────┐
│  AppBar: "Madoula" 🌿               │  ← Fond vert #2E7D32
├─────────────────────────────────────┤
│                                     │
│         ┌───────────┐               │
│         │   🌿 LOGO │               │  ← Cercle vert 120x120
│         │  120x120  │               │
│         └───────────┘               │
│                                     │
│         MADOULA                     │  ← 32px, gras, vert foncé
│   Détection de maladies agricoles   │  ← Sous-titre
│                                     │
│   ┌───────────────────────────────┐ │
│   │  📷 Prendre une photo         │ │  ← ElevatedButton (vert plein)
│   └───────────────────────────────┘ │
│                                     │
│   ┌───────────────────────────────┐ │
│   │  🖼 Choisir depuis la galerie │ │  ← OutlinedButton (bordure verte)
│   └───────────────────────────────┘ │
│                                     │
│   Langue: [FR] [EWO] [FUL]          │  ← Boutons de langue
│                                     │
│         IAI Cameroun 2026           │  ← Footer
└─────────────────────────────────────┘
```

**Palette de Couleurs :**

| Couleur | Code Hex | Utilisation |
|---------|----------|-------------|
| Vert principal | `#2E7D32` | AppBar, boutons sélectionnés, ElevatedButton |
| Vert foncé | `#1B5E20` | Texte principal, bordures |
| Vert très pâle | `#F1F8E9` | Fond de l'écran |
| Blanc | `#FFFFFF` | Fond des boutons non sélectionnés, texte sur fond vert |

#### Navigation
- **Vers :** `ApercuScreen` via `Navigator.push()`
- **Données envoyées :** `imageFile` (File), `langue` (String)

#### Dépendances
- `package:image_picker/image_picker.dart` - Accès caméra et galerie
- `apercu_screen.dart` - Navigation vers l'écran 2

#### Importance dans le Flux
C'est le premier écran que voit l'utilisateur. Il capture les deux informations essentielles pour le reste du processus : la photo à analyser et la langue de préférence. Sans ces deux données, les écrans suivants ne peuvent pas fonctionner.

---

### 4.3 apercu_screen.dart

**Chemin :** `lib/screens/apercu_screen.dart`  
**Lignes :** 158

#### Rôle
Écran de vérification de la photo prise/sélectionnée. L'utilisateur peut confirmer que la photo est nette et bien cadrée avant de lancer l'analyse IA, ou la reprendre.

#### Structure

**Type :** `StatelessWidget` (aucun état interne modifiable)  
**Classe Publique :** `ApercuScreen`

#### Paramètres Reçus (via le constructeur)

| Paramètre | Type | Requis | Description |
|-----------|------|--------|-------------|
| `imageFile` | `File` | Oui | La photo capturée ou sélectionnée depuis la galerie |
| `langue` | `String` | Oui | La langue choisie (FR, EWO, FUL) - passée à l'écran suivant |

#### Interface Utilitaire (UI)

**Layout en Deux Zones :**

```
┌─────────────────────────────────────┐
│  ← Retour                           │  ← AppBar avec bouton retour
├─────────────────────────────────────┤
│                                     │
│                                     │
│          ZONE PHOTO                 │  ← 3/4 de l'écran (flex: 3)
│         (Expanded flex: 3)          │  ← Fond vert foncé #1B5E20
│                                     │  ← Image avec coins arrondis
│      ┌───────────────────┐          │  ← Ombre portée
│      │                   │          │
│      │    IMAGE PHOTO    │          │
│      │   224x224 resize  │          │
│      │                   │          │
│      └───────────────────┘          │
│                                     │
├─────────────────────────────────────┤
│  ┌───────────────────────────────┐  │  ← Zone boutons (flex: 1)
│  │ La photo est-elle nette et   │  │  ← Fond blanc
│  │ bien cadrée ?                 │  │  ← Coins arrondis en haut
│  │                               │  │
│  │  [Reprendre]  [Analyser]     │  │
│  └───────────────────────────────┘  │
└─────────────────────────────────────┘
```

**Zone Photo (flex: 3) :**
- Prend 3/4 de la hauteur de l'écran
- Fond vert foncé `#1B5E20` pour mettre en valeur la photo
- Image affichée avec `Image.file(widget.imageFile)`
- `fit: BoxFit.contain` - l'image est redimensionnée pour tenir dans l'espace sans déformation
- Coins arrondis : `BorderRadius.circular(16)`
- Ombre portée : `BoxShadow` pour un effet de profondeur

**Zone Boutons (flex: 1) :**
- Prend 1/4 de la hauteur de l'écran
- Fond blanc avec coins arrondis en haut seulement (`BorderRadius.vertical(top: Radius.circular(24))`)
- Question centrée : "La photo est-elle nette et bien cadrée ?"
- Deux boutons côte à côte :

**Bouton "Reprendre" :**
```dart
ElevatedButton.icon(
  onPressed: () => Navigator.pop(context),
  icon: const Icon(Icons.camera_alt),
  label: const Text('Reprendre'),
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.white,
    foregroundColor: const Color(0xFF2E7D32),
  ),
)
```
- Fond blanc, texte et icône verts
- `Navigator.pop(context)` - Retourne à l'écran d'accueil (dépile l'écran actuel)

**Bouton "Analyser" :**
```dart
ElevatedButton.icon(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultatScreen(
          imageFile: widget.imageFile,
          langue: widget.langue,
        ),
      ),
    );
  },
  icon: const Icon(Icons.analytics),
  label: const Text('Analyser'),
)
```
- Fond vert (par défaut du thème), texte blanc
- Navigue vers `ResultatScreen` en passant `imageFile` et `langue`

#### Navigation

| Action | Destination | Méthode | Données |
|--------|-------------|---------|---------|
| "Reprendre" | `AccueilScreen` | `Navigator.pop()` | Aucune |
| "Analyser" | `ResultatScreen` | `Navigator.push()` | `imageFile`, `langue` |

#### Dépendances
- `resultat_screen.dart` - Navigation vers l'écran 3

#### Importance dans le Flux
Cet écran sert de "porte de qualité". Il évite de lancer une analyse IA coûteuse (en temps et ressources) sur une photo floue ou mal cadrée. L'utilisateur garde le contrôle et peut recommencer la capture si nécessaire. Il transmet les deux données essentielles (photo + langue) à l'écran de résultat.

---

### 4.4 classifier.dart

**Chemin :** `lib/screens/classifier.dart`  
**Lignes :** 144

#### Rôle
Classeur IA principal qui utilise un modèle TensorFlow Lite pour prédire la maladie d'une plante à partir d'une photo. C'est le cœur de l'intelligence artificielle de l'application.

#### Structure

**Type :** Classe utilitaire (pas un Widget)  
**Classe Publique :** `Classifier`

#### Variables d'Instance

| Variable | Type | Description |
|----------|------|-------------|
| `_interpreter` | `Interpreter` | Interpréteur TensorFlow Lite qui exécute le modèle |
| `_classIndices` | `Map<String, int>` | Mapping nom de classe → index (ex: "Tomato___Early_blight" → 15) |
| `_indexToClass` | `Map<int, String>` | Mapping inverse : index → nom de classe (ex: 15 → "Tomato___Early_blight") |
| `_isLoaded` | `bool` | Indique si le modèle est chargé en mémoire |

#### Méthodes Clés

##### `charger()`
```dart
Future<void> charger() async {
  if (_isLoaded) return;

  // Charge le modèle TFLite
  _interpreter = await Interpreter.fromAsset('assets/madoula_compat.tflite');

  // Charge le mapping des classes
  final String jsonContent = await rootBundle.loadString('assets/class_indices.json');
  _classIndices = Map<String, int>.from(jsonDecode(jsonContent));

  // Inverse le mapping : index → classe
  _indexToClass = {};
  for (var entry in _classIndices.entries) {
    _indexToClass[entry.value] = entry.key;
  }

  _isLoaded = true;
}
```

**Fonctionnement Détaillé :**
1. **Vérification** : Si le modèle est déjà chargé (`_isLoaded == true`), retourne immédiatement (évite de recharger)
2. **Chargement du modèle** : `Interpreter.fromAsset()` charge le fichier `.tflite` depuis les assets et crée l'interpréteur TFLite
3. **Chargement du mapping** : Lit le fichier JSON `class_indices.json` et le décode en Map
4. **Inversion du mapping** : Crée le mapping inverse car le modèle retourne un index numérique, mais on a besoin du nom de la classe
5. **Flag** : Marque le modèle comme chargé

**Complexité :** O(n) où n = nombre de classes (22 dans notre cas)

##### `predire(File imageFile)`
```dart
Future<String?> predire(File imageFile) async {
  if (!_isLoaded) await charger();

  // Preprocessing de l'image
  final bytes = await imageFile.readAsBytes();
  final image = img.decodeImage(bytes);
  final resized = img.copyResize(image!, width: 224, height: 224);

  // Normalisation des pixels
  final input = List.filled(1 * 224 * 224 * 3, 0.0).reshape([1, 224, 224, 3]);
  for (int y = 0; y < 224; y++) {
    for (int x = 0; x < 224; x++) {
      final pixel = resized.getPixel(x, y);
      input[0][y][x][0] = pixel.r / 255.0;  // Rouge
      input[0][y][x][1] = pixel.g / 255.0;  // Vert
      input[0][y][x][2] = pixel.b / 255.0;  // Bleu
    }
  }

  // Tenseur de sortie
  final output = List.filled(1 * _classIndices.length, 0.0).reshape([1, _classIndices.length]);

  // Exécution de l'inférence
  _interpreter.run(input, output);

  // Trouver l'index avec le score maximum
  int maxIndex = 0;
  double maxScore = output[0][0];
  for (int i = 1; i < output[0].length; i++) {
    if (output[0][i] > maxScore) {
      maxScore = output[0][i];
      maxIndex = i;
    }
  }

  // Seuil de confiance
  if (maxScore < 0.30) {
    return 'NON_PLANTE';
  }

  return _indexToClass[maxIndex];
}
```

**Fonctionnement Détaillé - Étape par Étape :**

**Étape 1 : Vérification du chargement**
```dart
if (!_isLoaded) await charger();
```
Si le modèle n'est pas chargé, le charge d'abord.

**Étape 2 : Lecture de l'image**
```dart
final bytes = await imageFile.readAsBytes();
```
Lit les bytes bruts du fichier image (JPEG, PNG, etc.).

**Étape 3 : Décodage de l'image**
```dart
final image = img.decodeImage(bytes);
```
Convertit les bytes en objet image manipulable (format RGBA).

**Étape 4 : Redimensionnement**
```dart
final resized = img.copyResize(image!, width: 224, height: 224);
```
Redimensionne l'image à 224x224 pixels, taille standard d'entrée pour les modèles MobileNet/EfficientNet.

**Pourquoi 224x224 ?** C'est la taille d'entrée standard pour la plupart des modèles de classification d'images pré-entraînés. Le modèle a été entraîné avec cette taille, donc toute image d'entrée doit avoir exactement ces dimensions.

**Étape 5 : Création du tenseur d'entrée**
```dart
final input = List.filled(1 * 224 * 224 * 3, 0.0).reshape([1, 224, 224, 3]);
```
Crée un tableau 4D : `[batch=1, height=224, width=224, channels=3]`
- `batch=1` : On traite une seule image à la fois
- `height=224, width=224` : Dimensions de l'image
- `channels=3` : 3 canaux de couleur (Rouge, Vert, Bleu)

**Étape 6 : Normalisation des pixels**
```dart
for (int y = 0; y < 224; y++) {
  for (int x = 0; x < 224; x++) {
    final pixel = resized.getPixel(x, y);
    input[0][y][x][0] = pixel.r / 255.0;
    input[0][y][x][1] = pixel.g / 255.0;
    input[0][y][x][2] = pixel.b / 255.0;
  }
}
```
Parcourt chaque pixel de l'image 224x224 et normalise les valeurs RGB :
- Les valeurs originales des pixels vont de 0 à 255
- On les divise par 255 pour obtenir des valeurs entre 0.0 et 1.0
- C'est la normalisation standard pour les modèles de deep learning

**Étape 7 : Création du tenseur de sortie**
```dart
final output = List.filled(1 * _classIndices.length, 0.0).reshape([1, _classIndices.length]);
```
Crée un tableau 2D : `[batch=1, nombre_de_classes]`
- Contiendra les scores de probabilité pour chaque classe
- 22 classes = 22 scores

**Étape 8 : Exécution de l'inférence**
```dart
_interpreter.run(input, output);
```
Exécute le modèle TFLite :
- Prend le tenseur d'entrée (l'image normalisée)
- Remplit le tenseur de sortie avec les scores de probabilité
- C'est l'étape de calcul la plus lourde (utilise le CPU/GPU)

**Étape 9 : Recherche du score maximum (Argmax)**
```dart
int maxIndex = 0;
double maxScore = output[0][0];
for (int i = 1; i < output[0].length; i++) {
  if (output[0][i] > maxScore) {
      maxScore = output[0][i];
      maxIndex = i;
  }
}
```
Parcourt tous les scores de sortie et trouve :
- `maxIndex` : L'index de la classe avec le score le plus élevé
- `maxScore` : Le score de confiance de cette classe (entre 0.0 et 1.0)

**Étape 10 : Vérification du seuil de confiance**
```dart
if (maxScore < 0.30) {
  return 'NON_PLANTE';
}
```
Si la confiance est inférieure à 30%, considère que ce n'est pas une plante valide (résultat non fiable).

**Étape 11 : Retour du résultat**
```dart
return _indexToClass[maxIndex];
```
Retourne le nom de la classe prédite en utilisant le mapping inverse.

##### `predireAvecConfiance(File imageFile)`
```dart
Future<Map<String, dynamic>> predireAvecConfiance(File imageFile) async {
  // ... (même preprocessing que predire())

  // Même recherche du score maximum

  String classe = _indexToClass[maxIndex] ?? 'Inconnu';
  if (maxScore < 0.60) {
    classe = 'NON_PLANTE';
  }

  return {
    'classe': classe,
    'confiance': maxScore,
  };
}
```

**Différences avec `predire()` :**
- Retourne un `Map` avec deux clés : `'classe'` et `'confiance'`
- Utilise un seuil de **60%** au lieu de 30%
- Permet d'accéder au score de confiance pour l'affichage UI

**Structure de retour :**
```dart
{
  'classe': 'Tomato___Early_blight',
  'confiance': 0.85,
}
```

##### `dispose()`
```dart
void dispose() {
  _interpreter.close();
}
```
Ferme l'interpréteur TFLite et libère la mémoire. **Important** à appeler après chaque analyse pour éviter les fuites de mémoire.

#### Classes Reconnues (22 classes)

| Plante | Maladies | Classes |
|--------|----------|---------|
| **Maïs** | Cercospora, Common rust, Northern Leaf Blight | 4 maladies + 1 sain = 5 |
| **Agrumes** | Huanglongbing (Citrus greening) | 1 maladie + 1 sain = 2 |
| **Poivron** | Bacterial spot | 1 maladie + 1 sain = 2 (note: 2 maladies selon l'analyse) |
| **Pomme de terre** | Early blight, Late blight | 2 maladies + 1 sain = 3 |
| **Soja** | - | 1 sain = 1 |
| **Fraise** | - | 1 sain = 1 |
| **Tomate** | Bacterial spot, Early blight, Late blight, Leaf Mold, Septoria, Spider mites, Target Spot, TYLCV, Mosaic virus | 9 maladies + 1 sain = 10 |

#### Dépendances
- `package:tflite_flutter/tflite_flutter.dart` - Moteur d'inférence TensorFlow Lite
- `package:image/image.dart` - Manipulation d'images (décodage, redimensionnement)
- `assets/madoula_compat.tflite` - Modèle TFLite binaire
- `assets/class_indices.json` - Mapping des classes

#### Importance dans le Flux
C'est le cerveau de l'application. Sans ce classeur, l'application ne peut pas identifier les maladies. Il transforme une image brute en une prédiction de classe, qui sera ensuite mappée à des informations détaillées (symptômes, traitements) via la base de données JSON.

---

### 4.5 filter_classifier.dart

**Chemin :** `lib/screens/filter_classifier.dart`  
**Lignes :** 73

#### Rôle
Classeur binaire qui détermine si une image contient une plante ou non. C'est un filtre de pré-classification qui évite de lancer le classeur principal sur des images non pertinentes (ciel, sol, objets, etc.).

#### Structure

**Type :** Classe utilitaire (pas un Widget)  
**Classe Publique :** `FiltreClassifier`

#### Variables d'Instance

| Variable | Type | Description |
|----------|------|-------------|
| `_interpreter` | `Interpreter` | Interpréteur TensorFlow Lite pour le modèle de filtre |
| `_classIndices` | `Map<String, int>` | Mapping {"pas_plante": 0, "plante": 1} |
| `_isLoaded` | `bool` | Indique si le modèle est chargé |

#### Méthodes Clés

##### `charger()`
```dart
Future<void> charger() async {
  if (_isLoaded) return;

  _interpreter = await Interpreter.fromAsset('assets/filtre_model.tflite');

  final String jsonContent = await rootBundle.loadString('assets/filtre_indices.json');
  _classIndices = Map<String, int>.from(jsonDecode(jsonContent));

  _isLoaded = true;
}
```

**Fonctionnement :**
- Identique à `Classifier.charger()` mais avec le modèle de filtre binaire
- Charge `filtre_model.tflite` et `filtre_indices.json`
- Le mapping contient seulement 2 classes : `pas_plante` (index 0) et `plante` (index 1)

##### `estUnePlante(File imageFile)`
```dart
Future<bool> estUnePlante(File imageFile) async {
  if (!_isLoaded) await charger();

  // Même preprocessing que Classifier
  final bytes = await imageFile.readAsBytes();
  final image = img.decodeImage(bytes);
  final resized = img.copyResize(image!, width: 224, height: 224);

  // Normalisation
  final input = List.filled(1 * 224 * 224 * 3, 0.0).reshape([1, 224, 224, 3]);
  for (int y = 0; y < 224; y++) {
    for (int x = 0; x < 224; x++) {
      final pixel = resized.getPixel(x, y);
      input[0][y][x][0] = pixel.r / 255.0;
      input[0][y][x][1] = pixel.g / 255.0;
      input[0][y][x][2] = pixel.b / 255.0;
    }
  }

  // Tenseur de sortie : 1 seule valeur (classification binaire avec sigmoid)
  final output = List.filled(1 * 1, 0.0).reshape([1, 1]);

  // Inférence
  _interpreter.run(input, output);

  // Récupérer le score
  final planteIndex = _classIndices['plante'] ?? 1;
  final score = output[0][0];

  // Décision
  if (planteIndex == 1) {
    return score > 0.5;
  } else {
    return score < 0.5;
  }
}
```

**Fonctionnement Détaillé :**

**Étapes 1-6 (Preprocessing) :** Identiques au `Classifier` :
1. Vérifie le chargement
2. Lit les bytes de l'image
3. Décode l'image
4. Redimensionne à 224x224
5. Crée le tenseur d'entrée
6. Normalise les pixels

**Étape 7 : Tenseur de sortie binaire**
```dart
final output = List.filled(1 * 1, 0.0).reshape([1, 1]);
```
Contrairement au classeur principal (22 classes), le filtre n'a qu'**une seule valeur de sortie** car c'est une classification binaire avec fonction d'activation **sigmoid**.

**Qu'est-ce que sigmoid ?** Une fonction mathématique qui retourne une valeur entre 0 et 1, interprétée comme une probabilité :
- Proche de 0 = "pas_plante" avec haute certitude
- Proche de 1 = "plante" avec haute certitude
- Proche de 0.5 = incertain

**Étape 8 : Exécution de l'inférence**
```dart
_interpreter.run(input, output);
```
Exécute le modèle de filtre.

**Étape 9 : Décision**
```dart
final planteIndex = _classIndices['plante'] ?? 1;
final score = output[0][0];

if (planteIndex == 1) {
  return score > 0.5;
} else {
  return score < 0.5;
}
```
- Récupère l'index de la classe "plante" (normalement 1)
- Si `planteIndex == 1` : score > 0.5 signifie "c'est une plante"
- Si `planteIndex == 0` : score < 0.5 signifie "c'est une plante" (logique inversée)
- Le seuil de 0.5 est le point médian de la sigmoid

**Gestion d'erreur (non visible mais mentionnée) :**
```dart
// En cas d'erreur : retourne true (laisse passer par sécurité)
```
Si le modèle échoue pour quelque raison que ce soit, retourne `true` pour ne pas bloquer l'utilisateur. C'est un choix de "fail-safe" : mieux vaut analyser une image non-plante que de bloquer une image valide.

##### `dispose()`
```dart
void dispose() {
  _interpreter.close();
}
```
Libère la mémoire du modèle de filtre.

#### Architecture du Modèle de Filtre

| Caractéristique | Valeur |
|-----------------|--------|
| Type | Classification binaire |
| Classes | `pas_plante` (0), `plante` (1) |
| Fonction d'activation | Sigmoid |
| Sortie | 1 valeur entre 0 et 1 |
| Seuil de décision | 0.5 |
| Taille d'entrée | 224x224x3 |

#### Dépendances
- `package:tflite_flutter/tflite_flutter.dart` - Moteur TFLite
- `package:image/image.dart` - Manipulation d'images
- `assets/filtre_model.tflite` - Modèle TFLite binaire
- `assets/filtre_indices.json` - Mapping {"pas_plante": 0, "plante": 1}

#### Importance dans le Flux
Ce filtre est la **première ligne de défense**. Il évite de :
1. Perdre du temps à analyser une image qui ne contient pas de plante
2. Retourner un résultat absurde (ex: "Maïs Cercospora" sur une photo de ciel)
3. Frustrer l'utilisateur avec un diagnostic non pertinent

Il est exécuté **avant** le classeur principal dans le pipeline d'analyse.

---

### 4.6 resultat_screen.dart

**Chemin :** `lib/screens/resultat_screen.dart`  
**Lignes :** 619

#### Rôle
Écran de résultat du diagnostic. C'est l'écran le plus complexe de l'application. Il orchestre l'analyse IA complète (filtre + classeur), affiche les résultats avec symptômes et traitements, et gère le feedback utilisateur.

#### Structure

**Type :** `StatefulWidget` (état change pendant l'analyse et l'affichage)  
**Classe Publique :** `ResultatScreen`  
**Classe d'État :** `_ResultatScreenState`

#### Paramètres Reçus (via le constructeur)

| Paramètre | Type | Requis | Description |
|-----------|------|--------|-------------|
| `imageFile` | `File` | Oui | La photo à analyser |
| `langue` | `String` | Oui | Langue choisie (FR, EWO, FUL) |

#### Variables d'État

| Variable | Type | Valeur par défaut | Description |
|----------|------|-------------------|-------------|
| `isLoading` | `bool` | `true` | Indique si l'analyse est en cours |
| `maladie` | `Map<String, dynamic>?` | `null` | Données de la maladie trouvée dans le JSON |
| `erreur` | `String` | `''` | Message d'erreur si l'analyse échoue |
| `flutterTts` | `FlutterTts` | `FlutterTts()` | Moteur de synthèse vocale |
| `isReading` | `bool` | `false` | Indique si la lecture vocale est en cours |
| `_feedbackDonne` | `bool?` | `null` | Feedback utilisateur : null (pas donné), true (like), false (dislike) |
| `_confianceModele` | `double` | `0.0` | Confiance du modèle (note : jamais mis à jour - BUG) |

#### Méthodes Clés

##### `lancerAnalyse()`
```dart
Future<void> lancerAnalyse() async {
  setState(() {
    isLoading = true;
    erreur = '';
    maladie = null;
  });

  try {
    // ÉTAPE 1 : Filtre plante/non-plante
    final filtre = FiltreClassifier();
    await filtre.charger();
    final estPlante = await filtre.estUnePlante(widget.imageFile);
    filtre.dispose();

    if (!estPlante) {
      setState(() {
        erreur = 'Je ne détecte pas de plante dans cette image...';
        isLoading = false;
      });
      return;
    }

    // ÉTAPE 2 : Classification maladie
    final classifier = Classifier();
    await classifier.charger();
    final classePredite = await classifier.predire(widget.imageFile);
    classifier.dispose();

    if (classePredite == null || classePredite == 'NON_PLANTE') {
      setState(() {
        erreur = 'Maladie non répertoriée';
        isLoading = false;
      });
      return;
    }

    // ÉTAPE 3 : Correspondance JSON
    final String jsonContent = await rootBundle.loadString('assets/maladies_madoula.json');
    final List<dynamic> maladies = jsonDecode(jsonContent);

    final maladieTrouvee = maladies.firstWhere(
      (m) => m['classe_modele'] == classePredite,
      orElse: () => null,
    );

    if (maladieTrouvee == null) {
      setState(() {
        erreur = 'Maladie non répertoriée';
        isLoading = false;
      });
      return;
    }

    setState(() {
      maladie = maladieTrouvee;
      isLoading = false;
    });
  } catch (e) {
    setState(() {
      erreur = 'Erreur lors de l\'analyse : $e';
      isLoading = false;
    });
  }
}
```

**Fonctionnement Détaillé - Pipeline d'Analyse :**

**Initialisation :**
```dart
setState(() {
  isLoading = true;
  erreur = '';
  maladie = null;
});
```
Réinitialise l'état avant de commencer l'analyse. Affiche l'écran de chargement.

**ÉTAPE 1 : Filtre plante/non-plante**
```dart
final filtre = FiltreClassifier();
await filtre.charger();
final estPlante = await filtre.estUnePlante(widget.imageFile);
filtre.dispose();
```
1. Crée une instance du filtre
2. Charge le modèle de filtre en mémoire
3. Exécute la prédiction binaire sur l'image
4. Libère la mémoire du modèle

**Si PAS plante :**
```dart
if (!estPlante) {
  setState(() {
    erreur = 'Je ne détecte pas de plante dans cette image...';
    isLoading = false;
  });
  return;
}
```
Affiche un message d'erreur et arrête l'analyse. Pas besoin de continuer si ce n'est pas une plante.

**ÉTAPE 2 : Classification maladie**
```dart
final classifier = Classifier();
await classifier.charger();
final classePredite = await classifier.predire(widget.imageFile);
classifier.dispose();
```
1. Crée une instance du classeur principal
2. Charge le modèle de classification (22 classes)
3. Exécute la prédiction et retourne le nom de la classe (ex: "Tomato___Early_blight")
4. Libère la mémoire

**Si classe non valide :**
```dart
if (classePredite == null || classePredite == 'NON_PLANTE') {
  setState(() {
    erreur = 'Maladie non répertoriée';
    isLoading = false;
  });
  return;
}
```
Si le modèle retourne `null` ou `'NON_PLANTE'` (confiance < 30%), affiche une erreur.

**ÉTAPE 3 : Correspondance JSON**
```dart
final String jsonContent = await rootBundle.loadString('assets/maladies_madoula.json');
final List<dynamic> maladies = jsonDecode(jsonContent);

final maladieTrouvee = maladies.firstWhere(
  (m) => m['classe_modele'] == classePredite,
  orElse: () => null,
);
```
1. Charge la base de données des maladies depuis le fichier JSON
2. Decode le JSON en liste de Maps
3. Recherche la maladie dont `classe_modele` correspond à `classePredite`
4. `orElse: () => null` retourne null si aucune correspondance n'est trouvée

**Si maladie trouvée :**
```dart
setState(() {
  maladie = maladieTrouvee;
  isLoading = false;
});
```
Stocke les données de la maladie et arrête le chargement. L'écran de résultat s'affiche.

**Gestion d'erreur globale :**
```dart
catch (e) {
  setState(() {
    erreur = 'Erreur lors de l\'analyse : $e';
    isLoading = false;
  });
}
```
Attrape toute exception et affiche un message d'erreur détaillé.

##### `getTexte(Map<String, dynamic> maladie, String cle)`
```dart
String getTexte(Map<String, dynamic> maladie, String cle) {
  switch (widget.langue) {
    case 'EWO':
      return maladie['${cle}_ewondo'] ?? maladie['${cle}_fr'];
    case 'FUL':
      return maladie['${cle}_fulfulde'] ?? maladie['${cle}_fr'];
    default:
      return maladie['${cle}_fr'] ?? '';
  }
}
```

**Fonctionnement :**
Système de traduction simple basé sur la concaténation de clés :
- Pour `cle = 'nom'` et `langue = 'EWO'` → cherche `nom_ewondo`, fallback sur `nom_fr`
- Pour `cle = 'description'` et `langue = 'FR'` → cherche `description_fr`

**Fallback intelligent :** Si la traduction dans la langue choisie n'existe pas, utilise la version française.

##### `lireVoixHaute()`
```dart
Future<void> lireVoixHaute() async {
  if (isReading) {
    await flutterTts.stop();
    setState(() => isReading = false);
    return;
  }

  final texte = 'Résultat : ${getTexte(maladie!, 'nom')}. ${getTexte(maladie!, 'description')}';

  await flutterTts.setLanguage('fr-FR');
  await flutterTts.setSpeechRate(0.45);
  await flutterTts.speak(texte);

  setState(() => isReading = true);
}
```

**Fonctionnement :**
1. Si déjà en train de lire (`isReading == true`) :
   - Arrête la lecture avec `flutterTts.stop()`
   - Met à jour l'état
2. Sinon :
   - Construit le texte à lire : "Résultat : [nom]. [description]"
   - Configure la langue : `fr-FR` (français)
   - Configure la vitesse : `0.45` (lent, pour une bonne compréhension)
   - Lance la lecture avec `flutterTts.speak(texte)`
   - Met à jour l'état

**Note :** La langue est toujours `fr-FR`, même si l'utilisateur a choisi EWO ou FUL. C'est un BUG potentiel.

##### `getCouleurGravite(int score)`
```dart
Color getCouleurGravite(int score) {
  if (score <= 1) return Colors.green;
  if (score == 2) return Colors.amber;
  if (score == 3) return Colors.orange;
  return Colors.red;
}
```

**Échelle de gravité :**

| Score | Couleur | Niveau |
|-------|---------|--------|
| 0-1 | 🟢 Vert | Aucune / Faible |
| 2 | 🟡 Amber | Moyenne |
| 3 | 🟠 Orange | Élevée |
| 4+ | 🔴 Rouge | Très élevée |

##### `getIconeGravite(int score)`
```dart
IconData getIconeGravite(int score) {
  if (score <= 1) return Icons.check_circle;
  if (score == 2) return Icons.info;
  if (score == 3) return Icons.warning;
  return Icons.dangerous;
}
```

**Icônes associées :**

| Score | Icône | Signification |
|-------|-------|---------------|
| 0-1 | `check_circle` | ✓ Tout va bien |
| 2 | `info` | ℹ Information |
| 3 | `warning` | ⚠ Attention |
| 4+ | `dangerous` | ☠ Danger |

##### `_donnerFeedback(bool estCorrect)`
```dart
Future<void> _donnerFeedback(bool estCorrect) async {
  if (_feedbackDonne != null) return;

  await FeedbackService.sauvegarder(
    classePredi: maladie!['classe_modele'],
    confiance: _confianceModele, // Note : toujours 0.0 (BUG)
    estCorrect: estCorrect,
    langue: widget.langue,
  );

  setState(() => _feedbackDonne = estCorrect);
}
```

**Fonctionnement :**
1. Vérifie si un feedback a déjà été donné (empêche le double feedback)
2. Appelle `FeedbackService.sauvegarder()` avec :
   - `classePredi` : La classe prédite par le modèle
   - `confiance` : La confiance du modèle (toujours 0.0 - BUG)
   - `estCorrect` : true (like) ou false (dislike)
   - `langue` : La langue choisie par l'utilisateur
3. Met à jour l'état pour afficher la confirmation

#### Interface Utilitaire (UI)

**Trois États d'Affichage :**

##### État 1 : Écran de Chargement (`_ecranChargement()`)
```
┌─────────────────────────────────────┐
│  ← Retour                           │
├─────────────────────────────────────┤
│                                     │
│           ⏳                        │
│     (CircularProgressIndicator)     │
│                                     │
│     Analyse en cours...             │
│                                     │
└─────────────────────────────────────┘
```
- Spinner circulaire animé
- Texte "Analyse en cours..."

##### État 2 : Écran d'Erreur (`_ecranErreur()`)
```
┌─────────────────────────────────────┐
│  ← Retour                           │
├─────────────────────────────────────┤
│                                     │
│           ❌                        │
│        (Icon.error)                 │
│                                     │
│    [Message d'erreur]               │
│                                     │
│      [Réessayer]                    │
│                                     │
└─────────────────────────────────────┘
```
- Icône d'erreur rouge
- Message d'erreur descriptif
- Bouton "Réessayer" qui relance `lancerAnalyse()`

##### État 3 : Écran de Résultat (`_ecranResultat()`)
```
┌─────────────────────────────────────┐
│  ← Nouvelle analyse                 │
├─────────────────────────────────────┤
│  ┌───────────────────────────────┐  │
│  │ [Miniature de la photo]       │  │
│  │                               │  │
│  │ 🟢 [Nom de la maladie]        │  │  ← Couleur selon gravité
│  │ Plante: [nom de la plante]    │  │
│  │ Gravité: [niveau] ⚠️          │  │
│  │                               │  │
│  │ [Description de la maladie]   │  │
│  └───────────────────────────────┘  │
│                                     │
│  ┌───────────────────────────────┐  │
│  │ Symptômes observés :          │  │
│  │ • [symptôme 1]                │  │
│  │ • [symptôme 2]                │  │
│  │ • [symptôme 3]                │  │
│  └───────────────────────────────┘  │
│                                     │
│  ┌───────────────────────────────┐  │
│  │ Traitements recommandés :     │  │
│  │ 1. [traitement 1]             │  │
│  │ 2. [traitement 2]             │  │
│  │ 3. [traitement 3]             │  │
│  └───────────────────────────────┘  │
│                                     │
│  ┌───────────────────────────────┐  │
│  │ Ce diagnostic est-il correct ?│  │
│  │  [👍 Oui, correct]           │  │
│  │  [👎 Non, incorrect]         │  │
│  │                               │  │
│  │  ✓ Merci pour votre retour !  │  │  ← Affiché après feedback
│  └───────────────────────────────┘  │
│                                     │
│  [🔊 Lire à voix haute]             │
│                                     │
│  [Nouvelle analyse]                 │
└─────────────────────────────────────┘
```

**Carte Principale (Résultat) :**
- Miniature de la photo analysée
- Nom de la maladie (couleur dynamique selon gravité)
- Nom de la plante affectée
- Niveau de gravité avec icône
- Description de la maladie

**Carte Symptômes :**
- Liste à puces des symptômes observés
- Traduits selon la langue choisie

**Carte Traitements :**
- Liste numérotée des traitements recommandés
- Solutions locales accessibles
- Traduits selon la langue choisie

**Carte Feedback :**
- Question : "Ce diagnostic est-il correct ?"
- Bouton "Oui, correct" (vert) → like
- Bouton "Non, incorrect" (rouge) → dislike
- Message de confirmation après feedback

**Boutons d'Action :**
- "Lire à voix haute" - Synthèse vocale du résultat
- "Nouvelle analyse" - Retour à l'accueil via `Navigator.popUntil(context, (route) => route.isFirst)`

#### Navigation
- **Retour :** `Navigator.popUntil(context, (route) => route.isFirst)` - Retourne directement à l'écran d'accueil (dépile tous les écrans intermédiaires)

#### Dépendances
- `filter_classifier.dart` - Pour le filtre plante/non-plante
- `classifier.dart` - Pour la classification des maladies
- `../services/feedback_service.dart` - Pour le stockage du feedback
- `package:flutter_tts/flutter_tts.dart` - Synthèse vocale
- `assets/maladies_madoula.json` - Base de données des maladies

#### Importance dans le Flux
C'est l'écran le plus critique. Il orchestre tout le pipeline d'analyse IA et présente les résultats de manière compréhensible à l'utilisateur. C'est aussi le point de collecte du feedback, essentiel pour améliorer le modèle dans le futur.

---

### 4.7 feedback_service.dart

**Chemin :** `lib/services/feedback_service.dart`  
**Lignes :** 66

#### Rôle
Service de stockage local des feedbacks utilisateur (like/dislike sur les diagnostics). Permet de collecter des données pour améliorer le modèle IA dans le futur.

#### Structure

**Type :** Classe statique (pas d'instanciation nécessaire)  
**Classe Publique :** `FeedbackService`

#### Constantes

| Constante | Type | Valeur | Description |
|-----------|------|--------|-------------|
| `_cleStockage` | `String` | `'madoula_feedbacks'` | Clé utilisée dans SharedPreferences pour stocker les feedbacks |

#### Méthodes Statiques

##### `sauvegarder()`
```dart
static Future<void> sauvegarder({
  required String classePredi,
  required double confiance,
  required bool estCorrect,
  required String langue,
  String versionModele = 'v1.0',
}) async {
  final prefs = await SharedPreferences.getInstance();

  // Récupère la liste existante
  final String? jsonContent = prefs.getString(_cleStockage);
  List<Map<String, dynamic>> feedbacks = [];

  if (jsonContent != null) {
    final List<dynamic> decoded = jsonDecode(jsonContent);
    feedbacks = decoded.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  // Crée un nouveau feedback
  final nouveauFeedback = {
    'classe_predite': classePredi,
    'confiance': confiance,
    'correct': estCorrect,
    'langue': langue,
    'date': DateTime.now().toIso8601String(),
    'version_modele': versionModele,
  };

  feedbacks.add(nouveauFeedback);

  // Sauvegarde en JSON
  await prefs.setString(_cleStockage, jsonEncode(feedbacks));
}
```

**Fonctionnement Détaillé :**

**Étape 1 : Accès au stockage**
```dart
final prefs = await SharedPreferences.getInstance();
```
Obtient une instance de SharedPreferences (stockage clé-valeur local persistant sur le device).

**Étape 2 : Récupération des feedbacks existants**
```dart
final String? jsonContent = prefs.getString(_cleStockage);
List<Map<String, dynamic>> feedbacks = [];

if (jsonContent != null) {
  final List<dynamic> decoded = jsonDecode(jsonContent);
  feedbacks = decoded.map((e) => Map<String, dynamic>.from(e)).toList();
}
```
- Lit la chaîne JSON stockée sous la clé `'madoula_feedbacks'`
- Si elle existe, la décode en liste de Maps
- Sinon, initialise une liste vide

**Étape 3 : Création du nouveau feedback**
```dart
final nouveauFeedback = {
  'classe_predite': classePredi,
  'confiance': confiance,
  'correct': estCorrect,
  'langue': langue,
  'date': DateTime.now().toIso8601String(),
  'version_modele': versionModele,
};
```

**Structure d'un Feedback :**
```json
{
  "classe_predite": "Tomato___Early_blight",
  "confiance": 0.85,
  "correct": true,
  "langue": "FR",
  "date": "2026-05-03T10:30:00.000Z",
  "version_modele": "v1.0"
}
```

| Champ | Type | Description |
|-------|------|-------------|
| `classe_predite` | String | La classe prédite par le modèle (ex: "Tomato___Early_blight") |
| `confiance` | double | Score de confiance du modèle (0.0 à 1.0) |
| `correct` | bool | true = like, false = dislike |
| `langue` | String | Langue choisie par l'utilisateur (FR, EWO, FUL) |
| `date` | String | Timestamp ISO 8601 de l'instant du feedback |
| `version_modele` | String | Version du modèle utilisé (par défaut 'v1.0') |

**Étape 4 : Ajout et sauvegarde**
```dart
feedbacks.add(nouveauFeedback);
await prefs.setString(_cleStockage, jsonEncode(feedbacks));
```
- Ajoute le nouveau feedback à la liste
- Encode la liste complète en JSON
- Sauvegarde dans SharedPreferences

##### `recupererTous()`
```dart
static Future<List<Map<String, dynamic>>> recupererTous() async {
  final prefs = await SharedPreferences.getInstance();
  final String? jsonContent = prefs.getString(_cleStockage);

  if (jsonContent == null) return [];

  final List<dynamic> decoded = jsonDecode(jsonContent);
  return decoded.map((e) => Map<String, dynamic>.from(e)).toList();
}
```

**Fonctionnement :**
1. Obtient l'instance SharedPreferences
2. Lit la chaîne JSON stockée
3. Si vide, retourne une liste vide
4. Sinon, décode et retourne la liste de tous les feedbacks

**Utilité :** Utile pour le débogage ou une future interface d'administration.

##### `compterRetours()`
```dart
static Future<Map<String, int>> compterRetours() async {
  final feedbacks = await recupererTous();

  int likes = 0;
  int dislikes = 0;

  for (final feedback in feedbacks) {
    if (feedback['correct'] == true) {
      likes++;
    } else {
      dislikes++;
    }
  }

  return {
    'likes': likes,
    'dislikes': dislikes,
    'total': feedbacks.length,
  };
}
```

**Fonctionnement :**
1. Récupère tous les feedbacks
2. Parcourt la liste et compte les likes/dislikes
3. Retourne un Map avec les statistiques

**Structure de retour :**
```dart
{
  'likes': 42,
  'dislikes': 8,
  'total': 50,
}
```

**Utilité :** Permet de calculer le taux de satisfaction du modèle (likes/total).

#### Stockage Sous-Jacent

**SharedPreferences :**
- Stockage clé-valeur persistant sur le device
- Les données survivent aux redémarrages de l'app
- Limité en taille (quelques MB)
- Idéal pour des petites données structurées

**Format de stockage :**
```
Clé: 'madoula_feedbacks'
Valeur: '[{"classe_predite":"...","confiance":0.85,...}, {...}]'
```

#### Dépendances
- `package:shared_preferences/shared_preferences.dart` - Stockage local

#### Importance dans le Flux
Ce service permet de collecter des données précieuses pour :
1. **Améliorer le modèle** : Les feedbacks négatifs indiquent des erreurs de classification
2. **Mesurer la performance** : Le ratio likes/dislikes donne une métrique de qualité
3. **Future fonctionnalité** : Export des données pour réentraînement du modèle

---

## 5. Fichiers Assets

### 5.1 class_indices.json

**Chemin :** `assets/class_indices.json`  
**Lignes :** 24

#### Rôle
Mapping entre les noms de classes du modèle d'IA et leurs index numériques. Ce fichier est essentiel pour interpréter les sorties du modèle TFLite.

#### Contenu
```json
{
  "Corn___Cercospora_leaf_spot": 0,
  "Corn___Common_rust": 1,
  "Corn___Northern_Leaf_Blight": 2,
  "Corn___healthy": 3,
  "Orange___Haunglongbing": 4,
  "Pepper,_bell___Bacterial_spot": 5,
  "Pepper,_bell___healthy": 6,
  "Potato___Early_blight": 7,
  "Potato___Late_blight": 8,
  "Potato___healthy": 9,
  "Soybean___healthy": 10,
  "Strawberry___healthy": 11,
  "Tomato___Bacterial_spot": 12,
  "Tomato___Early_blight": 13,
  "Tomato___Late_blight": 14,
  "Tomato___Leaf_Mold": 15,
  "Tomato___Septoria_leaf_spot": 16,
  "Tomato___Spider_mites": 17,
  "Tomato___Target_Spot": 18,
  "Tomato___Tomato_Yellow_Leaf_Curl_Virus": 19,
  "Tomato___Tomato_mosaic_virus": 20,
  "Tomato___healthy": 21
}
```

#### Structure
- **Clés** : Noms de classes au format `Plante___Maladie` ou `Plante___healthy`
- **Valeurs** : Index numériques de 0 à 21 (22 classes au total)

#### Classes par Plante

| Plante | Index | Maladie |
|--------|-------|---------|
| **Maïs (Corn)** | 0 | Cercospora leaf spot |
| | 1 | Common rust |
| | 2 | Northern Leaf Blight |
| | 3 | healthy (sain) |
| **Agrumes (Orange)** | 4 | Huanglongbing (Citrus greening) |
| **Poivron (Pepper, bell)** | 5 | Bacterial spot |
| | 6 | healthy (sain) |
| **Pomme de terre (Potato)** | 7 | Early blight |
| | 8 | Late blight |
| | 9 | healthy (sain) |
| **Soja (Soybean)** | 10 | healthy (sain) |
| **Fraise (Strawberry)** | 11 | healthy (sain) |
| **Tomate (Tomato)** | 12 | Bacterial spot |
| | 13 | Early blight |
| | 14 | Late blight |
| | 15 | Leaf Mold |
| | 16 | Septoria leaf spot |
| | 17 | Spider mites |
| | 18 | Target Spot |
| | 19 | Tomato Yellow Leaf Curl Virus (TYLCV) |
| | 20 | Tomato mosaic virus |
| | 21 | healthy (sain) |

#### Utilisation dans le Code

**Dans `classifier.dart` :**
```dart
// Chargement
final String jsonContent = await rootBundle.loadString('assets/class_indices.json');
_classIndices = Map<String, int>.from(jsonDecode(jsonContent));

// Inversion pour avoir index → classe
_indexToClass = {};
for (var entry in _classIndices.entries) {
  _indexToClass[entry.value] = entry.key;
}

// Utilisation après inférence
return _indexToClass[maxIndex];
```

Le modèle retourne un index (ex: 13), on utilise ce fichier pour le convertir en nom de classe (ex: "Tomato___Early_blight").

---

### 5.2 filtre_indices.json

**Chemin :** `assets/filtre_indices.json`  
**Lignes :** 4

#### Rôle
Mapping binaire pour le filtre plante/non-plante. Beaucoup plus simple que `class_indices.json` car il n'a que 2 classes.

#### Contenu
```json
{
  "pas_plante": 0,
  "plante": 1
}
```

#### Structure
| Classe | Index | Signification |
|--------|-------|---------------|
| `pas_plante` | 0 | L'image ne contient pas de plante |
| `plante` | 1 | L'image contient une plante |

#### Utilisation dans le Code

**Dans `filter_classifier.dart` :**
```dart
final planteIndex = _classIndices['plante'] ?? 1;
final score = output[0][0];

if (planteIndex == 1) {
  return score > 0.5;
} else {
  return score < 0.5;
}
```

---

### 5.3 maladies_madoula.json

**Chemin :** `assets/maladies_madoula.json`  
**Lignes :** 337

#### Rôle
Base de données complète des maladies agricoles. Contient toutes les informations détaillées pour chaque maladie : noms, descriptions, symptômes, traitements, gravité, transmission, saison à risque.

#### Auteur
**Ndzana Christophe -- IAI Cameroun 2025**

#### Structure Globale
```json
[
  {
    "id": 1,
    "classe_modele": "Corn___Cercospora_leaf_spot",
    "plante": "Maïs",
    "nom_fr": "Cercosporiose du maïs",
    "nom_ewondo": "...",
    "nom_fulfulde": "...",
    "description_fr": "...",
    "symptomes": ["...", "..."],
    "traitements_locaux": ["...", "..."],
    "gravite": "moyenne",
    "gravite_score": 2,
    "transmission": "...",
    "saison_risque": "..."
  },
  // ... 21 autres entrées
]
```

#### Structure d'une Entrée de Maladie

| Champ | Type | Description | Exemple |
|-------|------|-------------|---------|
| `id` | int | Identifiant numérique unique | 1 |
| `classe_modele` | String | Correspondance exacte avec `class_indices.json` | "Corn___Cercospora_leaf_spot" |
| `plante` | String | Nom de la plante affectée | "Maïs" |
| `nom_fr` | String | Nom de la maladie en français | "Cercosporiose du maïs" |
| `nom_ewondo` | String | Nom en ewondo | "..." |
| `nom_fulfulde` | String | Nom en fulfulde | "..." |
| `description_fr` | String | Description détaillée en français | "Maladie fongique..." |
| `symptomes` | String[] | Liste des symptômes observables | ["Taches...", "Jaunissement..."] |
| `traitements_locaux` | String[] | Liste des traitements recommandés | ["Fongique...", "Rotation..."] |
| `gravite` | String | Niveau de gravité textuel | "moyenne" |
| `gravite_score` | int | Niveau de gravité numérique (0-4) | 2 |
| `transmission` | String | Mode de transmission de la maladie | "Spores fongiques..." |
| `saison_risque` | String | Période de l'année à risque | "Saison des pluies" |

#### Maladies Couvertes (22 entrées)

| ID | Plante | Maladie | Gravité |
|----|--------|---------|---------|
| 1 | Maïs | Cercosporiose | Moyenne |
| 2 | Maïs | Rouille commune | Moyenne |
| 3 | Maïs | Tache grise | Élevée |
| 4 | Maïs | Maïs sain | Aucune |
| 5 | Agrumes | Huanglongbing | Très élevée |
| 6 | Poivron | Tache bactérienne | Moyenne |
| 7 | Poivron | Poivron sain | Aucune |
| 8 | Pomme de terre | Alternariose | Moyenne |
| 9 | Pomme de terre | Mildiou | Très élevée |
| 10 | Pomme de terre | Pomme de terre saine | Aucune |
| 11 | Soja | Soja sain | Aucune |
| 12 | Fraise | Fraise saine | Aucune |
| 13 | Tomate | Tache bactérienne | Moyenne |
| 14 | Tomate | Alternariose | Moyenne |
| 15 | Tomate | Mildiou | Élevée |
| 16 | Tomate | Moisissure foliaire | Moyenne |
| 17 | Tomate | Septoriose | Moyenne |
| 18 | Tomate | Acariens | Moyenne |
| 19 | Tomate | Tache cible | Moyenne |
| 20 | Tomate | Virus TYLCV | Élevée |
| 21 | Tomate | Virus mosaïque | Élevée |
| 22 | Tomate | Tomate saine | Aucune |

#### Statistiques

| Métrique | Valeur |
|----------|--------|
| Total entrées | 22 |
| Plantes saines | 7 |
| Maladies | 15 |
| Plantes couvertes | 7 |
| Langues supportées | 3 (FR, EWO, FUL) |

#### Utilisation dans le Code

**Dans `resultat_screen.dart` :**
```dart
// Chargement
final String jsonContent = await rootBundle.loadString('assets/maladies_madoula.json');
final List<dynamic> maladies = jsonDecode(jsonContent);

// Recherche par classe_modele
final maladieTrouvee = maladies.firstWhere(
  (m) => m['classe_modele'] == classePredite,
  orElse: () => null,
);

// Accès aux données
getTexte(maladie, 'nom')      // → nom_fr, nom_ewondo, ou nom_fulfulde
getTexte(maladie, 'description') // → description_fr
maladie['symptomes']          // → Liste des symptômes
maladie['traitements_locaux'] // → Liste des traitements
maladie['gravite_score']      // → Score de gravité
```

---

### 5.4 madoula_compat.tflite

**Chemin :** `assets/madoula_compat.tflite`  
**Type :** Fichier binaire (modèle TensorFlow Lite)

#### Rôle
Modèle d'intelligence artificielle entraîné pour classifier les images de feuilles de plantes en 22 catégories différentes (maladies et états sains).

#### Caractéristiques Techniques

| Caractéristique | Valeur |
|-----------------|--------|
| Format | TensorFlow Lite (.tflite) |
| Type | Classification d'images |
| Nombre de classes | 22 |
| Taille d'entrée | 224x224x3 (RGB) |
| Taille de sortie | [1, 22] (scores de probabilité) |
| Fonction d'activation de sortie | Softmax (probabilités) |
| Architecture probable | MobileNetV2 ou EfficientNetLite (standard pour mobile) |

#### Fonctionnement

1. **Entrée** : Image 224x224 pixels avec 3 canaux (R, G, B) normalisés entre 0 et 1
2. **Traitement** : Le modèle applique des couches de convolution pour extraire des caractéristiques visuelles (formes, textures, couleurs)
3. **Sortie** : Tableau de 22 scores de probabilité, un pour chaque classe
4. **Interprétation** : La classe avec le score le plus élevé est la prédiction du modèle

#### Entraînement (Probable)

Le modèle a probablement été entraîné avec :
- **Dataset** : PlantVillage dataset (dataset public de maladies des plantes)
- **Transfer Learning** : Modèle pré-entraîné (ImageNet) fine-tuné sur les maladies des plantes
- **Augmentation** : Rotation, zoom, flip pour améliorer la robustesse
- **Optimisation** : Conversion en TFLite pour l'exécution sur mobile

#### Importance
C'est le cœur de l'IA de l'application. La qualité des prédictions dépend directement de la qualité de ce modèle et de ses données d'entraînement.

---

### 5.5 filtre_model.tflite

**Chemin :** `assets/filtre_model.tflite`  
**Type :** Fichier binaire (modèle TensorFlow Lite)

#### Rôle
Modèle d'intelligence artificielle binaire qui détermine si une image contient une plante ou non. Sert de filtre préalable avant la classification des maladies.

#### Caractéristiques Techniques

| Caractéristique | Valeur |
|-----------------|--------|
| Format | TensorFlow Lite (.tflite) |
| Type | Classification binaire |
| Nombre de classes | 2 (plante / pas_plante) |
| Taille d'entrée | 224x224x3 (RGB) |
| Taille de sortie | [1, 1] (score sigmoid) |
| Fonction d'activation de sortie | Sigmoid (valeur entre 0 et 1) |
| Seuil de décision | 0.5 |

#### Fonctionnement

1. **Entrée** : Image 224x224 pixels avec 3 canaux (R, G, B) normalisés
2. **Traitement** : Extraction de caractéristiques visuelles pour déterminer la présence d'une plante
3. **Sortie** : Une seule valeur entre 0 et 1
   - > 0.5 → "plante"
   - < 0.5 → "pas_plante"

#### Importance
Évite de lancer le modèle principal sur des images non pertinentes, économisant du temps de calcul et évitant des résultats absurdes.

---

## 6. Flux de l'Application

### 6.1 Navigation entre Écrans

```
┌─────────────────────────────────────────────────────────────────┐
│                        MadoulaApp (main.dart)                    │
│                    Theme: Material 3, Vert #2E7D32               │
└────────────────────────────┬────────────────────────────────────┘
                             │ runApp()
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│  ÉCRAN 1: AccueilScreen                                         │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  🌿 Logo circulaire vert (120x120)                        │  │
│  │  MADOULA                                                  │  │
│  │  Détection de maladies agricoles                          │  │
│  │                                                           │  │
│  │  [📷 Prendre une photo]                                   │  │
│  │  [🖼 Choisir depuis la galerie]                           │  │
│  │                                                           │  │
│  │  Langue: [FR] [EWO] [FUL]                                 │  │
│  │                                                           │  │
│  │  IAI Cameroun 2026                                        │  │
│  └───────────────────────────────────────────────────────────┘  │
│                                                                 │
│  Navigation: Navigator.push → ApercuScreen                      │
│  Données envoyées: imageFile (File), langue (String)            │
└────────────────────────────┬────────────────────────────────────┘
                             │ Navigator.push(imageFile, langue)
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│  ÉCRAN 2: ApercuScreen                                          │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │                                                           │  │
│  │              ZONE PHOTO (3/4 de l'écran)                  │  │
│  │              Fond vert foncé #1B5E20                      │  │
│  │              ┌─────────────────────────┐                  │  │
│  │              │                         │                  │  │
│  │              │   PHOTO CAPTURÉE        │                  │  │
│  │              │   (coins arrondis)      │                  │  │
│  │              │                         │                  │  │
│  │              └─────────────────────────┘                  │  │
│  │                                                           │  │
│  ├───────────────────────────────────────────────────────────┤  │
│  │  La photo est-elle nette et bien cadrée ?                 │  │
│  │                                                           │  │
│  │  [📷 Reprendre]        [🔍 Analyser]                      │  │
│  └───────────────────────────────────────────────────────────┘  │
│                                                                 │
│  Reprendre → Navigator.pop() → AccueilScreen                    │
│  Analyser  → Navigator.push() → ResultatScreen                  │
│  Données envoyées: imageFile (File), langue (String)            │
└────────────────────────────┬────────────────────────────────────┘
                             │ Navigator.push(imageFile, langue)
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│  ÉCRAN 3: ResultatScreen                                        │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  ┌─ PHASE D'ANALYSE IA ─────────────────────────────────┐ │  │
│  │  │  Étape 1: FiltreClassifier                            │ │  │
│  │  │    → Charger filtre_model.tflite                      │ │  │
│  │  │    → estUnePlante(imageFile)                          │ │  │
│  │  │    → Si false: erreur "pas de plante détectée"        │ │  │
│  │  │                                                       │ │  │
│  │  │  Étape 2: Classifier                                  │ │  │
│  │  │    → Charger madoula_compat.tflite                    │ │  │
│  │  │    → predire(imageFile)                               │ │  │
│  │  │    → Retourne classe_predite                          │ │  │
│  │  │                                                       │ │  │
│  │  │  Étape 3: Lookup JSON                                 │ │  │
│  │  │    → Charger maladies_madoula.json                    │ │  │
│  │  │    → Trouver maladie par classe_modele                │ │  │
│  │  └───────────────────────────────────────────────────────┘ │  │
│  │                                                           │  │
│  │  ┌─ AFFICHAGE DU RÉSULTAT ──────────────────────────────┐ │  │
│  │  │  [📷 Miniature photo]                                 │ │  │
│  │  │  🟢 [Nom de la maladie]                              │ │  │
│  │  │  Plante: [nom] | Gravité: [niveau] ⚠️                │ │  │
│  │  │  [Description]                                        │ │  │
│  │  │                                                       │ │  │
│  │  │  Symptômes :                                          │ │  │
│  │  │  • [symptôme 1]                                       │ │  │
│  │  │  • [symptôme 2]                                       │ │  │
│  │  │                                                       │ │  │
│  │  │  Traitements :                                        │ │  │
│  │  │  1. [traitement 1]                                    │ │  │
│  │  │  2. [traitement 2]                                    │ │  │
│  │  │                                                       │ │  │
│  │  │  Ce diagnostic est-il correct ?                       │ │  │
│  │  │  [👍 Oui, correct] [👎 Non, incorrect]               │ │  │
│  │  └───────────────────────────────────────────────────────┘ │  │
│  │                                                           │  │
│  │  [🔊 Lire à voix haute]                                   │  │
│  │  [Nouvelle analyse] → popUntil(isFirst) → AccueilScreen   │  │
│  └───────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

### 6.2 Flux de Données

```
┌──────────────┐
│   Camera     │
│   Galerie    │
└──────┬───────┘
       │ (File: image brute)
       ▼
┌──────────────────┐
│  AccueilScreen   │
│  - langueChoisie │
│  - _picker       │
└──────┬───────────┘
       │ Navigator.push(imageFile, langue)
       ▼
┌──────────────────┐
│  ApercuScreen    │
│  - imageFile     │
│  - langue        │
└──────┬───────────┘
       │ Navigator.push(imageFile, langue)
       ▼
┌──────────────────────────────────────────────────────────┐
│                    ResultatScreen                        │
│                                                          │
│  ┌────────────────┐  ┌────────────────┐  ┌────────────┐ │
│  │ FiltreClassifier│  │   Classifier   │  │maladies_   │ │
│  │                │  │                │  │madoula.json│ │
│  │ filtre_model.  │  │ madoula_compat.│  │            │ │
│  │ tflite         │  │ tflite         │  │            │ │
│  │ filtre_indices.│  │ class_indices. │  │            │ │
│  │ json           │  │ json           │  │            │ │
│  └───────┬────────┘  └───────┬────────┘  └─────┬──────┘ │
│          │                   │                  │        │
│          ▼                   ▼                  ▼        │
│   estPlante: bool    classePredite: String  maladie: Map │
│          │                   │                  │        │
│          └───────────────────┼──────────────────┘        │
│                              ▼                           │
│                    ┌──────────────────┐                  │
│                    │ Affichage UI     │                  │
│                    │ - Nom maladie    │                  │
│                    │ - Symptômes      │                  │
│                    │ - Traitements    │                  │
│                    │ - Gravité        │                  │
│                    └────────┬─────────┘                  │
│                             │                            │
│                             ▼                            │
│                    ┌──────────────────┐                  │
│                    │ FeedbackService  │                  │
│                    │ (SharedPreferences)                  │
│                    │ - classe_predite │                  │
│                    │ - confiance      │                  │
│                    │ - correct        │                  │
│                    │ - langue         │                  │
│                    │ - date           │                  │
│                    └──────────────────┘                  │
└──────────────────────────────────────────────────────────┘
```

### 6.3 Pipeline de Classification IA

```
┌─────────────────────────────────────────────────────────────────┐
│                    IMAGE BRUTE (File)                            │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│  ÉTAPE 1: Décodage                                               │
│  img.decodeImage(imageBytes)                                     │
│  → Conversion des bytes en objet image manipulable (RGBA)        │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│  ÉTAPE 2: Redimensionnement                                      │
│  img.copyResize(224, 224)                                        │
│  → Resize vers 224x224 pixels (taille standard du modèle)        │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│  ÉTAPE 3: Normalisation                                          │
│  pixel.r / 255.0, pixel.g / 255.0, pixel.b / 255.0              │
│  → Conversion des valeurs [0-255] en [0.0-1.0]                   │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│  ÉTAPE 4: Création du tenseur d'entrée                           │
│  [1, 224, 224, 3]                                                │
│  → batch=1, height=224, width=224, channels=3 (RGB)             │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│  ÉTAPE 5: Inférence                                              │
│  interpreter.run(input, output)                                  │
│  → Exécution du modèle TFLite sur le CPU/GPU                     │
│  → Sortie: [1, nombre_de_classes] (scores de probabilité)        │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│  ÉTAPE 6: Argmax                                                 │
│  Trouver l'index du score maximum                                │
│  → maxIndex = index de la classe la plus probable                │
│  → maxScore = score de confiance (0.0 à 1.0)                     │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│  ÉTAPE 7: Mapping                                                │
│  index → nom de classe via _indexToClass                         │
│  → ex: 13 → "Tomato___Early_blight"                              │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│  ÉTAPE 8: Vérification du seuil                                  │
│  Si maxScore < 0.30 → 'NON_PLANTE'                               │
│  Si maxScore >= 0.30 → classe_predite                            │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│  ÉTAPE 9: Résultat                                               │
│  classe_predite (String)                                         │
│  → ex: "Tomato___Early_blight"                                   │
└─────────────────────────────────────────────────────────────────┘
```

### 6.4 Diagramme de Séquence

```
Utilisateur        AccueilScreen        ApercuScreen        ResultatScreen        FiltreClassifier        Classifier        maladies_madoula.json        FeedbackService
    │                   │                    │                    │                      │                    │                      │                      │
    │── Prendre photo ──▶│                    │                    │                      │                    │                      │                      │
    │                   │                    │                    │                      │                    │                      │                      │
    │◀── Photo prise ───│                    │                    │                      │                    │                      │                      │
    │                   │                    │                    │                      │                    │                      │                      │
    │─────────────── Navigator.push(imageFile, langue) ──────────▶│                      │                    │                      │                      │
    │                   │                    │                    │                      │                    │                      │                      │
    │                   │  ◀── Affiche photo ─│                    │                      │                    │                      │                      │
    │                   │                    │                    │                      │                    │                      │                      │
    │── "Analyser" ────▶│                    │                    │                      │                    │                      │                      │
    │                   │                    │                    │                      │                    │                      │                      │
    │─────────────────────────────────────── Navigator.push() ──────────────────────────▶│                      │                      │                      │
    │                   │                    │                    │                      │                    │                      │                      │
    │                   │                    │                    │── charger() ────────▶│                      │                      │                      │
    │                   │                    │                    │                      │◀── Modèle chargé ──│                      │                      │
    │                   │                    │                    │                      │                    │                      │                      │
    │                   │                    │                    │── estUnePlante() ──▶│                      │                      │                      │
    │                   │                    │                    │                      │── Inférence ──────▶│                      │                      │
    │                   │                    │                    │                      │◀── score: 0.85 ───│                      │                      │
    │                   │                    │                    │◀── true (plante) ───│                      │                      │                      │
    │                   │                    │                    │                      │                    │                      │                      │
    │                   │                    │                    │── charger() ────────────────────────────▶│                      │                      │
    │                   │                    │                    │                      │                    │◀── Modèle chargé ────│                      │
    │                   │                    │                    │                      │                    │                      │                      │
    │                   │                    │                    │── predire() ────────────────────────────▶│                      │                      │
    │                   │                    │                    │                      │                    │── Inférence ────────▶│                      │
    │                   │                    │                    │                      │                    │◀── classe: "Tomato___Early_blight"             │
    │                   │                    │                    │◀─────────────────────────────────────────│                      │                      │
    │                   │                    │                    │                      │                    │                      │                      │
    │                   │                    │                    │── loadString() ────────────────────────────────────────────────▶│                      │
    │                   │                    │                    │                      │                    │                      │◀── JSON chargé ──────│
    │                   │                    │                    │                      │                    │                      │                      │
    │                   │                    │                    │── firstWhere() ────────────────────────────────────────────────▶│                      │
    │                   │                    │                    │◀── maladie trouvée ─────────────────────────────────────────────│                      │
    │                   │                    │                    │                      │                    │                      │                      │
    │◀── Affiche résultat ───────────────────│                    │                      │                    │                      │                      │
    │                   │                    │                    │                      │                    │                      │                      │
    │── "👍 Oui, correct" ──────────────────▶│                    │                      │                    │                      │                      │
    │                   │                    │                    │                      │                    │                      │                      │
    │                   │                    │                    │── sauvegarder() ──────────────────────────────────────────────────────────────────────▶│
    │                   │                    │                    │                      │                    │                      │                      │
    │                   │                    │                    │                      │                    │                      │◀── Stocké en JSON ───│
    │                   │                    │                    │                      │                    │                      │                      │
    │◀── ✓ Merci ──────▶│                    │                    │                      │                    │                      │                      │
    │                   │                    │                    │                      │                    │                      │                      │
    │── "Nouvelle analyse" ─────────────────▶│                    │                      │                    │                      │                      │
    │                   │                    │                    │                      │                    │                      │                      │
    │◀─────────────────────────────────────── popUntil(isFirst) ──│                      │                    │                      │                      │
    │                   │                    │                    │                      │                    │                      │                      │
```

---

## 7. Dépendances Croisées

### Matrice des Dépendances

| Fichier | Importe | Est importé par |
|---------|---------|-----------------|
| `main.dart` | `screens/accueil_screen.dart` | (point d'entrée) |
| `accueil_screen.dart` | `apercu_screen.dart`, `image_picker` | `main.dart` |
| `apercu_screen.dart` | `resultat_screen.dart` | `accueil_screen.dart` |
| `classifier.dart` | `tflite_flutter`, `image` | `resultat_screen.dart` |
| `filter_classifier.dart` | `tflite_flutter`, `image` | `resultat_screen.dart` |
| `resultat_screen.dart` | `classifier.dart`, `filter_classifier.dart`, `feedback_service.dart`, `flutter_tts` | `apercu_screen.dart` |
| `feedback_service.dart` | `shared_preferences` | `resultat_screen.dart` |

### Graphique des Dépendances

```
main.dart
  │
  └──> accueil_screen.dart
         │
         ├──> image_picker (package)
         │
         └──> apercu_screen.dart
                │
                └──> resultat_screen.dart
                       │
                       ├──> filter_classifier.dart
                       │      │
                       │      ├──> tflite_flutter (package)
                       │      │
                       │      └──> image (package)
                       │
                       ├──> classifier.dart
                       │      │
                       │      ├──> tflite_flutter (package)
                       │      │
                       │      └──> image (package)
                       │
                       ├──> feedback_service.dart
                       │      │
                       │      └──> shared_preferences (package)
                       │
                       └──> flutter_tts (package)
```

### Dépendances Externes (Packages)

| Package | Version | Utilisé par | Rôle |
|---------|---------|-------------|------|
| `image_picker` | ^1.0.4 | `accueil_screen.dart` | Accès caméra et galerie photo |
| `flutter_tts` | ^4.2.5 | `resultat_screen.dart` | Synthèse vocale (lecture des résultats) |
| `tflite_flutter` | ^0.11.0 | `classifier.dart`, `filter_classifier.dart` | Moteur d'inférence TensorFlow Lite |
| `image` | ^4.1.3 | `classifier.dart`, `filter_classifier.dart` | Manipulation d'images (décodage, resize) |
| `shared_preferences` | ^2.2.2 | `feedback_service.dart` | Stockage local clé-valeur |
| `cupertino_icons` | ^1.0.8 | (thème global) | Icônes style iOS |
| `sqflite` | ^2.3.0 | (déclaré mais non utilisé) | Base de données SQLite (futur usage) |
| `path_provider` | ^2.1.1 | (déclaré mais non utilisé) | Chemins de fichiers (futur usage) |

---

## 8. Configuration du Projet

### pubspec.yaml

**Chemin :** `pubspec.yaml`

#### Informations Générales

| Champ | Valeur |
|-------|--------|
| **Nom du package** | `madoula_project` |
| **Description** | Application mobile de détection de maladies agricoles - IAI Cameroun 2025 |
| **Version** | 1.0.0+1 |
| **SDK Dart** | ^3.11.4 |

#### Dépendances Principales

```yaml
dependencies:
  flutter:
    sdk: flutter

  # Capture photo
  image_picker: ^1.0.4

  # Synthèse vocale
  flutter_tts: ^4.2.5

  # Base de données SQLite (déclaré mais non utilisé)
  sqflite: ^2.3.0
  path_provider: ^2.1.1

  # TensorFlow Lite pour l'IA
  tflite_flutter: ^0.11.0
  image: ^4.1.3

  # Stockage local
  shared_preferences: ^2.2.2

  # Icônes iOS
  cupertino_icons: ^1.0.8
```

#### Assets Déclarés

```yaml
flutter:
  assets:
    - assets/maladies_madoula.json
    - assets/madoula_compat.tflite
    - assets/class_indices.json
    - assets/filtre_model.tflite
    - assets/filtre_indices.json
```

### analysis_options.yaml

**Chemin :** `analysis_options.yaml`

Fichier de configuration du linter Dart. Utilise les règles par défaut de Flutter avec potentiellement des règles personnalisées.

---

## 9. Observations et Problèmes Potentiels

### 9.1 Bugs Identifiés

#### BUG 1 : Test défectueux
**Fichier :** `test/widget_test.dart`  
**Problème :** Le test référence `MyApp` qui n'existe pas (la classe s'appelle `MadoulaApp` dans `main.dart`).  
**Impact :** Le test échouera à l'exécution.  
**Solution :** Remplacer `MyApp` par `MadoulaApp` et adapter le test à la logique réelle de l'app.

#### BUG 2 : `_confianceModele` jamais assigné
**Fichier :** `lib/screens/resultat_screen.dart`  
**Problème :** La variable `_confianceModele` est déclarée à `0.0` mais jamais mise à jour avec la vraie confiance du modèle.  
**Impact :** Tous les feedbacks sont sauvegardés avec `confiance: 0.0`, rendant cette donnée inutile.  
**Solution :** Utiliser `predireAvecConfiance()` au lieu de `predire()` dans `lancerAnalyse()` et assigner le résultat à `_confianceModele`.

#### BUG 3 : Synthèse vocale toujours en français
**Fichier :** `lib/screens/resultat_screen.dart`  
**Problème :** `lireVoixHaute()` utilise toujours `'fr-FR'` même si l'utilisateur a choisi EWO ou FUL.  
**Impact :** La lecture vocale ne correspond pas à la langue choisie.  
**Solution :** Mapper la langue choisie à un code de langue TTS (ex: `EWO` → langue locale si supportée, sinon fallback FR).

### 9.2 Incohérences

#### Incohérence 1 : Seuils de confiance différents
**Fichier :** `lib/screens/classifier.dart`  
**Problème :** `predire()` utilise un seuil de 30% (`maxScore < 0.30`) alors que `predireAvecConfiance()` utilise 60% (`maxScore < 0.60`). Les commentaires mentionnent 60% dans les deux cas.  
**Impact :** Comportement inattendu selon la méthode utilisée.  
**Solution :** Harmoniser les seuils et corriger les commentaires.

#### Incohérence 2 : Dépendances inutilisées
**Fichier :** `pubspec.yaml`  
**Problème :** `sqflite` et `path_provider` sont déclarés mais jamais importés dans le code.  
**Impact :** Augmente la taille de l'application et le temps de build sans bénéfice.  
**Solution :** Supprimer ces dépendances si elles ne sont pas prévues pour une future fonctionnalité.

### 9.3 Améliorations Potentielles

#### Amélioration 1 : Instance unique des classifieurs
**Problème :** `FiltreClassifier` et `Classifier` sont créés et détruits à chaque analyse.  
**Impact :** Temps de chargement du modèle à chaque analyse (lent).  
**Solution :** Implémenter un pattern Singleton ou garder les instances en mémoire pour réutilisation.

#### Amélioration 2 : Gestion d'état globale
**Problème :** Les données sont passées via les constructeurs (prop drilling).  
**Impact :** Difficile à maintenir si l'app grandit.  
**Solution :** Utiliser un gestionnaire d'état comme Provider, Riverpod ou Bloc.

#### Amélioration 3 : Mise en cache des résultats
**Problème :** Les analyses ne sont pas stockées localement.  
**Impact :** L'utilisateur ne peut pas revoir ses anciens diagnostics.  
**Solution :** Utiliser `sqflite` (déjà déclaré) pour stocker l'historique des analyses.

#### Amélioration 4 : Export des feedbacks
**Problème :** Les feedbacks sont stockés localement mais ne peuvent pas être exportés.  
**Impact :** Impossible de collecter les données pour améliorer le modèle.  
**Solution :** Ajouter une fonctionnalité d'export JSON ou d'envoi à un serveur.

#### Amélioration 5 : Support TTS multilingue
**Problème :** La synthèse vocale ne supporte que le français.  
**Impact :** Les utilisateurs EWO et FUL ne peuvent pas entendre les résultats dans leur langue.  
**Solution :** Vérifier les langues supportées par `flutter_tts` et mapper en conséquence.

### 9.4 Points Forts

✅ **Architecture claire et simple** : Séparation logique entre UI, IA et services  
✅ **Multilingue** : Support de 3 langues locales (FR, EWO, FUL)  
✅ **Filtre plante/non-plante** : Évite les analyses inutiles  
✅ **Feedback utilisateur** : Permet de collecter des données pour améliorer le modèle  
✅ **Synthèse vocale** : Accessibilité pour les utilisateurs analphabètes  
✅ **Traitements locaux** : Recommandations pratiques et accessibles  
✅ **Base de données complète** : 22 maladies avec symptômes et traitements détaillés  
✅ **Thème cohérent** : Design Material 3 avec couleur verte thématique agriculture  

---

## 10. Résumé Exécutif

**Madoula** est une application mobile Flutter de diagnostic de maladies agricoles par IA, conçue pour le contexte camerounais. Elle utilise deux modèles TensorFlow Lite embarqués : un filtre binaire (plante/non-plante) et un classeur de 22 maladies. L'application supporte 3 langues (Français, Ewondo, Fulfulde) et fournit des symptômes et traitements locaux pour chaque maladie détectée.

### Flux Principal
1. **Accueil** → Capture photo + sélection langue
2. **Aperçu** → Vérification de la qualité de la photo
3. **Résultat** → Analyse IA (filtre → classeur → lookup JSON) → Affichage symptômes/traitements → Feedback

### Technologies Clés
- **Flutter/Dart** : Framework UI cross-platform
- **TensorFlow Lite** : Inférence IA sur mobile
- **SharedPreferences** : Stockage local des feedbacks
- **Flutter TTS** : Synthèse vocale

### Métriques
- **7 plantes** couvertes (Maïs, Agrumes, Poivron, Pomme de terre, Soja, Fraise, Tomate)
- **22 classes** de classification (15 maladies + 7 états sains)
- **3 langues** supportées (FR, EWO, FUL)
- **6 fichiers assets** (2 modèles TFLite, 2 JSON de mapping, 1 base de données maladies, 1 JSON de filtre)
- **7 fichiers source** (1 main, 3 screens, 2 classifieurs, 1 service)
