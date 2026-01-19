import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_store_upd/core/bloc/language_cubit.dart';
import 'package:paperless_store_upd/core/bloc/global_auth_cubit.dart';
import 'package:paperless_store_upd/injection/injection_container.dart';

class AppProviders {
  //  all global providers
  static List<BlocProvider> get providers => [
        BlocProvider<LanguageCubit>(
          create: (context) => sl<LanguageCubit>(),
        ),
        BlocProvider<GlobalAuthCubit>(
          create: (context) => sl<GlobalAuthCubit>(),
        ),
      ];
}