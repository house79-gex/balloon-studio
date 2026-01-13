import 'package:isar/isar.dart';

part 'element_model.g.dart';

/// Element model - rappresenta un elemento del design (balloon, struttura, etc.)
@collection
class Element {
  Id id = Isar.autoIncrement;
  
  late int projectId;
  
  late String name;
  late String description;
  
  // Element type (balloon, column, arch, etc.)
  @enumerated
  late ElementType type;
  
  // Balloon specifications
  String? balloonBrand;
  String? balloonColor;
  String? balloonSize;
  
  int quantity = 1;
  
  // Pricing
  double unitPrice = 0.0;
  double totalPrice = 0.0;
  
  // Position in design
  double? positionX;
  double? positionY;
  
  @Index()
  late DateTime createdAt;
  
  Element();
}

enum ElementType {
  balloon,
  column,
  arch,
  garland,
  bouquet,
  sculpture,
  other,
}
