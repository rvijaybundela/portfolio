import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portfolio Site',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: 1.5,
            color: Colors.teal.shade900,
          ),
        ),
      ),
      home: OnePage(),
      debugShowCheckedModeBanner: false,
      );
    }
}

class OnePage extends StatefulWidget {
  @override
  _OnePageState createState() => _OnePageState();
}

class _OnePageState extends State<OnePage> with SingleTickerProviderStateMixin {
  // Set to 0 to select Profile by default
  int? selectedIndex = 0;
  bool started = false;
  bool showSplash = true;
  bool _startButtonPressed = false;

  late AnimationController _pulseController;

  final List<_ButtonData> buttons = [
  _ButtonData(
    icon: Icons.person,
    label: 'Profile',
    colors: [Colors.teal, Colors.cyan],
  ),
  _ButtonData(
    icon: Icons.description,
    label: 'Resume',
    colors: [Colors.deepPurple, Colors.pinkAccent],
  ),
  _ButtonData(
    icon: Icons.work,
    label: 'Project',
    colors: [Colors.orange, Colors.amber],
  ),
  _ButtonData(
    icon: Icons.timeline,
    label: 'Experience',
    colors: [Colors.green, Colors.lightGreen],
  ),
  _ButtonData(
    icon: Icons.mail,
    label: 'Connect',
    colors: [Colors.redAccent, Colors.deepOrange],
  ),
];

  @override
  void initState() {
    super.initState();
    selectedIndex = 0;
    _pulseController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
      lowerBound: 0.95,
      upperBound: 1.05,
    )..repeat(reverse: true);

    // Show splash for 3 seconds, then start main UI
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        showSplash = false;
        started = true;
      });
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use a relaxed gradient background everywhere
    Widget background = Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.teal.shade100,
            Colors.blue.shade100,
            Colors.purple.shade100,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );

    // Directly show your main UI (no splash)
    return Stack(
      children: [
        background,
        Scaffold(
          body: Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: 900,
                      minWidth: 320,
                      minHeight: 400,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.teal.shade100,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.teal.withOpacity(0.08),
                          blurRadius: 16,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left: Animated vertical buttons
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                height: 60,
                                child: Marquee(
                                  text: 'Welcome to my portfolio! Explore my work and connect with me.',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.teal.shade900,
                                  ),
                                  scrollAxis: Axis.horizontal,
                                  blankSpace: 120.0,
                                  velocity: 40.0,
                                  pauseAfterRound: Duration(seconds: 1),
                                  startPadding: 10.0,
                                  accelerationDuration: Duration(seconds: 1),
                                  accelerationCurve: Curves.easeInOut,
                                  decelerationDuration: Duration(seconds: 1),
                                  decelerationCurve: Curves.easeInOut,
                                ),
                              ),
                              SizedBox(height: 24),
                              ...List.generate(buttons.length, (index) {
                                final data = buttons[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                                  child: _AnimatedCircleButton(
                                    icon: data.icon,
                                    label: data.label,
                                    colors: data.colors,
                                    onTap: () {
                                      setState(() {
                                        selectedIndex = index;
                                      });
                                    },
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                        SizedBox(width: 32),
                        // Right: Show selected card content
                        Expanded(
                          flex: 2,
                          child: AnimatedSwitcher(
                            duration: Duration(milliseconds: 400),
                            child: selectedIndex != null
                                ? _buildCardContent(selectedIndex!)
                                : Center(
                                    child: Text(
                                      'Select an option to view details',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.teal.shade700,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCardContent(int index) {
    switch (buttons[index].label) {
      case 'Profile':
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(
                    'https://as1.ftcdn.net/v2/jpg/06/28/25/78/1000_F_628257885_xPfc4T4Uvb5ao9abfJNrDd8iAdMyo1Aq.jpg', // Direct image link from Freepik preview
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Vijay Bundela',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade900,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  "Flutter Developer\n\nPost-graduate with strong Flutter development skills, showcased through a live project in the final semester. Experienced graphic designer with a creative edge and proven leadership as a team captain. Known for balancing multiple roles with excellent time management and a problem-solving mindset.",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Text(
                  'Social Links',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.teal.shade900,
                  ),
                ),
                SizedBox(height: 10),
                ListTile(
                  leading: Icon(Icons.link, color: Colors.purple),
                  title: Text('Instagram'),
                  subtitle: Text('vjbundela'),
                  onTap: () => launchUrl(Uri.parse('https://www.instagram.com/vjbundela')),
                ),
                ListTile(
                  leading: Icon(Icons.link, color: Colors.black),
                  title: Text('GitHub'),
                  subtitle: Text('rvijaybundela'),
                  onTap: () => launchUrl(Uri.parse('https://github.com/rvijaybundela')),
                ),
                ListTile(
                  leading: Icon(Icons.link, color: Colors.blue[800]),
                  title: Text('LinkedIn'),
                  subtitle: Text('rvjbundela2024'),
                  onTap: () => launchUrl(Uri.parse('https://www.linkedin.com/in/rvjbundela2024/')),
                ),
              ],
            ),
          ),
        );
      case 'Resume':
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'My Resume',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade900,
                  ),
                ),
                SizedBox(height: 16),
                TextButton(
                  child: Text(
                    'Open Resume (Word Document)',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.deepPurple,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () {
                    launchUrl(Uri.parse('https://1drv.ms/w/c/cb527eef245230ae/ETSRuUY-X4BGoGsSRLI72TMBGrE9WtHRh2KLSyqj225dxg?e=JQ9ptj'));
                  },
                ),
              ],
            ),
          ),
        );
      case 'Project':
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Projects',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade900,
                  ),
                ),
                SizedBox(height: 12),
                ListTile(
                  leading: Icon(Icons.link, color: Colors.teal),
                  title: Text('Portfolio App (GitHub)'),
                  onTap: () => launchUrl(Uri.parse('https://github.com/rvijaybundela')),
                ),
                ListTile(
                  leading: Icon(Icons.link, color: Colors.green),
                  title: Text('Carbon Shodhak (Live)'),
                  onTap: () => launchUrl(Uri.parse('https://carbonshodhak.vercel.app/')),
                ),
              ],
            ),
          ),
        );
      case 'Experience':
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Experience',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade900,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Academic Project:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.teal.shade800,
                  ),
                ),
                SizedBox(height: 6),
              
                Text(
                  'Carbon Shodhak – Vehicle Emission Tracking App\n'
                  'Developed a Flutter-based mobile app to monitor vehicle emissions using MQ7 and MQ135 sensors, with real-time data visualization. Integrated features like Firebase Authentication, carbon credit calculation, and emission alerts. Designed a responsive UI for Android, promoting environmental awareness and user action.',
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
                SizedBox(height: 18),
                Text(
                  'Graphic Designer – E-Cell, SCSIT, DAVV',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.teal.shade800,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Designed digital graphics for social media, posters, and event promotions over 8 months. Boosted E-Cell\'s engagement and visibility through impactful visual content and collaboration with the team.',
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
              ],
            ),
          ),
        );
      case 'Connect':
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Let\'s Connect!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade900,
                  ),
                ),
                SizedBox(height: 12),
                // Email is hidden, but button still works
                // Text(
                //   'Email: ranvjbundela48@gmail.com',
                //   style: TextStyle(fontSize: 16, color: Colors.teal.shade700),
                // ),
                SizedBox(height: 12),
                ElevatedButton.icon(
                  icon: Icon(Icons.email),
                  label: Text('Send Email'),
                  onPressed: () {
                    launchUrl(Uri.parse('mailto:ranvjbundela48@gmail.com?subject=Contact%20from%20Portfolio'));
                  },
                ),
              ],
            ),
          ),
        );
      default:
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text('No content'),
          ),
        );
    }
  }

  Future<void> _showSplashScreen() async {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Splash',
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) => const SizedBox.square(),
      transitionBuilder: (context, anim1, anim2, child) {
        return Opacity(
          opacity: anim1.value,
          child: Center(
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
              ),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(const Color.fromARGB(255, 244, 239, 239)),
                strokeWidth: 6,
              ),
            ),
          ),
        );
      },
    );
    await Future.delayed(Duration(seconds: 1));
    Navigator.of(context).pop();
  }
}

