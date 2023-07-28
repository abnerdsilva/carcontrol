class ValidationUtils {
  static bool isValidName(String name) {
    // Utilizar uma expressão regular para validar o formato do nome
    String nameRegex = r'^[A-Za-zÀ-ÖØ-öø-ÿ]+([\s-][A-Za-zÀ-ÖØ-öø-ÿ]+)*$';
    RegExp regex = RegExp(nameRegex);
    return regex.hasMatch(name);
  }

  static bool isValidCPF(String cpf) {
    // Utilizar uma expressão regular para validar o formato do CPF
    String cpfRegex = r'^\d{3}\.\d{3}\.\d{3}-\d{2}$';
    RegExp regex = RegExp(cpfRegex);
    return regex.hasMatch(cpf);
  }

  static bool isValidDateOfBirth(String dateOfBirth) {
    // Utilizar uma expressão regular para validar o formato da data de nascimento (DD/MM/YYYY)
    String dobRegex =
        r'^(0[1-9]|1\d|2[0-9]|3[0-1])/(0[1-9]|1[0-2])/(19\d{2}|20\d{2})$';
    RegExp regex = RegExp(dobRegex);
    return regex.hasMatch(dateOfBirth);
  }

  static bool isValidCity(String city) {
    // Utilizar uma expressão regular para validar o formato da cidade
    String cityRegex = r'^[A-Za-zÀ-ÖØ-öø-ÿ\s]+$';
    RegExp regex = RegExp(cityRegex);
    return regex.hasMatch(city);
  }

  static bool isValidNeighborhood(String neighborhood) {
    // Utilizar uma expressão regular para validar o formato do bairro
    String neighborhoodRegex = r'^[A-Za-zÀ-ÖØ-öø-ÿ\s]+$';
    RegExp regex = RegExp(neighborhoodRegex);
    return regex.hasMatch(neighborhood);
  }

  static bool isValidNumber(String number) {
    // Utilizar uma expressão regular para validar o formato do número
    String numberRegex = r'^\(\d{2}\) \d{5}-\d{4}$';
    RegExp regex = RegExp(numberRegex);
    return regex.hasMatch(number);
  }

  static bool isValidCNH(String cnh) {
    // Utilizar uma expressão regular para validar o formato da CNH
    String cnhRegex = r'^\d{9}$';
    RegExp regex = RegExp(cnhRegex);
    return regex.hasMatch(cnh);
  }

  static bool isValidEmail(String email) {
    // Utilizar uma expressão regular para validar o formato do e-mail
    String emailRegex = r'^[\w-]+(?:\.[\w-]+)*@(?:[\w-]+\.)+[a-zA-Z]{2,7}$';
    RegExp regex = RegExp(emailRegex);
    return regex.hasMatch(email);
  }
}
