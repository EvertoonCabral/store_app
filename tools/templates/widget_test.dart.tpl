import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:service_gestao_de_os/{{page_import_path}}.dart';
import 'package:service_gestao_de_os/{{viewmodel_import_path}}.dart';

class Mock{{ViewModelName}} extends Mock implements {{ViewModelName}} {}

void main() {
  late Mock{{ViewModelName}} mockViewModel;

  setUp(() {
    mockViewModel = Mock{{ViewModelName}}();
  });

  Widget buildTestableWidget() {
    return MaterialApp(
      home: ChangeNotifierProvider<{{ViewModelName}}>.value(
        value: mockViewModel,
        child: const {{PageName}}(),
      ),
    );
  }

  group('{{PageName}} - Testes de Widget', () {
    testWidgets('deve exibir loading inicialmente', (tester) async {
      when(() => mockViewModel.isLoading).thenReturn(true);

      await tester.pumpWidget(buildTestableWidget());
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('deve exibir conteúdo após carregamento', (tester) async {
      when(() => mockViewModel.isLoading).thenReturn(false);
      when(() => mockViewModel.data).thenReturn('Dados carregados');

      await tester.pumpWidget(buildTestableWidget());
      await tester.pump();

      expect(find.text('Dados carregados'), findsOneWidget);
    });

    testWidgets('deve chamar método ao pressionar botão', (tester) async {
      when(() => mockViewModel.isLoading).thenReturn(false);

      await tester.pumpWidget(buildTestableWidget());
      await tester.tap(find.text('Carregar'));
      verify(() => mockViewModel.loadData()).called(1);
    });
  });
}