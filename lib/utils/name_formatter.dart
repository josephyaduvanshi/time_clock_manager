extension NameFormatter on String {
  String get inTitleCase {
    // Split the string by spaces to handle first and last names separately.
    List<String> parts = split(' ');
    // Capitalize the first letter of each part and join them back with a space.
    return parts.map((part) {
      if (part.isNotEmpty) {
        // Convert the first character to uppercase and the rest to lowercase.
        return part[0].toUpperCase() + part.substring(1).toLowerCase();
      }
      return '';
    }).join(' ');
  }
}
