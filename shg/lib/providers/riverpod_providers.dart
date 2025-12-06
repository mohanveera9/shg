import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../models/group.dart';
import '../models/transaction.dart';
import '../models/loan.dart';
import '../models/product.dart';
import '../models/order.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../database/database.dart';

final apiServiceProvider = Provider((ref) => ApiService());
final authServiceProvider = Provider((ref) => AuthService());
final storageServiceProvider = Provider((ref) => StorageService());
final databaseProvider = Provider<AppDatabase>((ref) => AppDatabase());

class AuthState {
  final User? user;
  final bool isAuthenticated;
  final bool isLoading;
  final String? errorMessage;

  AuthState({
    this.user,
    this.isAuthenticated = false,
    this.isLoading = false,
    this.errorMessage,
  });

  AuthState copyWith({
    User? user,
    bool? isAuthenticated,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AuthState(
      user: user ?? this.user,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService authService;
  final StorageService storageService;

  AuthNotifier(this.authService, this.storageService) : super(AuthState());

  Future<void> checkAuthStatus() async {
    state = state.copyWith(isLoading: true);
    final isAuth = await authService.isAuthenticated();
    state = state.copyWith(isAuthenticated: isAuth, isLoading: false);
  }

  Future<bool> sendOTP(String phone) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final response = await authService.sendOTP(phone);
    state = state.copyWith(
      isLoading: false,
      errorMessage: response['success'] != true ? response['message'] : null,
    );
    return response['success'] == true;
  }

  Future<bool> verifyOTP(String phone, String otp) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final response = await authService.verifyOTP(phone, otp);
    
    if (response['success'] == true) {
      final user = authService.parseUser(response);
      if (user != null) {
        await storageService.saveLanguage(user.language);
      }
      state = state.copyWith(
        user: user,
        isAuthenticated: true,
        isLoading: false,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        errorMessage: response['message'],
      );
    }
    
    return response['success'] == true;
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    await authService.logout();
    state = AuthState();
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    ref.read(authServiceProvider),
    ref.read(storageServiceProvider),
  );
});

class GroupState {
  final List<Group> groups;
  final Group? currentGroup;
  final bool isLoading;
  final String? errorMessage;

  GroupState({
    this.groups = const [],
    this.currentGroup,
    this.isLoading = false,
    this.errorMessage,
  });

  GroupState copyWith({
    List<Group>? groups,
    Group? currentGroup,
    bool? isLoading,
    String? errorMessage,
  }) {
    return GroupState(
      groups: groups ?? this.groups,
      currentGroup: currentGroup ?? this.currentGroup,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class GroupNotifier extends StateNotifier<GroupState> {
  final ApiService apiService;

  GroupNotifier(this.apiService) : super(GroupState());

  Future<void> fetchUserGroups() async {
    state = state.copyWith(isLoading: true);
    final response = await apiService.get('/groups/my-groups', needsAuth: true);
    
    if (response['success'] == true) {
      final groups = (response['groups'] as List)
          .map((json) => Group.fromJson(json))
          .toList();
      state = state.copyWith(
        groups: groups,
        currentGroup: groups.isNotEmpty ? groups[0] : null,
        isLoading: false,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        errorMessage: response['message'],
      );
    }
  }

  void setCurrentGroup(Group group) {
    state = state.copyWith(currentGroup: group);
  }

  Future<bool> createGroup(Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true);
    final response = await apiService.post('/groups/create', data, needsAuth: true);
    
    if (response['success'] == true) {
      await fetchUserGroups();
      return true;
    } else {
      state = state.copyWith(
        isLoading: false,
        errorMessage: response['message'],
      );
      return false;
    }
  }

  Future<bool> joinGroup(String groupCode) async {
    state = state.copyWith(isLoading: true);
    final response = await apiService.post(
      '/groups/join',
      {'groupCode': groupCode},
      needsAuth: true,
    );
    
    if (response['success'] == true) {
      await fetchUserGroups();
      return true;
    } else {
      state = state.copyWith(
        isLoading: false,
        errorMessage: response['message'],
      );
      return false;
    }
  }
}

final groupProvider = StateNotifierProvider<GroupNotifier, GroupState>((ref) {
  return GroupNotifier(ref.read(apiServiceProvider));
});

final dashboardProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, groupId) async {
  final api = ref.read(apiServiceProvider);
  final response = await api.get('/dashboard/$groupId', needsAuth: true);
  return response;
});

final transactionsProvider = FutureProvider.family<List<Transaction>, String>((ref, groupId) async {
  final api = ref.read(apiServiceProvider);
  final response = await api.get('/transactions/$groupId', needsAuth: true);
  
  if (response['success'] == true) {
    return (response['transactions'] as List)
        .map((json) => Transaction.fromJson(json))
        .toList();
  }
  return [];
});

final loansProvider = FutureProvider.family<List<Loan>, String>((ref, groupId) async {
  final api = ref.read(apiServiceProvider);
  final response = await api.get('/loans/$groupId', needsAuth: true);
  
  if (response['success'] == true) {
    return (response['loans'] as List)
        .map((json) => Loan.fromJson(json))
        .toList();
  }
  return [];
});

final productsProvider = FutureProvider.family<List<Product>, String>((ref, groupId) async {
  final api = ref.read(apiServiceProvider);
  final response = await api.get('/products/$groupId', needsAuth: true);
  
  if (response['success'] == true) {
    return (response['products'] as List)
        .map((json) => Product.fromJson(json))
        .toList();
  }
  return [];
});

final ordersProvider = FutureProvider.family<List<OrderModel>, String>((ref, groupId) async {
  final api = ref.read(apiServiceProvider);
  final response = await api.get('/orders/$groupId', needsAuth: true);
  
  if (response['success'] == true) {
    return (response['orders'] as List)
        .map((json) => OrderModel.fromJson(json))
        .toList();
  }
  return [];
});

final languageProvider = StateProvider<String>((ref) => 'te');

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier(ref.read(storageServiceProvider));
});

class SettingsState {
  final bool notificationsEnabled;
  final bool dataUsageAllowed;
  final String language;

  SettingsState({
    this.notificationsEnabled = true,
    this.dataUsageAllowed = true,
    this.language = 'te',
  });

  SettingsState copyWith({
    bool? notificationsEnabled,
    bool? dataUsageAllowed,
    String? language,
  }) {
    return SettingsState(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      dataUsageAllowed: dataUsageAllowed ?? this.dataUsageAllowed,
      language: language ?? this.language,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  final StorageService storageService;

  SettingsNotifier(this.storageService) : super(SettingsState()) {
    loadSettings();
  }

  Future<void> loadSettings() async {
    final language = await storageService.getLanguage();
    state = state.copyWith(language: language);
  }

  Future<void> setNotifications(bool enabled) async {
    state = state.copyWith(notificationsEnabled: enabled);
  }

  Future<void> setDataUsage(bool allowed) async {
    state = state.copyWith(dataUsageAllowed: allowed);
  }

  Future<void> setLanguage(String language) async {
    await storageService.saveLanguage(language);
    state = state.copyWith(language: language);
  }
}
