import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_store_upd/core/bloc/global_auth_cubit/global_auth_cubit.dart';
import 'package:paperless_store_upd/core/bloc/language_cubit.dart';
import 'package:paperless_store_upd/injection/injection_container.dart';

class AppProviders {
  static List<BlocProvider> get providers => [
        BlocProvider<LanguageCubit>(
          create: (_) => LanguageCubit(),
        ),
        BlocProvider<GlobalAuthCubit>(
          create: (_) => sl<GlobalAuthCubit>(),
        ),
      ];
}
