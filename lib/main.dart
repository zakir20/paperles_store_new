<<<<<<< HEAD
import 'package:flutter/material.dart'; 
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_store_upd/core/bloc/app_bloc_observer.dart';
import 'package:paperless_store_upd/injection/injection_container.dart' as di;
import 'package:paperless_store_upd/app.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  Bloc.observer = AppBlocObserver();
=======
import 'package:flutter/material.dart';
import 'app.dart';

void main() {
>>>>>>> 80e79e0d57498f8285b6aee913ad20e8f7441117
  runApp(const MyApp());
}