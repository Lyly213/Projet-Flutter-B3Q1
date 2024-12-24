import 'package:flutter/material.dart';

// AddPage widget = create a new habit (habit name, date, time, frequency and color).
// Once all required fields have been filled in, the habit details are returned to the previous screen in the form of a LIST of cards.
class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  Color _selectedColor = const Color(0xFFFFFCE0);
  DateTime? _selectedDate;
  String? _selectedHour;
  String? _selectedFrequency;
  final TextEditingController _habitNameController = TextEditingController();

  void _selectColor(Color color) {
    setState(() {
      _selectedColor = color;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  void dispose() {
    _habitNameController.dispose();
    super.dispose();
  }

  Widget _buildColorCircle(Color color) {
    return GestureDetector(
      onTap: () => _selectColor(color),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: Border.all(
            color: _selectedColor == color ? Colors.black : Colors.transparent,
            width: 2,
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _generateCardsForFrequency() {
    List<Map<String, dynamic>> cards = [];
    if (_selectedFrequency == 'daily') {
      for (int i = 0; i < 7; i++) {
        final newDate = _selectedDate!.add(Duration(days: i));
        cards.add({
          'name': _habitNameController.text,
          'color': _selectedColor,
          'date': newDate.toIso8601String(),
          'hours': _selectedHour ?? 'all day',
          'frequency': _selectedFrequency,
        });
      }
    } else if (_selectedFrequency == 'weekly') {
      for (int i = 0; i < 4; i++) {
        final newDate = _selectedDate!.add(Duration(days: i * 7));
        cards.add({
          'name': _habitNameController.text,
          'color': _selectedColor,
          'date': newDate.toIso8601String(),
          'hours': _selectedHour ?? 'all day',
          'frequency': _selectedFrequency,
        });
      }
    } else {
      cards.add({
        'name': _habitNameController.text,
        'color': _selectedColor,
        'date': _selectedDate!.toIso8601String(),
        'hours': _selectedHour ?? 'all day',
        'frequency': _selectedFrequency,
      });
    }
    return cards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 130, 176, 146),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              final habitName = _habitNameController.text;
              if (habitName.isNotEmpty && _selectedDate != null) {
                final cards = _generateCardsForFrequency();
                debugPrint("Cards to add: $cards");
                Navigator.pop(context, cards);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill all fields')),
                );
              }
            },
            child: const Text(
              'Add',
              style: TextStyle(color: Color(0xFFFFFCE0), fontSize: 18),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          color: Color(0xFFFFFCE0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Name habit',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 130, 176, 146),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _habitNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Days',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 130, 176, 146),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today, color: Color.fromARGB(255, 130, 176, 146)),
                    onPressed: () => _selectDate(context),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                controller: TextEditingController(
                  text: _selectedDate != null
                      ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"
                      : '',
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Hours',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 130, 176, 146),
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: const [
                  DropdownMenuItem(value: 'all day', child: Text('All Day')),
                  DropdownMenuItem(value: 'morning', child: Text('Morning')),
                  DropdownMenuItem(value: 'afternoon', child: Text('Afternoon')),
                  DropdownMenuItem(value: 'evening', child: Text('Evening')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedHour = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Frequency',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 130, 176, 146),
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: const [
                  DropdownMenuItem(value: 'none', child: Text('None')),
                  DropdownMenuItem(value: 'daily', child: Text('Daily')),
                  DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedFrequency = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Colors',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 130, 176, 146),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildColorCircle(const Color.fromARGB(255, 253, 196, 215)),
                  _buildColorCircle(const Color.fromARGB(255, 253, 221, 190)),
                  _buildColorCircle(const Color.fromARGB(255, 221, 202, 250)),
                  _buildColorCircle(const Color.fromARGB(255, 187, 214, 248)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}