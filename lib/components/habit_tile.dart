import "package:flutter/material.dart";
import "package:flutter_slidable/flutter_slidable.dart";

class HabitTile extends StatelessWidget {
  final String habitname;
  final bool habitCompleted;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? onEdit;
  final Function(BuildContext)? onDelete;

  const HabitTile(
      {super.key,
      required this.habitname,
      required this.habitCompleted,
      required this.onChanged,
      required this.onEdit,
      required this.onDelete
      });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Slidable(
        endActionPane: ActionPane(motion: StretchMotion(), children: [
          SlidableAction(
            onPressed: onEdit,
            icon: Icons.edit,
            foregroundColor: Colors.blue[900],
            label: "Edit",
            borderRadius: BorderRadius.circular(12),
            backgroundColor: Colors.blue.shade100,
          ),
          SlidableAction(
            onPressed: onDelete,
            icon: Icons.delete,
            foregroundColor: Colors.green[900],
            label: "Delete",
            borderRadius: BorderRadius.circular(12),
            backgroundColor: Colors.green.shade100,
          ),
        ]),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              // checkbox
              Checkbox(
                value: habitCompleted,
                onChanged: onChanged,
              ),

              // habit name
              Text(habitname)
            ],
          ),
        ),
      ),
    );
  }
}
