import 'package:flutter/material.dart';

class MultiSelectFormField extends FormField<List<dynamic>> {
  MultiSelectFormField({
    Key key,
    @required List<dynamic> initialValues,
    @required List<dynamic> options,
    @required Widget Function(dynamic) titleBuilder,
    @required Widget Function(dynamic) chipLabelBuilder,
    hint,
    this.decoration = const InputDecoration(),
    this.onChanged,
    FormFieldSetter onSaved,
    FormFieldValidator<List> validator,
  }) : assert(options != null ||
              options.isEmpty ||
              initialValues == null ||
              initialValues.every((value) =>
                  options.where((option) {return option == value;
                  }).length ==
                  1)),
        assert(decoration != null),
        super(
          key: key,
          onSaved: onSaved,
          initialValue: initialValues,
          validator: validator,
          builder: (FormFieldState<List> field) {
            final InputDecoration effectiveDecoration =
                decoration.applyDefaults(
                  Theme.of(field.context).inputDecorationTheme,
                );
            return InputDecorator(
              decoration:
                effectiveDecoration.copyWith(errorText: field.errorText),
              isEmpty: field.value.isEmpty,
              child: MultiSelectionField(
                values: field.value,
                options: options,
                titleBuilder: titleBuilder,
                chipLabelBuilder: chipLabelBuilder,
                hint: field.value.isNotEmpty ? hint : null,
                onChanged: field.didChange
              ),
            );
          },
      );
  final ValueChanged<List> onChanged;
  final InputDecoration decoration;
  @override
  _MultiSelectFormFieldState createState() =>
      _MultiSelectFormFieldState();
}

class _MultiSelectFormFieldState extends FormFieldState<List> {
  @override
  MultiSelectFormField get widget => super.widget;
  @override
  void didChange(List values) {
    super.didChange(values);
    if (widget.onChanged != null) {
      widget.onChanged(values);
    }
  }
}

class MultiSelectionField extends StatelessWidget {
  MultiSelectionField({
    Key key,
    this.values,
    @required this.options,
    this.titleBuilder,
    @required this.chipLabelBuilder,
    this.hint,
    @required this.onChanged,
  }) : assert(options == null ||
              options.isEmpty ||
              values == null ||
              values.every((value) =>
                options.where((option) {
                  return option == value;
                }).length ==
                1)),
      assert(chipLabelBuilder != null),
      assert(onChanged != null),
      super(key: key);
  final ValueChanged<List> onChanged;
  final List<dynamic> values;
  final List<dynamic> options;
  final Widget hint;
  final Widget Function(dynamic) titleBuilder;
  final Widget Function(dynamic) chipLabelBuilder;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonHideUnderline(
          child: DropdownButton<dynamic>(
            value: null,
            items: options
              .map<DropdownMenuItem>(
                (dynamic option) => DropdownMenuItem(
                  value: option,
                  child: MyCheckBoxListTile(
                    selected: values.contains(option),
                    title: titleBuilder(option),
                    onChanged: (_) {
                      if (!values.contains(option)) {
                        values.add(option);
                      } else {
                        values.remove(option);
                      }
                      onChanged(values);
                    },
                  ),
                ),
            ).toList(),
            selectedItemBuilder: (BuildContext context) {
              return options.map<Widget>((dynamic option) {
                return Text('');
              }).toList();
            },
            hint: hint, onChanged: onChanged == null ? null : (dynamic value) {},
          ),
        ),
        SizedBox(height: 8.0),
        Row(
          children: [
            Expanded(
              child: ChipList(
                values: values,
                chipBuilder: (dynamic value) {
                  return Chip(
                    label: chipLabelBuilder(value),
                    onDeleted: () {
                      values.remove(value);
                      onChanged(values);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class MyCheckBoxListTile extends StatefulWidget {
  MyCheckBoxListTile({
    Key key,
    @required this.title,
    @required this.onChanged,
    @required this.selected,
  }) : assert(title != null),
      assert(onChanged != null),
      assert(selected != null),
      super(key: key);
  final Widget title;
  final dynamic onChanged;
  final bool selected;
  @override
  _MyCheckboxListTileState createState() => _MyCheckboxListTileState();
}

class _MyCheckboxListTileState extends State<MyCheckBoxListTile> {
  _MyCheckboxListTileState();
  bool _checked;
  @override
  void initState() {
    _checked = widget.selected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: _checked,
      selected: _checked,
      title: widget.title,
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (checked) {
        widget.onChanged(checked);
        setState(() {
          _checked = checked;
        });
      },
    );
  }
}

class ChipList extends StatelessWidget {
  const ChipList({
    @required this.values,
    @required this.chipBuilder,
  });
  final List<dynamic> values;
  final Chip Function(dynamic) chipBuilder;
  List _buildChipList() {
    final List items = [];
    for(dynamic value in values) {
      items.add(chipBuilder(value));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChipList(),
    );
  }
 }