// Клас Прийом
class Appointment {
  String _day;
  int _visitorCount;
  String _comment;

  Appointment({
    required String day,
    required int visitorCount,
    required String comment,
  })  : _day = day,
        _visitorCount = visitorCount,
        _comment = comment;

  String get day => _day;
  int get visitorCount => _visitorCount;
  String get comment => _comment;

  set day(String value) => _day = value;
  set visitorCount(int value) => _visitorCount = value;
  set comment(String value) => _comment = value;

  void displayInfo() {
    print('День: $_day, Відвідувачів: $_visitorCount, Коментар: $_comment');
  }
}

// Generic клас для колекції
class Collection<T> {
  final Set<T> _items = {};

  void add(T item) => _items.add(item);
  Set<T> getAll() => _items;
  int get count => _items.length;
  bool get isEmpty => _items.isEmpty;

  // Generic метод 1: Знайти за умовою
  T? findWhere(bool Function(T) condition) => 
      _items.firstWhere(condition, orElse: () => null as T);

  // Generic метод 2: Фільтрація
  List<T> filterBy(bool Function(T) condition) => 
      _items.where(condition).toList();

  // Generic метод 3: Отримати мін/макс значення
  R? getExtreme<R extends Comparable>(R Function(T) selector, {bool max = false}) {
    if (_items.isEmpty) return null;
    return _items.map(selector).reduce((a, b) => 
        max ? (a.compareTo(b) > 0 ? a : b) : (a.compareTo(b) < 0 ? a : b));
  }

  // Generic метод 4: Обчислити середнє
  double calculateAverage(num Function(T) selector) {
    if (_items.isEmpty) return 0;
    return _items.map(selector).reduce((a, b) => a + b) / _items.length;
  }
}

// Клас Лікар
class Doctor {
  String _surname;
  int _experience;
  final Collection<Appointment> _appointments = Collection<Appointment>();

  Doctor({required String surname, required int experience})
      : _surname = surname,
        _experience = experience;

  String get surname => _surname;
  int get experience => _experience;
  Collection<Appointment> get appointments => _appointments;

  set surname(String value) => _surname = value;
  set experience(int value) => _experience = value;

  void addAppointment(Appointment appointment) => _appointments.add(appointment);

  // Використання generic методів
  double getAverageVisitors() => 
      _appointments.calculateAverage((a) => a.visitorCount);

  Appointment? getMinVisitorsAppointment() {
    int? minCount = _appointments.getExtreme<int>((a) => a.visitorCount);
    return minCount != null 
        ? _appointments.findWhere((a) => a.visitorCount == minCount) 
        : null;
  }

  Appointment? getLongestCommentAppointment() {
    int? maxLength = _appointments.getExtreme<int>((a) => a.comment.length, max: true);
    return maxLength != null 
        ? _appointments.findWhere((a) => a.comment.length == maxLength) 
        : null;
  }

  List<Appointment> filterAppointments(bool Function(Appointment) condition) =>
      _appointments.filterBy(condition);

  void displayAllAppointments() {
    print('\nЛікар: $_surname, Стаж: $_experience років');
    print('Прийоми:');
    _appointments.getAll().forEach((a) => a.displayInfo());
  }

  void displayStatistics() {
    print('\n--- Результати аналізу ---');
    print('Середня кількість відвідувачів: ${getAverageVisitors().toStringAsFixed(2)}');

    final minAppointment = getMinVisitorsAppointment();
    if (minAppointment != null) {
      print('\nПрийом з мінімальною кількістю відвідувачів:');
      minAppointment.displayInfo();
    }

    final longestAppointment = getLongestCommentAppointment();
    if (longestAppointment != null) {
      print('\nПрийом з найдовшим коментарем:');
      longestAppointment.displayInfo();
    }
  }
}

void main() {
  final doctor = Doctor(surname: 'Петренко', experience: 15);

  // Додавання прийомів
  [
    Appointment(day: 'Понеділок', visitorCount: 25, comment: 'Плановий прийом'),
    Appointment(day: 'Вівторок', visitorCount: 18, comment: 'Консультації пацієнтів'),
    Appointment(day: 'Середа', visitorCount: 30, comment: 'Багато пацієнтів, потрібна додаткова допомога'),
    Appointment(day: 'Четвер', visitorCount: 15, comment: 'Спокійний день'),
    Appointment(day: 'П\'ятниця', visitorCount: 22, comment: 'Профілактичні огляди та повторні консультації пацієнтів'),
  ].forEach(doctor.addAppointment);

  doctor.displayAllAppointments();
  doctor.displayStatistics();

  print('\n--- Додаткова фільтрація ---');
  print('\nПрийоми з більше ніж 20 відвідувачів:');
  doctor.filterAppointments((a) => a.visitorCount > 20)
      .forEach((a) => a.displayInfo());
}