import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pl.dart';

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
    Locale('pl'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Subscription Manager'**
  String get appTitle;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get register;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get logout;

  /// No description provided for @loginToAccount.
  ///
  /// In en, this message translates to:
  /// **'Sign in to your account'**
  String get loginToAccount;

  /// No description provided for @registerNewAccount.
  ///
  /// In en, this message translates to:
  /// **'Create a new account'**
  String get registerNewAccount;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get emailAddress;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterEmail;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// No description provided for @pleaseEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterEmail;

  /// No description provided for @pleaseEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterPassword;

  /// No description provided for @pleaseEnterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get pleaseEnterValidEmail;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @resetPasswordInstruction.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we\'ll send you a link to reset your password.'**
  String get resetPasswordInstruction;

  /// No description provided for @passwordResetSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset link has been sent'**
  String get passwordResetSent;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Link'**
  String get sendResetLink;

  /// No description provided for @userProfile.
  ///
  /// In en, this message translates to:
  /// **'User Profile'**
  String get userProfile;

  /// No description provided for @appSettings.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get appSettings;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @selectTheme.
  ///
  /// In en, this message translates to:
  /// **'Select Theme'**
  String get selectTheme;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @noDataToDisplay.
  ///
  /// In en, this message translates to:
  /// **'No data to display'**
  String get noDataToDisplay;

  /// No description provided for @paymentCalendar.
  ///
  /// In en, this message translates to:
  /// **'Payment Calendar'**
  String get paymentCalendar;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @subscriptionMarkedPaid.
  ///
  /// In en, this message translates to:
  /// **'Subscription marked as paid'**
  String get subscriptionMarkedPaid;

  /// No description provided for @todaySummary.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Summary'**
  String get todaySummary;

  /// No description provided for @weeklySummary.
  ///
  /// In en, this message translates to:
  /// **'Weekly Summary'**
  String get weeklySummary;

  /// No description provided for @monthlySummary.
  ///
  /// In en, this message translates to:
  /// **'Monthly Summary'**
  String get monthlySummary;

  /// No description provided for @paymentCount.
  ///
  /// In en, this message translates to:
  /// **'Payment Count'**
  String get paymentCount;

  /// No description provided for @totalCost.
  ///
  /// In en, this message translates to:
  /// **'Total Cost'**
  String get totalCost;

  /// No description provided for @paymentsToday.
  ///
  /// In en, this message translates to:
  /// **'Payments Today'**
  String get paymentsToday;

  /// No description provided for @paymentsThisWeek.
  ///
  /// In en, this message translates to:
  /// **'Payments This Week'**
  String get paymentsThisWeek;

  /// No description provided for @paymentsThisMonth.
  ///
  /// In en, this message translates to:
  /// **'Payments This Month'**
  String get paymentsThisMonth;

  /// No description provided for @noPaymentsToday.
  ///
  /// In en, this message translates to:
  /// **'No payments today'**
  String get noPaymentsToday;

  /// No description provided for @noPaymentsThisWeek.
  ///
  /// In en, this message translates to:
  /// **'No payments this week'**
  String get noPaymentsThisWeek;

  /// No description provided for @noPaymentsThisMonth.
  ///
  /// In en, this message translates to:
  /// **'No payments this month'**
  String get noPaymentsThisMonth;

  /// No description provided for @welcomeUser.
  ///
  /// In en, this message translates to:
  /// **'Welcome {userName}!'**
  String welcomeUser(String userName);

  /// No description provided for @mySubscriptions.
  ///
  /// In en, this message translates to:
  /// **'My Subscriptions'**
  String get mySubscriptions;

  /// No description provided for @allSubscriptions.
  ///
  /// In en, this message translates to:
  /// **'All Subscriptions'**
  String get allSubscriptions;

  /// No description provided for @dueTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Due Tomorrow'**
  String get dueTomorrow;

  /// No description provided for @dueToday.
  ///
  /// In en, this message translates to:
  /// **'Due Today'**
  String get dueToday;

  /// No description provided for @period.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get period;

  /// No description provided for @paymentDates.
  ///
  /// In en, this message translates to:
  /// **'Payment Dates'**
  String get paymentDates;

  /// No description provided for @lastPayment.
  ///
  /// In en, this message translates to:
  /// **'Last Payment'**
  String get lastPayment;

  /// No description provided for @payToday.
  ///
  /// In en, this message translates to:
  /// **'Pay Today'**
  String get payToday;

  /// No description provided for @additionalInfo.
  ///
  /// In en, this message translates to:
  /// **'Additional Information'**
  String get additionalInfo;

  /// No description provided for @reminder.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get reminder;

  /// No description provided for @createdDate.
  ///
  /// In en, this message translates to:
  /// **'Created Date'**
  String get createdDate;

  /// No description provided for @enabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabled;

  /// No description provided for @daysBefore.
  ///
  /// In en, this message translates to:
  /// **'days before'**
  String get daysBefore;

  /// No description provided for @daysBeforeParam.
  ///
  /// In en, this message translates to:
  /// **'{days} days before'**
  String daysBeforeParam(int days);

  /// No description provided for @subscriptionIcon.
  ///
  /// In en, this message translates to:
  /// **'Subscription Icon'**
  String get subscriptionIcon;

  /// No description provided for @costPLN.
  ///
  /// In en, this message translates to:
  /// **'Cost (PLN)'**
  String get costPLN;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @howOften.
  ///
  /// In en, this message translates to:
  /// **'How Often'**
  String get howOften;

  /// No description provided for @costSummary.
  ///
  /// In en, this message translates to:
  /// **'Cost Summary'**
  String get costSummary;

  /// No description provided for @averageCostPerSubscription.
  ///
  /// In en, this message translates to:
  /// **'Average Cost per Subscription'**
  String get averageCostPerSubscription;

  /// No description provided for @perMonth.
  ///
  /// In en, this message translates to:
  /// **'/month'**
  String get perMonth;

  /// No description provided for @expensesByCategory.
  ///
  /// In en, this message translates to:
  /// **'Expenses by Category'**
  String get expensesByCategory;

  /// No description provided for @totalCostWithCurrency.
  ///
  /// In en, this message translates to:
  /// **'Total Cost: {cost} PLN'**
  String totalCostWithCurrency(String cost);

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @main.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get main;

  /// No description provided for @calendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @stats.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get stats;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @subscriptions.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions'**
  String get subscriptions;

  /// No description provided for @addSubscription.
  ///
  /// In en, this message translates to:
  /// **'Add Subscription'**
  String get addSubscription;

  /// No description provided for @editSubscription.
  ///
  /// In en, this message translates to:
  /// **'Edit Subscription'**
  String get editSubscription;

  /// No description provided for @subscriptionDetails.
  ///
  /// In en, this message translates to:
  /// **'Subscription Details'**
  String get subscriptionDetails;

  /// No description provided for @subscriptionName.
  ///
  /// In en, this message translates to:
  /// **'Subscription Name'**
  String get subscriptionName;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @cost.
  ///
  /// In en, this message translates to:
  /// **'Cost'**
  String get cost;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @nextPayment.
  ///
  /// In en, this message translates to:
  /// **'Next Payment'**
  String get nextPayment;

  /// No description provided for @paymentPeriod.
  ///
  /// In en, this message translates to:
  /// **'Payment Period'**
  String get paymentPeriod;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @icon.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get icon;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'daily'**
  String get daily;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'weekly'**
  String get weekly;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'monthly'**
  String get monthly;

  /// No description provided for @yearly.
  ///
  /// In en, this message translates to:
  /// **'yearly'**
  String get yearly;

  /// No description provided for @entertainment.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get entertainment;

  /// No description provided for @music.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get music;

  /// No description provided for @video.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get video;

  /// No description provided for @gaming.
  ///
  /// In en, this message translates to:
  /// **'Gaming'**
  String get gaming;

  /// No description provided for @productivity.
  ///
  /// In en, this message translates to:
  /// **'Productivity'**
  String get productivity;

  /// No description provided for @education.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get education;

  /// No description provided for @fitness.
  ///
  /// In en, this message translates to:
  /// **'Fitness'**
  String get fitness;

  /// No description provided for @health.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get health;

  /// No description provided for @shopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get shopping;

  /// No description provided for @transport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get transport;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @markAsPaid.
  ///
  /// In en, this message translates to:
  /// **'Mark as Paid'**
  String get markAsPaid;

  /// No description provided for @deleteSubscription.
  ///
  /// In en, this message translates to:
  /// **'Delete Subscription'**
  String get deleteSubscription;

  /// No description provided for @upcomingPayments.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Payments'**
  String get upcomingPayments;

  /// No description provided for @overduePayments.
  ///
  /// In en, this message translates to:
  /// **'Overdue Payments'**
  String get overduePayments;

  /// No description provided for @noSubscriptions.
  ///
  /// In en, this message translates to:
  /// **'No Subscriptions'**
  String get noSubscriptions;

  /// No description provided for @noSubscriptionsDescription.
  ///
  /// In en, this message translates to:
  /// **'Add your first subscription to start managing your expenses'**
  String get noSubscriptionsDescription;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// No description provided for @daysLeft.
  ///
  /// In en, this message translates to:
  /// **'{days} days left'**
  String daysLeft(int days);

  /// No description provided for @overdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get overdue;

  /// No description provided for @totalMonthly.
  ///
  /// In en, this message translates to:
  /// **'Total Monthly'**
  String get totalMonthly;

  /// No description provided for @totalYearly.
  ///
  /// In en, this message translates to:
  /// **'Total Yearly'**
  String get totalYearly;

  /// No description provided for @averagePerSubscription.
  ///
  /// In en, this message translates to:
  /// **'Average per Subscription'**
  String get averagePerSubscription;

  /// No description provided for @mostExpensive.
  ///
  /// In en, this message translates to:
  /// **'Most Expensive'**
  String get mostExpensive;

  /// No description provided for @cheapest.
  ///
  /// In en, this message translates to:
  /// **'Cheapest'**
  String get cheapest;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkTheme;

  /// No description provided for @systemTheme.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemTheme;

  /// No description provided for @polish.
  ///
  /// In en, this message translates to:
  /// **'Polish'**
  String get polish;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmNewPassword;

  /// No description provided for @enterCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter current password'**
  String get enterCurrentPassword;

  /// No description provided for @enterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter new password'**
  String get enterNewPassword;

  /// No description provided for @passwordRequirements.
  ///
  /// In en, this message translates to:
  /// **'New password must be at least 6 characters and contain letters and numbers.'**
  String get passwordRequirements;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @enableNotifications.
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get enableNotifications;

  /// No description provided for @reminderDays.
  ///
  /// In en, this message translates to:
  /// **'Reminder Days Before'**
  String get reminderDays;

  /// No description provided for @notificationTime.
  ///
  /// In en, this message translates to:
  /// **'Notification Time'**
  String get notificationTime;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello {name}!'**
  String hello(String name);

  /// No description provided for @errorGeneral.
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again.'**
  String get errorGeneral;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network error. Check your connection.'**
  String get errorNetwork;

  /// No description provided for @errorAuth.
  ///
  /// In en, this message translates to:
  /// **'Authentication error. Please sign in again.'**
  String get errorAuth;

  /// No description provided for @errorInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get errorInvalidEmail;

  /// No description provided for @errorWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password is too weak'**
  String get errorWeakPassword;

  /// No description provided for @errorEmailAlreadyInUse.
  ///
  /// In en, this message translates to:
  /// **'Email is already in use'**
  String get errorEmailAlreadyInUse;

  /// No description provided for @errorUserNotFound.
  ///
  /// In en, this message translates to:
  /// **'User not found'**
  String get errorUserNotFound;

  /// No description provided for @errorWrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Wrong password'**
  String get errorWrongPassword;

  /// No description provided for @errorPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords don\'t match'**
  String get errorPasswordMismatch;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @subscriptionAdded.
  ///
  /// In en, this message translates to:
  /// **'Subscription added successfully'**
  String get subscriptionAdded;

  /// No description provided for @subscriptionUpdated.
  ///
  /// In en, this message translates to:
  /// **'Subscription updated successfully'**
  String get subscriptionUpdated;

  /// No description provided for @subscriptionDeleted.
  ///
  /// In en, this message translates to:
  /// **'Subscription deleted successfully'**
  String get subscriptionDeleted;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdated;

  /// No description provided for @passwordChanged.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get passwordChanged;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this subscription?'**
  String get confirmDelete;

  /// No description provided for @confirmLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get confirmLogout;

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

  /// No description provided for @enterSubscriptionName.
  ///
  /// In en, this message translates to:
  /// **'Enter subscription name'**
  String get enterSubscriptionName;

  /// No description provided for @enterCost.
  ///
  /// In en, this message translates to:
  /// **'Enter cost'**
  String get enterCost;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select category'**
  String get selectCategory;

  /// No description provided for @selectIcon.
  ///
  /// In en, this message translates to:
  /// **'Select icon'**
  String get selectIcon;

  /// No description provided for @enterNotes.
  ///
  /// In en, this message translates to:
  /// **'Enter notes (optional)'**
  String get enterNotes;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get selectDate;

  /// No description provided for @enterFirstName.
  ///
  /// In en, this message translates to:
  /// **'Enter first name'**
  String get enterFirstName;

  /// No description provided for @enterLastName.
  ///
  /// In en, this message translates to:
  /// **'Enter last name'**
  String get enterLastName;

  /// No description provided for @pleaseEnterFirstName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your first name'**
  String get pleaseEnterFirstName;

  /// No description provided for @pleaseEnterLastName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your last name'**
  String get pleaseEnterLastName;

  /// No description provided for @emailCannotBeChanged.
  ///
  /// In en, this message translates to:
  /// **'Email cannot be changed'**
  String get emailCannotBeChanged;

  /// No description provided for @accountEmail.
  ///
  /// In en, this message translates to:
  /// **'Account email'**
  String get accountEmail;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// No description provided for @validation_required.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get validation_required;

  /// No description provided for @validation_email.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get validation_email;

  /// No description provided for @validation_password.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get validation_password;

  /// No description provided for @validation_passwordMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords must match'**
  String get validation_passwordMatch;

  /// No description provided for @validation_cost.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid cost'**
  String get validation_cost;

  /// No description provided for @validation_name.
  ///
  /// In en, this message translates to:
  /// **'Enter valid first/last name'**
  String get validation_name;

  /// No description provided for @paymentDate.
  ///
  /// In en, this message translates to:
  /// **'Payment: {date}'**
  String paymentDate(String date);

  /// No description provided for @subscriptionMarkedAsPaid.
  ///
  /// In en, this message translates to:
  /// **'Subscription marked as paid'**
  String get subscriptionMarkedAsPaid;

  /// No description provided for @allCurrentSubscriptionsPaid.
  ///
  /// In en, this message translates to:
  /// **'All current subscriptions are paid'**
  String get allCurrentSubscriptionsPaid;

  /// No description provided for @paymentTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Payment tomorrow'**
  String get paymentTomorrow;

  /// No description provided for @daysUntilPayment.
  ///
  /// In en, this message translates to:
  /// **'{days} days until payment'**
  String daysUntilPayment(int days);

  /// No description provided for @addFirstSubscription.
  ///
  /// In en, this message translates to:
  /// **'Add your first subscription to start managing expenses'**
  String get addFirstSubscription;

  /// No description provided for @confirmDeleteSubscription.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete subscription \"{title}\"? This operation cannot be undone.'**
  String confirmDeleteSubscription(String title);

  /// No description provided for @markingAsPaid.
  ///
  /// In en, this message translates to:
  /// **'Marking as paid...'**
  String get markingAsPaid;

  /// No description provided for @enterValidCost.
  ///
  /// In en, this message translates to:
  /// **'Enter valid cost'**
  String get enterValidCost;

  /// No description provided for @updateSubscription.
  ///
  /// In en, this message translates to:
  /// **'Update subscription'**
  String get updateSubscription;

  /// No description provided for @nextPaymentDate.
  ///
  /// In en, this message translates to:
  /// **'Next payment date'**
  String get nextPaymentDate;

  /// No description provided for @paymentDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment Date'**
  String get paymentDateLabel;

  /// No description provided for @paymentOverdue.
  ///
  /// In en, this message translates to:
  /// **'Payment overdue ({days} days)'**
  String paymentOverdue(int days);

  /// No description provided for @paymentInDays.
  ///
  /// In en, this message translates to:
  /// **'Payment in {days} days'**
  String paymentInDays(int days);

  /// No description provided for @authenticationError.
  ///
  /// In en, this message translates to:
  /// **'Authentication error'**
  String get authenticationError;

  /// No description provided for @defaultIcon.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get defaultIcon;

  /// No description provided for @subscriptionNotFound.
  ///
  /// In en, this message translates to:
  /// **'Subscription not found'**
  String get subscriptionNotFound;

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// No description provided for @createNewAccount.
  ///
  /// In en, this message translates to:
  /// **'Create new account'**
  String get createNewAccount;

  /// No description provided for @fillFormToCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Fill the form to create account'**
  String get fillFormToCreateAccount;

  /// No description provided for @provideFirstName.
  ///
  /// In en, this message translates to:
  /// **'Provide first name'**
  String get provideFirstName;

  /// No description provided for @firstNameMinLength.
  ///
  /// In en, this message translates to:
  /// **'First name must be at least 2 characters'**
  String get firstNameMinLength;

  /// No description provided for @lastNameMinLength.
  ///
  /// In en, this message translates to:
  /// **'Last name must be at least 2 characters'**
  String get lastNameMinLength;

  /// No description provided for @provideValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Provide valid email address'**
  String get provideValidEmail;

  /// No description provided for @providePassword.
  ///
  /// In en, this message translates to:
  /// **'Provide password'**
  String get providePassword;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinLength;

  /// No description provided for @enterPasswordAgain.
  ///
  /// In en, this message translates to:
  /// **'Enter password again'**
  String get enterPasswordAgain;

  /// No description provided for @repeatPasswordField.
  ///
  /// In en, this message translates to:
  /// **'Repeat password'**
  String get repeatPasswordField;

  /// No description provided for @passwordsNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords are not identical'**
  String get passwordsNotMatch;

  /// No description provided for @alreadyHaveAccountQuestion.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccountQuestion;

  /// No description provided for @every3Days.
  ///
  /// In en, this message translates to:
  /// **'every 3 days'**
  String get every3Days;

  /// No description provided for @biweekly.
  ///
  /// In en, this message translates to:
  /// **'every 2 weeks'**
  String get biweekly;

  /// No description provided for @quarterly.
  ///
  /// In en, this message translates to:
  /// **'quarterly'**
  String get quarterly;

  /// No description provided for @paymentHistory.
  ///
  /// In en, this message translates to:
  /// **'Payment dates'**
  String get paymentHistory;

  /// No description provided for @lastPaymentLabel.
  ///
  /// In en, this message translates to:
  /// **'Last payment'**
  String get lastPaymentLabel;

  /// No description provided for @nextPaymentLabel.
  ///
  /// In en, this message translates to:
  /// **'Next payment'**
  String get nextPaymentLabel;

  /// No description provided for @additionalInformation.
  ///
  /// In en, this message translates to:
  /// **'Additional information'**
  String get additionalInformation;

  /// No description provided for @creationDate.
  ///
  /// In en, this message translates to:
  /// **'Creation date'**
  String get creationDate;

  /// No description provided for @markAsPaidButton.
  ///
  /// In en, this message translates to:
  /// **'Mark as paid'**
  String get markAsPaidButton;

  /// No description provided for @deleteButton.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteButton;

  /// No description provided for @periodDaily.
  ///
  /// In en, this message translates to:
  /// **'daily'**
  String get periodDaily;

  /// No description provided for @periodWeekly.
  ///
  /// In en, this message translates to:
  /// **'weekly'**
  String get periodWeekly;

  /// No description provided for @periodMonthly.
  ///
  /// In en, this message translates to:
  /// **'monthly'**
  String get periodMonthly;

  /// No description provided for @periodYearly.
  ///
  /// In en, this message translates to:
  /// **'yearly'**
  String get periodYearly;

  /// No description provided for @period3Days.
  ///
  /// In en, this message translates to:
  /// **'every 3 days'**
  String get period3Days;

  /// No description provided for @periodBiweekly.
  ///
  /// In en, this message translates to:
  /// **'biweekly'**
  String get periodBiweekly;

  /// No description provided for @periodQuarterly.
  ///
  /// In en, this message translates to:
  /// **'quarterly'**
  String get periodQuarterly;

  /// No description provided for @addSubscriptionsToSeeStats.
  ///
  /// In en, this message translates to:
  /// **'Add subscriptions to see statistics'**
  String get addSubscriptionsToSeeStats;

  /// No description provided for @paymentPeriods.
  ///
  /// In en, this message translates to:
  /// **'Payment periods'**
  String get paymentPeriods;

  /// No description provided for @mostExpensiveSubscriptions.
  ///
  /// In en, this message translates to:
  /// **'Most expensive subscriptions'**
  String get mostExpensiveSubscriptions;

  /// No description provided for @noPaymentsNext7Days.
  ///
  /// In en, this message translates to:
  /// **'No payments in the next 7 days'**
  String get noPaymentsNext7Days;

  /// No description provided for @subscriptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Subscription name'**
  String get subscriptionTitle;

  /// No description provided for @subscriptionCost.
  ///
  /// In en, this message translates to:
  /// **'Subscription cost'**
  String get subscriptionCost;

  /// No description provided for @reminderDaysBefore.
  ///
  /// In en, this message translates to:
  /// **'Reminder (days before)'**
  String get reminderDaysBefore;

  /// No description provided for @editMenuItem.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editMenuItem;

  /// No description provided for @viewMenuItem.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get viewMenuItem;

  /// No description provided for @markAsPaidMenuItem.
  ///
  /// In en, this message translates to:
  /// **'Mark as paid'**
  String get markAsPaidMenuItem;

  /// No description provided for @deleteMenuItem.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteMenuItem;

  /// No description provided for @everyXDays.
  ///
  /// In en, this message translates to:
  /// **'Every {days} days'**
  String everyXDays(int days);

  /// No description provided for @everyXWeeks.
  ///
  /// In en, this message translates to:
  /// **'Every {weeks} weeks'**
  String everyXWeeks(int weeks);

  /// No description provided for @everyXMonths.
  ///
  /// In en, this message translates to:
  /// **'Every {months} months'**
  String everyXMonths(int months);

  /// No description provided for @everyXYears.
  ///
  /// In en, this message translates to:
  /// **'Every {years} years'**
  String everyXYears(int years);

  /// No description provided for @categoryBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Category Breakdown'**
  String get categoryBreakdown;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get totalAmount;

  /// No description provided for @averagePerMonth.
  ///
  /// In en, this message translates to:
  /// **'Average per Month'**
  String get averagePerMonth;

  /// No description provided for @categoryEntertainment.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get categoryEntertainment;

  /// No description provided for @categoryMusic.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get categoryMusic;

  /// No description provided for @categoryVideo.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get categoryVideo;

  /// No description provided for @categoryGames.
  ///
  /// In en, this message translates to:
  /// **'Games'**
  String get categoryGames;

  /// No description provided for @categoryProductivity.
  ///
  /// In en, this message translates to:
  /// **'Productivity'**
  String get categoryProductivity;

  /// No description provided for @categoryEducation.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get categoryEducation;

  /// No description provided for @categoryHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get categoryHealth;

  /// No description provided for @categorySport.
  ///
  /// In en, this message translates to:
  /// **'Sport'**
  String get categorySport;

  /// No description provided for @categoryFinance.
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get categoryFinance;

  /// No description provided for @categoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get categoryOther;

  /// No description provided for @periodType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get periodType;

  /// No description provided for @periodInterval.
  ///
  /// In en, this message translates to:
  /// **'Every'**
  String get periodInterval;

  /// No description provided for @paymentToday.
  ///
  /// In en, this message translates to:
  /// **'Payment today'**
  String get paymentToday;

  /// No description provided for @paidThisMonth.
  ///
  /// In en, this message translates to:
  /// **'Paid this month'**
  String get paidThisMonth;

  /// No description provided for @daysToPayment.
  ///
  /// In en, this message translates to:
  /// **'{days} days until payment'**
  String daysToPayment(int days);

  /// No description provided for @daysShort.
  ///
  /// In en, this message translates to:
  /// **'{days} days'**
  String daysShort(int days);

  /// No description provided for @monthlyLabel.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthlyLabel;

  /// No description provided for @yearlyLabel.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get yearlyLabel;

  /// No description provided for @subscriptionNotFoundForEdit.
  ///
  /// In en, this message translates to:
  /// **'Subscription not found for editing'**
  String get subscriptionNotFoundForEdit;

  /// No description provided for @subscriptionNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Netflix, Spotify...'**
  String get subscriptionNameHint;

  /// No description provided for @minimumOne.
  ///
  /// In en, this message translates to:
  /// **'Min. 1'**
  String get minimumOne;

  /// No description provided for @notesHint.
  ///
  /// In en, this message translates to:
  /// **'Additional information...'**
  String get notesHint;

  /// No description provided for @loadingChangingPassword.
  ///
  /// In en, this message translates to:
  /// **'Changing password...'**
  String get loadingChangingPassword;

  /// No description provided for @loadingUpdatingProfile.
  ///
  /// In en, this message translates to:
  /// **'Updating profile...'**
  String get loadingUpdatingProfile;

  /// No description provided for @loadingUpdatingSubscription.
  ///
  /// In en, this message translates to:
  /// **'Updating subscription...'**
  String get loadingUpdatingSubscription;

  /// No description provided for @loadingDeletingSubscription.
  ///
  /// In en, this message translates to:
  /// **'Deleting subscription...'**
  String get loadingDeletingSubscription;

  /// No description provided for @loadingMarkingAsPaid.
  ///
  /// In en, this message translates to:
  /// **'Marking as paid...'**
  String get loadingMarkingAsPaid;

  /// No description provided for @loadingProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get loadingProcessing;

  /// No description provided for @loadingPleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please wait...'**
  String get loadingPleaseWait;

  /// No description provided for @loadingDefault.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loadingDefault;

  /// No description provided for @errorChangingPassword.
  ///
  /// In en, this message translates to:
  /// **'Error while changing password: {error}'**
  String errorChangingPassword(String error);

  /// No description provided for @errorInitializingApp.
  ///
  /// In en, this message translates to:
  /// **'Error while initializing app'**
  String get errorInitializingApp;

  /// No description provided for @errorLoadingApp.
  ///
  /// In en, this message translates to:
  /// **'Error loading app'**
  String get errorLoadingApp;

  /// No description provided for @errorPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorPageTitle;

  /// No description provided for @errorLogin.
  ///
  /// In en, this message translates to:
  /// **'Error occurred during login'**
  String get errorLogin;

  /// No description provided for @errorRegister.
  ///
  /// In en, this message translates to:
  /// **'Error occurred during registration'**
  String get errorRegister;

  /// No description provided for @errorInvalidLogin.
  ///
  /// In en, this message translates to:
  /// **'Invalid login or password'**
  String get errorInvalidLogin;

  /// No description provided for @errorEmailAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'Account with this email already exists'**
  String get errorEmailAlreadyExists;

  /// No description provided for @errorWeakPasswordAuth.
  ///
  /// In en, this message translates to:
  /// **'Password is too weak'**
  String get errorWeakPasswordAuth;

  /// No description provided for @errorUserDisabled.
  ///
  /// In en, this message translates to:
  /// **'User account has been disabled'**
  String get errorUserDisabled;

  /// No description provided for @errorTooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many login attempts. Please try again later'**
  String get errorTooManyRequests;

  /// No description provided for @errorOperationNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'Operation is not allowed'**
  String get errorOperationNotAllowed;

  /// No description provided for @errorNetworkFailed.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get errorNetworkFailed;

  /// No description provided for @errorGenericAuth.
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again later'**
  String get errorGenericAuth;

  /// No description provided for @errorUnexpected.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred'**
  String get errorUnexpected;

  /// No description provided for @errorUserDataNotFound.
  ///
  /// In en, this message translates to:
  /// **'User data not found'**
  String get errorUserDataNotFound;

  /// No description provided for @verifyYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Verify your email'**
  String get verifyYourEmail;

  /// No description provided for @checkEmailForVerification.
  ///
  /// In en, this message translates to:
  /// **'Check your inbox and click the verification link.'**
  String get checkEmailForVerification;

  /// No description provided for @checkVerification.
  ///
  /// In en, this message translates to:
  /// **'Check verification'**
  String get checkVerification;

  /// No description provided for @resendEmail.
  ///
  /// In en, this message translates to:
  /// **'Resend email'**
  String get resendEmail;

  /// No description provided for @hide.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get hide;

  /// No description provided for @emailVerificationSent.
  ///
  /// In en, this message translates to:
  /// **'Verification email has been sent again'**
  String get emailVerificationSent;

  /// No description provided for @emailVerified.
  ///
  /// In en, this message translates to:
  /// **'Email has been verified! 🎉'**
  String get emailVerified;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @orSignInWith.
  ///
  /// In en, this message translates to:
  /// **'Or sign in with'**
  String get orSignInWith;

  /// No description provided for @orSignUpWith.
  ///
  /// In en, this message translates to:
  /// **'Or sign up with'**
  String get orSignUpWith;

  /// No description provided for @enterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get enterValidEmail;
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
      <String>['en', 'pl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pl':
      return AppLocalizationsPl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
