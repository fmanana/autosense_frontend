import 'package:flutter/material.dart';

// A custom textfield that can be used throughout the app
class MyTextField extends StatefulWidget {
  final String hint;
  final IconData? icon;
  final ValueChanged<String> onChanged;
  final RegExp? validator;
  final String? initialValue;
  final bool enabled;

  const MyTextField({
    Key? key,
    required this.hint,
    this.icon,
    required this.onChanged,
    this.validator,
    this.initialValue,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            widget.hint,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.grey[200]!,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: Colors.grey[700]!,
              width: 1,
            ),
          ),
          child: TextFormField(
            onChanged: widget.onChanged,
            initialValue: widget.initialValue,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (text) {
              if (text == null || text.isEmpty) {
                return '${widget.hint} is required';
              } else if (widget.validator != null &&
                  !widget.validator!.hasMatch(text)) {
                return '${widget.hint} is invalid';
              }

              return null;
            },
            autocorrect: true,
            enabled: widget.enabled,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.grey.withOpacity(0.7)),
              hintText: widget.hint,
              icon: widget.icon != null
                  ? Icon(
                      widget.icon,
                      color: Theme.of(context).primaryColor,
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
