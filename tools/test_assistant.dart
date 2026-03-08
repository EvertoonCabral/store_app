// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:convert';

import 'package:mustache_template/mustache.dart';

String? _openAiKey;

Future<void> main() async {
  _openAiKey = _loadKeyFromEnv();

  if (_openAiKey == null) {
    print('Erro: OPENAI_API_KEY não encontrada no arquivo .env ou no sistema.');
    return;
  }

  print('🔍 Detectando arquivos alterados...');
  final changedFiles = await getChangedDartFiles();
  if (changedFiles.isEmpty) {
    print('✅ Nenhum arquivo Dart alterado.');
    return;
  }

  print('📁 Arquivos alterados:');
  for (final file in changedFiles) {
    print(' - $file');
  }

  for (final file in changedFiles) {
    final testFile = mapToTestFile(file);
    print('\n🧪 Verificando teste para: $file');

    if (!await File(testFile).exists()) {
      print('🆕 Teste não encontrado. Gerando novo teste...');
      await generateNewTest(file, testFile);
    } else {
      print('🔁 Teste encontrado. Executando...');
      final exitCode = await runTest(testFile);
      if (exitCode == 0) {
        print('✅ Teste passou.');
      } else {
        print('❌ Teste falhou. Solicitando correção via IA...');
        await fixTestWithLLM(file, testFile);
      }
    }
  }
}

Future<List<String>> getChangedDartFiles() async {
  final result = await Process.run('git', ['diff', '--name-only', '--staged']);
  return (result.stdout as String)
      .split('\n')
      .where((line) => line.trim().endsWith('.dart'))
      .toList();
}

String mapToTestFile(String sourceFile) {
  if (!sourceFile.startsWith('lib/')) return '';
  return sourceFile
      .replaceFirst('lib/', 'test/')
      .replaceAll('.dart', '_test.dart');
}

Future<int> runTest(String testPath) async {
  final result =
      await Process.run('flutter', ['test', testPath], runInShell: true);
  stdout.write(result.stdout);
  stderr.write(result.stderr);
  return result.exitCode;
}

Future<void> generateNewTest(String sourceFile, String testFile) async {
  final sourceCode = await File(sourceFile).readAsString();
  final fileType = detectFileType(sourceCode);
  final data = extractDataFromFile(sourceCode, fileType);

  final templatePath = '.tools/templates/${fileType}_test.dart.tpl';
  if (!await File(templatePath).exists()) {
    print('⚠️ Template não encontrado: $templatePath');
    return;
  }

  final template = File(templatePath).readAsStringSync();
  final renderer = Template(template);
  final output = renderer.renderString(data);

  await saveTestFile(testFile, output);
}

String detectFileType(String sourceCode) {
  if (sourceCode.contains('extends Equatable')) return 'entity';
  if (sourceCode.contains('class') && sourceCode.contains('ViewModel')) {
    return 'viewmodel';
  }
  if (sourceCode.contains('class') && sourceCode.contains('StatefulWidget')) {
    return 'widget';
  }
  return 'unknown';
}

Map<String, dynamic> extractDataFromFile(String sourceCode, String fileType) {
  final className =
      RegExp(r'class (\w+)').firstMatch(sourceCode)?.group(1) ?? 'UnknownClass';
  final importPath = 'src/features/servicos/entities/servico_entity';

  switch (fileType) {
    case 'entity':
      final fields = extractEntityFields(sourceCode);
      return {
        'EntityName': className,
        'entity_import_path': importPath,
        'fields': fields,
        'field_count': fields.length,
      };
    case 'viewmodel':
      return {
        'ViewModelName': className,
        'viewmodel_import_path': importPath,
        'repository_import_path': '$importPath/repository',
        'RepositoryName': '${className.replaceAll('ViewModel', '')}Repository',
        'InitialStatus': 'Status.initial',
      };
    case 'widget':
      return {
        'PageName': className,
        'page_import_path': importPath,
        'viewmodel_import_path': '$importPath/viewmodel',
        'ViewModelName': '${className.replaceAll('Page', '')}ViewModel',
      };
    default:
      return {};
  }
}

List<Map<String, String>> extractEntityFields(String sourceCode) {
  final fields = <Map<String, String>>[];
  final classBody = RegExp(r'class \w+[^{]*\{([^}]*)\}', dotAll: true)
          .firstMatch(sourceCode)
          ?.group(1) ??
      '';

  final fieldMatches = RegExp(r'final (\w+\??) (\w+);').allMatches(classBody);
  for (var match in fieldMatches) {
    final type = match.group(1)!;
    final name = match.group(2)!;
    fields.add({
      'name': name,
      'sample_value': getSampleValue(type),
      'default_value': getDefaultValue(type),
      'different_value': getDifferentValue(type),
    });
  }
  return fields;
}

