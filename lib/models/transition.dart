class Transition {
  final String id;
  final String name;
  final List<int> inputPlacesIds;
  final List<int> outputPlacesIds;
  final int delay;
  int currentIterations = 0;

  final String? conflictTransitionId;
  final double? probabilityChance;

  bool isTransitionRunning = false;
  bool isTransitionSkipped = false;

  Transition({
    required this.id,
    required this.name,
    this.inputPlacesIds = const [],
    this.outputPlacesIds = const [],
    this.delay = 0,
    this.probabilityChance,
    this.conflictTransitionId,
  });

  Future<void> run() async {
    //isTransitionRunning = true;
    //await Future.delayed(delay);
    // clearInputPlaces();
    //isTransitionRunning = false;
  }

  @override
  String toString() {
    return 'id: $id, name: $name, is running: $isTransitionRunning, is skipped: $isTransitionSkipped';
  }
}
