import 'package:firebase_analytics/firebase_analytics.dart';

class Analytics {
  static FirebaseAnalytics _fireBaseAnalytics = FirebaseAnalytics.instance;

  static getNavigatorObserver() =>
      FirebaseAnalyticsObserver(analytics: _fireBaseAnalytics);

  static _newEvent({required String name, required Map<String, dynamic> parameters}) =>
      _fireBaseAnalytics.logEvent(name: name, parameters: parameters);

  static setCurrentScreen(String screenName) =>
      _fireBaseAnalytics.setCurrentScreen(screenName: screenName);

  static notificationClicked(String itemType) =>
      _newEvent(name: 'notification_clicked', parameters: {'item_type': itemType});

  static scheduledNotificationCreated(String itemType) => _newEvent(
      name: 'scheduled_notification_created', parameters: {'item_type': itemType});

  static void itemCreated(String itemType) =>
      _newEvent(name: 'item_created', parameters: {'item_type': itemType});

  static itemCreatedFAB(String itemType) =>
      _newEvent(name: 'fab_item_created', parameters: {'item_type': itemType});

  static editItemTitle(
      String itemType, String oldTitle, String newTitle) =>
      _newEvent(name: 'item_title_edited', parameters: {
        'item_type': itemType,
        'oldTitle': oldTitle,
        'newTitle': newTitle
      });

  static markAsUnseen(String itemType) =>
      _newEvent(name: 'item_marked_unseen', parameters: {'item type': itemType});

  static newReminderTime(
      String itemType, bool wasSnoozed, Duration newReminder) =>
      _newEvent(name: 'item_marked_unseen', parameters: {
        'item_type': itemType,
        'wasSnoozed': wasSnoozed,
        'newReminder': newReminder
      });

  static itemMovedToHistory(String itemType) => _newEvent(
      name: 'item_moved_to_history', parameters: {'item_type': itemType});

  static itemPermanentlyDeleted(String itemType) => _newEvent(
      name: 'item_permanently_deleted', parameters: {'item_type': itemType});

  static itemRestoredFromHistory(String itemType) => _newEvent(
      name: 'item_restored_from_history', parameters: {'item_type': itemType});

  static deleteAllItemFromHistory(int numOfItemDeleted) => _newEvent(
      name: 'delete_all_items_from_history',
      parameters: {'num_of_item_deleted': numOfItemDeleted});

  //from: history / main_page / notification
  static itemOpened(String itemType, String from) =>
      _newEvent(name: 'item_opened_$from', parameters: {'item_type': itemType});

  static settingsAutoDeleteFromHistory(String duration) => _newEvent(
      name: 'auto_delete_from_history_setting', parameters: {'duration': duration});
}
