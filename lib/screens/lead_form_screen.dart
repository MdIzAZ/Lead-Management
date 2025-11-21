import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/lead.dart';
import '../providers/lead_provider.dart';

class LeadFormScreen extends StatefulWidget {
  final Lead lead;
  const LeadFormScreen({Key? key, required this.lead}) : super(key: key);

  @override
  State<LeadFormScreen> createState() => _LeadFormScreenState();
}

class _LeadFormScreenState extends State<LeadFormScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _name;
  late TextEditingController _email;
  late TextEditingController _phone;
  late TextEditingController _source;
  late TextEditingController _notes;
  String status = 'New';
  late AnimationController _ctrl;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.lead.name);
    _email = TextEditingController(text: widget.lead.email);
    _phone = TextEditingController(text: widget.lead.phone);
    _source = TextEditingController(text: widget.lead.source);
    _notes = TextEditingController(text: widget.lead.notes);
    status = widget.lead.status;

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    Future.delayed(const Duration(milliseconds: 100), () => _ctrl.forward());
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _source.dispose();
    _notes.dispose();
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = Provider.of<LeadProvider>(context, listen: false);

    final updated = Lead(
      id: widget.lead.id,
      name: _name.text.trim(),
      email: _email.text.trim(),
      phone: _phone.text.trim(),
      source: _source.text.trim(),
      notes: _notes.text.trim(),
      status: status,
      createdAt: widget.lead.createdAt,
    );

    final isNew = widget.lead.name.isEmpty &&
        widget.lead.email.isEmpty &&
        widget.lead.phone.isEmpty;

    isNew ? await provider.addLead(updated) : await provider.updateLead(updated);
    Navigator.pop(context);
  }

  Widget buildTextField(String label, TextEditingController ctrl,
      {int maxLines = 1, String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: ctrl,
        maxLines: maxLines,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.4),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Lead Form"),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fade,
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                    color: Colors.black.withOpacity(0.08),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    buildTextField(
                      "Full Name",
                      _name,
                      validator: (v) =>
                      v == null || v.trim().isEmpty ? "Name required" : null,
                    ),
                    buildTextField(
                      "Email",
                      _email,
                      validator: (v) => v != null &&
                          v.isNotEmpty &&
                          !v.contains('@')
                          ? "Enter valid email"
                          : null,
                    ),
                    buildTextField("Phone", _phone),
                    buildTextField("Lead Source", _source),
                    buildTextField("Notes", _notes, maxLines: 3),

                    DropdownButtonFormField<String>(
                      value: status,
                      decoration: InputDecoration(
                        labelText: "Lead Status",
                        filled: true,
                        fillColor:
                        theme.colorScheme.surfaceVariant.withOpacity(0.4),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: "New", child: Text("New")),
                        DropdownMenuItem(
                            value: "Contacted", child: Text("Contacted")),
                        DropdownMenuItem(
                            value: "Converted", child: Text("Converted")),
                        DropdownMenuItem(value: "Lost", child: Text("Lost")),
                      ],
                      onChanged: (v) => setState(() => status = v ?? "New"),
                    ),

                    const SizedBox(height: 30),

                    GestureDetector(
                      onTap: _save,
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: [
                              theme.colorScheme.primary.withOpacity(0.95),
                              theme.colorScheme.primary.withOpacity(0.75),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 10,
                              color: theme.colorScheme.primary.withOpacity(0.4),
                              offset: const Offset(0, 5),
                            )
                          ],
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          "Save Lead",
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
