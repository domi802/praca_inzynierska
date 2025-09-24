// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Substracto';

  @override
  String get login => 'Sign In';

  @override
  String get register => 'Sign Up';

  @override
  String get logout => 'Sign Out';

  @override
  String get loginToAccount => 'Sign in to your account';

  @override
  String get registerNewAccount => 'Create a new account';

  @override
  String get emailAddress => 'Email address';

  @override
  String get enterEmail => 'Enter your email';

  @override
  String get enterPassword => 'Enter your password';

  @override
  String get pleaseEnterEmail => 'Please enter your email';

  @override
  String get pleaseEnterPassword => 'Please enter your password';

  @override
  String get pleaseEnterValidEmail => 'Please enter a valid email address';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get resetPasswordInstruction =>
      'Enter your email address and we\'ll send you a link to reset your password.';

  @override
  String get passwordResetSent => 'Password reset link has been sent';

  @override
  String get sendResetLink => 'Send Link';

  @override
  String get userProfile => 'User Profile';

  @override
  String get appSettings => 'App Settings';

  @override
  String get account => 'Account';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get selectTheme => 'Select Theme';

  @override
  String get error => 'Error';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get noDataToDisplay => 'No data to display';

  @override
  String get appInitializationError => 'Application initialization error';

  @override
  String get checkInternetConnection =>
      'Check your internet connection and try again';

  @override
  String get paymentCalendar => 'Payment Calendar';

  @override
  String get thisWeek => 'This Week';

  @override
  String get thisMonth => 'This Month';

  @override
  String get details => 'Details';

  @override
  String get subscriptionMarkedPaid => 'Subscription marked as paid';

  @override
  String get todaySummary => 'Today\'s Summary';

  @override
  String get weeklySummary => 'Weekly Summary';

  @override
  String get monthlySummary => 'Monthly Summary';

  @override
  String get paymentCount => 'Payment Count';

  @override
  String get totalCost => 'Total Cost';

  @override
  String get paymentsToday => 'Payments Today';

  @override
  String get paymentsThisWeek => 'Payments This Week';

  @override
  String get paymentsThisMonth => 'Payments This Month';

  @override
  String get noPaymentsToday => 'No payments today';

  @override
  String get noPaymentsThisWeek => 'No payments this week';

  @override
  String get noPaymentsThisMonth => 'No payments this month';

  @override
  String welcomeUser(String userName) {
    return 'Welcome $userName!';
  }

  @override
  String get mySubscriptions => 'My Subscriptions';

  @override
  String get allSubscriptions => 'All Subscriptions';

  @override
  String get dueTomorrow => 'Due Tomorrow';

  @override
  String get dueToday => 'Due Today';

  @override
  String get period => 'Period';

  @override
  String get paymentDates => 'Payment Dates';

  @override
  String get lastPayment => 'Last Payment';

  @override
  String get payToday => 'Pay Today';

  @override
  String get additionalInfo => 'Additional Information';

  @override
  String get reminder => 'Reminder';

  @override
  String get createdDate => 'Created Date';

  @override
  String get enabled => 'Enabled';

  @override
  String get daysBefore => 'days before';

  @override
  String daysBeforeParam(int days) {
    return '$days days before';
  }

  @override
  String get subscriptionIcon => 'Subscription Icon';

  @override
  String get costPLN => 'Cost (PLN)';

  @override
  String get type => 'Type';

  @override
  String get howOften => 'How Often';

  @override
  String get costSummary => 'Cost Summary';

  @override
  String get averageCostPerSubscription => 'Average Cost per Subscription';

  @override
  String get perMonth => '/month';

  @override
  String get expensesByCategory => 'Expenses by Category';

  @override
  String totalCostWithCurrency(String cost) {
    return 'Total Cost: $cost PLN';
  }

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get firstName => 'First Name';

  @override
  String get lastName => 'Last Name';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get createAccount => 'Create Account';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get or => 'or';

  @override
  String get main => 'Home';

  @override
  String get calendar => 'Calendar';

  @override
  String get add => 'Add';

  @override
  String get stats => 'Statistics';

  @override
  String get profile => 'Profile';

  @override
  String get subscriptions => 'Subscriptions';

  @override
  String get addSubscription => 'Add Subscription';

  @override
  String get editSubscription => 'Edit Subscription';

  @override
  String get subscriptionDetails => 'Subscription Details';

  @override
  String get subscriptionName => 'Subscription Name';

  @override
  String get category => 'Category';

  @override
  String get cost => 'Cost';

  @override
  String get currency => 'Currency';

  @override
  String get nextPayment => 'Next Payment';

  @override
  String get paymentPeriod => 'Payment Period';

  @override
  String get notes => 'Notes';

  @override
  String get icon => 'Icon';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get daily => 'daily';

  @override
  String get weekly => 'weekly';

  @override
  String get monthly => 'monthly';

  @override
  String get yearly => 'yearly';

  @override
  String get entertainment => 'Entertainment';

  @override
  String get music => 'Music';

  @override
  String get video => 'Video';

  @override
  String get gaming => 'Gaming';

  @override
  String get productivity => 'Productivity';

  @override
  String get education => 'Education';

  @override
  String get fitness => 'Fitness';

  @override
  String get health => 'Health';

  @override
  String get shopping => 'Shopping';

  @override
  String get transport => 'Transport';

  @override
  String get other => 'Other';

  @override
  String get markAsPaid => 'Mark as Paid';

  @override
  String get deleteSubscription => 'Delete Subscription';

  @override
  String get upcomingPayments => 'Upcoming Payments';

  @override
  String get overduePayments => 'Overdue Payments';

  @override
  String get noSubscriptions => 'No Subscriptions';

  @override
  String get noSubscriptionsDescription =>
      'Add your first subscription to start managing your expenses';

  @override
  String get today => 'Today';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String daysLeft(int days) {
    return '$days days left';
  }

  @override
  String get overdue => 'Overdue';

  @override
  String get totalMonthly => 'Total Monthly';

  @override
  String get totalYearly => 'Total Yearly';

  @override
  String get averagePerSubscription => 'Average per Subscription';

  @override
  String get mostExpensive => 'Most Expensive';

  @override
  String get cheapest => 'Cheapest';

  @override
  String get settings => 'Settings';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get notifications => 'Notifications';

  @override
  String get theme => 'Theme';

  @override
  String get language => 'Language';

  @override
  String get security => 'Security';

  @override
  String get changePassword => 'Change Password';

  @override
  String get lightTheme => 'Light';

  @override
  String get darkTheme => 'Dark';

  @override
  String get systemTheme => 'System';

  @override
  String get polish => 'Polish';

  @override
  String get english => 'English';

  @override
  String get currentPassword => 'Current Password';

  @override
  String get newPassword => 'New Password';

  @override
  String get confirmNewPassword => 'Confirm New Password';

  @override
  String get enterCurrentPassword => 'Enter current password';

  @override
  String get enterNewPassword => 'Enter new password';

  @override
  String get passwordRequirements =>
      'Password must be at least 6 characters and contain at least one digit, one uppercase letter, and one special character.';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get enableNotifications => 'Enable Notifications';

  @override
  String get reminderDays => 'Reminder Days Before';

  @override
  String get notificationTime => 'Notification Time';

  @override
  String hello(String name) {
    return 'Hello $name!';
  }

  @override
  String get errorGeneral => 'An error occurred. Please try again.';

  @override
  String get errorNetwork => 'Network error. Check your connection.';

  @override
  String get errorAuth => 'Authentication error. Please sign in again.';

  @override
  String get errorInvalidEmail => 'Invalid email address';

  @override
  String get errorWeakPassword => 'Password is too weak';

  @override
  String get errorEmailAlreadyInUse => 'Email is already in use';

  @override
  String get errorUserNotFound => 'User not found';

  @override
  String get errorWrongPassword => 'Wrong password';

  @override
  String get errorPasswordMismatch => 'Passwords don\'t match';

  @override
  String get success => 'Success';

  @override
  String get subscriptionAdded => 'Subscription added successfully';

  @override
  String get subscriptionUpdated => 'Subscription updated successfully';

  @override
  String get subscriptionDeleted => 'Subscription deleted successfully';

  @override
  String get profileUpdated => 'Profile updated successfully';

  @override
  String get passwordChanged => 'Password changed successfully';

  @override
  String get confirmDelete =>
      'Are you sure you want to delete this subscription?';

  @override
  String get confirmLogout => 'Are you sure you want to sign out?';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get enterSubscriptionName => 'Enter subscription name';

  @override
  String get enterCost => 'Enter cost';

  @override
  String get selectCategory => 'Select category';

  @override
  String get selectIcon => 'Select icon';

  @override
  String get enterNotes => 'Enter notes (optional)';

  @override
  String get selectDate => 'Select date';

  @override
  String get enterFirstName => 'Enter first name';

  @override
  String get enterLastName => 'Enter last name';

  @override
  String get pleaseEnterFirstName => 'Please enter your first name';

  @override
  String get pleaseEnterLastName => 'Please enter your last name';

  @override
  String get emailCannotBeChanged => 'Email cannot be changed';

  @override
  String get accountEmail => 'Account email';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get validation_required => 'This field is required';

  @override
  String get validation_email => 'Please enter a valid email address';

  @override
  String get validation_password => 'Password must be at least 6 characters';

  @override
  String get validation_passwordMatch => 'Passwords must match';

  @override
  String get validation_cost => 'Please enter a valid cost';

  @override
  String get validation_name => 'Enter valid first/last name';

  @override
  String paymentDate(String date) {
    return 'Payment: $date';
  }

  @override
  String get subscriptionMarkedAsPaid => 'Subscription marked as paid';

  @override
  String get allCurrentSubscriptionsPaid =>
      'All current subscriptions are paid';

  @override
  String get paymentTomorrow => 'Payment tomorrow';

  @override
  String daysUntilPayment(int days) {
    return '$days days until payment';
  }

  @override
  String get addFirstSubscription =>
      'Add your first subscription to start managing expenses';

  @override
  String confirmDeleteSubscription(String title) {
    return 'Are you sure you want to delete subscription \"$title\"? This operation cannot be undone.';
  }

  @override
  String get markingAsPaid => 'Marking as paid...';

  @override
  String get enterValidCost => 'Enter valid cost';

  @override
  String get updateSubscription => 'Update subscription';

  @override
  String get nextPaymentDate => 'Next payment date';

  @override
  String get paymentDateLabel => 'Payment Date';

  @override
  String paymentOverdue(int days) {
    return 'Payment overdue ($days days)';
  }

  @override
  String paymentInDays(int days) {
    return 'Payment in $days days';
  }

  @override
  String get authenticationError => 'Authentication error';

  @override
  String get defaultIcon => 'Default';

  @override
  String get subscriptionNotFound => 'Subscription not found';

  @override
  String get disabled => 'Disabled';

  @override
  String get createNewAccount => 'Create new account';

  @override
  String get fillFormToCreateAccount => 'Fill the form to create account';

  @override
  String get provideFirstName => 'Provide first name';

  @override
  String get firstNameMinLength => 'First name must be at least 2 characters';

  @override
  String get lastNameMinLength => 'Last name must be at least 2 characters';

  @override
  String get provideValidEmail => 'Provide valid email address';

  @override
  String get providePassword => 'Provide password';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters';

  @override
  String get enterPasswordAgain => 'Enter password again';

  @override
  String get repeatPasswordField => 'Repeat password';

  @override
  String get passwordsNotMatch => 'Passwords are not identical';

  @override
  String get alreadyHaveAccountQuestion => 'Already have an account? ';

  @override
  String get every3Days => 'every 3 days';

  @override
  String get biweekly => 'every 2 weeks';

  @override
  String get quarterly => 'quarterly';

  @override
  String get paymentHistory => 'Payment dates';

  @override
  String get lastPaymentLabel => 'Last payment';

  @override
  String get nextPaymentLabel => 'Next payment';

  @override
  String get additionalInformation => 'Additional information';

  @override
  String get creationDate => 'Creation date';

  @override
  String get markAsPaidButton => 'Mark as paid';

  @override
  String get deleteButton => 'Delete';

  @override
  String get periodDaily => 'daily';

  @override
  String get periodWeekly => 'weekly';

  @override
  String get periodMonthly => 'monthly';

  @override
  String get periodYearly => 'yearly';

  @override
  String get period3Days => 'every 3 days';

  @override
  String get periodBiweekly => 'biweekly';

  @override
  String get periodQuarterly => 'quarterly';

  @override
  String get addSubscriptionsToSeeStats =>
      'Add subscriptions to see statistics';

  @override
  String get paymentPeriods => 'Payment periods';

  @override
  String get mostExpensiveSubscriptions => 'Most expensive subscriptions';

  @override
  String get noPaymentsNext7Days => 'No payments in the next 7 days';

  @override
  String get subscriptionTitle => 'Subscription name';

  @override
  String get subscriptionCost => 'Subscription cost';

  @override
  String get reminderDaysBefore => 'Reminder (days before)';

  @override
  String get editMenuItem => 'Edit';

  @override
  String get viewMenuItem => 'Details';

  @override
  String get markAsPaidMenuItem => 'Mark as paid';

  @override
  String get deleteMenuItem => 'Delete';

  @override
  String everyXDays(int days) {
    return 'Every $days days';
  }

  @override
  String everyXWeeks(int weeks) {
    return 'Every $weeks weeks';
  }

  @override
  String everyXMonths(int months) {
    return 'Every $months months';
  }

  @override
  String everyXYears(int years) {
    return 'Every $years years';
  }

  @override
  String get categoryBreakdown => 'Category Breakdown';

  @override
  String get totalAmount => 'Total Amount';

  @override
  String get averagePerMonth => 'Average per Month';

  @override
  String get categoryEntertainment => 'Entertainment';

  @override
  String get categoryMusic => 'Music';

  @override
  String get categoryVideo => 'Video';

  @override
  String get categoryGames => 'Games';

  @override
  String get categoryProductivity => 'Productivity';

  @override
  String get categoryEducation => 'Education';

  @override
  String get categoryHealth => 'Health';

  @override
  String get categorySport => 'Sport';

  @override
  String get categoryFinance => 'Finance';

  @override
  String get categoryOther => 'Other';

  @override
  String get periodType => 'Type';

  @override
  String get periodInterval => 'Every';

  @override
  String get paymentToday => 'Payment today';

  @override
  String get paidThisMonth => 'Paid this month';

  @override
  String daysToPayment(int days) {
    return '$days days until payment';
  }

  @override
  String daysShort(int days) {
    return '$days days';
  }

  @override
  String get monthlyLabel => 'Monthly';

  @override
  String get yearlyLabel => 'Yearly';

  @override
  String get subscriptionNotFoundForEdit =>
      'Subscription not found for editing';

  @override
  String get subscriptionNameHint => 'e.g. Netflix, Spotify...';

  @override
  String get minimumOne => 'Min. 1';

  @override
  String get notesHint => 'Additional information...';

  @override
  String get loadingChangingPassword => 'Changing password...';

  @override
  String get loadingUpdatingProfile => 'Updating profile...';

  @override
  String get loadingUpdatingSubscription => 'Updating subscription...';

  @override
  String get loadingDeletingSubscription => 'Deleting subscription...';

  @override
  String get loadingMarkingAsPaid => 'Marking as paid...';

  @override
  String get loadingProcessing => 'Processing...';

  @override
  String get loadingPleaseWait => 'Please wait...';

  @override
  String get loadingDefault => 'Loading...';

  @override
  String errorChangingPassword(String error) {
    return 'Error while changing password: $error';
  }

  @override
  String get errorInitializingApp => 'Error while initializing app';

  @override
  String get errorLoadingApp => 'Error loading app';

  @override
  String get errorPageTitle => 'Error';

  @override
  String get errorLogin => 'Error occurred during login';

  @override
  String get errorRegister => 'Error occurred during registration';

  @override
  String get errorInvalidLogin => 'Invalid login or password';

  @override
  String get errorEmailAlreadyExists =>
      'Account with this email already exists';

  @override
  String get errorWeakPasswordAuth => 'Password is too weak';

  @override
  String get errorUserDisabled => 'User account has been disabled';

  @override
  String get errorTooManyRequests =>
      'Too many login attempts. Please try again later';

  @override
  String get errorOperationNotAllowed => 'Operation is not allowed';

  @override
  String get errorNetworkFailed => 'No internet connection';

  @override
  String get errorGenericAuth => 'An error occurred. Please try again later';

  @override
  String get errorUnexpected => 'An unexpected error occurred';

  @override
  String get errorUserDataNotFound => 'User data not found';

  @override
  String get verifyYourEmail => 'Verify your email';

  @override
  String get checkEmailForVerification =>
      'Check your inbox and click the verification link.';

  @override
  String get checkVerification => 'Check verification';

  @override
  String get resendEmail => 'Resend email';

  @override
  String get hide => 'Hide';

  @override
  String get emailVerificationSent => 'Verification email has been sent again';

  @override
  String get emailVerified => 'Email has been verified! 🎉';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get orSignInWith => 'Or sign in with';

  @override
  String get orSignUpWith => 'Or sign up with';

  @override
  String get enterValidEmail => 'Enter a valid email address';

  @override
  String get passwordRequiredMessage => 'Password is required';

  @override
  String get passwordMinLengthMessage =>
      'Password must be at least 6 characters';

  @override
  String get passwordDigitRequiredMessage =>
      'Password must contain at least one digit';

  @override
  String get passwordUppercaseRequiredMessage =>
      'Password must contain at least one uppercase letter';

  @override
  String get passwordSpecialCharRequiredMessage =>
      'Password must contain at least one special character';

  @override
  String get passwordAllRequirementsMustBeMet =>
      'All password requirements must be met';
}
