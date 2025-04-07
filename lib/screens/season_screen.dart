import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SeasonScreen extends StatefulWidget {
  const SeasonScreen({super.key});

  @override
  State<SeasonScreen> createState() => _SeasonScreenState();
}

class _SeasonScreenState extends State<SeasonScreen> {
  final TextEditingController _seasonNameController = TextEditingController();
  DateTime startDate = DateTime.now();
  DateTime? endDate;
  bool manualEndDate = false;
  bool seasonActive = false;
  String? endedSeasonSummary;

  void _startNewSeason() {
    setState(() {
      seasonActive = true;
      endedSeasonSummary = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("New season started!")),
    );
  }

  void _endSeason() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("End Season"),
        content: const Text("Are you sure you want to end the current season?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("End"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        seasonActive = false;
        endDate = DateTime.now();
        endedSeasonSummary =
            "Season: ${_seasonNameController.text}\nStart: ${DateFormat.yMMMd().format(startDate)}\nEnd: ${DateFormat.yMMMd().format(endDate!)}";
        _seasonNameController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Season ended.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Season Control',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 34, 75, 35),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (!seasonActive) ...[
              const Text(
                'Start New Season',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _seasonNameController,
                decoration: const InputDecoration(
                  labelText: 'Season Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text("Start Date: "),
                  Text(DateFormat.yMMMd().format(startDate)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: manualEndDate,
                    onChanged: (val) {
                      setState(() => manualEndDate = val!);
                    },
                  ),
                  const Text("Set End Date Manually"),
                ],
              ),
              if (manualEndDate)
                ElevatedButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: startDate.add(const Duration(days: 30)),
                      firstDate: startDate,
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setState(() {
                        endDate = picked;
                      });
                    }
                  },
                  child: const Text("Pick End Date"),
                ),
              if (manualEndDate && endDate != null)
                Text("Selected End Date: ${DateFormat.yMMMd().format(endDate!)}"),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _seasonNameController.text.isNotEmpty
                    ? _startNewSeason
                    : null,
                child: const Text("Start Season"),
              ),
            ] else ...[
              const Text(
                'Current Season Active',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text("Season Name: ${_seasonNameController.text}"),
              Text("Start Date: ${DateFormat.yMMMd().format(startDate)}"),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _endSeason,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text("End Current Season"),
              ),
            ],
            const SizedBox(height: 24),
            if (endedSeasonSummary != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Season Summary:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(endedSeasonSummary!),
                ],
              )
          ],
        ),
      ),
    );
  }
}

