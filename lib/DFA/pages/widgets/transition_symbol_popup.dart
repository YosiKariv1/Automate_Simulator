import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TransitionSymbolPopup extends StatefulWidget {
  final String alphabet;
  final Set<String> initialSymbols;
  final Set<String> usedSymbols;

  const TransitionSymbolPopup({
    super.key,
    required this.alphabet,
    required this.initialSymbols,
    required this.usedSymbols,
  });

  @override
  State<TransitionSymbolPopup> createState() => _TransitionSymbolPopupState();
}

class _TransitionSymbolPopupState extends State<TransitionSymbolPopup> {
  late Set<String> selectedSymbols;

  @override
  void initState() {
    super.initState();
    selectedSymbols = {...widget.initialSymbols};
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 480,
            minWidth: 300,
            minHeight: 280,
            maxHeight: 460,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: Colors.deepPurple,
                blurRadius: 32,
                offset: Offset(0, 8),
              ),
            ],
            border: Border.all(
              color: Colors.deepPurple.shade100,
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTitleBar(),
              const SizedBox(height: 18),
              _buildSelectedTextBar(),
              const SizedBox(height: 18),
              _buildSymbolButtons(),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: _buildActionButtons(),
              ),
              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 34, horizontal: 0),
      decoration: const BoxDecoration(
        color: Color(0xFF6C3EC1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Text(
        'Select Transition Symbols',
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 27,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Widget _buildSelectedTextBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.deepPurple[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.deepPurple[100]!),
      ),
      child: Text(
        selectedSymbols.isEmpty
            ? 'No symbols selected'
            : selectedSymbols.join(', '),
        style: GoogleFonts.poppins(
          fontSize: 20,
          color: selectedSymbols.isEmpty
              ? Colors.deepPurple.shade300
              : Colors.deepPurple.shade800,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildSymbolButtons() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 13,
      runSpacing: 13,
      children: widget.alphabet.split('').map((letter) {
        final isSelected = selectedSymbols.contains(letter);
        final isUsed = widget.usedSymbols.contains(letter);
        return SizedBox(
          width: 46,
          height: 46,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor:
                  isSelected ? Colors.white : Colors.deepPurple[800],
              backgroundColor: isSelected
                  ? Colors.deepPurple[600]
                  : isUsed
                      ? Colors.grey[200]
                      : Colors.deepPurple[50],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: isSelected ? 4 : 0,
              side: BorderSide(
                color:
                    isSelected ? Colors.deepPurple : Colors.deepPurple.shade100,
                width: isSelected ? 2 : 1.2,
              ),
              padding: EdgeInsets.zero,
            ),
            onPressed: isUsed
                ? null
                : () {
                    setState(() {
                      if (isSelected) {
                        selectedSymbols.remove(letter);
                      } else {
                        selectedSymbols.add(letter);
                      }
                    });
                  },
            child: Text(
              letter,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple.shade700,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9),
            ),
            elevation: 0,
            fixedSize: const Size(120, 40),
          ),
          onPressed: selectedSymbols.isNotEmpty
              ? () => Navigator.of(context).pop(selectedSymbols)
              : null,
          child: Text(
            'Confirm',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.deepPurple.shade700,
            side: BorderSide(color: Colors.deepPurple.shade300),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9),
            ),
            elevation: 0,
            fixedSize: const Size(120, 40),
          ),
          onPressed: () => Navigator.of(context).pop(null),
          child: Text(
            'Cancel',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
