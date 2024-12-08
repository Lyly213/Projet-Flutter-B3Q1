import 'package:flutter/material.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  Color _selectedColor = const Color.fromARGB(255, 255, 227, 125);
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
            onPressed: () {
              final habitName = _habitNameController.text;
              if(habitName.isNotEmpty && _selectedDate != null) {
                Navigator.pop(context, {
                  'name': habitName,
                  'color': _selectedColor,
                  'date': _selectedDate!,
                  'hours': _selectedHour ?? 'all day',
                  'frequency': _selectedFrequency ?? 'none',
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill all fields')),
                );
              }
            },
            child: const Text(
              'add',
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
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
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
              onChanged: (value) {},
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
              onChanged: (value) {},
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
    );
  }
}