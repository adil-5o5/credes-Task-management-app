import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_providers.dart';
import 'widgets/custom_app_bar.dart';
import 'widgets/custom_text_field.dart';

// quick search page for tasks, kept clean so it doesnt feel heavy
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final searchtext = TextEditingController();
  List<Map<String, Object?>> results = [];

  @override
  void dispose() {
    searchtext.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Search',
        isDark: isDark,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CustomTextField(
              labelText: 'Search Tasks',
              hintText: 'Type to search...',
              controller: searchtext,
              onChanged: (_) => _run(),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: results.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search,
                            size: 64,
                            color: isDark ? Colors.grey[700] : Colors.grey[400],
                          ),
                          const SizedBox(height: 24),
                          Text(
                            searchtext.text.isEmpty
                                ? 'Start typing to search'
                                : 'No results found',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: isDark ? Colors.grey[400] : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: results.length,
                      itemBuilder: (_, i) {
                        final r = results[i];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 0,
                          color: isDark ? Colors.black : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                              width: 1,
                            ),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            title: Text(
                              r['title'] as String,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                  'List: ${r['listTitle']}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color:
                                        isDark ? Colors.grey[400] : Colors.grey[600],
                                  ),
                                ),
                                if (r['dueDate'] != null) ...[
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today,
                                        size: 14,
                                        color: isDark
                                            ? Colors.grey[500]
                                            : Colors.grey[500],
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        DateTime.fromMillisecondsSinceEpoch(
                                          r['dueDate'] as int,
                                        )
                                            .toLocal()
                                            .toString()
                                            .split(' ')[0],
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: isDark
                                              ? Colors.grey[500]
                                              : Colors.grey[500],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                            onTap: () {
                              // jump into that task list so you can see it fast
                              Navigator.pushNamed(
                                context,
                                '/tasks',
                                arguments: {
                                  'listId': r['listId'],
                                  'listTitle': r['listTitle'],
                                },
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _run() async {
    final q = searchtext.text.trim();
    if (q.isEmpty) {
      setState(() => results = []);
      return;
    }
    final repo = ref.read(tasksRepoProvider);
    final out = await repo.globalSearchByTitle(q);
    setState(() => results = out);
  }
}
