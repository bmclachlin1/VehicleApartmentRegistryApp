import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'landing_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(
            providerConfigs: [
              const EmailProviderConfiguration(),
              GoogleProviderConfiguration(
                  clientId: dotenv.env["googleProviderClientId"]!)
            ],
            sideBuilder: (context, constraints) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: AspectRatio(
                    aspectRatio: 1, child: Image.asset('Dashatars.png')),
              );
            },
            subtitleBuilder: (context, action) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: action == AuthAction.signIn
                    ? const Text(
                        'Welcome to Vehicle.io, please sign in to register your vehicle!')
                    : const Text(
                        'Welcome to Vehicle.io, please sign up to register your vehicle!'),
              );
            },
          );
        }
        return const LandingPage();
      },
    );
  }
}