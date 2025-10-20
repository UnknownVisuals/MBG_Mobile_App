enum TimelineEventType {
  // PIC_DAPUR events
  mulaiMemasak,
  selesaiMemasak,
  selesaiPacking,
  kitchenReceived,
  washingComplete,
  // DRIVER events
  schoolToDriverReturn,
  driverToKitchen,
}

class TimelineEventData {
  final TimelineEventType type;
  final String title;
  final String description;
  final DateTime timestamp;
  final bool isCompleted;
  final bool isActive;

  TimelineEventData({
    required this.type,
    required this.title,
    required this.description,
    required this.timestamp,
    this.isCompleted = false,
    this.isActive = false,
  });
}
