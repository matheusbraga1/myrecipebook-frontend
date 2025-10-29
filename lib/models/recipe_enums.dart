// Tempo de Cozimento
enum CookingTime {
  lessThan10Minutes(0, 'Menos de 10 minutos'),
  between10And30Minutes(1, 'Entre 10 e 30 minutos'),
  between30And60Minutes(2, 'Entre 30 e 60 minutos'),
  greaterThan60Minutes(3, 'Mais de 60 minutos');

  final int value;
  final String label;

  const CookingTime(this.value, this.label);

  static CookingTime? fromValue(int? value) {
    if (value == null) return null;
    return CookingTime.values.firstWhere((e) => e.value == value);
  }
}

// Dificuldade
enum Difficulty {
  low(0, 'Fácil'),
  medium(1, 'Médio'),
  high(2, 'Difícil');

  final int value;
  final String label;

  const Difficulty(this.value, this.label);

  static Difficulty? fromValue(int? value) {
    if (value == null) return null;
    return Difficulty.values.firstWhere((e) => e.value == value);
  }
}

// Tipo de Prato
enum DishType {
  breakfast(0, 'Café da Manhã'),
  lunch(1, 'Almoço'),
  appetizers(2, 'Aperitivos'),
  snack(3, 'Lanche'),
  dessert(4, 'Sobremesa'),
  dinner(5, 'Jantar'),
  drinks(6, 'Bebidas');

  final int value;
  final String label;

  const DishType(this.value, this.label);

  static DishType? fromValue(int? value) {
    if (value == null) return null;
    return DishType.values.firstWhere((e) => e.value == value);
  }
}