/*Declaração de Propriedade Intelectual

Eu, Flora Rosa Pupo, declaro que sou o detentor dos direitos autorais do código e de todas as contribuições que fiz para o mesmo. 

Eu afirmo que detenho todos os direitos de propriedade intelectual, incluindo direitos autorais, sobre este código. Qualquer uso não autorizado, reprodução, distribuição ou modificação do código, no todo ou em parte, sem minha permissão expressa por escrito, é estritamente proibido.
*/


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:projeto_prefeitura/pages/loginpage.dart';
import 'package:projeto_prefeitura/pages/painel.dart';
import 'package:projeto_prefeitura/pages/realtime.dart';
import 'package:projeto_prefeitura/pages/registerpage.dart';
import 'package:projeto_prefeitura/pages/homepage.dart';

import 'package:projeto_prefeitura/pages/exportar.dart';
import 'package:projeto_prefeitura/pages/forms/contribuinte.dart';
import 'package:projeto_prefeitura/pages/forms/imovel.dart';
import 'package:projeto_prefeitura/pages/painel.dart';
import 'package:projeto_prefeitura/pages/quarteiroes.dart';
import 'package:projeto_prefeitura/test.dart';

import 'package:intl/intl.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:flutter_launcher_icons/android.dart';

import 'package:flutter_launcher_icons/constants.dart';
import 'package:flutter_launcher_icons/custom_exceptions.dart';
import 'package:flutter_launcher_icons/ios.dart';
import 'package:flutter_launcher_icons/main.dart';
import 'package:flutter_launcher_icons/utils.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';

import 'package:date_format/date_format.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [Locale('pt', 'BR')],
      home: HomePage(),
      theme: ThemeData(
        //useMaterial3: true,
        fontFamily: 'Montserrat',
        //primarySwatch: Colors.white10,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.light,
        errorColor: Colors.red,
        hoverColor: Colors.redAccent,
      ),
    );
  }
}
