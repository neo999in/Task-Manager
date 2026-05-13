import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const TaskCard({
    Key? key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isOverdue = task.date.isBefore(DateTime.now()) && !task.isCompleted;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: onToggle,
                  child: Container(
                    margin: const EdgeInsets.only(top: 2, right: 16),
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: task.isCompleted ? Colors.green : Colors.grey[400]!,
                        width: 2,
                      ),
                      color: task.isCompleted ? Colors.green : Colors.transparent,
                    ),
                    child: task.isCompleted
                        ? const Icon(Icons.check, size: 18, color: Colors.white)
                        : null,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              task.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                                color: task.isCompleted ? Colors.grey[500] : Colors.black87,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: task.isCompleted 
                                  ? Colors.green.withOpacity(0.1) 
                                  : (isOverdue ? Colors.red.withOpacity(0.1) : Colors.orange.withOpacity(0.1)),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              task.isCompleted ? 'Done' : (isOverdue ? 'Overdue' : 'Pending'),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: task.isCompleted 
                                    ? Colors.green 
                                    : (isOverdue ? Colors.red : Colors.orange),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (task.description.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          task.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: task.isCompleted 
                                ? Colors.grey[400] 
                                : (isOverdue ? Colors.red[300] : Colors.grey[500]),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            DateFormat('MMM dd, yyyy - hh:mm a').format(task.date),
                            style: TextStyle(
                              fontSize: 13,
                              color: task.isCompleted 
                                  ? Colors.grey[500] 
                                  : (isOverdue ? Colors.red[400] : Colors.grey[600]),
                              fontWeight: isOverdue && !task.isCompleted ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: onDelete,
                            child: const Icon(
                              Icons.delete_outline,
                              size: 22,
                              color: Colors.redAccent,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
