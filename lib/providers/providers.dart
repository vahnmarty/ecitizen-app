import 'package:citizen/providers/auth_provider.dart';
import 'package:citizen/providers/location_provider.dart';
import 'package:citizen/providers/news_provider.dart';
import 'package:citizen/providers/services_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providers = [...independentProviders];
List<SingleChildWidget> independentProviders = [
  ChangeNotifierProvider(create: (_) => NewsProvider()),
  ChangeNotifierProvider(create: (_) => LocationProvider()),
  ChangeNotifierProvider(create: (_) => AuthProvider()),
  ChangeNotifierProvider(create: (_) => ServicesProvider()),
];
