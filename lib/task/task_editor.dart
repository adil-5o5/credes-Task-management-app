import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';

// editor for making / updating a task, kept readable
class TaskEditor extends StatefulWidget {
  final int listid;
  final Task? existing;

  const TaskEditor({super.key, required this.listid, this.existing});

  @override
  State<TaskEditor> createState() => _TaskEditorState();
}

class _TaskEditorState extends State<TaskEditor> {
  final form = GlobalKey<FormState>();
  late TextEditingController title;
  late TextEditingController desc;

  DateTime? due;
  int priority = 1;

  @override
  void initState() {
    super.initState();
    title = TextEditingController(text: widget.existing?.title ?? '');
    desc = TextEditingController(text: widget.existing?.description ?? '');

    if (widget.existing?.dueDate != null) {
      due = DateTime.fromMillisecondsSinceEpoch(widget.existing!.dueDate!);
    }

    priority = widget.existing?.priority ?? 1;
  }

  @override
  void dispose() {
    title.dispose();
    desc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(
        title: isEdit ? 'Edit Task' : 'New Task',
        isDark: isDark,
      ),
      body: Form(
        key: form,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            CustomTextField(
              labelText: 'Title',
              hintText: 'Enter task title',
              controller: title,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Title is required' : null,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              labelText: 'Description',
              hintText: 'Enter task description (optional)',
              controller: desc,
              maxLines: 4,
            ),
            const SizedBox(height: 24),
            // Due date picker
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final now = DateTime.now();
                      final picked = await showDatePicker(
                        context: context,
                        firstDate: now.subtract(const Duration(days: 365)),
                        lastDate: now.add(const Duration(days: 365 * 5)),
                        initialDate: due ?? now,
                        builder: (context, child) {
                          return Theme(
                            data: isDark
                                ? ThemeData.dark().copyWith(
                                    colorScheme: const ColorScheme.dark(
                                      primary: Colors.white,
                                      onPrimary: Colors.black,
                                    ),
                                  )
                                : ThemeData.light().copyWith(
                                    colorScheme: const ColorScheme.light(
                                      primary: Colors.black,
                                      onPrimary: Colors.white,
                                    ),
                                  ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        setState(() => due = picked);
                      }
                    },
                    icon: Icon(
                      Icons.calendar_today,
                      size: 18,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    label: Text(
                      due == null
                          ? 'Set Due Date'
                          : due.toString().split(' ').first,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(
                        color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Priority dropdown
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<int>(
                    value: priority,
                    underline: const SizedBox(),
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    items: const [
                      DropdownMenuItem(value: 0, child: Text('Low')),
                      DropdownMenuItem(value: 1, child: Text('Medium')),
                      DropdownMenuItem(value: 2, child: Text('High')),
                    ],
                    onChanged: (v) => setState(() => priority = v ?? 1),
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    dropdownColor: isDark ? Colors.black : Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            PrimaryButton(
              text: isEdit ? 'Save' : 'Create Task',
              onPressed: () {
                if (!form.currentState!.validate()) return;

                final data = (widget.existing ??
                        Task(listId: widget.listid, title: ''))
                    .copyWith(
                      title: title.text.trim(),
                      description:
                          desc.text.trim().isEmpty ? null : desc.text.trim(),
                      dueDate: due?.millisecondsSinceEpoch,
                      priority: priority,
                    );

                Navigator.pop(context, data);
              },
            ),
          ],
        ),
      ),
    );
  }
}
