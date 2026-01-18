import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart'; 
import 'package:paperless_store_upd/core/bloc/language_cubit.dart';
import 'package:paperless_store_upd/core/bloc/global_auth_cubit.dart'; 
import 'package:paperless_store_upd/injection/injection_container.dart';
import 'package:paperless_store_upd/core/theme/app_colors.dart'; 
import 'package:paperless_store_upd/navigation/app_router.dart'; 

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Use MultiBlocProvider to handle both Language and Auth globally
    return MultiBlocProvider(
      providers: [
        BlocProvider<LanguageCubit>(
          create: (context) => sl<LanguageCubit>(),
        ),
        BlocProvider<GlobalAuthCubit>(
          create: (context) => sl<GlobalAuthCubit>(),
        ),
      ],
      child: MaterialApp.router( 
        debugShowCheckedModeBanner: false,
        title: 'Paperless Store',
      
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,

        routeInformationParser: AppRouter.router.routeInformationParser,
        routerDelegate: AppRouter.router.routerDelegate,
        routeInformationProvider: AppRouter.router.routeInformationProvider,
        backButtonDispatcher: AppRouter.router.backButtonDispatcher,
        
        theme: ThemeData(
          useMaterial3: true,
          primaryColor: AppColors.primary, 
          scaffoldBackgroundColor: AppColors.scaffoldBg,
          fontFamily: 'Kalpurush', 
        ),
      ),
    );
  }
}