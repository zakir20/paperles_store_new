import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:paperless_store_upd/core/network/dio_client.dart';
import 'package:paperless_store_upd/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:paperless_store_upd/features/auth/presentation/bloc/auth_cubit.dart'; 

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => DioClient(sl()));

  // Data Sources
  sl.registerLazySingleton(() => AuthRemoteDataSource(sl()));

  // Cubit 
  sl.registerFactory(() => AuthCubit(sl())); 
}