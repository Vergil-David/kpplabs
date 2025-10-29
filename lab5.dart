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

  // АСИНХРОННІ ВЕРСІЇ GENERIC МЕТОДІВ
  
  // Future.value - конструктор першого виду
  // Асинхронне знаходження елемента за умовою
  Future<T?> findWhereAsync(bool Function(T) condition) {
    return Future.value(findWhere(condition));
  }

  // Future.delayed - конструктор другого виду
  // Асинхронна фільтрація з затримкою
  Future<List<T>> filterByAsync(
    bool Function(T) condition, 
    {Duration delay = const Duration(seconds: 1)}
  ) {
    return Future.delayed(delay, () => filterBy(condition));
  }

  // Future.value - конструктор першого виду
  // Асинхронне отримання екстремального значення
  Future<R?> getExtremeAsync<R extends Comparable>(
    R Function(T) selector, 
    {bool max = false}
  ) {
    return Future.value(getExtreme<R>(selector, max: max));
  }

  // Future.delayed - конструктор другого виду
  // Асинхронне обчислення середнього значення
  Future<double> calculateAverageAsync(
    num Function(T) selector, 
    {Duration delay = const Duration(milliseconds: 500)}
  ) {
    return Future.delayed(delay, () => calculateAverage(selector));
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

  // Синхронні методи
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

  // АСИНХРОННІ МЕТОДИ

  // Асинхронна версія обчислення середнього
  Future<double> getAverageVisitorsAsync() async {
    print('[ПРОЦЕС] Обчислення середньої кількості відвідувачів...');
    return await _appointments.calculateAverageAsync((a) => a.visitorCount);
  }

  // Асинхронна версія пошуку мінімального прийому
  Future<Appointment?> getMinVisitorsAppointmentAsync() async {
    print('[ПРОЦЕС] Пошук прийому з мінімальною кількістю відвідувачів...');
    int? minCount = await _appointments.getExtremeAsync<int>((a) => a.visitorCount);
    if (minCount == null) return null;
    return await _appointments.findWhereAsync((a) => a.visitorCount == minCount);
  }

  // Асинхронна версія пошуку прийому з найдовшим коментарем
  Future<Appointment?> getLongestCommentAppointmentAsync() async {
    print('[ПРОЦЕС] Пошук прийому з найдовшим коментарем...');
    int? maxLength = await _appointments.getExtremeAsync<int>(
      (a) => a.comment.length, 
      max: true
    );
    if (maxLength == null) return null;
    return await _appointments.findWhereAsync((a) => a.comment.length == maxLength);
  }

  // Асинхронна фільтрація прийомів
  Future<List<Appointment>> filterAppointmentsAsync(
    bool Function(Appointment) condition,
    {Duration delay = const Duration(seconds: 1)}
  ) async {
    print('[ПРОЦЕС] Виконання фільтрації прийомів...');
    return await _appointments.filterByAsync(condition, delay: delay);
  }

  // Основна асинхронна функція з послідовним викликом та обробкою помилок
  Future<void> performAsyncAnalysis() async {
    print('\n--- ПОЧАТОК АСИНХРОННОГО АНАЛІЗУ ---\n');

    try {
      // Крок 1: Обчислення середнього
      final avgVisitors = await getAverageVisitorsAsync();
      print('[РЕЗУЛЬТАТ] Середня кількість відвідувачів: ${avgVisitors.toStringAsFixed(2)}\n');

      // Крок 2: Пошук мінімального прийому
      final minAppointment = await getMinVisitorsAppointmentAsync();
      if (minAppointment != null) {
        print('[РЕЗУЛЬТАТ] Прийом з мінімальною кількістю відвідувачів:');
        minAppointment.displayInfo();
        print('');
      } else {
        print('[ПОПЕРЕДЖЕННЯ] Не знайдено прийомів з мінімальною кількістю\n');
      }

      // Крок 3: Пошук прийому з найдовшим коментарем
      final longestAppointment = await getLongestCommentAppointmentAsync();
      if (longestAppointment != null) {
        print('[РЕЗУЛЬТАТ] Прийом з найдовшим коментарем:');
        longestAppointment.displayInfo();
        print('');
      } else {
        print('[ПОПЕРЕДЖЕННЯ] Не знайдено прийомів з найдовшим коментарем\n');
      }

      // Крок 4: Фільтрація завантажених днів
      final busyDays = await filterAppointmentsAsync(
        (a) => a.visitorCount > 20,
        delay: Duration(milliseconds: 800)
      );
      print('[РЕЗУЛЬТАТ] Знайдено ${busyDays.length} завантажених днів (понад 20 відвідувачів):');
      for (var appointment in busyDays) {
        appointment.displayInfo();
      }

      print('\n--- АСИНХРОННИЙ АНАЛІЗ ЗАВЕРШЕНО УСПІШНО ---');

    } on TypeError catch (e) {
      print('[ПОМИЛКА] Помилка типу даних: $e');
    } on StateError catch (e) {
      print('[ПОМИЛКА] Помилка стану: $e');
    } catch (e, stackTrace) {
      print('[ПОМИЛКА] Неочікувана помилка: $e');
      print('Stack trace: $stackTrace');
    } finally {
      print('\n--- ЗАВЕРШЕННЯ АСИНХРОННОЇ ОПЕРАЦІЇ ---\n');
    }
  }

  void displayAllAppointments() {
    print('\nЛікар: $_surname, Стаж: $_experience років');
    print('Прийоми:');
    for (var appointment in _appointments.getAll()) {
      appointment.displayInfo();
    }
  }

  void displayStatistics() {
    print('\n--- СИНХРОННИЙ АНАЛІЗ ---');
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

void main() async {
  final doctor = Doctor(surname: 'Петренко', experience: 15);

  // Додавання прийомів
  [
    Appointment(day: 'Понеділок', visitorCount: 25, comment: 'Плановий прийом'),
    Appointment(day: 'Вівторок', visitorCount: 18, comment: 'Консультації пацієнтів'),
    Appointment(day: 'Середа', visitorCount: 30, comment: 'Багато пацієнтів, потрібна додаткова допомога'),
    Appointment(day: 'Четвер', visitorCount: 15, comment: 'Спокійний день'),
    Appointment(day: 'П\'ятниця', visitorCount: 22, comment: 'Профілактичні огляди та повторні консультації пацієнтів'),
  ].forEach(doctor.addAppointment);

  // Виведення всіх прийомів
  doctor.displayAllAppointments();

  // Синхронний аналіз
  doctor.displayStatistics();

  // Асинхронний аналіз з обробкою помилок
  await doctor.performAsyncAnalysis();

  // Додатковий приклад асинхронної обробки
  print('--- ДОДАТКОВИЙ АСИНХРОННИЙ ТЕСТ ---\n');
  
  try {
    final filtered = await doctor.filterAppointmentsAsync(
      (a) => a.visitorCount < 20,
      delay: Duration(milliseconds: 500)
    );
    print('[РЕЗУЛЬТАТ] Спокійні дні (менше 20 відвідувачів): ${filtered.length} прийомів');
    for (var appointment in filtered) {
      appointment.displayInfo();
    }
  } catch (e) {
    print('[ПОМИЛКА] Помилка при фільтрації: $e');
  }
  
  print('\n--- ПРОГРАМА ЗАВЕРШЕНА ---');
}