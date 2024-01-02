import 'package:petri_net_with_conflicts/models/petri_net.dart';
import 'package:petri_net_with_conflicts/models/place.dart';
import 'package:petri_net_with_conflicts/models/transition.dart';

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
