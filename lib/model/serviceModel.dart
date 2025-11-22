/// Represents a single medical service.
class Service {
  final String name;
  final int price;
  final String description;

  Service({
    required this.name,
    required this.price,
    required this.description,
  });
}

class ServiceCategory {
  final String categoryName;
  final List<Service> services;

  ServiceCategory({
    required this.categoryName,
    required this.services,
  });
}

class Category {
  final String id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });
}
