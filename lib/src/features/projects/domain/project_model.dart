import 'package:isar/isar.dart';

part 'project_model.g.dart';

/// Project model - rappresenta un progetto di design
@collection
class Project {
  Id id = Isar.autoIncrement;
  
  late String name;
  late String description;
  
  @Index()
  late DateTime createdAt;
  
  late DateTime updatedAt;
  
  // Client information
  String? clientName;
  String? clientEmail;
  String? clientPhone;
  
  // Project metadata
  String? eventType;
  DateTime? eventDate;
  String? venue;
  
  // Number of elements in this project
  int elementCount = 0;
  
  // Project status
  @enumerated
  late ProjectStatus status;
  
  Project();
}

enum ProjectStatus {
  draft,
  inProgress,
  completed,
  archived,
}
