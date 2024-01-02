import 'dart:async';
import 'dart:math';

import 'package:petri_net_with_conflicts/models/place.dart';
import 'package:petri_net_with_conflicts/models/transition.dart';

class PetriNet {
  final List<Transition> transitions;
  final List<Place> places;

  const PetriNet({required this.transitions, required this.places});

  void runTransition(int index) {
    transitions[index].isTransitionRunning = true;
    if (transitions[index].currentIterations == 0) {
      clearInputPlaces(index);
    }
    if (transitions[index].delay == transitions[index].currentIterations) {
      addMarkersToOutput(index);
      transitions[index].isTransitionRunning = false;
      transitions[index].currentIterations = 0;
    } else {
      transitions[index].currentIterations++;
    }
  }

  void clearInputPlaces(int index) {
    for (var inputPlaceId in transitions[index].inputPlacesIds) {
      places[getPlaceIndex(inputPlaceId)].markersNumber -= 1;
    }
  }

  void addMarkersToOutput(int index) {
    for (var outputPlaceId in transitions[index].outputPlacesIds) {
      places[getPlaceIndex(outputPlaceId)].markersNumber += 1;
    }
  }

  Future<void> run() async {
    int iterations = 0;
    while (iterations != 100) {
      iterations++;
      print('Iteration #$iterations');
      final indexesOfTransition = <int>[];
      for (int i = 0; i < transitions.length; i++) {
        if (transitions[i].isTransitionSkipped) {
          transitions[i].isTransitionSkipped = false;
          continue;
        }
        if (transitions[i].isTransitionRunning) {
          if (transitions[i].delay != 0) {
            indexesOfTransition.add(i);
          }
          continue;
        }
        bool isTransitionAvailable = true;
        for (final inputPlaceId in transitions[i].inputPlacesIds) {
          if (places[getPlaceIndex(inputPlaceId)].markersNumber == 0) {
            isTransitionAvailable = false;
          }
        }
        if (!isTransitionAvailable) {
          continue;
        }

        if (transitions[i].conflictTransitionId != null) {
          final conflictTnIndex = transitions.indexWhere((t) => t.id == transitions[i].conflictTransitionId);
          final isConTAvailable = checkIfConflictTrAvailable(transitions[conflictTnIndex]);

          if (isConTAvailable) {
            final skip = resolveConflict([transitions[i], transitions[conflictTnIndex]]);
            if (!skip) {
              transitions[conflictTnIndex].isTransitionSkipped = true;
            } else {
              continue;
            }
          }
        }
        indexesOfTransition.add(i);
      }
      for (var index in indexesOfTransition) {
        runTransition(index);
      }
      printResults();
      print('\n');
    }
  }

  bool checkIfConflictTrAvailable(Transition conflictTransition) {
    /// All input places of transition should have at least 1 marker
    /// so that transition is ready to run and can cause conflict
    return conflictTransition.inputPlacesIds.every((id) => places[getPlaceIndex(id)].markersNumber != 0) &&
        !conflictTransition.isTransitionRunning;
  }

  // if true - current transition lost conflict
  bool resolveConflict(List<Transition> conflictTransitions) {
    final double randomValue = Random().nextDouble();
    if (randomValue <= conflictTransitions[0].probabilityChance!) {
      return false;
    } else {
      return true;
    }
  }

  int getPlaceIndex(int id) => places.indexWhere((p) => p.id == id);

  void printResults() {
    for (var place in places) {
      print(place.toString());
    }
  }
}

void main() {
  final places = [
    Place(id: 1, markersNumber: 10, name: 'Entry'),
    Place(id: 2, markersNumber: 0, name: 'Queue'),
    Place(id: 3, markersNumber: 0, name: '1st dep check'),
    Place(id: 4, markersNumber: 0, name: '2nd dep check'),
    Place(id: 5, markersNumber: 0, name: '1st Dep pass checks'),
    Place(id: 6, markersNumber: 0, name: '2nd Dep pass check'),
    Place(id: 7, markersNumber: 0, name: '1st dep failed check'),
    Place(id: 8, markersNumber: 0, name: '2nd Dep failed check'),
    Place(id: 9, markersNumber: 0, name: '1st dep failed checks num'),
    Place(id: 10, markersNumber: 0, name: '2nd dep failed checks num'),
    Place(id: 11, markersNumber: 1, name: 'Free 1st dep'),
    Place(id: 12, markersNumber: 1, name: 'Free 2nd dep'),
  ];
  final transitions = <Transition>[
    Transition(
      id: '1',
      name: 'Entry Queue',
      inputPlacesIds: [1],
      outputPlacesIds: [2],
    ),
    Transition(
      id: '2',
      name: 'First department check',
      inputPlacesIds: [
        2,
        11,
      ],
      outputPlacesIds: [3],
      probabilityChance: 0.5,
      conflictTransitionId: '3',
      delay: 3,
    ),
    Transition(
      id: '3',
      name: 'Second department check',
      inputPlacesIds: [
        2,
        12,
      ],
      outputPlacesIds: [4],
      probabilityChance: 0.5,
      delay: 2,
    ),
    Transition(
      id: '4',
      name: 'First Dep pass check',
      inputPlacesIds: [3],
      outputPlacesIds: [
        5,
        11,
      ],
      probabilityChance: 0.8,
      conflictTransitionId: '5',
    ),
    Transition(
      id: '5',
      name: 'First Dep fail check',
      inputPlacesIds: [3],
      outputPlacesIds: [
        7,
        11,
      ],
      probabilityChance: 0.2,
    ),
    Transition(
      id: '6',
      name: 'Second Dep pass check',
      inputPlacesIds: [4],
      outputPlacesIds: [
        6,
        12,
      ],
      probabilityChance: 0.8,
      conflictTransitionId: '7',
    ),
    Transition(
      id: '7',
      name: 'Second Dep fail check',
      inputPlacesIds: [4],
      outputPlacesIds: [
        8,
        12,
      ],
      probabilityChance: 0.2,
    ),
    Transition(
      id: '8',
      name: 'First Dep project fix',
      inputPlacesIds: [7],
      outputPlacesIds: [
        9,
        2,
      ],
    ),
    Transition(
      id: '9',
      name: 'Second Dep project fix',
      inputPlacesIds: [8],
      outputPlacesIds: [
        10,
        2,
      ],
    ),
  ];
  final petriNet = PetriNet(transitions: transitions, places: places);
  petriNet.run();
}
