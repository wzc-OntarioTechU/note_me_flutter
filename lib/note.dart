class Note {
  final int? id; // Nullable for new notes
  String title;
  String subject;
  String body;
  int colour;
  DateTime created;
  String? photopath; // Nullable for cases when no photo path is provided

  Note({
    this.id,
    required this.title,
    required this.subject,
    required this.body,
    required this.colour,
    required this.created,
    this.photopath,
  });

  // Convert Note object to a Map for SQLite operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subject': subject,
      'body': body,
      'colour': colour,
      'created': created.millisecondsSinceEpoch, // Store DateTime as milliseconds since epoch
      'photopath': photopath,
    };
  }

  // Create a Note object from a Map (e.g., retrieved from the database)
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      subject: map['subject'],
      body: map['body'],
      colour: map['colour'],
      created: DateTime.fromMillisecondsSinceEpoch(map['created']),
      photopath: map['photopath'],
    );
  }

  // Update fields of the note (optional)
  void update({
    String? title,
    String? subject,
    String? body,
    int? colour,
    DateTime? created,
    String? photopath,
  }) {
    if (title != null) this.title = title;
    if (subject != null) this.subject = subject;
    if (body != null) this.body = body;
    if (colour != null) this.colour = colour;
    if (created != null) this.created = created;
    if (photopath != null) this.photopath = photopath;
  }
}
