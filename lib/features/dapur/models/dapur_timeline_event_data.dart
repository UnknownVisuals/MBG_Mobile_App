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
  TimelineEventData({
    this.type,
    this.title,
    this.description,
    this.timestamp,
    this.role,
    this.isCompleted,
    this.isActive,
  });

  final TimelineEventType? type;
  final String? title;
  final String? description;
  final DateTime? timestamp;
  final bool? isCompleted;
  final bool? isActive;
  final String? role;
}
