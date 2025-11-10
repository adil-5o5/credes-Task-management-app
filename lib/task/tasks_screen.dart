import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models.dart';
import '../app_providers.dart';
import 'task_editor.dart';
import 'package:google_fonts/google_fonts.dart';

class TasksScreen extends ConsumerStatefulWidget {
  final int listid;
  final String listtitle;

  const TasksScreen({
    super.key,
    required this.listid,
    required this.listtitle,
  });

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  @override
  void initState() {
    super.initState();

    // ✅ LISTEN HERE (only once)
    ref.listen<String>(filterProvider, (prev, next) {
      ref.read(tasksProvider(widget.listid).notifier).apply(
            next,
            ref.read(sortAscProvider),
            '',
          );
    });

    ref.listen<bool>(sortAscProvider, (prev, next) {
      ref.read(tasksProvider(widget.listid).notifier).apply(
            ref.read(filterProvider),
            next,
            '',
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(tasksProvider(widget.listid));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.listtitle),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_alt),
            onSelected: (value) async {
              ref.read(filterProvider.notifier).state = value;
              await ref
                  .read(tasksProvider(widget.listid).notifier)
                  .apply(value, ref.read(sortAscProvider), '');
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'all', child: Text('All')),
              PopupMenuItem(value: 'todo', child: Text('Todo')),
              PopupMenuItem(value: 'done', child: Text('Done')),
            ],
          ),

          // SORT
          IconButton(
            icon: Icon(
              ref.watch(sortAscProvider)
                  ? Icons.arrow_upward
                  : Icons.arrow_downward,
            ),
            onPressed: () async {
              final newAsc = !ref.read(sortAscProvider);
              ref.read(sortAscProvider.notifier).state = newAsc;

              await ref
                  .read(tasksProvider(widget.listid).notifier)
                  .apply(ref.read(filterProvider), newAsc, '');
            },
          ),
        ],
      ),
      body: tasks.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (items) => ListView.builder(
          itemCount: items.length,
          itemBuilder: (_, i) => _TaskTile(task: items[i]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push<Task>(
            context,
            MaterialPageRoute(
              builder: (_) => TaskEditor(listid: widget.listid),
            ),
          );

          if (result != null) {
            await ref.read(tasksProvider(widget.listid).notifier).add(result);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _TaskTile extends ConsumerWidget {
  final Task task;

  const _TaskTile({required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final done = task.status == 'done';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Checkbox(
          value: done,
          onChanged: (_) async {
            final next = done ? 'todo' : 'done';
            await ref
                .read(tasksProvider(task.listId).notifier)
                .toggle(task.id!, next);
          },
        ),
        title: Text(
          task.title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            decoration: done ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          '${task.dueDate != null ? DateTime.fromMillisecondsSinceEpoch(task.dueDate!).toLocal().toString().split(' ').first : 'No due'} • ${['Low', 'Med', 'High'][task.priority]}',
          style: GoogleFonts.poppins(fontSize: 12),
        ),
        onLongPress: () async {
          final dark = Theme.of(context).brightness == Brightness.dark;

          final choice = await showModalBottomSheet<String>(
            context: context,
            backgroundColor: dark ? Colors.black : Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            builder: (_) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('Edit'),
                  onTap: () => Navigator.pop(context, 'Edit'),
                ),
                Divider(color: dark ? Colors.grey[800] : Colors.grey[300]),
                ListTile(
                  title: const Text('Delete'),
                  onTap: () => Navigator.pop(context, 'Delete'),
                ),
              ],
            ),
          );

          if (choice == 'Edit') {
            final updated = await Navigator.push<Task>(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    TaskEditor(listid: task.listId, existing: task),
              ),
            );
            if (updated != null) {
              await ref
                  .read(tasksProvider(task.listId).notifier)
                  .update(updated);
            }
          } else if (choice == 'Delete') {
            await ref.read(tasksProvider(task.listId).notifier).remove(task.id!);
          }
        },
      ),
    );
  }
}
