import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:paperless_store_upd/core/bloc/global_auth_cubit/global_auth_cubit.dart';
import 'package:paperless_store_upd/core/bloc/language_cubit.dart';
import 'package:paperless_store_upd/core/network/dio_client.dart';
import 'package:paperless_store_upd/core/network/network_executor.dart';
import 'package:paperless_store_upd/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:paperless_store_upd/features/auth/domain/repositories/auth_repository.dart';
import 'package:paperless_store_upd/features/products/presentation/bloc/product_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => DioClient(sl()));
  sl.registerLazySingleton(() => NetworkExecutor(sl()));
  sl.registerLazySingleton(() => LanguageCubit());
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GlobalAuthCubit(sl()));
  sl.registerFactory(() => ProductCubit());
}
