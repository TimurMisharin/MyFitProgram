isNumeric(string) =>
    string != null && int.tryParse(string.toString().trim()) != null;

cleanInt(string) => int.parse(string.toString().trim());
