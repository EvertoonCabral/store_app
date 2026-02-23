import 'package:flutter_test/flutter_test.dart';
import 'package:faker/faker.dart';
import 'package:service_gestao_de_os/{{entity_import_path}}.dart';

void main() {
  group('{{EntityName}}', () {
    test('fromMap e toMap devem ser inversos', () {
      final faker = Faker();
      final map = {
        {{#fields}}
        '{{name}}': {{sample_value}},
        {{/fields}}
      };

      final entity = {{EntityName}}.fromMap(map);
      expect(entity.toMap(), map);
    });

    test('duas entidades com mesmos dados são iguais', () {
      const e1 = {{EntityName}}(
        {{#fields}}
        {{name}}: {{default_value}},
        {{/fields}}
      );
      const e2 = {{EntityName}}(
        {{#fields}}
        {{name}}: {{default_value}},
        {{/fields}}
      );
      expect(e1, e2);
    });

    test('entidades com campos diferentes não são iguais', () {
      const e1 = {{EntityName}}(
        {{#fields}}
        {{name}}: {{default_value}},
        {{/fields}}
      );
      const e2 = {{EntityName}}(
        {{#fields}}
        {{name}}: {{different_value}},
        {{/fields}}
      );
      expect(e1 == e2, isFalse);
    });

    test('props do Equatable retorna todos os campos', () {
      const entity = {{EntityName}}(
        {{#fields}}
        {{name}}: {{default_value}},
        {{/fields}}
      );
      expect(entity.props.length, {{field_count}});
      expect(entity.props, containsAll([
        {{#fields}}
        {{default_value}},
        {{/fields}}
      ]));
    });
  });
}