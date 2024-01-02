import 'package:habit_tracker/datetime/date_time.dart';
import 'package:hive_flutter/hive_flutter.dart';

final _myBox = Hive.box("Habit_Database");

class HabitDatabase {
  List todaysHabitList = [];
  Map<DateTime, int> heatMapDataSet = {};

  // create init default data
  void createDefaultDatabase() {
    todaysHabitList = [
      // [habit name, habit completed]
      ["Morning Run", false],
      ["Drink Water", false],
      ["Read Book", false],
      ["Meditate", false],
      ["Eat Healthy", false],
      ["Sleep Early", false],
    ];
  }

  // load data if it already exists
  void loadData() {
    if (_myBox.get(todaysDateFormatted()) == null) {
      todaysHabitList = _myBox.get("CURRENT_HABBIT_LIST");

      for (int i = 0; i < todaysHabitList.length; i++) {
        todaysHabitList[i][1] = false;
      }
    } else {
      todaysHabitList = _myBox.get(todaysDateFormatted());
    }
  }

  // update database
  void updateDatabase() {
    // update todays entry
    _myBox.put(todaysDateFormatted(), todaysHabitList);

    // update universal entry
    _myBox.put("CURRENT_HABBIT_LIST", todaysHabitList);

    // calculate habit complete percentages for each day
    calculateHabitPercentage();
    // load heat map
  }

  void calculateHabitPercentage() {
    int countCompleted = 0;
    for (int i = 0, len = todaysHabitList.length; i < len; i++) {
      if (todaysHabitList[i][1] == true) {
        countCompleted++;
      }
    }

    String percent = todaysHabitList.isEmpty
        ? '0.0'
        : (countCompleted / todaysHabitList.length).toStringAsFixed(1);

    _myBox.put("HABBIT_PERCENTAGE_${todaysDateFormatted()}", percent);
  }

  void loadHeatMap() {
    DateTime startDate = createDateTimeObject(_myBox.get("START_DATE"));

    // count the number of days to load
    int daysInBetween = DateTime.now().difference(startDate).inDays;

    // go from start date to today and add each percentage to the dataset
    // "PERCENTAGE_SUMMARY_yyyymmdd" will be the key in the database
    for (int i = 0; i < daysInBetween + 1; i++) {
      String yyyymmdd = convertDateTimeToString(
        startDate.add(Duration(days: i)),
      );

      double strengthAsPercent = double.parse(
        _myBox.get("PERCENTAGE_SUMMARY_$yyyymmdd") ?? "0.0",
      );

      // split the datetime up like below so it doesn't worry about hours/mins/secs etc.

      // year
      int year = startDate.add(Duration(days: i)).year;

      // month
      int month = startDate.add(Duration(days: i)).month;

      // day
      int day = startDate.add(Duration(days: i)).day;

      final percentForEachDay = <DateTime, int>{
        DateTime(year, month, day): (10 * strengthAsPercent).toInt(),
      };

      heatMapDataSet.addEntries(percentForEachDay.entries);
      print(heatMapDataSet);
    }
  }
}
