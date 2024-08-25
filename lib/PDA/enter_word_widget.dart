import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/classes/pda_class.dart';
import 'package:provider/provider.dart';

class EnterWordWidget extends StatefulWidget {
  const EnterWordWidget({super.key});

  @override
  EnterWordWidgetState createState() => EnterWordWidgetState();
}

class EnterWordWidgetState extends State<EnterWordWidget> {
  bool _showInputField = false;
  final TextEditingController _textController = TextEditingController();
  String _inputText = "";

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _toggleInputField() {
    setState(() {
      _showInputField = !_showInputField;
      if (!_showInputField) {
        _textController.clear();
      }
    });
  }

  void _submitWord(PDA automatonModel) {
    if (_textController.text.isNotEmpty) {
      setState(() {
        _inputText = _textController.text;
        automatonModel.word = _inputText;
        _showInputField = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final automatonModel = Provider.of<PDA>(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_showInputField)
          _buildInputField(automatonModel)
        else
          _buildDisplayField(),
      ],
    );
  }

  Widget _buildInputField(PDA automatonModel) {
    return Column(
      children: [
        TextField(
          controller: _textController,
          decoration: InputDecoration(
            hintText: 'Enter Word To check',
            hintStyle: GoogleFonts.poppins(),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
            ),
          ),
          style: GoogleFonts.poppins(),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: _textController.text.isNotEmpty
                  ? () => _submitWord(automatonModel)
                  : null,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.deepPurple,
                disabledBackgroundColor: Colors.grey,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('Submit', style: GoogleFonts.poppins()),
            ),
            ElevatedButton(
              onPressed: _toggleInputField,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.deepPurple,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('Cancel', style: GoogleFonts.poppins()),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDisplayField() {
    return Column(
      children: [
        const SizedBox(height: 16),
        Text(
          _inputText.isEmpty ? 'No word entered' : _inputText,
          style: GoogleFonts.poppins(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _toggleInputField,
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.deepPurple,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text('Enter word', style: GoogleFonts.poppins()),
        ),
      ],
    );
  }
}
