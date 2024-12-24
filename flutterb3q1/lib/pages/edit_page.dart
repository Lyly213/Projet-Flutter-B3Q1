import 'package:flutter/material.dart';

// EditPage widget = edit or delete an existing habit card.
// Edit habit details + delete habit
// Updated details are returned to the previous screen when the user confirms changes.
class EditPage extends StatefulWidget {
  final String id;
  final String name;
  final Color color;
  final DateTime date;
  final String hours;
  final String frequency;

  const EditPage({
    super.key,
    required this.id,
    required this.name,
    required this.color,
    required this.date,
    required this.hours,
    required this.frequency,
  });

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late TextEditingController _habitNameController;
  late Color _selectedColor;
  late DateTime _selectedDate;
  late String _selectedHours;
  late String _selectedFrequency;

  @override
  void initState() {
    super.initState();
    _habitNameController = TextEditingController(text: widget.name);
    _selectedColor = widget.color;
    _selectedDate = widget.date;
    _selectedHours = widget.hours;
    _selectedFrequency = widget.frequency;
  }

  void _selectColor(Color color) {
    setState(() {
      _selectedColor = color;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
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

  void _handleFrequencyChange() {
    List<Map<String, dynamic>> newCards = [];

    if (_selectedFrequency == 'weekly') {
      for (int i = 1; i <= 3; i++) {
        final newDate = _selectedDate.add(Duration(days: i * 7));
        newCards.add({
          'name': _habitNameController.text,
          'color': _selectedColor,
          'date': newDate.toIso8601String(),
          'hours': _selectedHours,
          'frequency': _selectedFrequency,
        });
      }
    }

    Navigator.pop(context, {
      'action': 'update',
      'id': widget.id,
      'name': _habitNameController.text,
      'originalName': widget.name,
      'color': _selectedColor,
      'date': _selectedDate,
      'hours': _selectedHours,
      'frequency': _selectedFrequency,
      'originalFrequency': widget.frequency,
      'new_cards': newCards,
    });
  }

  void _deleteCard() {
    Navigator.pop(context, {
      'id': widget.id,
      'action': 'delete',
      'originalName': widget.name,
      'originalFrequency': widget.frequency,
    });
  }

  @override
  void dispose() {
    _habitNameController.dispose();
    super.dispose();
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
            onPressed: _handleFrequencyChange,
            child: const Text(
              'Update',
              style: TextStyle(color: Color(0xFFFFFCE0), fontSize: 18),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          color: const Color(0xFFFFFCE0),
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
                  text: "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
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
                value: _selectedHours,
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
                    _selectedHours = value!;
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
                value: _selectedFrequency,
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
                    _selectedFrequency = value!;
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
      floatingActionButton: FloatingActionButton(
        onPressed: _deleteCard,
        backgroundColor: const Color.fromARGB(255, 248, 107, 97),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
    );
  }
}