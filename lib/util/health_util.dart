import 'package:health/health.dart';

class HealthUtil {
  final DateTime _startTime;
  final DateTime _finishTime;
  List<HealthDataPoint> _healthDataList = [];
  int _steps = 0;

  HealthUtil(this._startTime, this._finishTime);

  Future<void> fetchData() async {
    HealthFactory health = HealthFactory();

    // Define thne types to get.
    List<HealthDataType> types = [
      HealthDataType.STEPS,
      HealthDataType.WEIGHT,
      HealthDataType.HEIGHT,
      HealthDataType.BLOOD_GLUCOSE,
      //HealthDataType.DISTANCE_WALKING_RUNNING,
    ];

    // You MUST request access to the data types before reading them
    bool accessWasGranted = await health.requestAuthorization(types);

    if (accessWasGranted) {
      try {
        // Fetch new data
        List<HealthDataPoint> healthData =
            await health.getHealthDataFromTypes(_startTime, _finishTime, types);

        // Save all the new data points
        _healthDataList.addAll(healthData);
      } catch (e) {
        print("Caught exception in getHealthDataFromTypes: $e");
      }

      // Filter out duplicates
      _healthDataList = HealthFactory.removeDuplicates(_healthDataList);

      // Print the results
      _healthDataList.forEach((x) {
        print("Data point: $x");
        _steps += (x.value as int);
      });

      print("Step: $_steps");
    }
  }

  int getStep() {
    return _steps;
  }
}
