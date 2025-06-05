import 'package:flutter/material.dart';
import 'package:automaton_simulator/DFA/pages/dfa_page.dart';
import 'package:automaton_simulator/PDA/pda_page.dart';
import 'package:automaton_simulator/TM/tm_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HeaderSection(),
            SimulatorOptionsSection(),
            FeaturesSection(),
            AboutMeSection(),
            FooterSection(),
          ],
        ),
      ),
    );
  }
}

/// ---------- HEADER -----------
class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.deepPurple.shade700, Colors.deepPurple.shade400],
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(35)),
      ),
      child: const Center(
        child: Column(
          children: [
            Text(
              'Educational Automaton Simulator',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 42,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 15),
            Text(
              'Learn & Explore Automaton Models',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.w300,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ----------- SIMULATOR OPTIONS -----------
class SimulatorOptionsSection extends StatelessWidget {
  const SimulatorOptionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      color: Colors.white,
      child: Column(
        children: [
          Text(
            'Choose Your Simulator',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: Colors.deepPurple[800],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Select the model you wish to simulate and start exploring automata theory in action.',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 17,
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: Colors.deepPurple[400],
            ),
          ),
          const SizedBox(height: 38),
          Wrap(
            spacing: 35,
            runSpacing: 35,
            alignment: WrapAlignment.center,
            children: [
              SimulatorCard(
                title: 'DFA',
                subtitle: 'Finite Automaton',
                icon: FontAwesomeIcons.codeBranch,
                color: Colors.blue,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DfaPage()),
                ),
              ),
              SimulatorCard(
                title: 'PDA',
                subtitle: 'Pushdown Automaton',
                icon: FontAwesomeIcons.layerGroup,
                color: Colors.green,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PdaPage()),
                ),
              ),
              SimulatorCard(
                title: 'TM',
                subtitle: 'Turing Machine',
                icon: FontAwesomeIcons.memory,
                color: Colors.orange,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TmPage()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SimulatorCard extends StatelessWidget {
  final String title, subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const SimulatorCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 410,
      child: Card(
        elevation: 7,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: color, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 44, horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 70, color: color),
                const SizedBox(height: 25),
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 29,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey[850],
                  ),
                ),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 11),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ----------- FEATURES -----------
class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF7F7F8),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 70),
      child: Column(
        children: [
          Text(
            'Features',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 38,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple[800],
            ),
          ),
          const SizedBox(height: 55),
          const Wrap(
            spacing: 80,
            runSpacing: 40,
            alignment: WrapAlignment.center,
            children: [
              FeatureBox(
                icon: FontAwesomeIcons.play,
                iconBg: Color(0xFF6B39CF),
                title: 'Interactive Simulations',
                subtitle:
                    'Visualize automata in action with\nstep-by-step animations',
              ),
              FeatureBox(
                icon: FontAwesomeIcons.graduationCap,
                iconBg: Color(0xFF6B39CF),
                title: 'Comprehensive Tutorials',
                subtitle: 'Learn the theory behind each\ncomputational model',
              ),
              FeatureBox(
                icon: FontAwesomeIcons.pen,
                iconBg: Color(0xFF6B39CF),
                title: 'Custom Automata Creation',
                subtitle:
                    'Design and test your own automata\nwith an intuitive interface',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FeatureBox extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final String title;
  final String subtitle;
  const FeatureBox({
    super.key,
    required this.icon,
    required this.iconBg,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 340,
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF4725A6), size: 50),
          const SizedBox(height: 25),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Color(0xFF383838),
            ),
          ),
          const SizedBox(height: 9),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Poppins',
              height: 1.4,
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

/// ----------- ABOUT ME -----------
class AboutMeSection extends StatelessWidget {
  const AboutMeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 30),
      color: Colors.white,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'About This Project',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Colors.deepPurple[800],
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'Automaton Simulator was created to help students, educators, and anyone curious about computation explore the world of automata.\n\nHere you can visualize, experiment with, and truly understand the concepts behind finite automata, pushdown automata, and Turing machines — in an intuitive and interactive way.\n\nWhether you’re struggling with theory or just want to play with machines, this tool is for you!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  color: Colors.grey[800],
                  height: 1.7,
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'This project was lovingly developed by a single developer. If you found it helpful or inspiring, feel free to support, share, or just say hi!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: Colors.deepPurple[400],
                ),
              ),
              const SizedBox(height: 28),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SocialLinkButton(
                    icon: FontAwesomeIcons.github,
                    label: 'Support / Star',
                    url: 'https://github.com/YosiKariv1',
                  ),
                  SizedBox(width: 18),
                  SocialLinkButton(
                    icon: FontAwesomeIcons.linkedin,
                    label: 'Connect',
                    url: 'https://www.linkedin.com/in/yosi-kariv/',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Created and maintained by Yosi Kariv 💜',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Colors.deepPurple[200],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SocialLinkButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String url;
  const SocialLinkButton({
    super.key,
    required this.icon,
    required this.label,
    required this.url,
  });

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      icon: FaIcon(icon, size: 22, color: Colors.deepPurple[600]),
      label: Text(
        label,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          color: Colors.deepPurple[600],
        ),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.deepPurple.shade100),
        ),
      ),
      onPressed: () => _launchURL(url),
    );
  }
}

/// ----------- FOOTER -----------
class FooterSection extends StatelessWidget {
  const FooterSection({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      color: Colors.deepPurple[900],
      child: const Center(
        child: Text(
          '© 2024 Automaton Simulator. All rights reserved.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 15,
            fontWeight: FontWeight.w300,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
