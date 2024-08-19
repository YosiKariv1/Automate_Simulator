import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PdaPage extends StatelessWidget {
  const PdaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'PDA Simulator',
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32,
                color: Colors.white,
              ),
            ),
          ),
        ),
        backgroundColor: Colors.deepPurple[800],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple[700]!, Colors.deepPurple[900]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return constraints.maxWidth > 1200
                  ? _buildWideLayout(context)
                  : _buildNarrowLayout(context);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildWideLayout(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: _buildMainArea(context),
        ),
        Expanded(
          flex: 1,
          child: _buildSidePanel(context),
        ),
      ],
    );
  }

  Widget _buildNarrowLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildMainArea(context),
          _buildSidePanel(context),
        ],
      ),
    );
  }

  Widget _buildMainArea(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            flex: 4,
            child: _buildEditorArea(context),
          ),
          const SizedBox(height: 16),
          Expanded(
            flex: 1,
            child: _buildControlPanel(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSidePanel(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildInputArea(context),
          const SizedBox(height: 16),
          _buildStackVisualization(context),
          const SizedBox(height: 16),
          Expanded(
            child: _buildInfoArea(context),
          ),
        ],
      ),
    );
  }

  Widget _buildEditorArea(BuildContext context) {
    return Container(
      decoration: _buildBoxDecoration(),
      child: const Center(
        child: Text('PDA Editor Area'),
      ),
    );
  }

  Widget _buildControlPanel(BuildContext context) {
    return Container(
      decoration: _buildBoxDecoration(color: Colors.deepPurple[50]),
      child: const Center(
        child: Text('Simulation Control Panel'),
      ),
    );
  }

  Widget _buildInputArea(BuildContext context) {
    return Container(
      height: 120,
      decoration: _buildBoxDecoration(color: Colors.deepPurple[50]),
      child: const Center(
        child: Text('Input Control Area'),
      ),
    );
  }

  Widget _buildStackVisualization(BuildContext context) {
    return Container(
      height: 300,
      decoration: _buildBoxDecoration(),
      child: const Center(
        child: Text('Stack Visualization'),
      ),
    );
  }

  Widget _buildInfoArea(BuildContext context) {
    return Container(
      decoration: _buildBoxDecoration(color: Colors.deepPurple[50]),
      child: const Center(
        child: Text('PDA Information Area'),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration({Color? color}) {
    return BoxDecoration(
      color: color ?? Colors.white,
      borderRadius: BorderRadius.circular(15.0),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          spreadRadius: 5,
        ),
      ],
    );
  }
}
