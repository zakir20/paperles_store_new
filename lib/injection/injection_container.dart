import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:paperless_store_upd/core/network/dio_client.dart';
import 'package:paperless_store_upd/core/network/network_executor.dart'; 
import 'package:paperless_store_upd/core/bloc/language_cubit.dart'; 
import 'package:paperless_store_upd/core/bloc/global_auth_cubit.dart';
import 'package:paperless_store_upd/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:paperless_store_upd/features/auth/domain/repositories/auth_repository.dart'; 
import 'package:paperless_store_upd/features/auth/data/repositories/auth_repository_impl.dart'; 
import 'package:paperless_store_upd/features/auth/presentation/bloc/login_cubit.dart'; 
import 'package:paperless_store_upd/features/auth/presentation/bloc/register_cubit.dart'; 

final sl = GetIt.instance;

Future<void> init() async {
  //  Core
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => DioClient(sl()));
  sl.registerLazySingleton(() => NetworkExecutor(sl()));

  //  Data Sources
  sl.registerLazySingleton(() => AuthRemoteDataSource(sl()));

  // Repositories (Connecting Data to Domain) 
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  //  Global Cubits
  sl.registerLazySingleton(() => LanguageCubit());
  sl.registerLazySingleton(() => GlobalAuthCubit());

  // Feature Cubits
  sl.registerFactory(() => LoginCubit(sl())); 
  sl.registerFactory(() => RegisterCubit(sl())); 
}