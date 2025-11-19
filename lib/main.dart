import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize local notifications
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
    onDidReceiveLocalNotification:
        (int id, String? title, String? body, String? payload) async {},
  );
  
  final InitializationSettings initializationSettings =
      InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );
  
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse:
        (NotificationResponse notificationResponse) async {},
  );

  runApp(const LocationReminderApp());
}

class LocationReminderApp extends StatelessWidget {
  const LocationReminderApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Location Reminder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Location location = Location();
  List<ReminderItem> reminders = [];
  bool isLocationEnabled = false;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    final PermissionStatus status = await Permission.location.request();
    setState(() {
      isLocationEnabled = status.isGranted;
    });
  }

  void _addNewReminder() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Add Location Reminder'),
        content: AddReminderDialog(onReminderAdded: (reminder) {
          setState(() {
            reminders.add(reminder);
          });
          Navigator.pop(context);
        }),
      ),
    );
  }

  void _triggerAlarm(String destinationName) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'location_reminder_channel',
      'Location Reminders',
      channelDescription: 'Notifications for location-based reminders',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('alarm'),
    );
    
    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'Approaching Destination',
      'You are about to reach $destinationName',
      platformChannelSpecifics,
      payload: destinationName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Reminder'),
        centerTitle: true,
        elevation: 0,
      ),
      body: isLocationEnabled
          ? reminders.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.location_off, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text(
                        'No reminders yet',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _addNewReminder,
                        child: const Text('Add Your First Reminder'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: reminders.length,
                  itemBuilder: (context, index) {
                    final reminder = reminders[index];
                    return ListTile(
                      title: Text(reminder.destinationName),
                      subtitle: Text(
                        'Alert: ${reminder.minutesBefore} minutes before arrival',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() => reminders.removeAt(index));
                        },
                      ),
                    );
                  },
                )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_disabled, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text('Location access required'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _checkLocationPermission,
                    child: const Text('Enable Location'),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewReminder,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ReminderItem {
  final String destinationName;
  final double latitude;
  final double longitude;
  final int minutesBefore;

  ReminderItem({
    required this.destinationName,
    required this.latitude,
    required this.longitude,
    required this.minutesBefore,
  });
}

class AddReminderDialog extends StatefulWidget {
  final Function(ReminderItem) onReminderAdded;

  const AddReminderDialog({Key? key, required this.onReminderAdded})
      : super(key: key);

  @override
  State<AddReminderDialog> createState() => _AddReminderDialogState();
}

class _AddReminderDialogState extends State<AddReminderDialog> {
  late TextEditingController nameController;
  late TextEditingController latitudeController;
  late TextEditingController longitudeController;
  int selectedMinutes = 5;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    latitudeController = TextEditingController();
    longitudeController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Destination Name'),
        ),
        TextField(
          controller: latitudeController,
          decoration: const InputDecoration(labelText: 'Latitude'),
          keyboardType: TextInputType.number,
        ),
        TextField(
          controller: longitudeController,
          decoration: const InputDecoration(labelText: 'Longitude'),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        DropdownButton<int>(
          value: selectedMinutes,
          items: [5, 10, 15, 20, 30].map((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text('$value minutes before'),
            );
          }).toList(),
          onChanged: (int? newValue) {
            setState(() => selectedMinutes = newValue ?? 5);
          },
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            if (nameController.text.isNotEmpty &&
                latitudeController.text.isNotEmpty &&
                longitudeController.text.isNotEmpty) {
              widget.onReminderAdded(
                ReminderItem(
                  destinationName: nameController.text,
                  latitude: double.parse(latitudeController.text),
                  longitude: double.parse(longitudeController.text),
                  minutesBefore: selectedMinutes,
                ),
              );
            }
          },
          child: const Text('Save Reminder'),
        ),
      ],
    );
  }
}
