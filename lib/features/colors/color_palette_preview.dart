import 'package:flutter/material.dart';

/// Ekran podglądu nowej palety kolorów aplikacji
class ColorPalettePreview extends StatelessWidget {
  const ColorPalettePreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nowa Paleta Kolorów'),
        backgroundColor: const Color(0xFFFFA726),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection('Główne Kolory', [
              _ColorCard('Primary', Color(0xFFFFA726), Colors.white),
              _ColorCard('Primary Variant', Color(0xFFFB8C00), Colors.white),
              _ColorCard('Secondary', Color(0xFF29B6F6), Colors.white),
              _ColorCard('Secondary Variant', Color(0xFF0288D1), Colors.white),
            ]),
            
            _buildSection('Tło i Powierzchnie', [
              _ColorCard('Background', Color(0xFFFDFDFD), Color(0xFF212121)),
              _ColorCard('Surface', Color(0xFFFFFFFF), Color(0xFF212121)),
              _ColorCard('On Background', Color(0xFF212121), Colors.white),
              _ColorCard('On Surface', Color(0xFF757575), Colors.white),
            ]),
            
            _buildSection('Kolory Statusu', [
              _ColorCard('Success', Color(0xFF66BB6A), Colors.white),
              _ColorCard('Error', Color(0xFFE53935), Colors.white),
              _ColorCard('Warning', Color(0xFFFFB300), Colors.white),
              _ColorCard('Divider', Color(0xFFE0E0E0), Color(0xFF212121)),
            ]),
            
            _buildSection('Kolory do Wykresów', [
              _ColorCard('Chart 1', Color(0xFFFFA726), Colors.white),
              _ColorCard('Chart 2', Color(0xFF29B6F6), Colors.white),
              _ColorCard('Chart 3', Color(0xFF66BB6A), Colors.white),
              _ColorCard('Chart 4', Color(0xFFAB47BC), Colors.white),
              _ColorCard('Chart 5', Color(0xFFE53935), Colors.white),
              _ColorCard('Chart 6', Color(0xFFFFB300), Colors.white),
              _ColorCard('Chart 7', Color(0xFF9E9E9E), Colors.white),
            ]),
            
            const SizedBox(height: 20),
            _buildInteractiveDemo(),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF212121),
            ),
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: colors,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildInteractiveDemo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Przykład zastosowania',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF212121),
              ),
            ),
            const SizedBox(height: 16),
            
            // Przycisk Primary
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFA726),
                foregroundColor: Colors.white,
              ),
              child: const Text('Przycisk Primary'),
            ),
            
            const SizedBox(height: 8),
            
            // Przycisk Secondary
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF29B6F6),
                foregroundColor: Colors.white,
              ),
              child: const Text('Przycisk Secondary'),
            ),
            
            const SizedBox(height: 16),
            
            // Status indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatusIndicator('Sukces', Color(0xFF66BB6A), Icons.check_circle),
                _StatusIndicator('Błąd', Color(0xFFE53935), Icons.error),
                _StatusIndicator('Ostrzeżenie', Color(0xFFFFB300), Icons.warning),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorCard extends StatelessWidget {
  final String name;
  final Color color;
  final Color textColor;

  const _ColorCard(this.name, this.color, this.textColor);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 80,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            '#${color.value.toRadixString(16).substring(2).toUpperCase()}',
            style: TextStyle(
              color: textColor.withOpacity(0.8),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusIndicator extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;

  const _StatusIndicator(this.label, this.color, this.icon);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
