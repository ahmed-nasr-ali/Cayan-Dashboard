// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api, avoid_print, unnecessary_new, unused_field, prefer_const_literals_to_create_immutables

import 'package:cayan/locale/locale_helper.dart';
import 'package:cayan/network/api_errors/403errors/error_403.dart';
import 'package:cayan/network/api_errors/auth%20errors/auth_log_in_error.dart';
import 'package:cayan/network/api_errors/blog%20errors/blog_errors.dart';
import 'package:cayan/network/api_errors/branche%20error/branche_error.dart';
import 'package:cayan/network/api_errors/category%20error/category_error.dart';
import 'package:cayan/network/api_errors/change%20password%20error/change_password_error.dart';
import 'package:cayan/network/api_errors/customer%20error/customer_error.dart';
import 'package:cayan/network/api_errors/customer%20review%20error/customer_review_error.dart';
import 'package:cayan/network/api_errors/edit%20employee%20error/edit_empolyee_error.dart';
import 'package:cayan/network/api_errors/home%20server%20error/home_server_error.dart';
import 'package:cayan/network/api_errors/news%20errors/news_errors.dart';
import 'package:cayan/network/api_errors/offer%20error/offer_error.dart';
import 'package:cayan/network/api_errors/order%20error/order_api_error.dart';
import 'package:cayan/network/api_errors/project%20error/project_error.dart';
import 'package:cayan/network/api_errors/server%20error/server_error.dart';
import 'package:cayan/network/api_errors/services%20api%20error/services_api_error.dart';
import 'package:cayan/network/api_errors/source_error/source_error.dart';
import 'package:cayan/network/api_errors/store/store_error.dart';
import 'package:cayan/network/api_errors/team%20work%20store%20error/team_work_store_error.dart';
import 'package:cayan/network/api_errors/unauthorized/unauthorized_error.dart';
import 'package:cayan/providers/choosecountry.dart';
import 'package:cayan/providers/navigation_bar_screen.dart';
import 'package:cayan/providers/theme_provider.dart';
import 'package:cayan/shared_preferences/control%20panel/control_panel.dart';
import 'package:cayan/shared_preferences/follow%20source%20data/follow_source_data.dart';
import 'package:cayan/shared_preferences/follow_prefrmance/follow_prefromance_data.dart';
import 'package:cayan/shared_preferences/order%20user%20data/order_user_data.dart';
import 'package:cayan/shared_preferences/services%20user%20data/services_user_data.dart';
import 'package:cayan/shared_preferences/team%20work%20user%20data/team_work_user_data.dart';
import 'package:cayan/shared_preferences/user_data.dart';
import 'package:cayan/shared_preferences/user_information_data.dart';
import 'package:cayan/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'locale/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'network/api_errors/roles and perimssions api error/roles_and_perimission_api_errors.dart';
import 'providers/add_roles_and_perimisson_provider.dart';
import 'shared_preferences/shared_preferences_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserData.init();
  await UserInformation.init();
  await TeamWorkUserData.init();
  await ServicesUserData.init();
  await OrderUserData.init();
  await FollowSourceUserData.init();
  await ControlPanleUserData.init();
  await FollowPrefUserData.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    run();
  });
}

void run() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Locale _locale;

  onLocaleChange(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  Future<void> _getLanguage() async {
    String language = await SharedPreferencesHelper.getUserLang();
    print('lan:$language');
    onLocaleChange(Locale(language));
  }

  @override
  void initState() {
    super.initState();
    helper.onLocaleChanged = onLocaleChange;
    _locale = new Locale('en');
    _getLanguage();
  }

  @override
  Widget build(BuildContext context) {
    // final themeProvider = Provider.of<ThemeProvider>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthLogInError(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChooseCountryData(),
        ),
        ChangeNotifierProvider(
          create: (_) => UnauthorizedError(),
        ),
        ChangeNotifierProvider(
          create: (_) => StoreError(),
        ),
        ChangeNotifierProvider(
          create: (_) => EditEmployeeError(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChangePasswordError(),
        ),
        ChangeNotifierProvider(
          create: (_) => Error403(),
        ),
        ChangeNotifierProvider(
          create: (_) => ServerError(),
        ),
        ChangeNotifierProvider(
          create: (_) => HomeServerError(),
        ),
        ChangeNotifierProvider(
          create: (_) => NavigationBarScreen(),
        ),
        ChangeNotifierProvider(
          create: (_) => TeamWorkStoreError(),
        ),
        ChangeNotifierProvider(
          create: (_) => ServicesStoreError(),
        ),
        ChangeNotifierProvider(
          create: (_) => CategoryStoreError(),
        ),
        ChangeNotifierProvider(
          create: (_) => OfferStoreError(),
        ),
        ChangeNotifierProvider(
          create: (_) => AddRolesAndPerimissionsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => RolesAndPerimissionApiError(),
        ),
        ChangeNotifierProvider(
          create: (_) => OrderStoreError(),
        ),
        ChangeNotifierProvider(
          create: (_) => NewsStoreError(),
        ),
        ChangeNotifierProvider(
          create: (_) => BlogStoreError(),
        ),
        ChangeNotifierProvider(
          create: (_) => CustomerError(),
        ),
        ChangeNotifierProvider(
          create: (_) => SourceStoreError(),
        ),
        ChangeNotifierProvider(
          create: (_) => BrancheStoreError(),
        ),
        ChangeNotifierProvider(
          create: (_) => CustomerReviewStoreError(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProjectStoreError(),
        ),
        // ChangeNotifierProvider(
        //   create: (_) => ProjectStoreError(),
        // ),
      ],
      child: MaterialApp(
        locale: _locale,
        supportedLocales: [
          Locale('en', 'US'),
          Locale('ar', ''),
        ],
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        title: 'CAYAN',
        debugShowCheckedModeBanner: false,
        theme: MyThemes.lightTheme,
        darkTheme: MyThemes.darkThemes,
        themeMode: ThemeMode.light,
        routes: routes,
      ),
    );
  }
}
