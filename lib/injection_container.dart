import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';
import 'core/util/input_converter.dart';
import 'features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

GetIt servLocator = GetIt.instance;

Future<void> init() async {
  //! Features - Number Trivia

  //Bloc
  servLocator.registerFactory(
    () => NumberTriviaBloc(
      concrete: servLocator(),
      random: servLocator(),
      inputConverter: servLocator(),
    ),
  );

  //Use Cases
  servLocator.registerLazySingleton(
    () => GetConcreteNumberTrivia(servLocator()),
  );

  servLocator.registerLazySingleton(
    () => GetRandomNumberTrivia(servLocator()),
  );

  //Repository
  servLocator.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      remoteDataSource: servLocator(),
      localDataSource: servLocator(),
      networkInfo: servLocator(),
    ),
  );

  //Data Sources
  servLocator.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImpl(client: servLocator()),
  );

  servLocator.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(sharedPreferences: servLocator()),
  );

  //Core
  servLocator.registerLazySingleton(() => InputConverter());
  servLocator.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(servLocator()),
  );

  //! Externals
  servLocator.registerLazySingleton(() => http.Client());
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  servLocator.registerLazySingleton(() => sharedPreferences);
  servLocator.registerLazySingleton(() => DataConnectionChecker());
}
