import 'package:flutter/material.dart';

class TodoFormWidget extends StatelessWidget {
  final String title;
  final String description;
  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedDescription;
  final VoidCallback onSavedTodo;
  final Key? key;

  const TodoFormWidget({
    this.title = '',
    this.description = '',
    required this.onChangedTitle,
    required this.onChangedDescription,
    required this.onSavedTodo,
    this.key,
  });

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildTitle(),
        SizedBox(height: 8),
        buildDescription(),
        SizedBox(height: 32),
        buildButton(context),
      ],
    ),
  );

  Widget buildTitle() => TextFormField(
    maxLines: 1,
    initialValue: title,
    onChanged: onChangedTitle,
    validator: (title) {
      if (title!.isEmpty) {
        return 'The title cannot be empty';
      }
      return null;
    },
    decoration: InputDecoration(
      border: UnderlineInputBorder(),
      labelText: 'Title',
      labelStyle: TextStyle(
        fontSize: 16, // Adjust the font size as needed
        fontWeight: FontWeight.w400, // Adjust the font weight
        color: Colors.black, // Adjust the text color
      ),
    ),
  );

  Widget buildDescription() => TextFormField(
    maxLines: 3,
    initialValue: description,
    onChanged: onChangedDescription,
    decoration: InputDecoration(
      border: UnderlineInputBorder(),
      labelText: 'Description',
      labelStyle: TextStyle(
        fontSize: 16, // Adjust the font size as needed
        fontWeight: FontWeight.w400, // Adjust the font weight
        color: Colors.black, // Adjust the text color
      ),
    ),
  );

  Widget buildButton(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 30,
    child: ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.pink),
      ),
      onPressed: () {
        // Close the dialog here
        // Navigator.of(context).pop();

        // Call the onSavedTodo callback
        onSavedTodo();
      },
      child: Text('Save'),
    ),
  );
}