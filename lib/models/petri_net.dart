import 'dart:async';
import 'dart:math';

import 'package:petri_net_with_conflicts/models/place.dart';
import 'package:petri_net_with_conflicts/models/transition.dart';
import 'package:petri_net_with_conflicts/utils.dart';

class PetriNet {
  final List<Transition> transitions;
  final List<Place> places;

  const PetriNet({required this.transitions, required this.places});

  Future<void> runTransition(int index) async {
    transitions[index].isTransitionRunning = true;
    await transitions[index].run();
    transitions[index].clearInputPlaces();
    transitions[index].addMarkersToOutput();
    if (index < transitions.length - 1) {}

    // for (var outputPlace in transitions[index].outputPlaces) {
    //   if (transition2.inputPlaces.any((inputPlace) => inputPlace.name == outputPlace.name)) {
    //     commonPlaces.add(outputPlace);
    //   }
    // }

    // List<Transition> matchingTransitions = transitions.where((transition) {
    //   return const ListEquality().equals(transitions[index].outputPlaces, transition.inputPlaces);
    // }).toList();

    transitions[index].isTransitionRunning = false;
  }

  void run() {
    while (true) {
      for (int i = 0; i <= transitions.length; i++) {
        if (transitions[i].isTransitionSkipped) {
          transitions[i].isTransitionSkipped = false;
          continue;
        }
        if (transitions[i].isTransitionRunning) {
          continue;
        }
        bool isTransitionAvailable = true;
        for (final inputPlace in transitions[i].inputPlaces) {
          if (inputPlace.markersNumber == 0) {
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
              removeMarkerFromConflictPlace(i, conflictTnIndex);
            } else {
              continue;
            }
          }
        }

        unawaited(transitions[i].run());
      }
    }
  }

  bool checkIfConflictTrAvailable(Transition conflictTransition) {
    // final conflictTransition = transitions.firstWhereOrNull(
    //   (t) => t.id != transitionId && t.inputPlaces.any((iP) => iP.id == inputPlace.id),
    // );
    // if (conflictTransition == null) {
    //   return '';
    // }

    /// All input places of transition should have at least 1 marker
    /// so that transition is ready to run and can cause conflict
    return conflictTransition.inputPlaces.every((iP) => iP.markersNumber != 0);
    //   return conflictTransition.id;
    // }
    //return '';
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

  void removeMarkerFromConflictPlace(int index, int conflictIndex) {
    final transition = transitions[index];
    final inputPlaceIndex =
        transitions[conflictIndex].inputPlaces.indexWhere((iP) => transition.inputPlaces.any((ip) => ip.id == iP.id));
    transitions[conflictIndex].clearPlace(inputPlaceIndex);
  }
}

void main() {
  final transitions = <Transition>[
    Transition(
      id: '1',
      name: 'Entry Queue',
      inputPlaces: [places['entry_project']!],
      outputPlaces: [places['queue']!],
    ),
    Transition(
      id: '2',
      name: 'First department check',
      inputPlaces: [
        places['queue']!,
        places['first_dep_free']!,
      ],
      outputPlaces: [places['first_department_check']!],
      probabilityChance: 0.5,
      conflictTransitionId: '3',
    ),
    Transition(
      id: '3',
      name: 'Second department check',
      inputPlaces: [
        places['queue']!,
        places['second_dep_free']!,
      ],
      outputPlaces: [places['second_department_check']!],
      probabilityChance: 0.5,
    ),
    Transition(
      id: '4',
      name: 'First Dep pass check',
      inputPlaces: [places['first_department_check']!],
      outputPlaces: [
        places['first_dep_success_number']!,
        places['first_dep_free']!,
      ],
      probabilityChance: 0.9,
      conflictTransitionId: '5',
    ),
    Transition(
      id: '5',
      name: 'First Dep fail check',
      inputPlaces: [places['first_department_check']!],
      outputPlaces: [
        places['first_dep_failed_check']!,
        places['first_dep_free']!,
      ],
      probabilityChance: 0.1,
    ),
    Transition(
      id: '6',
      name: 'Second Dep pass check',
      inputPlaces: [places['second_department_check']!],
      outputPlaces: [
        places['second_dep_success_number']!,
        places['second_dep_free']!,
      ],
      probabilityChance: 0.9,
      conflictTransitionId: '7',
    ),
    Transition(
      id: '7',
      name: 'Second Dep fail check',
      inputPlaces: [places['second_department_check']!],
      outputPlaces: [
        places['second_dep_failed_check']!,
        places['second_dep_free']!,
      ],
      probabilityChance: 0.1,
    ),
    Transition(
      id: '8',
      name: 'First Dep project fix',
      inputPlaces: [places['first_dep_failed_check']!],
      outputPlaces: [
        places['first_dep_failed_check_num']!,
        places['queue']!,
      ],
    ),
    Transition(
      id: '9',
      name: 'Second Dep project fix',
      inputPlaces: [places['second_dep_failed_check']!],
      outputPlaces: [
        places['second_dep_failed_check_num']!,
        places['queue']!,
      ],
    ),
  ];
  //final petriNet = PetriNet(transitions: []);
}
