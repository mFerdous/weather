import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/size_config.dart';
import '../../../landing/presentation/screens/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? accessToken;
  String? checkOnlineOffline;
  getSignInResponse() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    accessToken = sharedPreferences.getString("access_token");
  }

  @override
  void initState() {
    super.initState();
    getSignInResponse();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: AnimatedSplashScreen(
        splashIconSize: double.infinity,
        duration: 3000,
        splash: Center(
            child: Stack(
          alignment: Alignment.center,
          children: [
            const Image(image: AssetImage('assets/images/background.png')),
            Text(
              'TFR',
              style: GoogleFonts.agbalumo(
                textStyle: Theme.of(context).textTheme.displayLarge,
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        )),
        nextScreen: accessToken == null ? const HomePage() : const HomePage(),
        splashTransition: SplashTransition.fadeTransition,
        backgroundColor: const Color(0xff042a49),
      ),
    );
  }
}
