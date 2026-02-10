class Validators {
  String? defaultValidation(String? input) {
    if (input == null || input.isEmpty) {
      return "This field is required!";
    }
    return null;
  }

  String? emailValidation(String? email) {
    if (email == null || email.isEmpty) {
      return "This field is required!";
    } else if (!RegExp(r'^[a-zA-Z\d.]+@[a-zA-Z\d]+\.[a-zA-Z]+')
        .hasMatch(email)) {
      return "Invalid email!";
    }
    return null;
  }

  String? passwordValidation(String? password) {
    if (password == null || password.isEmpty) {
      return "This field is required!";
    } else if (password.length < 6) {
      return "Password must contain at least 6 characters!";
    }
    return null;
  }

  String? passwordConfirmationValidation(
      String? password, String? confirmPassword) {
    // Step 1: Validate confirmPassword using passwordValidation
    final initialValidation = passwordValidation(confirmPassword);
    if (initialValidation != null) {
      return initialValidation; // Return empty or length error if present
    }

    // Step 2: Check if passwords match
    if (password != confirmPassword) {
      return "Password not matching!";
    }

    return null; // All checks passed
  }

  String? dropdownValidation(String? value) {
    if (value == null || value.isEmpty) {
      return "This field is required!";
    }
    return null;
  }

  String? validatePhone(String? number) {
    if (number == null || number.isEmpty) {
      return "This field is required!";
    } else if (number.length != 8 || !RegExp(r'^-?[0-9]+$').hasMatch(number)) {
      return "Invalid phone number!";
    }
    return null;
  }
}
