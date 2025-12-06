import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_te.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('te'),
  ];

  /// No description provided for @app_name.
  ///
  /// In en, this message translates to:
  /// **'SHG Management'**
  String get app_name;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @language_selection.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get language_selection;

  /// No description provided for @language_selection_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred language'**
  String get language_selection_subtitle;

  /// No description provided for @permissions_title.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get permissions_title;

  /// No description provided for @camera_permission.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera_permission;

  /// No description provided for @storage_permission.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get storage_permission;

  /// No description provided for @data_sharing_consent.
  ///
  /// In en, this message translates to:
  /// **'I agree to share data for research purposes'**
  String get data_sharing_consent;

  /// No description provided for @phone_input_title.
  ///
  /// In en, this message translates to:
  /// **'Enter Phone Number'**
  String get phone_input_title;

  /// No description provided for @phone_input_hint.
  ///
  /// In en, this message translates to:
  /// **'10-digit mobile number'**
  String get phone_input_hint;

  /// No description provided for @send_otp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get send_otp;

  /// No description provided for @otp_verification_title.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get otp_verification_title;

  /// No description provided for @otp_verification_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code sent to'**
  String get otp_verification_subtitle;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @resend_otp.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resend_otp;

  /// No description provided for @group_selection_title.
  ///
  /// In en, this message translates to:
  /// **'Select Group'**
  String get group_selection_title;

  /// No description provided for @create_group.
  ///
  /// In en, this message translates to:
  /// **'Create New Group'**
  String get create_group;

  /// No description provided for @join_group.
  ///
  /// In en, this message translates to:
  /// **'Join Existing Group'**
  String get join_group;

  /// No description provided for @group_name.
  ///
  /// In en, this message translates to:
  /// **'Group Name'**
  String get group_name;

  /// No description provided for @village.
  ///
  /// In en, this message translates to:
  /// **'Village'**
  String get village;

  /// No description provided for @block.
  ///
  /// In en, this message translates to:
  /// **'Block'**
  String get block;

  /// No description provided for @district.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get district;

  /// No description provided for @group_code.
  ///
  /// In en, this message translates to:
  /// **'Group Code'**
  String get group_code;

  /// No description provided for @scan_qr.
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code'**
  String get scan_qr;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @cash_in_hand.
  ///
  /// In en, this message translates to:
  /// **'Cash in Hand'**
  String get cash_in_hand;

  /// No description provided for @group_savings.
  ///
  /// In en, this message translates to:
  /// **'Group Savings'**
  String get group_savings;

  /// No description provided for @due_loans.
  ///
  /// In en, this message translates to:
  /// **'Due Loans'**
  String get due_loans;

  /// No description provided for @today_tasks.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Tasks'**
  String get today_tasks;

  /// No description provided for @top_product.
  ///
  /// In en, this message translates to:
  /// **'Top Product'**
  String get top_product;

  /// No description provided for @quick_actions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quick_actions;

  /// No description provided for @bookkeeping.
  ///
  /// In en, this message translates to:
  /// **'Bookkeeping'**
  String get bookkeeping;

  /// No description provided for @transactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// No description provided for @add_transaction.
  ///
  /// In en, this message translates to:
  /// **'Add Transaction'**
  String get add_transaction;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @member.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get member;

  /// No description provided for @date_range.
  ///
  /// In en, this message translates to:
  /// **'Date Range'**
  String get date_range;

  /// No description provided for @income.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get income;

  /// No description provided for @expense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expense;

  /// No description provided for @savings.
  ///
  /// In en, this message translates to:
  /// **'Savings'**
  String get savings;

  /// No description provided for @loan_repayment.
  ///
  /// In en, this message translates to:
  /// **'Loan Repayment'**
  String get loan_repayment;

  /// No description provided for @loan_disbursal.
  ///
  /// In en, this message translates to:
  /// **'Loan Disbursal'**
  String get loan_disbursal;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @member_savings.
  ///
  /// In en, this message translates to:
  /// **'Member Savings'**
  String get member_savings;

  /// No description provided for @pending_sync.
  ///
  /// In en, this message translates to:
  /// **'Pending Sync'**
  String get pending_sync;

  /// No description provided for @sync_now.
  ///
  /// In en, this message translates to:
  /// **'Sync Now'**
  String get sync_now;

  /// No description provided for @loans.
  ///
  /// In en, this message translates to:
  /// **'Loans'**
  String get loans;

  /// No description provided for @request_loan.
  ///
  /// In en, this message translates to:
  /// **'Request Loan'**
  String get request_loan;

  /// No description provided for @my_loans.
  ///
  /// In en, this message translates to:
  /// **'My Loans'**
  String get my_loans;

  /// No description provided for @pending_approvals.
  ///
  /// In en, this message translates to:
  /// **'Pending Approvals'**
  String get pending_approvals;

  /// No description provided for @approve_loan.
  ///
  /// In en, this message translates to:
  /// **'Approve Loan'**
  String get approve_loan;

  /// No description provided for @disburse_loan.
  ///
  /// In en, this message translates to:
  /// **'Disburse Loan'**
  String get disburse_loan;

  /// No description provided for @repay_loan.
  ///
  /// In en, this message translates to:
  /// **'Repay Loan'**
  String get repay_loan;

  /// No description provided for @emi_schedule.
  ///
  /// In en, this message translates to:
  /// **'EMI Schedule'**
  String get emi_schedule;

  /// No description provided for @loan_amount.
  ///
  /// In en, this message translates to:
  /// **'Loan Amount'**
  String get loan_amount;

  /// No description provided for @purpose.
  ///
  /// In en, this message translates to:
  /// **'Purpose'**
  String get purpose;

  /// No description provided for @tenure.
  ///
  /// In en, this message translates to:
  /// **'Tenure (Months)'**
  String get tenure;

  /// No description provided for @interest_rate.
  ///
  /// In en, this message translates to:
  /// **'Interest Rate'**
  String get interest_rate;

  /// No description provided for @emi.
  ///
  /// In en, this message translates to:
  /// **'EMI'**
  String get emi;

  /// No description provided for @payment_method.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get payment_method;

  /// No description provided for @payment_reference.
  ///
  /// In en, this message translates to:
  /// **'Payment Reference'**
  String get payment_reference;

  /// No description provided for @upi.
  ///
  /// In en, this message translates to:
  /// **'UPI'**
  String get upi;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @add_product.
  ///
  /// In en, this message translates to:
  /// **'Add Product'**
  String get add_product;

  /// No description provided for @edit_product.
  ///
  /// In en, this message translates to:
  /// **'Edit Product'**
  String get edit_product;

  /// No description provided for @delete_product.
  ///
  /// In en, this message translates to:
  /// **'Delete Product'**
  String get delete_product;

  /// No description provided for @product_details.
  ///
  /// In en, this message translates to:
  /// **'Product Details'**
  String get product_details;

  /// No description provided for @share_product.
  ///
  /// In en, this message translates to:
  /// **'Share Product'**
  String get share_product;

  /// No description provided for @product_name.
  ///
  /// In en, this message translates to:
  /// **'Product Name'**
  String get product_name;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @stock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get stock;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @order_status.
  ///
  /// In en, this message translates to:
  /// **'Order Status'**
  String get order_status;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @accepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get accepted;

  /// No description provided for @packed.
  ///
  /// In en, this message translates to:
  /// **'Packed'**
  String get packed;

  /// No description provided for @delivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get delivered;

  /// No description provided for @accept_order.
  ///
  /// In en, this message translates to:
  /// **'Accept Order'**
  String get accept_order;

  /// No description provided for @update_status.
  ///
  /// In en, this message translates to:
  /// **'Update Status'**
  String get update_status;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @income_vs_expense.
  ///
  /// In en, this message translates to:
  /// **'Income vs Expense'**
  String get income_vs_expense;

  /// No description provided for @savings_by_member.
  ///
  /// In en, this message translates to:
  /// **'Savings by Member'**
  String get savings_by_member;

  /// No description provided for @outstanding_loans.
  ///
  /// In en, this message translates to:
  /// **'Outstanding Loans'**
  String get outstanding_loans;

  /// No description provided for @top_products.
  ///
  /// In en, this message translates to:
  /// **'Top Products'**
  String get top_products;

  /// No description provided for @date_range_selector.
  ///
  /// In en, this message translates to:
  /// **'Date Range'**
  String get date_range_selector;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @export_csv.
  ///
  /// In en, this message translates to:
  /// **'Export CSV'**
  String get export_csv;

  /// No description provided for @export_pdf.
  ///
  /// In en, this message translates to:
  /// **'Export PDF'**
  String get export_pdf;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @edit_name.
  ///
  /// In en, this message translates to:
  /// **'Edit Name'**
  String get edit_name;

  /// No description provided for @update_photo.
  ///
  /// In en, this message translates to:
  /// **'Update Photo'**
  String get update_photo;

  /// No description provided for @language_selection_label.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language_selection_label;

  /// No description provided for @consent.
  ///
  /// In en, this message translates to:
  /// **'Research Consent'**
  String get consent;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @data_usage.
  ///
  /// In en, this message translates to:
  /// **'Data Usage'**
  String get data_usage;

  /// No description provided for @app_version.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get app_version;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @empty_state.
  ///
  /// In en, this message translates to:
  /// **'No records found'**
  String get empty_state;

  /// No description provided for @try_again.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get try_again;

  /// No description provided for @loan_pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get loan_pending;

  /// No description provided for @loan_approved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get loan_approved;

  /// No description provided for @loan_disbursed.
  ///
  /// In en, this message translates to:
  /// **'Disbursed'**
  String get loan_disbursed;

  /// No description provided for @loan_closed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get loan_closed;

  /// No description provided for @todays_tasks.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Tasks'**
  String get todays_tasks;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'te'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'te':
      return AppLocalizationsTe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
