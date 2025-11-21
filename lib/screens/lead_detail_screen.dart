import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/lead.dart';
import '../providers/lead_provider.dart';
import 'lead_form_screen.dart';

class LeadDetailScreen extends StatelessWidget {
  final Lead lead;
  const LeadDetailScreen({Key? key, required this.lead}) : super(key: key);

  Color _statusColor(String s) {
    switch (s) {
      case "Contacted":
        return Colors.orange.shade700;
      case "Converted":
        return Colors.green.shade700;
      case "Lost":
        return Colors.red.shade700;
      default:
        return Colors.blueGrey.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LeadProvider>(context);
    final freshLead = provider.leads.firstWhere(
          (l) => l.id == lead.id,
      orElse: () => lead,
    );

    final theme = Theme.of(context);
    final statusColor = _statusColor(freshLead.status);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Lead Details",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () =>
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LeadFormScreen(lead: freshLead),
                  ),
                ).then(
                      (_) =>
                      Provider.of<LeadProvider>(context, listen: false)
                          .loadAll(),
                ),
          )
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [

          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                  color: Colors.black.withOpacity(0.06),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  children: [
                    Container(
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primary.withOpacity(0.9),
                            theme.colorScheme.primary.withOpacity(0.6),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        freshLead.name.isEmpty
                            ? "?"
                            : freshLead.name[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        freshLead.name.isEmpty
                            ? "Unnamed Lead"
                            : freshLead.name,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 22),

                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: statusColor.withOpacity(0.14),
                    border: Border.all(
                      color: statusColor.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    freshLead.status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13.5,
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                _infoTile("Email",
                    freshLead.email.isEmpty ? "N/A" : freshLead.email,
                    theme),
                _infoTile("Phone",
                    freshLead.phone.isEmpty ? "N/A" : freshLead.phone,
                    theme),
                _infoTile("Source",
                    freshLead.source.isEmpty ? "N/A" : freshLead.source,
                    theme),

                const SizedBox(height: 10),

                Text(
                  "Notes",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 6),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    freshLead.notes.isEmpty
                        ? "No notes added"
                        : freshLead.notes,
                    style: TextStyle(
                      fontSize: 14.5,
                      height: 1.45,
                      color: theme.textTheme.bodyMedium!.color!
                          .withOpacity(0.85),
                    ),
                  ),
                ),

              ],
            ),
          ),

          const SizedBox(height: 28),

          GestureDetector(
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) =>
                    AlertDialog(
                      title: const Text("Delete Lead"),
                      content: Text("Delete lead \"${freshLead.name}\"?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text("Cancel"),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                          ),
                          child: const Text("Delete"),
                        )
                      ],
                    ),
              );

              if (confirm == true) {
                await Provider.of<LeadProvider>(context, listen: false)
                    .deleteLead(freshLead.id);
                Navigator.pop(context);
              }
            },
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.redAccent,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 8,
                    color: Colors.red.withOpacity(0.4),
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              alignment: Alignment.center,
              child: const Text(
                "Delete Lead",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget _infoTile(String title, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13.5,
              color:
              theme.textTheme.bodySmall!.color!.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
