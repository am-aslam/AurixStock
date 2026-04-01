class AppConstants {
  static const String appName    = 'AurixStock';
  static const String appVersion = '2.0.0';
  static const String appTagline = 'Premium Gold Stock Manager';

  // Hive boxes
  static const String stockBox       = 'stock_entries';
  static const String vendorBox      = 'vendors';
  static const String transactionBox = 'transactions';
  static const String settingsBox    = 'settings';

  // Hive type IDs
  static const int stockTypeId       = 0;
  static const int vendorTypeId      = 1;
  static const int transactionTypeId = 2;

  // Settings keys
  static const String keyTheme           = 'theme_mode';
  static const String keyPinEnabled      = 'pin_enabled';
  static const String keyPin             = 'pin_code';
  static const String keyBiometric       = 'biometric_enabled';
  static const String keyCurrency        = 'currency';
  static const String keyWeightUnit      = 'weight_unit';
  static const String keyShopName        = 'shop_name';
  static const String keyLastBackup      = 'last_backup';
  static const String keyOnboarded       = 'onboarded';

  // Defaults
  static const String defaultCurrency   = '₹';
  static const String defaultWeightUnit = 'g';
  static const String defaultShopName   = 'My Gold Shop';

  // Gold categories
  static const List<String> goldCategories = [
    'Ring', 'Necklace', 'Bracelet', 'Earring',
    'Pendant', 'Bangle', 'Chain', 'Anklet',
    'Nose Pin', 'Coin', 'Bar', 'Other',
  ];

  // Karat options
  static const List<String> karatOptions = [
    '24K', '22K', '21K', '20K', '18K', '14K', '10K',
  ];

  // Payment modes
  static const List<String> paymentModes = [
    'Cash', 'UPI', 'Bank Transfer', 'Card', 'Cheque', 'Other',
  ];

  // Transaction types
  static const String txIn     = 'in';
  static const String txOut    = 'out';
  static const String credit   = 'credit';
  static const String debit    = 'debit';
}
