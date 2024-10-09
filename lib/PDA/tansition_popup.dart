import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:automaton_simulator/classes/operations_class.dart';

class PDATransitionPopup extends StatefulWidget {
  final List<Operations> initialOperations;

  const PDATransitionPopup({super.key, required this.initialOperations});

  @override
  PDATransitionPopupState createState() => PDATransitionPopupState();
}

class PDATransitionPopupState extends State<PDATransitionPopup> {
  late List<Operations> operations;
  late List<bool> editModes;

  @override
  void initState() {
    super.initState();
    operations = List.from(widget.initialOperations);
    editModes = List.generate(operations.length, (_) => false);
  }

  void addAction() {
    setState(() {
      operations.add(Operations(
        inputTopSymbol: '',
        stackPopSymbol: '',
        stackPushSymbol: '',
      ));
      editModes.add(true);
    });
  }

  void removeAction(int index) {
    setState(() {
      operations.removeAt(index);
      editModes.removeAt(index);
    });
  }

  void toggleEditMode(int index) {
    setState(() {
      editModes[index] = !editModes[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "PDA Transition Input",
              style: GoogleFonts.rajdhani(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple[800],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.5,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: operations.asMap().entries.map((entry) {
                    int index = entry.key;
                    Operations action = entry.value;
                    return _buildActionCard(action, index);
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: addAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  minimumSize: const Size(150, 36),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Add Operation",
                  style: GoogleFonts.poppins(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildActionButton(
                  'Confirm',
                  operations.isNotEmpty ? Colors.deepPurple : Colors.grey,
                  operations.isNotEmpty
                      ? () => Navigator.of(context).pop(operations)
                      : null,
                ),
                _buildActionButton(
                  'Cancel',
                  Colors.white,
                  () => Navigator.of(context).pop(null),
                  textColor: Colors.deepPurple[800]!,
                  borderColor: Colors.deepPurple[800]!,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(Operations operetion, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  editModes[index] ? "Edit Action" : "Action Preview",
                  style: GoogleFonts.rajdhani(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple[800],
                  ),
                ),
                if (!editModes[index])
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.deepPurple[800]),
                    onPressed: () => toggleEditMode(index),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (editModes[index])
              _buildEditFields(operetion, index)
            else
              Center(
                child: Text(
                  operetion.toString(),
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.deepPurple[800],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditFields(Operations action, int index) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildTextField(
              label: "Input Top",
              value: action.inputTopSymbol,
              onChanged: (value) =>
                  setState(() => action.inputTopSymbol = value),
            ),
            _buildTextField(
              label: "Stack Top/Pop",
              value: action.stackPopSymbol,
              onChanged: (value) =>
                  setState(() => action.stackPopSymbol = value),
            ),
            _buildTextField(
              label: "Stack Push",
              value: action.stackPushSymbol,
              onChanged: (value) =>
                  setState(() => action.stackPushSymbol = value),
              isPushField: true, // להרחיב את שדה ה-Push
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => toggleEditMode(index),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple[300],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: Text('Save', style: GoogleFonts.poppins()),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () => removeAction(index),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple[800],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: Text('Delete', style: GoogleFonts.poppins()),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String value,
    required ValueChanged<String> onChanged,
    bool isPushField = false, // פרמטר חדש לבדוק אם זה שדה ה-Push
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: GoogleFonts.rajdhani(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple[800],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: isPushField ? 120 : 60, // מרחיבים את שדה ה-Push
          height: 40,
          child: TextField(
            controller: TextEditingController(text: value),
            onChanged: onChanged,
            textAlign: TextAlign.center,
            maxLength: isPushField
                ? 10
                : 1, // לשדה ה-Push נוכל להגדיר מגבלה גבוהה יותר
            style: GoogleFonts.roboto(
              fontSize: 18,
              color: Colors.deepPurple[800],
            ),
            decoration: InputDecoration(
              counterText: '',
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.deepPurple),
              ),
              filled: true,
              fillColor: Colors.deepPurple[50],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    String text,
    Color backgroundColor,
    VoidCallback? onPressed, {
    Color textColor = Colors.white,
    Color? borderColor,
  }) {
    return SizedBox(
      height: 40,
      width: 120,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: borderColor != null
                ? BorderSide(color: borderColor)
                : BorderSide.none,
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(fontSize: 16),
        ),
      ),
    );
  }
}
