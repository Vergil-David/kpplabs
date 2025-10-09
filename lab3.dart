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

// Клас Лікар
class Doctor {
  String _surname;
  int _experience;
  Set<Appointment> _appointments;

  // Конструктор
  Doctor({
    required String surname,
    required int experience,
  })  : _surname = surname,
        _experience = experience,
        _appointments = {};

  // Геттери
  String get surname => _surname;
  int get experience => _experience;
  Set<Appointment> get appointments => _appointments;

  // Сеттери
  set surname(String value) => _surname = value;
  set experience(int value) => _experience = value;

  // Додати прийом
  void addAppointment(Appointment appointment) {
    _appointments.add(appointment);
  }

  // Метод: середня кількість відвідувачів
  double getAverageVisitors() {
    if (_appointments.isEmpty) return 0;
    
    int total = 0;
    for (var appointment in _appointments) {
      total += appointment.visitorCount;
    }
    return total / _appointments.length;
  }

  // Метод: прийом з мінімальною кількістю відвідувачів
  Appointment? getMinVisitorsAppointment() {
    if (_appointments.isEmpty) return null;
    
    Appointment? minAppointment;
    int minCount = double.maxFinite.toInt();
    
    for (var appointment in _appointments) {
      if (appointment.visitorCount < minCount) {
        minCount = appointment.visitorCount;
        minAppointment = appointment;
      }
    }
    return minAppointment;
  }

  // Метод: прийом з найдовшим коментарем
  Appointment? getLongestCommentAppointment() {
    if (_appointments.isEmpty) return null;
    
    Appointment? longestAppointment;
    int maxLength = 0;
    
    for (var appointment in _appointments) {
      if (appointment.comment.length > maxLength) {
        maxLength = appointment.comment.length;
        longestAppointment = appointment;
      }
    }
    return longestAppointment;
  }

  // Метод виведення всіх прийомів
  void displayAllAppointments() {
    print('\nЛікар: $_surname, Стаж: $_experience років');
    print('Прийоми:');
    for (var appointment in _appointments) {
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
}