import 'package:petri_net_with_conflicts/models/place.dart';

final places = <String, Place>{
  'entry_project': Place(
    id: '1',
    markersNumber: 1,
  ),
  'queue': Place(
    id: '2',
    markersNumber: 0,
  ),
  'first_department_check': Place(
    id: '3',
    markersNumber: 0,
  ),
  'second_department_check': Place(
    id: '4',
    markersNumber: 0,
  ),
  'first_dep_success_number': Place(
    id: '5',
    markersNumber: 0,
  ),
  'second_dep_success_number': Place(
    id: '6',
    markersNumber: 0,
  ),
  'first_dep_failed_check': Place(
    id: '7',
    markersNumber: 0,
  ),
  'second_dep_failed_check': Place(
    id: '8',
    markersNumber: 0,
  ),
  'first_dep_failed_check_num': Place(
    id: '9',
    markersNumber: 0,
  ),
  'second_dep_failed_check_num': Place(
    id: '10',
    markersNumber: 0,
  ),
  'first_dep_free': Place(
    id: '11',
    markersNumber: 1,
  ),
  'second_dep_free': Place(
    id: '12',
    markersNumber: 1,
  ),
};
