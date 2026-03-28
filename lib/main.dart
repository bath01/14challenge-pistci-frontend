import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pistci/core/constants/app_colors.dart';
import 'package:pistci/core/router/app_router.dart';
import 'package:pistci/core/theme/app_theme.dart';
import 'package:pistci/core/theme/theme_provider.dart';
import 'package:pistci/features/onboarding/presentation/pages/onboarding_page.dart';

void main() {
  runApp(const ProviderScope(child: PistCIApp()));
}

class PistCIApp extends ConsumerWidget {
  const PistCIApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp(
      title: 'PistCI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const _AppBootstrap(),
    );
  }
}

enum _BootState { splash, onboarding, ready }

class _AppBootstrap extends StatefulWidget {
  const _AppBootstrap();
  @override
  State<_AppBootstrap> createState() => _AppBootstrapState();
}

class _AppBootstrapState extends State<_AppBootstrap> with SingleTickerProviderStateMixin {
  _BootState _state = _BootState.splash;
  late final AnimationController _loaderCtrl;

  @override
  void initState() {
    super.initState();
    _loaderCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat();
    _runSplash();
  }

  Future<void> _runSplash() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    setState(() => _state = _BootState.onboarding);
  }

  @override
  void dispose() {
    _loaderCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (_state) {
      case _BootState.splash:
        return _SplashView(loaderCtrl: _loaderCtrl);
      case _BootState.onboarding:
        return OnboardingPage(
          onComplete: () => setState(() => _state = _BootState.ready),
        );
      case _BootState.ready:
        return Router(routerDelegate: AppRouter.router.routerDelegate, routeInformationParser: AppRouter.router.routeInformationParser, routeInformationProvider: AppRouter.router.routeInformationProvider);
    }
  }
}

class _SplashView extends StatelessWidget {
  final AnimationController loaderCtrl;
  const _SplashView({required this.loaderCtrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 3),

            // Drapeau CI
            Container(
              width: 80, height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
                boxShadow: [BoxShadow(color: AppColors.ciOrange.withAlpha(40), blurRadius: 30, spreadRadius: 5)],
              ),
              clipBehavior: Clip.antiAlias,
              child: Row(children: [
                Expanded(child: Container(color: AppColors.ciOrange)),
                Expanded(child: Container(color: Colors.white)),
                Expanded(child: Container(color: AppColors.ciGreen)),
              ]),
            ),
            const SizedBox(height: 24),

            // Logo
            const Text.rich(TextSpan(children: [
              TextSpan(text: 'Pist', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800, color: AppColors.textPrimary, letterSpacing: -1)),
              TextSpan(text: 'CI', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800, color: AppColors.ciOrange, letterSpacing: -1)),
            ])),
            const SizedBox(height: 8),
            const Text("Cartographie interactive — Cote d'Ivoire",
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),

            const Spacer(flex: 2),

            // Loader
            AnimatedBuilder(
              animation: loaderCtrl,
              builder: (context, _) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _bar(AppColors.ciOrange, 0.0),
                  const SizedBox(width: 6),
                  _bar(Colors.white, 0.2),
                  const SizedBox(width: 6),
                  _bar(AppColors.ciGreen, 0.4),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text('Chargement...', style: TextStyle(fontSize: 11, color: AppColors.textDim)),

            const Spacer(),
            const Padding(
              padding: EdgeInsets.only(bottom: 32),
              child: Text('CHALLENGE 14-14-14  //  JOUR 12',
                  style: TextStyle(fontSize: 9, color: AppColors.textDim, letterSpacing: 2)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bar(Color color, double delay) {
    final t = ((loaderCtrl.value + delay) % 1.0) * 6.28318;
    final sinVal = t - (t * t * t) / 6.0 + (t * t * t * t * t) / 120.0;
    final h = 8.0 + 16.0 * (0.5 + 0.5 * (sinVal % 2.0 - 1.0).clamp(-1.0, 1.0));
    return Container(width: 4, height: h, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)));
  }
}
