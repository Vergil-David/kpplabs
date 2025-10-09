// Інтерфейс Будівля
abstract interface class Building {
  String get address;
  double get area;
  int get yearBuilt;
  void displayInfo();
}

// Абстрактний клас Громадська будівля
abstract class PublicBuilding implements Building {
  @override
  final String address;
  
  @override
  final double area;
  
  @override
  final int yearBuilt;
  
  final int capacity;
  
  PublicBuilding({
    required this.address,
    required this.area,
    required this.yearBuilt,
    required this.capacity,
  });
  
  @override
  void displayInfo() {
    print('Адреса: $address');
    print('Площа: $area м²');
    print('Рік побудови: $yearBuilt');
    print('Місткість: $capacity осіб');
  }
}

// Дочірній клас Театр
class Theater extends PublicBuilding {
  final String name;
  final int numberOfSeats;
  final String genre;
  
  Theater({
    required this.name,
    required super.address,
    required super.area,
    required super.yearBuilt,
    required super.capacity,
    required this.numberOfSeats,
    required this.genre,
  });
  
  @override
  void displayInfo() {
    print('\nТеатр: $name');
    super.displayInfo();
    print('Кількість місць: $numberOfSeats');
    print('Жанр: $genre');
  }
}

void main() {
  // Створення театрів
  Theater theater1 = Theater(
    name: 'Національний театр опери та балету',
    address: 'вул. Володимирська, 50',
    area: 10000.0,
    yearBuilt: 1901,
    capacity: 1500,
    numberOfSeats: 1300,
    genre: 'Опера та балет',
  );
  
  Theater theater2 = Theater(
    name: 'Драматичний театр',
    address: 'вул. Шевченка, 15',
    area: 5000.0,
    yearBuilt: 1950,
    capacity: 800,
    numberOfSeats: 700,
    genre: 'Драма',
  );
  
  // Виведення характеристик
  theater1.displayInfo();
  theater2.displayInfo();
}