import 'package:get/get.dart';

import '../models/notification_model.dart';
import '../models/user_model.dart';
import '../providers/laravel_provider.dart';

class NotificationRepository {
  LaravelApiClient _laravelApiClient;

  NotificationRepository() {
    this._laravelApiClient = Get.find<LaravelApiClient>();
  }

  Future<List<NotificationModel>> getAll() {
    return _laravelApiClient.getNotifications();
  }

  Future<NotificationModel> remove(NotificationModel notification) {
    return _laravelApiClient.removeNotification(notification);
  }

  Future<NotificationModel> markAsRead(NotificationModel notification) {
    return _laravelApiClient.markAsReadNotification(notification);
  }

  Future<bool> sendNotification(List<User> users, User from, String type, String text, String id) {
    return _laravelApiClient.sendNotification(users, from, type, text, id);
  }
}
