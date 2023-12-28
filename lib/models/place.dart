import 'package:equatable/equatable.dart';
import 'package:petri_net_with_conflicts/models/transition.dart';

class Place extends Equatable {
  final String id;
  int markersNumber;
  final List<Transition> inputTransitions;
  final List<Transition> outputTransitions;

  Place({
    required this.id,
    this.markersNumber = 0,
    this.inputTransitions = const [],
    this.outputTransitions = const [],
  });

  @override
  List<Object?> get props => [
        id,
        markersNumber,
      ];
}
