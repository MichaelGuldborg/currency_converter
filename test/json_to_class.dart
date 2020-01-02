void main() {
  final String className = 'Currency';
  final json = {
    'name': '',
    'euro': 0.1,
  };

  printModelSourceCode(className, json);
}

void printModelSourceCode(String className, Map<String, dynamic> json) {
  /// Convert json to list of fields
  final List<ClassField> fields =
      json.keys.map((key) => ClassField.fromKeyValue(key, json[key])).toList();

  /// print class with fields
  print('');
  print('class $className {');
  fields.forEach((field) {
    print('final ${field.type} ${field.name};');
  });

  /// print class constructor
  print('');
  print('$className({');
  fields.forEach((field) {
    print('this.${field.name},');
  });
  print('});');

  /// print factory method fromJson
  print('');
  print('factory $className.fromMap(Map<String, dynamic> map) {');
  print('return $className(');
  fields.forEach((field) {
    print('${field.name}: map[\'${field.key}\'],');
  });
  print(');');
  print('}');
  print('}');

  /// print method toMap
  print('');
  print('Map<String, dynamic> toMap() {');
  print('return {');
  fields.forEach((field) {
    print('\'${field.key}\': ${field.name},');
  });
  print('};');
  print('}');

  /// Recursively print model source code of app model values
  final List<ClassField> appModelFields = fields.where((field) => field.isAppModel).toList();
  appModelFields.toSet().toList().forEach((field) {
    printModelSourceCode(field.type, json[field.key]);
  });
}

class ClassField {
  final String key;
  final String name;
  final String type;
  final bool isAppModel;

  ClassField({
    this.key,
    this.name,
    this.type,
    this.isAppModel,
  });

  factory ClassField.fromKeyValue(String key, dynamic value) {
    final String fieldName = snakeToCamelCase(key);

    // type name
    final Type runtimeType = value.runtimeType;
    final String runtimeTypeName = '$runtimeType';
    final bool isAppModel = runtimeTypeName.contains('HashMap');
    final String typeName = isAppModel ? capitalize(fieldName) : runtimeTypeName;
    return ClassField(
      key: key,
      name: fieldName,
      type: typeName,
      isAppModel: isAppModel,
    );
  }
}

String snakeToCamelCase(String name) {
  final List<String> words = name.split('_');
  final List<String> capitalWords = words.sublist(1).map((w) => capitalize(w)).toList();
  return words.first + capitalWords.join('');
}

String capitalize(String name) {
  if (name.isEmpty) return name;
  if (name.length == 1) return name.toUpperCase();
  return name.substring(0, 1).toUpperCase() + name.substring(1);
}
