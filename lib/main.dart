import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:animated_background/animated_background.dart';
import 'dart:async'; // for Timer

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GlassLoginPage(),
    );
  }
}

class GlassLoginPage extends StatefulWidget {
  const GlassLoginPage({super.key});

  @override
  State<GlassLoginPage> createState() => _GlassLoginPageState();
}

class _GlassLoginPageState extends State<GlassLoginPage> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  // Gradient animation variables
  final List<List<Color>> _gradients = [
    [Color(0xFFff9a9e), Color(0xFFfad0c4)],
    [Color(0xFFa18cd1), Color(0xFFfbc2eb)],
    [Color(0xFF89f7fe), Color(0xFF66a6ff)],
    [Color(0xFFfddb92), Color(0xFFd1fdff)],
    [Color(0xFFc2e9fb), Color(0xFFa1c4fd)],
  ];

  late List<Color> _currentGradient;
  int _gradientIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    _currentGradient = _gradients[0];

    // Start gradient loop
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => _changeGradient());

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.98, end: 1.02).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );
  }

  void _changeGradient() {
    setState(() {
      _gradientIndex = (_gradientIndex + 1) % _gradients.length;
      _currentGradient = _gradients[_gradientIndex];
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _scaleController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          AnimatedContainer(
            duration: const Duration(seconds: 4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _currentGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Particle Effect
          AnimatedBackground(
            behaviour: RandomParticleBehaviour(
              options: ParticleOptions(
                baseColor: Colors.white.withOpacity(0.3),
                spawnOpacity: 0.0,
                opacityChangeRate: 0.25,
                minOpacity: 0.15,
                maxOpacity: 0.5,
                spawnMinSpeed: 10.0,
                spawnMaxSpeed: 70.0,
                particleCount: 80,
                spawnMinRadius: 3,
                spawnMaxRadius: 8,
              ),
            ),
            vsync: this,
            child: const SizedBox.expand(),
          ),

          // Optional overlay to enhance card visibility
          Container(color: Colors.black.withOpacity(0.1)),

          // Glowing animated login card
          Center(
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOut,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.25),
                        blurRadius: 70,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                      child: Container(
                        width: 330,
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: Colors.white.withOpacity(0.45), width: 1.4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 30,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Hero-like animated title
                            TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0, end: 1),
                              duration: const Duration(seconds: 2),
                              builder: (context, value, child) {
                                return Opacity(
                                  opacity: value,
                                  child: Transform.translate(
                                    offset: Offset(0, (1 - value) * 20),
                                    child: child,
                                  ),
                                );
                              },
                              child: const Text(
                                "Welcome Back!",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 8.0,
                                      color: Colors.black54,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Shimmering TextFields with enhanced animations
                            _buildAnimatedField("Email", delay: 500),
                            const SizedBox(height: 16),
                            _buildAnimatedField("Password", obscure: true, delay: 700),
                            const SizedBox(height: 26),

                            // Animated Login Button with Ripple Effect
                            GestureDetector(
                              onTapDown: (_) => setState(() => _scaleController.forward()),
                              onTapUp: (_) => setState(() => _scaleController.reverse()),
                              onTap: () {
                                // Add your login functionality here
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.35),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 15,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: const Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 5.0,
                                        color: Colors.black26,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // This is the _buildTextField method inside the class
  Widget _buildTextField(String hint, {bool obscure = false}) {
    return TextField(
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // This is the _buildAnimatedField method inside the class
  Widget _buildAnimatedField(String hint, {bool obscure = false, int delay = 300}) {
    return FutureBuilder(
      future: Future.delayed(Duration(milliseconds: delay)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 800),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, (1 - value) * 20),
                  child: child,
                ),
              );
            },
            child: _buildTextField(hint, obscure: obscure),
          );
        } else {
          return const SizedBox.shrink(); // placeholder while waiting
        }
      },
    );
  }
}
