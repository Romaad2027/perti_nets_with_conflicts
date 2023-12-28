import 'package:petri_net_with_conflicts/models/place.dart';

class Transition {
  final String id;
  final String name;
  final List<Place> inputPlaces;
  final List<Place> outputPlaces;
  final Duration delay;

  final String? conflictTransitionId;
  final double? probabilityChance;

  bool isTransitionRunning = false;
  bool isTransitionSkipped = false;

  Transition({
    required this.id,
    required this.name,
    this.inputPlaces = const [],
    this.outputPlaces = const [],
    this.delay = const Duration(milliseconds: 100),
    this.probabilityChance,
    this.conflictTransitionId,
  });

  Future<void> run() async {
    isTransitionRunning = true;
    await Future.delayed(delay);
    clearInputPlaces();
    isTransitionRunning = false;
  }

  void clearInputPlaces() {
    for (int i = 0; i <= inputPlaces.length; i++) {
      inputPlaces[i].markersNumber -= 1;
    }
  }

  void clearPlace(int index) {
    inputPlaces[index].markersNumber -= 1;
  }

  void addMarkersToOutput() {
    for (int i = 0; i <= outputPlaces.length; i++) {
      outputPlaces[i].markersNumber += 1;
    }
  }
}