class _AnimatedCircleButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final List<Color> colors;
  final VoidCallback onTap;

  const _AnimatedCircleButton({
    required this.icon,
    required this.label,
    required this.colors,
    required this.onTap,
  });

  @override
  State<_AnimatedCircleButton> createState() => _AnimatedCircleButtonState();
}

class _AnimatedCircleButtonState extends State<_AnimatedCircleButton>
    with SingleTickerProviderStateMixin {
  bool _pressed = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    _scaleAnim = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  return FadeTransition(
    opacity: _fadeAnim,
    child: ScaleTransition(
      scale: _scaleAnim,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) {
          setState(() => _pressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedScale(
          scale: _pressed ? 1.07 : 1.0,
          duration: Duration(milliseconds: 180),
          curve: Curves.easeInOut,
          child: Container(
            width: 180,
            height: 70,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: widget.colors
                    .map((c) => c.withOpacity(0.35))
                    .toList(), // Lighten the colors
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(widget.icon, size: 30, color: Colors.teal.shade900.withOpacity(0.7)),
                SizedBox(width: 14),
                AnimatedDefaultTextStyle(
                  duration: Duration(milliseconds: 300),
                  style: TextStyle(
                    color: Colors.teal.shade900.withOpacity(0.8),
                    fontWeight: FontWeight.bold,
                    fontSize: _pressed ? 22 : 20,
                    letterSpacing: 1.2,
                  ),
                  child: Text(widget.label),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
}

class _ButtonData {
  final IconData icon;
  final String label;
  final List<Color> colors;

  _ButtonData({
    required this.icon,
    required this.label,
    required this.colors,
  });
  
  String get text => '';
  
  String get image => '';
}
