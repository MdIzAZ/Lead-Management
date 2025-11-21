import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../data/db_helper.dart';
import '../providers/lead_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/lead_card.dart';
import 'lead_detail_screen.dart';
import 'lead_form_screen.dart';

class LeadListScreen extends StatefulWidget {
  const LeadListScreen({Key? key}) : super(key: key);

  @override
  State<LeadListScreen> createState() => _LeadListScreenState();
}

class _LeadListScreenState extends State<LeadListScreen> {
  String filter = "All";
  String search = "";
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final provider = Provider.of<LeadProvider>(context, listen: false);
    if (!_scrollController.hasClients) return;
    final threshold = 200.0;
    if (_scrollController.position.maxScrollExtent - _scrollController.position.pixels <= threshold) {
      if (!provider.isLoading && provider.hasMore) {
        provider.loadMore();
      }
    }
  }

  Future<void> _exportJson() async {
    try {
      final db = DBHelper();
      final all = await db.fetchAll();

      final jsonObj = {
        'exportedAt': DateTime.now().toIso8601String(),
        'total': all.length,
        'leads': all.map((l) => l.toMap()).toList(),
      };

      final jsonString = const JsonEncoder.withIndent('  ').convert(jsonObj);
      final dir = await getApplicationDocumentsDirectory();
      final name = 'leads_export_${DateTime.now().toIso8601String().replaceAll(':', '-')}.json';
      final file = File('${dir.path}/$name');
      await file.writeAsString(jsonString);

      await Share.shareXFiles([XFile(file.path)], text: 'Leads Exported');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Export complete')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Export failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LeadProvider>(context);
    final leads = search.isEmpty ? provider.filterByStatus(filter) : provider.search(search);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text("Lead Manager", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.download_rounded),
            onPressed: _exportJson,
          ),
          Consumer<ThemeProvider>(
            builder: (_, theme, __) {
              return IconButton(
                icon: Icon(theme.isDark ? Icons.dark_mode : Icons.light_mode),
                onPressed: theme.toggleTheme,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => provider.loadAll(),
          ),
          const SizedBox(width: 6),
        ],
      ),

      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Theme.of(context).colorScheme.surfaceVariant,
                    ),
                    child: TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        prefixIcon: Icon(Icons.search),
                        hintText: "Search leads...",
                      ),
                      onChanged: (v) => setState(() => search = v),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Theme.of(context).colorScheme.surfaceVariant,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: filter,
                      items: const [
                        DropdownMenuItem(value: "All", child: Text("All")),
                        DropdownMenuItem(value: "New", child: Text("New")),
                        DropdownMenuItem(value: "Contacted", child: Text("Contacted")),
                        DropdownMenuItem(value: "Converted", child: Text("Converted")),
                        DropdownMenuItem(value: "Lost", child: Text("Lost")),
                      ],
                      onChanged: (v) => setState(() => filter = v ?? "All"),
                    ),
                  ),
                )
              ],
            ),
          ),

          Expanded(
            child: leads.isEmpty
                ? const Center(child: Text("No Leads Found", style: TextStyle(fontSize: 16)))
                : ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              itemCount: leads.length + (provider.hasMore ? 1 : 0),
              itemBuilder: (_, i) {
                if (i < leads.length) {
                  final l = leads[i];
                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => LeadDetailScreen(lead: l),
                        transitionsBuilder: (_, anim, __, child) =>
                            FadeTransition(opacity: anim, child: child),
                      ),
                    ).then((_) => provider.loadAll()),
                    child: AnimatedLeadCard(lead: l),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: Center(
                      child: SizedBox(
                          height: 28,
                          width: 28,
                          child: CircularProgressIndicator(strokeWidth: 2.4)),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LeadFormScreen(lead: provider.createEmpty()),
            ),
          ).then((_) => provider.loadAll());
        },

        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,

        icon: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.onSecondaryContainer,
        ),

        label: Text(
          "Add Lead",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSecondaryContainer,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),

    );
  }
}
