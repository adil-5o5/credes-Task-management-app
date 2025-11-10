import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_providers.dart';
import '../models.dart';

class ListsScreen extends ConsumerWidget {
  const ListsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lists = ref.watch(listsProvider);
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Task Lists',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: dark ? Colors.white : Colors.black,
            ),
            onPressed: () => Navigator.pushNamed(context, '/search'),
          ),
        ],
      ),
      body: lists.when(
        loading: () => Center(
          child: CircularProgressIndicator(
            color: dark ? Colors.white : Colors.black,
          ),
        ),
        error: (e, _) => Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, color: dark ? Colors.grey[500] : Colors.grey[600]),
                const SizedBox(height: 12),
                Text(
                  'couldn\'t load lists, soz',
                  style: GoogleFonts.poppins(
                    color: dark ? Colors.grey[400] : Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  '$e',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: dark ? Colors.grey[500] : Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        data: (items) => AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: items.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.folder_open, size: 56, color: dark ? Colors.grey[700] : Colors.grey[400]),
                        const SizedBox(height: 20),
                        Text(
                          'No lists yet',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'make one quick and start adding tasks',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: dark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            onPressed: () => _newList(context, ref),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: dark ? Colors.transparent : Colors.black,
                              foregroundColor: Colors.white,
                              side: dark ? const BorderSide(color: Colors.white, width: 1.3) : null,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: Text(
                              'Create List',
                              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  itemCount: items.length,
                  itemBuilder: (_, i) => _Item(list: items[i]),
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _newList(context, ref),
        backgroundColor: dark ? Colors.white : Colors.black,
        foregroundColor: dark ? Colors.black : Colors.white,
        elevation: 0,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _newList(BuildContext context, WidgetRef ref) {
    final titletext = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Theme.of(context).dividerColor),
        ),
        title: Text('New List', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: TextField(
          controller: titletext,
          decoration: const InputDecoration(labelText: 'Title'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.poppins()),
          ),
          ElevatedButton(
            onPressed: () async {
              final t = titletext.text.trim();
              if (t.isNotEmpty) {
                await ref.read(listsProvider.notifier).add(t);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(elevation: 0),
            child: Text('Save', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class _Item extends ConsumerWidget {
  final TaskList list;
  const _Item({required this.list});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: dark ? Colors.black : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: dark ? Colors.grey[800]! : Colors.grey[300]!, width: 1),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        title: Text(
          list.title,
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        trailing: Icon(Icons.chevron_right, color: dark ? Colors.grey[600] : Colors.grey[500]),
        onTap: () {
          Navigator.pushNamed(
            context,
            '/tasks',
            arguments: {'listId': list.id!, 'listTitle': list.title},
          );
        },
        onLongPress: () => _menu(context, ref),
      ),
    );
  }

  void _menu(BuildContext context, WidgetRef ref) async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      builder: (_) {
        final theme = Theme.of(context);
        final dark = theme.brightness == Brightness.dark;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Rename', style: GoogleFonts.poppins(color: dark ? Colors.white : Colors.black)),
              onTap: () => Navigator.pop(context, 'Rename'),
            ),
            Divider(color: dark ? Colors.grey[800] : Colors.grey[300]),
            ListTile(
              title: Text('Delete', style: GoogleFonts.poppins(color: Colors.red)),
              onTap: () => Navigator.pop(context, 'Delete'),
            ),
            const SizedBox(height: 8),
          ],
        );
      },
    );

    if (choice == 'Rename') {
      final titletext = TextEditingController(text: list.title);
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Rename', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          content: TextField(controller: titletext),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: GoogleFonts.poppins()),
            ),
            ElevatedButton(
              onPressed: () async {
                final t = titletext.text.trim();
                if (t.isNotEmpty) {
                  await ref.read(listsProvider.notifier).rename(list.id!, t);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(elevation: 0),
              child: Text('Save', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      );
    }

    if (choice == 'Delete') {
      await ref.read(listsProvider.notifier).remove(list.id!);
    }
  }
}
