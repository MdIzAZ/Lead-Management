import 'package:flutter/material.dart';
import '../models/lead.dart';
import '../screens/lead_detail_screen.dart';

class AnimatedLeadCard extends StatefulWidget {
  final Lead lead;
  final Future<void> Function()? onDelete;

  const AnimatedLeadCard({Key? key, required this.lead, this.onDelete})
      : super(key: key);

  @override
  State<AnimatedLeadCard> createState() => _AnimatedLeadCardState();
}

class _AnimatedLeadCardState extends State<AnimatedLeadCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<Offset> _offsetAnim;
  late final Animation<double> _opacityAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 420));
    _offsetAnim = Tween<Offset>(
        begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _opacityAnim = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));

    Future.delayed(const Duration(milliseconds: 80), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Color _statusColor() {
    switch (widget.lead.status) {
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
    final theme = Theme.of(context);
    final statusColor = _statusColor();

    return SlideTransition(
      position: _offsetAnim,
      child: FadeTransition(
        opacity: _opacityAnim,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: theme.cardColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(18),
            child: InkWell(
              borderRadius: BorderRadius.circular(18),

              // ✅ RESTORED — Navigate to LeadDetailScreen
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LeadDetailScreen(lead: widget.lead),
                  ),
                );
              },

              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primary.withOpacity(0.85),
                            theme.colorScheme.primary.withOpacity(0.55),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        widget.lead.name.isEmpty
                            ? '?'
                            : widget.lead.name[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.lead.name.isEmpty
                                ? "Unnamed Lead"
                                : widget.lead.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.lead.email.isNotEmpty
                                ? widget.lead.email
                                : (widget.lead.phone.isNotEmpty
                                ? widget.lead.phone
                                : "No contact info"),
                            style: TextStyle(
                              fontSize: 14,
                              color: theme.textTheme.bodyMedium!.color!
                                  .withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: statusColor.withOpacity(0.12),
                        border: Border.all(
                            color: statusColor.withOpacity(0.4), width: 1),
                      ),
                      child: Text(
                        widget.lead.status,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 12.5,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
