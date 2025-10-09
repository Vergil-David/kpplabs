import 'dart:math';

void main() {
  // Вхідні дані за варіантом №11
  const double y = 50.6;
  const double z = 3.327;
  const double xStart = 13.53;
  const double xEnd = 23.53;
  const double deltaX = 1.0;
  const double bConst = 2.5;

  // Функція a(x, y, z, b) з використанням замикання
  Function makeA(double yVal, double zVal, double bVal) {
    return (double x) {
      double sinPart = pow(sin(pow((yVal + bVal).abs(), 1.0/3.0)), 2).toDouble();
      double numerator = zVal + sinPart;
      
      double innerFraction = pow(x, 2) / (yVal + pow(x, 3) / 3);
      double lnPart = log(x.abs());
      double denominator = pow(zVal, 2) + (innerFraction - lnPart).abs();
      
      return pow(yVal, 2) + numerator / denominator;
    };
  }

  // Функція b(x, y, z) як анонімна функція
  var b = (double x, double yVal, double zVal) {
    double cosPart = pow(cos(yVal - 2 * pow(x, 3)), 2).toDouble();
    double numerator = 1 + cosPart;
    
    double sinPart = pow(sin(pow(zVal.abs(), 0.2)), 2).toDouble();
    double denominator = 2 + pow(x.abs(), 1.5) * sinPart;
    
    double lnPart = pow(log((zVal - yVal).abs()), 2).toDouble();
    
    return numerator / denominator + lnPart;
  };

  // Створення функції a з замиканням
  var a = makeA(y, z, bConst);

  print('=' * 80);
  print('Табулювання функцій a(x) та b(x)');
  print('Варіант №11');
  print('=' * 80);
  print('Вхідні параметри:');
  print('Y = $y');
  print('Z = $z');
  print('X: від $xStart до $xEnd з кроком $deltaX');
  print('b (константа) = $bConst');
  print('=' * 80);
  print('${' X '} | ${' a(x) '} | ${' b(x) '}');
  print('-' * 80);

  // Табулювання функцій
  for (double x = xStart; x <= xEnd; x += deltaX) {
    try {
      double resultA = a(x);
      double resultB = b(x, y, z);
      
      print('${x.toStringAsFixed(2).padLeft(6)} | '
            '${resultA.toStringAsFixed(6).padLeft(12)} | '
            '${resultB.toStringAsFixed(6).padLeft(12)}');
    } catch (e) {
      print('${x.toStringAsFixed(2).padLeft(6)} | '
            '${'Помилка'.padLeft(12)} | '
            '${'Помилка'.padLeft(12)}');
    }
  }
  
  print('=' * 80);
}