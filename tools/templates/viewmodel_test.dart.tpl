import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:service_gestao_de_os/{{viewmodel_import_path}}.dart';
import 'package:service_gestao_de_os/{{repository_import_path}}.dart';

class Mock{{RepositoryName}} extends Mock implements {{RepositoryName}} {}

void main() {
  late {{ViewModelName}} viewModel;
  late Mock{{RepositoryName}} mockRepository;

  setUp(() {
    mockRepository = Mock{{RepositoryName}}();
    viewModel = {{ViewModelName}}(repository: mockRepository);
  });

  group('{{ViewModelName}}', () {
    test('estado inicial', () {
      expect(viewModel.status, {{InitialStatus}});
    });

    test('sucesso ao carregar dados', () async {
      when(() => mockRepository.fetchData())
          .thenAnswer((_) async => const Right(expectedData));

      await viewModel.loadData();

      expect(viewModel.status, Status.success);
      expect(viewModel.data, expectedData);
    });

    test('erro ao carregar dados', () async {
      when(() => mockRepository.fetchData())
          .thenAnswer((_) async => Left(ServerFailure('Erro')));

      await viewModel.loadData();

      expect(viewModel.status, Status.error);
      expect(viewModel.errorMessage, 'Erro');
    });
  });
}