import 'package:flutter/material.dart';

class EditPage extends StatefulWidget {
  final String id; // L'ID du document dans Firestore
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

  void _updateCard() {
    Navigator.pop(context, {
      'action': 'update',
      'id': widget.id,
      'name': _habitNameController.text,
      'color': _selectedColor,
      'date': _selectedDate,
      'hours': _selectedHours,
      'frequency': _selectedFrequency,
    });
  }

  void _deleteCard() {
    Navigator.pop(context, {
      'id': widget.id,
      'action': 'delete',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: _updateCard,
            child: const Text(
              'update',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Name habit',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
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
                fillColor: Colors.green[50],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Days',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              readOnly: true,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today, color: Colors.green),
                  onPressed: () => _selectDate(context),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                fillColor: Colors.green[50],
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
                color: Colors.green,
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
                fillColor: Colors.green[50],
              ),
              items: const [
                DropdownMenuItem(value: 'all day', child: Text('all day')),
                DropdownMenuItem(value: 'morning', child: Text('morning')),
                DropdownMenuItem(value: 'afternoon', child: Text('afternoon')),
                DropdownMenuItem(value: 'evening', child: Text('evening')),
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
                color: Colors.green,
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
                fillColor: Colors.green[50],
              ),
              items: const [
                DropdownMenuItem(value: 'none', child: Text('none')),
                DropdownMenuItem(value: 'daily', child: Text('daily')),
                DropdownMenuItem(value: 'weekly', child: Text('weekly')),
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
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildColorCircle(const Color.fromARGB(255, 255, 166, 196)),
                _buildColorCircle(const Color.fromARGB(255, 255, 198, 141)),
                _buildColorCircle(const Color.fromARGB(255, 201, 165, 255)),
                _buildColorCircle(const Color.fromARGB(255, 162, 204, 255)),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _deleteCard,
        backgroundColor: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
    );
  }
}