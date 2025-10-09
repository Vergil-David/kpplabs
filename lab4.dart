// Клас Прийом
class Appointment {
  String _day;
  int _visitorCount;
  String _comment;

  // Конструктор
  Appointment({
    required String day,
    required int visitorCount,
    required String comment,
  })  : _day = day,
        _visitorCount = visitorCount,
        _comment = comment;

  // Геттери
  String get day => _day;
  int get visitorCount => _visitorCount;
  String get comment => _comment;

  // Сеттери
  set day(String value) => _day = value;
  set visitorCount(int value) => _visitorCount = value;
  set comment(String value) => _comment = value;

  // Метод виведення інформації
  void displayInfo() {
    print('День: $_day, Відвідувачів: $_visitorCount, Коментар: $_comment');
  }
}

// Generic клас для колекції
class Collection<T> {
  Set<T> _items;

  Collection() : _items = {};

  // Додати елемент
  void add(T item) {
    _items.add(item);
  }

  // Отримати всі елементи
  Set<T> getAll() => _items;

  // Кількість елементів
  int get count => _items.length;

  // Перевірка чи порожня колекція
  bool get isEmpty => _items.isEmpty;

  // Generic метод 1: Знайти елемент за умовою
  T? findWhere(bool Function(T) condition) {
    for (var item in _items) {
      if (condition(item)) {
        return item;
      }
    }
    return null;
  }

  // Generic метод 2: Фільтрація елементів
  List<T> filterBy(bool Function(T) condition) {
    List<T> result = [];
    for (var item in _items) {
      if (condition(item)) {
        result.add(item);
      }
    }
    return result;
  }

  // Generic метод 3: Отримати значення за допомогою селектора
  R? getValueBy<R>(R Function(T) selector, bool Function(R, R) comparator) {
    if (_items.isEmpty) return null;

    R? result;
    for (var item in _items) {
      R value = selector(item);
      if (result == null || comparator(value, result)) {
        result = value;
      }
    }
    return result;
  }

  // Generic метод 4: Обчислити середнє значення
  double calculateAverage(num Function(T) selector) {
    if (_items.isEmpty) return 0;

    num total = 0;
    for (var item in _items) {
      total += selector(item);
    }
    return total / _items.length;
  }
}

// Клас Лікар з використанням generic класу
class Doctor {
  String _surname;
  int _experience;
  Collection<Appointment> _appointments;

  // Конструктор
  Doctor({
    required String surname,
    required int experience,
  })  : _surname = surname,
        _experience = experience,
        _appointments = Collection<Appointment>();

  // Геттери
  String get surname => _surname;
  int get experience => _experience;
  Collection<Appointment> get appointments => _appointments;

  // Сеттери
  set surname(String value) => _surname = value;
  set experience(int value) => _experience = value;

  // Додати прийом
  void addAppointment(Appointment appointment) {
    _appointments.add(appointment);
  }

  // Метод: середня кількість відвідувачів (використовує generic метод)
  double getAverageVisitors() {
    return _appointments.calculateAverage((appointment) => appointment.visitorCount);
  }

  // Метод: прийом з мінімальною кількістю відвідувачів (використовує generic метод)
  Appointment? getMinVisitorsAppointment() {
    return _appointments.findWhere((appointment) {
      int minCount = _appointments.getValueBy<int>(
            (a) => a.visitorCount,
            (value, result) => value < result,
          ) ??
          0;
      return appointment.visitorCount == minCount;
    });
  }

  // Метод: прийом з найдовшим коментарем (використовує generic метод)
  Appointment? getLongestCommentAppointment() {
    return _appointments.findWhere((appointment) {
      int maxLength = _appointments.getValueBy<int>(
            (a) => a.comment.length,
            (value, result) => value > result,
          ) ??
          0;
      return appointment.comment.length == maxLength;
    });
  }

  // Generic метод: Фільтрувати прийоми за умовою
  List<Appointment> filterAppointments(bool Function(Appointment) condition) {
    return _appointments.filterBy(condition);
  }

  // Метод виведення всіх прийомів
  void displayAllAppointments() {
    print('\nЛікар: $_surname, Стаж: $_experience років');
    print('Прийоми:');
    for (var appointment in _appointments.getAll()) {
      appointment.displayInfo();
    }
  }

  // Метод виведення результатів основного завдання
  void displayStatistics() {
    print('\n--- Результати аналізу ---');

    print('Середня кількість відвідувачів: ${getAverageVisitors().toStringAsFixed(2)}');

    Appointment? minAppointment = getMinVisitorsAppointment();
    if (minAppointment != null) {
      print('\nПрийом з мінімальною кількістю відвідувачів:');
      minAppointment.displayInfo();
    }

    Appointment? longestAppointment = getLongestCommentAppointment();
    if (longestAppointment != null) {
      print('\nПрийом з найдовшим коментарем:');
      longestAppointment.displayInfo();
    }
  }
}

void main() {
  // Створення лікаря
  Doctor doctor = Doctor(
    surname: 'Петренко',
    experience: 15,
  );

  // Додавання прийомів
  doctor.addAppointment(Appointment(
    day: 'Понеділок',
    visitorCount: 25,
    comment: 'Плановий прийом',
  ));

  doctor.addAppointment(Appointment(
    day: 'Вівторок',
    visitorCount: 18,
    comment: 'Консультації пацієнтів',
  ));

  doctor.addAppointment(Appointment(
    day: 'Середа',
    visitorCount: 30,
    comment: 'Багато пацієнтів, потрібна додаткова допомога',
  ));

  doctor.addAppointment(Appointment(
    day: 'Четвер',
    visitorCount: 15,
    comment: 'Спокійний день',
  ));

  doctor.addAppointment(Appointment(
    day: 'П\'ятниця',
    visitorCount: 22,
    comment: 'Профілактичні огляди та повторні консультації пацієнтів',
  ));

  // Виведення всіх прийомів
  doctor.displayAllAppointments();

  // Виведення статистики
  doctor.displayStatistics();

  // Демонстрація використання generic методів
  print('\n--- Додаткова фільтрація ---');

  // Фільтр: прийоми з більше ніж 20 відвідувачів
  List<Appointment> busyDays = doctor.filterAppointments((a) => a.visitorCount > 20);
  print('\nПрийоми з більше ніж 20 відвідувачів:');
  for (var appointment in busyDays) {
    appointment.displayInfo();
  }
}