import 'package:flutter/material.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/onboarding/language_selection_screen.dart';
import '../screens/onboarding/permissions_screen.dart';
import '../screens/auth/phone_input_screen.dart';
import '../screens/auth/otp_verification_screen.dart';
import '../screens/auth/complete_profile_screen.dart';
import '../screens/home/home_dashboard_screen.dart';
import '../screens/home/solo_user_dashboard_screen.dart';
import '../screens/home/group_selection_screen.dart';
import '../screens/home/create_group_screen.dart';
import '../screens/home/join_group_screen.dart';
import '../screens/home/group_created_screen.dart';
import '../screens/home/manage_members_screen.dart';
import '../screens/bookkeeping/transactions_list_screen.dart';
import '../screens/bookkeeping/add_transaction_screen.dart';
import '../screens/loans/loans_dashboard_screen.dart';
import '../screens/loans/request_loan_screen.dart';
import '../screens/loans/my_loans_screen.dart';
import '../screens/loans/loan_detail_screen.dart';
import '../screens/loans/repay_emi_screen.dart';
import '../screens/loans/pending_approvals_screen.dart';
import '../screens/loans/approve_loan_screen.dart';
import '../screens/loans/disburse_loan_screen.dart';
import '../screens/products/products_list_screen.dart';
import '../screens/products/add_edit_product_screen.dart';
import '../screens/products/product_detail_screen.dart';
import '../screens/orders/orders_list_screen.dart';
import '../screens/orders/order_detail_screen.dart';
import '../screens/reports/reports_dashboard_screen.dart';
import '../screens/reports/income_expense_chart_screen.dart';
import '../screens/reports/savings_by_member_screen.dart';
import '../screens/reports/outstanding_loans_screen.dart';
import '../screens/reports/top_products_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/edit_profile_screen.dart';
import '../screens/settings/settings_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String languageSelection = '/language-selection';
  static const String permissions = '/permissions';
  static const String phoneInput = '/phone-input';
  static const String otpVerification = '/otp-verification';
  static const String completeProfile = '/complete-profile';
  static const String soloDashboard = '/solo-dashboard';
  static const String groupSelection = '/group-selection';
  static const String createGroup = '/create-group';
  static const String joinGroup = '/join-group';
  static const String groupCreated = '/group-created';
  static const String manageMembers = '/manage-members';
  static const String home = '/home';
  
  static const String transactionsList = '/transactions';
  static const String addTransaction = '/add-transaction';
  
  static const String loansDashboard = '/loans';
  static const String requestLoan = '/request-loan';
  static const String pendingApprovals = '/pending-approvals';
  static const String approveLoan = '/approve-loan';
  static const String disburseLoan = '/disburse-loan';
  static const String myLoans = '/my-loans';
  static const String loanDetail = '/loan-detail';
  static const String repayEmi = '/repay-emi';
  
  static const String productsList = '/products';
  static const String addProduct = '/add-product';
  static const String editProduct = '/edit-product';
  static const String productDetail = '/product-detail';
  
  static const String ordersList = '/orders';
  static const String orderDetail = '/order-detail';
  
  static const String reportsDashboard = '/reports';
  static const String incomeExpenseChart = '/income-expense-chart';
  static const String savingsByMember = '/savings-by-member';
  static const String outstandingLoans = '/outstanding-loans-report';
  static const String topProducts = '/top-products';
  
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String settings = '/settings';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashScreen(),
      languageSelection: (context) => const LanguageSelectionScreen(),
      permissions: (context) => const PermissionsScreen(),
      phoneInput: (context) => const PhoneInputScreen(),
      otpVerification: (context) => const OtpVerificationScreen(),
      completeProfile: (context) => const CompleteProfileScreen(),
      soloDashboard: (context) => const SoloUserDashboardScreen(),
      groupSelection: (context) => const GroupSelectionScreen(),
      createGroup: (context) => const CreateGroupScreen(),
      joinGroup: (context) => const JoinGroupScreen(),
      home: (context) => const HomeDashboardScreen(),
      
      transactionsList: (context) => const TransactionsListScreen(),
      addTransaction: (context) => const AddTransactionScreen(),
      
      loansDashboard: (context) => const LoansDashboardScreen(),
      requestLoan: (context) => const RequestLoanScreen(),
      pendingApprovals: (context) => const PendingApprovalsScreen(),
      myLoans: (context) => const MyLoansScreen(),
      
      productsList: (context) => const ProductsListScreen(),
      addProduct: (context) => const AddEditProductScreen(isEdit: false),
      
      ordersList: (context) => const OrdersListScreen(),
      
      reportsDashboard: (context) => const ReportsDashboardScreen(),
      incomeExpenseChart: (context) => const IncomeExpenseChartScreen(),
      savingsByMember: (context) => const SavingsByMemberScreen(),
      outstandingLoans: (context) => const OutstandingLoansScreen(),
      topProducts: (context) => const TopProductsScreen(),
      
      profile: (context) => const ProfileScreen(),
      editProfile: (context) => const EditProfileScreen(),
      settings: (context) => const SettingsScreen(),
    };
  }
  
  // For routes that need arguments, use onGenerateRoute instead
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case groupCreated:
        final group = settings.arguments as dynamic;
        return MaterialPageRoute(
          builder: (context) => GroupCreatedScreen(group: group),
        );
      case approveLoan:
        final loanId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (context) => ApproveLoanScreen(loanId: loanId),
        );
      case disburseLoan:
        final loanId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (context) => DisburseLoanScreen(loanId: loanId),
        );
      case loanDetail:
        final loanId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (context) => LoanDetailScreen(loanId: loanId),
        );
      case repayEmi:
        final loanId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (context) => RepayEmiScreen(loanId: loanId),
        );
      case editProduct:
        final productId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (context) => AddEditProductScreen(isEdit: true, productId: productId),
        );
      case productDetail:
        final productId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (context) => ProductDetailScreen(productId: productId),
        );
      case orderDetail:
        final orderId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (context) => OrderDetailScreen(orderId: orderId),
        );
      case manageMembers:
        final groupId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (context) => ManageMembersScreen(groupId: groupId),
        );
      default:
        return null;
    }
  }
}