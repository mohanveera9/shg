import 'package:flutter/foundation.dart';
import '../models/group.dart';
import '../services/api_service.dart';

class GroupProvider with ChangeNotifier {
  final _api = ApiService();
  
  List<Group> _groups = [];
  Group? _currentGroup;
  bool _isLoading = false;
  String? _errorMessage;

  List<Group> get groups => _groups;
  Group? get currentGroup => _currentGroup;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> createGroup({
    required String name,
    required String village,
    required String block,
    required String district,
    List<String>? foundingMembers,
    bool researchConsent = false,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await _api.post('/groups/create', {
      'name': name,
      'village': village,
      'block': block,
      'district': district,
      'foundingMembers': foundingMembers ?? [],
      'researchConsent': researchConsent,
    }, needsAuth: true);

    _isLoading = false;
    
    if (response['success'] == true && response['group'] != null) {
      _currentGroup = Group.fromJson(response['group']);
      await fetchUserGroups();
      notifyListeners();
      return true;
    } else {
      _errorMessage = response['message'] ?? 'Failed to create group';
      notifyListeners();
      return false;
    }
  }

  Future<bool> joinGroup(String groupCode) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await _api.post('/groups/join', {
      'groupCode': groupCode,
    }, needsAuth: true);

    _isLoading = false;
    
    if (response['success'] == true && response['group'] != null) {
      _currentGroup = Group.fromJson(response['group']);
      await fetchUserGroups();
      notifyListeners();
      return true;
    } else {
      _errorMessage = response['message'] ?? 'Failed to join group';
      notifyListeners();
      return false;
    }
  }

  Future<void> fetchUserGroups() async {
    _isLoading = true;
    notifyListeners();

    final response = await _api.get('/groups/my-groups', needsAuth: true);
    print('Fetch Groups Response: $response');

    if (response['success'] == true && response['groups'] != null) {
      _groups = (response['groups'] as List)
          .map((g) => Group.fromJson(g))
          .toList();
      
      if (_groups.isNotEmpty && _currentGroup == null) {
        _currentGroup = _groups.first;
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  void setCurrentGroup(Group group) {
    _currentGroup = group;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
