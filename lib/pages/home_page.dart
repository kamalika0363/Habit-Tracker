import "package:flutter/material.dart";
import "package:habit_tracker/components/habit_tile.dart";
import "package:habit_tracker/components/monthly_summary.dart";
import "package:habit_tracker/components/my_fab.dart";
import 'package:habit_tracker/components/my_alert_box.dart';
import "package:habit_tracker/data/habit_database.dart";
import "package:hive/hive.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // data string for todays list
  HabitDatabase habitDatabase = HabitDatabase();
  final _myBox = Hive.box("Habit_Database");

  @override
  void initState() {
    if (_myBox.get("CURRENT_HABBIT_LIST") == null) {
      habitDatabase.createDefaultDatabase();
    } else {
      habitDatabase.loadData();
    }

    habitDatabase.updateDatabase();
    super.initState();
  }

  // bool to control habit completed
  bool habitCompleted = false;

  // checkbox was tapped
  void checkboxTapped(bool? value, int index) {
    setState(() {
      // getting the index of the habbit we are looking for
      // and changing the value of the completed
      // [index][1] is the completed value from here "[habit name, habit completed]"
      habitDatabase.todaysHabitList[index][1] = value!;
    });
    habitDatabase.updateDatabase();
  }

  // create a new habit
  final _newHabitNameController = TextEditingController();

  void createNewHabit() {
    // show alert dialog for user to enter the new habit details
    showDialog(
      context: context,
      builder: (context) {
        return MyAlertBox(
          controller: _newHabitNameController,
          hintText: "Enter New Habit",
          onSave: saveNewHabit,
          onCancel: cancelDialogBox,
        );
      },
    );
    habitDatabase.updateDatabase();
  }

  // save the new habit
  void saveNewHabit() {
    // add the new habit to the list
    setState(() {
      // [habit name, habit completed]
      habitDatabase.todaysHabitList.add([_newHabitNameController.text, false]);
    });

    habitDatabase.updateDatabase();

    // clear the text field
    _newHabitNameController.clear();

    // close the dialog
    Navigator.pop(context);
  }

  // cancel the new habit
  void cancelDialogBox() {
    _newHabitNameController.clear();
    Navigator.pop(context);
  }

  // edit a habit
  void openHabitEdit(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return MyAlertBox(
            controller: _newHabitNameController,
            hintText: habitDatabase.todaysHabitList[index][0],
            onSave: () => saveExistingHabit(index),
            onCancel: cancelDialogBox,
          );
        });
    _newHabitNameController.clear();
  }

  // save the existing habit
  void saveExistingHabit(int index) {
    // add the new habit to the list
    setState(() {
      // [habit name, habit completed]
      habitDatabase.todaysHabitList[index][0] = _newHabitNameController.text;
    });
    _newHabitNameController.clear();

    // close the dialog
    Navigator.pop(context);
    habitDatabase.updateDatabase();
  }

  // delete a habit
  void openHabitDelete(int index) {
    setState(() {
      habitDatabase.todaysHabitList.removeAt(index);
    });
    habitDatabase.updateDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(224, 224, 224, 1),
      floatingActionButton: MyFloatingActionButton(onPressed: createNewHabit),
      body: ListView(
        children: [
          // header
          Container(
            padding: const EdgeInsets.only(top: 25, bottom: 5),
            child: const Center(
              child: Text(
                "Habit Tracker",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // monthly summary
          MonthlySummary(
            datasets: habitDatabase.heatMapDataSet,
            startDate: "20210101",
          ),

          // list of habits
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: habitDatabase.todaysHabitList.length,
            itemBuilder: (context, index) {
              return HabitTile(
                habitname: habitDatabase.todaysHabitList[index][0],
                habitCompleted: habitDatabase.todaysHabitList[index][1],
                onChanged: (value) => checkboxTapped(value, index),
                onEdit: (context) => openHabitEdit(index),
                onDelete: (context) => openHabitDelete(index),
              );
            },
          ),
        ],
      ),
    );
  }
}
