import 'package:equatable/equatable.dart';
import 'package:petri_net_with_conflicts/models/transition.dart';

class Place extends Equatable {
  final int id;
  final String name;
  int markersNumber;
  final List<Transition> inputTransitions;
  final List<Transition> outputTransitions;

  Place({
    required this.id,
    required this.name,
    this.markersNumber = 0,
    this.inputTransitions = const [],
    this.outputTransitions = const [],
  });

  @override
  String toString() {
    return 'id: $id, name: $name, markers number: $markersNumber';
  }

  @override
  List<Object?> get props => [
        id,
        markersNumber,
      ];
}
