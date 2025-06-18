import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationLocalService {
  static final NotificationLocalService _instance = NotificationLocalService._internal();

  factory NotificationLocalService() => _instance;

  NotificationLocalService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  bool _initialized = false;
  bool get initialized => _initialized;

  Future<void> init() async {
    if (_initialized) return;

    await _setupTimezone();
    await _initializeNotifications();
    await requestNotificationPermission();
    _initialized = true;
  }

  Future<void> _setupTimezone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  Future<void> _initializeNotifications() async {
    // prepara as configurações iniciais para Android e iOS
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iOSSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Configurações de inicialização para Android e iOS
    const InitializationSettings initializationSettings = InitializationSettings(android: androidSettings, iOS: iOSSettings);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  Future<void> requestNotificationPermission() async {
    final status = await Permission.notification.status;

    if (!status.isGranted) {
      final result = await Permission.notification.request();

      if (result.isGranted) {
        debugPrint('Permissão concedida');
      } else {
        debugPrint('Permissão negada');
      }
    }
  }

  Future<void> requestExactAlarmPermission(BuildContext context) async {
    if (defaultTargetPlatform != TargetPlatform.android) return;

    final status = await Permission.scheduleExactAlarm.status;

    if (!context.mounted) return;

    switch (status) {
      case PermissionStatus.granted:
        // Permissão já concedida, não faz nada.
        break;

      case PermissionStatus.denied:
        // Permissão negada, solicita novamente.
        await Permission.scheduleExactAlarm.request();
        break;

      case PermissionStatus.permanentlyDenied:
        // Permissão negada permanentemente, guia o usuário para as configurações.
        await showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Permissão Necessária'),
            content: const Text(
              'Para que os lembretes funcionem na hora certa, por favor, habilite a permissão para "Alarmes e lembretes" nas configurações do aplicativo.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  openAppSettings();
                  Navigator.of(context).pop();
                },
                child: const Text('Abrir Configurações'),
              ),
            ],
          ),
        );
        break;
      default:
        await Permission.scheduleExactAlarm.request();
        break;
    }
  }

  NotificationDetails getNotificationDetails() {
    // Configurações específicas para Android
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'first_count_channel_id',
      'Notificação de Primeira Contagem',
      channelDescription: 'Notificação para a data da primeira contagem de sementes germinadas',
      importance: Importance.max,
      priority: Priority.high,
    );

    return const NotificationDetails(android: androidDetails, iOS: DarwinNotificationDetails());
  }

  Future<void> scheduleGerminationNotification({
    required int testId,
    required DateTime date,
    required String seedName,
  }) async {
    final scheduledDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      9, // hora
      0, // minuto
      0, // segundo
    );
    final scheduledDate = tz.TZDateTime.from(scheduledDateTime, tz.local);

    //final scheduledDate = tz.TZDateTime.from(date.add(Duration(seconds: 10)), tz.local);
    print('Notificação agendada para: $scheduledDate');

    await flutterLocalNotificationsPlugin.zonedSchedule(
      testId,
      'Hora da contagem!',
      'A semente "$seedName" está pronta para a primeira contagem.',
      scheduledDate,
      getNotificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  Future<void> cancelGerminationNotification(int testId) async {
    await flutterLocalNotificationsPlugin.cancel(testId);
  }
}
