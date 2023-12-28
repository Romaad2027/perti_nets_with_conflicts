import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

class Place extends Equatable {
  final String name;

  Place(this.name);

  @override
  // TODO: implement props
  List<Object?> get props => [name];
}

class Transition extends Equatable {
  final List<Place> inputPlaces;
  final List<Place> outputPlaces;

  Transition(this.inputPlaces, this.outputPlaces);

  @override
  List<Object?> get props => [inputPlaces, outputPlaces];
}

void main() {
  // Створення об'єктів Transition
  List<Transition> transitions = [
    Transition(
      [Place('A'), Place('B'), Place('C')],
      [Place('X'), Place('Y'), Place('A')],
    ),
    Transition(
      [Place('X'), Place('Y'), Place('A')],
      [Place('A'), Place('B'), Place('Z')],
    ),
    // Додайте інші об'єкти Transition сюди
  ];

  // Візьмемо перший об'єкт Transition для порівняння
  Transition? firstTransition = transitions.isNotEmpty ? transitions[0] : null;

  if (firstTransition != null) {
    // Знайдемо об'єкти Transition, у яких inputPlaces співпадають з outputPlaces першого об'єкта Transition
    List<Transition> matchingTransitions = transitions.where((transition) {
      return ListEquality().equals(firstTransition.outputPlaces, transition.inputPlaces);
    }).toList();

    // Виведемо знайдені об'єкти Transition
    print('Знайдені об\'єкти Transition:');
    for (var transition in matchingTransitions) {
      print('InputPlaces: ${transition.inputPlaces.map((place) => place.name)}');
      print('OutputPlaces: ${transition.outputPlaces.map((place) => place.name)}');
    }
  } else {
    print('Список Transition порожній');
  }
}
