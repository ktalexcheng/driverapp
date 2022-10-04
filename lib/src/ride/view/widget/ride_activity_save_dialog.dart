import 'package:flutter/material.dart';

class RideActivitySaveNamePrompt extends StatelessWidget {
  const RideActivitySaveNamePrompt({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _textEditingController =
        TextEditingController();

    Widget confirmButton = TextButton(
      child: const Text("Confirm"),
      onPressed: () {
        if (_textEditingController.text == '') {
        } else {
          Navigator.pop(context, _textEditingController.text);
        }
      },
    );

    Widget discardButton = TextButton(
      child: const Text("Discard"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    return AlertDialog(
      title: const Text('Enter ride name:'),
      content: TextField(
        controller: _textEditingController,
        decoration: const InputDecoration(hintText: "Ride name"),
      ),
      actions: [
        confirmButton,
        discardButton,
      ],
    );
  }
}

class RideActivitySaveDialog extends StatelessWidget {
  const RideActivitySaveDialog({super.key});

  @override
  Widget build(BuildContext context) {
    Widget saveDataButton = TextButton(
      child: const Text("Save"),
      onPressed: () {
        // Button returns 'true' to RideActivityControls if saving ride
        Navigator.pop(context, true);
      },
    );

    Widget discardDataButton = TextButton(
      child: const Text("Discard"),
      onPressed: () {
        // Button returns 'false' to RideActivityControls if discarding ride
        Navigator.pop(context, false);
      },
    );

    return AlertDialog(
      title: const Text("Save data?"),
      content: const Text("Would you like to save data for this ride?"),
      actions: [
        saveDataButton,
        discardDataButton,
      ],
    );
  }
}
