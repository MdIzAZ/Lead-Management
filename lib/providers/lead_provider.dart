import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../data/db_helper.dart';
import '../models/lead.dart';

class LeadProvider extends ChangeNotifier {
  final DBHelper _db = DBHelper();
  final List<Lead> _leads = [];

  // Pagination state
  final int _pageSize = 10;
  int _offset = 0;
  bool _isLoading = false;
  bool _hasMore = true;

  List<Lead> get leads => List.unmodifiable(_leads);
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

  /// Load first page (reset)
  Future<void> loadAll() async {
    _offset = 0;
    _hasMore = true;
    _leads.clear();
    notifyListeners();
    await loadMore();
  }

  /// Load next page (if any)
  Future<void> loadMore() async {
    if (_isLoading || !_hasMore) return;
    _isLoading = true;
    notifyListeners();

    final page = await _db.fetchPage(limit: _pageSize, offset: _offset);
    if (page.isEmpty) {
      _hasMore = false;
    } else {
      _leads.addAll(page);
      _offset += page.length;
      if (page.length < _pageSize) {
        _hasMore = false;
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addLead(Lead lead) async {
    await _db.insertLead(lead);
    _leads.insert(0, lead);
    _offset += 1;
    notifyListeners();
  }

  Future<void> updateLead(Lead lead) async {
    await _db.updateLead(lead);
    final idx = _leads.indexWhere((l) => l.id == lead.id);
    if (idx != -1) {
      _leads[idx] = lead;
      notifyListeners();
    } else {
      await loadAll();
    }
  }

  Future<void> deleteLead(String id) async {
    await _db.deleteLead(id);
    _leads.removeWhere((l) => l.id == id);
    if (!_isLoading && _hasMore) {
      await loadMore();
    } else {
      notifyListeners();
    }
  }

  List<Lead> filterByStatus(String status) {
    if (status == 'All') return leads;
    return _leads.where((l) => l.status == status).toList();
  }

  List<Lead> search(String q) {
    q = q.toLowerCase();
    return _leads.where((l) =>
    l.name.toLowerCase().contains(q) ||
        l.email.toLowerCase().contains(q) ||
        l.phone.toLowerCase().contains(q)).toList();
  }

  Lead createEmpty() => Lead(id: const Uuid().v4());
}