String getSampleValue(String type) {
  switch (type) {
    case 'int':
    case 'int?':
      return 'faker.randomGenerator.integer(9999)';
    case 'String':
    case 'String?':
      return 'faker.lorem.sentence()';
    case 'bool':
    case 'bool?':
      return 'faker.randomGenerator.boolean()';
    case 'num':
    case 'num?':
      return 'faker.randomGenerator.decimal()';
    default:
      return 'null';
  }
}

String getDefaultValue(String type) {
  switch (type) {
    case 'int':
    case 'int?':
      return '0';
    case 'String':
    case 'String?':
      return "''";
    case 'bool':
    case 'bool?':
      return 'false';
    case 'num':
    case 'num?':
      return '0';
    default:
      return 'null';
  }
}

String getDifferentValue(String type) {
  switch (type) {
    case 'int':
    case 'int?':
      return '1';
    case 'String':
    case 'String?':
      return "'different'";
    case 'bool':
    case 'bool?':
      return 'true';
    case 'num':
    case 'num?':
      return '1';
    default:
      return 'null';
  }
}

Future<void> fixTestWithLLM(String sourceFile, String testFile) async {
  final testCode = await File(testFile).readAsString();

  final diffResult = await Process.run('git', ['diff', sourceFile]);
  final diff = diffResult.stdout as String;

  final testRunResult =
      await Process.run('flutter', ['test', testFile], runInShell: true);
  final testOutput = '${testRunResult.stdout}\n${testRunResult.stderr}';

  final prompt = '''
Você é um especialista em Flutter. Um teste falhou após alterações no código-fonte. Corrija o teste com base nas informações abaixo.

Arquivo alterado: $sourceFile
Diff:
$diff

Código do teste atual:
$testCode

Saída do teste (erro):
$testOutput

Instruções:
- Explique brevemente o motivo da falha.
- Gere o código do teste corrigido.
- Responda apenas com a explicação e o código Dart do teste completo, começando e terminando com ```dart.
''';

  final fixedTestCode = await callLLM(prompt);
  await saveTestFile(testFile, fixedTestCode);
}

Future<String> callLLM(String prompt) async {
  if (_openAiKey == null || _openAiKey!.isEmpty) {
    print('⚠️  Chave da API não configurada.');
    return '// Erro: Chave da API não configurada.';
  }

  final response = await HttpClient().postUrl(
    Uri.parse('https://api.openai.com/v1/chat/completions'),
  )
    ..headers.set('Authorization', 'Bearer $_openAiKey')
    ..headers.set('Content-Type', 'application/json')
    ..write(jsonEncode({
      'model':
          'gpt-4o', // Dica: use 'gpt-4o' que é mais rápido e barato que o 'gpt-4'
      'messages': [
        {'role': 'user', 'content': prompt}
      ],
      'max_tokens': 2000,
    }));

  final resp = await response.close();
  final body = await resp.transform(utf8.decoder).join();
  final data = jsonDecode(body);

  if (data['choices'] != null && data['choices'].isNotEmpty) {
    final content = data['choices'][0]['message']['content'];
    final codeMatch =
        RegExp(r'```dart\s*(.*?)\s*```', dotAll: true).firstMatch(content);
    return codeMatch?.group(1)?.trim() ?? content;
  }

  return '// Erro ao gerar teste: ${data['error']?['message'] ?? 'Erro desconhecido'}';
}

Future<void> saveTestFile(String testFilePath, String content) async {
  final file = File(testFilePath);
  await file.create(recursive: true);
  await file.writeAsString(content);
  print('💾 Teste salvo em: $testFilePath');
}

String? _loadKeyFromEnv() {
  final systemKey = Platform.environment['OPENAI_API_KEY'];
  if (systemKey != null) return systemKey;

  // Se não achar, tenta ler do arquivo .env
  final envFile = File('.env');
  if (envFile.existsSync()) {
    final lines = envFile.readAsLinesSync();
    for (var line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty || trimmed.startsWith('#')) continue;
      if (trimmed.startsWith('OPENAI_API_KEY=')) {
        return trimmed
            .split('=')[1]
            .trim()
            .replaceAll('"', '')
            .replaceAll("'", "");
      }
    }
  }
  return null;
}
