typedef Validator<T> = String? Function(T? value);

abstract final class Validators {
  static String? required(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }

    return null;
  }
}
