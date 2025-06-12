import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/itinerary_generator.dart';
import 'itinerary_summary_page.dart';


class ItineraryFormPage extends StatefulWidget {
  const ItineraryFormPage({super.key});

  @override
  State<ItineraryFormPage> createState() => _ItineraryFormPageState();
}

class _ItineraryFormPageState extends State<ItineraryFormPage> {
  final _formKey = GlobalKey<FormState>();

  final destinationController = TextEditingController();
  final interestsController = TextEditingController();
  final travelDateController = TextEditingController();
  final returnDateController = TextEditingController();
  final durationController = TextEditingController();
  final costController = TextEditingController();

  String? selectedTransport;
  final List<String> transportOptions = ['Bus', 'Car', 'Flight', 'Bike', 'Other'];

  @override
  void dispose() {
    destinationController.dispose();
    interestsController.dispose();
    travelDateController.dispose();
    returnDateController.dispose();
    durationController.dispose();
    costController.dispose();
    super.dispose();
  }

  void submitForm() {
    if (_formKey.currentState!.validate() && selectedTransport != null) {
      final generatedPlan = generateManualPlan(
        destination: destinationController.text.trim(),
        duration: durationController.text.trim(),
        preferences: interestsController.text
            .split(',')
            .map((e) => e.trim().toLowerCase())
            .where((e) => e.isNotEmpty)
            .toList(),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ItinerarySummaryPage(
            destination: destinationController.text.trim(),
            travelDate: travelDateController.text.trim(),
            returnDate: returnDateController.text.trim(),
            duration: durationController.text.trim(),
            cost: costController.text.trim(),
            transport: selectedTransport!,
            preferences: interestsController.text
                .split(',')
                .map((e) => e.trim())
                .toList(),
            description: interestsController.text.trim(),
            aiResponse: generatedPlan,
          ),
        ),
      );
    }
  }

  Future<void> selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Widget buildTextField(String label, TextEditingController controller,
      {String? hint, bool isDate = false, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(
        onTap: isDate ? () => selectDate(context, controller) : null,
        child: AbsorbPointer(
          absorbing: isDate,
          child: TextFormField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              labelText: label,
              hintText: hint,
              border: const OutlineInputBorder(),
              suffixIcon: isDate ? const Icon(Icons.calendar_today) : null,
            ),
            validator: (value) =>
                value == null || value.trim().isEmpty ? 'Required field' : null,
          ),
        ),
      ),
    );
  }

  Widget buildTransportDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        value: selectedTransport,
        decoration: const InputDecoration(
          labelText: "Transport",
          border: OutlineInputBorder(),
        ),
        items: transportOptions.map((option) {
          return DropdownMenuItem(value: option, child: Text(option));
        }).toList(),
        onChanged: (value) => setState(() => selectedTransport = value),
        validator: (value) =>
            value == null || value.isEmpty ? 'Please select transport' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Itinerary Form'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              buildTextField("Destination", destinationController),
              buildTextField("Travel Interests", interestsController,
                  hint: "e.g., religious, sightseeing, food", maxLines: 3),
              buildTextField("Travel Date", travelDateController,
                  hint: "YYYY-MM-DD", isDate: true),
              buildTextField("Return Date", returnDateController,
                  hint: "YYYY-MM-DD", isDate: true),
              buildTextField("Duration", durationController,
                  hint: "e.g., 2 days or 6 hours"),
              buildTextField("Estimated Cost (NPR)", costController),
              buildTransportDropdown(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: submitForm,
                child: const Text("Generate Itinerary"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
