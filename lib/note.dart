class Note {
  final int? id; // Nullable for new notes
  String title;
  String subtitle;
  String body;
  DateTime created;

  Note({
    this.id,
    required this.title,
    required this.subtitle,
    required this.body,
    required this.created,
  });

  // Convert Note object to a Map for SQLite operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'body': body,
      'created': created.millisecondsSinceEpoch,
    };
  }

  // Create a Note object from a Map (e.g., retrieved from the database)
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      subtitle: map['subtitle'],
      body: map['body'],
      created: DateTime.fromMillisecondsSinceEpoch(map['created']),
    );
  }

  // Update fields of the note
  void update({
    String? title,
    String? subtitle,
    String? body,
    DateTime? created,
  }) {
    if (title != null) this.title = title;
    if (subtitle != null) this.subtitle = subtitle;
    if (body != null) this.body = body;
    if (created != null) this.created = created;
  }
}
