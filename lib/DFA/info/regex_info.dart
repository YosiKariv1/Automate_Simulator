import 'package:flutter/material.dart';

class RegexInfoPopup extends StatelessWidget {
  const RegexInfoPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Directionality(
        textDirection: TextDirection.rtl,
        child: Text('מהו ביטוי רגולרי?'),
      ),
      content: SingleChildScrollView(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: ListBody(
            children: <Widget>[
              const Text(
                'ביטוי רגולרי הוא תבנית לחיפוש טקסט. להלן כמה סימנים נפוצים:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildRegexExplanation(
                  '*', 'כוכבית מציינת אפס או יותר מופעים של התו הקודם.'),
              _buildRegexExplanation(
                  '+', 'פלוס מציין אחד או יותר מופעים של התו הקודם.'),
              _buildRegexExplanation('[abc]',
                  'סוגריים מרובעים מציינים כל אחד מהתווים שבתוך הסוגריים.'),
              _buildRegexExplanation('[a-z]', 'טווח של תווים בין a ל-z.'),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        Directionality(
          textDirection: TextDirection.rtl,
          child: TextButton(
            child: const Text('סגור'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRegexExplanation(String symbol, String explanation) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: <Widget>[
            Text(
              '$symbol:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Text(explanation),
            ),
          ],
        ),
      ),
    );
  }
}
