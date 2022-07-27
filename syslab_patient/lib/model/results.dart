
import 'package:patient/model/admin_result.dart';
import 'package:patient/model/patient_result.dart';

class Results {
  final ResultsInfo info;
  final AdminRes adminRes;
  final PatientRes patientRes;
  final List<ResultsItem> items;

  const Results({
    this.info,
    this.adminRes,
    this.patientRes,
    this.items,
  });
}

class ResultsInfo {
  final String description;
  final String number;
  final DateTime date;

  const ResultsInfo({
    this.description,
    this.number,
    this.date,
  });
}

class ResultsItem {
  final String description;
  final DateTime date;
  // final double price;

  const ResultsItem({
    this.description,
    this.date,
    // this.price,
  });
}
