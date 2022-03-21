import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:softify/model/CustomAttribute.dart';
import 'package:softify/model/requestbody/FormValue.dart';
import 'package:softify/service/GlobalService.dart';
import 'package:softify/utils/AttributeControlType.dart';
import 'package:softify/utils/Const.dart';
import 'package:softify/utils/ValidationMixin.dart';
import 'package:softify/utils/extensions.dart';
import 'package:softify/utils/utility.dart';
import 'package:softify/views/customWidget/cached_image.dart';

class CustomAttributeManager with ValidationMixin {
  Map<num, List<AttributeValue>> _attrMap;
  Map<num, String> _fileGuidMap =
      Map(); // map attribute ID to uploaded file's GUID
  Map<num, DateTime> _dateTimeMap = Map(); // map attribute ID to selected date

  final BuildContext context;
  final Function(bool) onClick;
  final Function(PlatformFile file, num attributeId) onFileSelected;

  static const KEY_TEXT_ATTRIBUTE = -1;
  static const KEY_FILE_ATTRIBUTE = -2;
  static const KEY_DATE_PICKER_ATTRIBUTE = -3;

  CustomAttributeManager({this.context, this.onClick, this.onFileSelected});

  Widget populateCustomAttributes(List<CustomAttribute> attributes) {
    if (attributes == null || attributes.isEmpty)
      return SizedBox(width: 0, height: 0);

    // populate preselected attributes
    if (_attrMap == null) {
      _attrMap = Map();
      attributes.forEach((attribute) {
        List<AttributeValue> selectedValue = [];
        attribute.values.forEach((element) {
          if (element.isPreSelected) selectedValue.add(element);
        });

        _attrMap[attribute.id] = selectedValue;
      });
    }

    List<Widget> listings = [];
    listings.add(Divider(color: Colors.grey[600]));

    attributes.forEach((attribute) {
      Widget attributeView;

      switch (attribute.attributeControlType) {
        case AttributeControlType.RadioList:
        case AttributeControlType.Checkboxes:
        case AttributeControlType.ReadonlyCheckboxes:
        case AttributeControlType.ColorSquares:
          String subtitle = '';
          _attrMap[attribute.id].forEach((element) {
            subtitle = subtitle + ', ' + element.name;
          });
          subtitle = subtitle.replaceFirst(', ', '');

          attributeView = ListTile(
              contentPadding: EdgeInsets.only(right: 5.0),
              title: Row(
                children: [
                  Text(attribute.name),
                  if (attribute.isRequired)
                    SizedBox(
                      width: 10,
                    ),
                  if (attribute.isRequired)
                    Icon(
                      Icons.star,
                      size: 13,
                      color: Colors.red,
                    ),
                ],
              ),
              subtitle: Container(
                  height: 48,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: attribute.values.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                            onTap: () {
                              if (_attrMap[attribute.id]
                                  .contains(attribute.values[index])) {
                                _attrMap[attribute.id]
                                    .remove(attribute.values[index]);
                              } else {
                                if (!isMultipleSelectionAllowed(
                                    attribute.attributeControlType))
                                  _attrMap[attribute.id].clear();

                                _attrMap[attribute.id]
                                    .add(attribute.values[index]);
                              }

                              var priceAdjNeeded = false;
                              attribute.values.forEach((element) {
                                if (element.priceAdjustment?.isNotEmpty ==
                                    true) {
                                  priceAdjNeeded = true;
                                }
                              });

                              onClick(priceAdjNeeded);
                            },
                            child: Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.fromLTRB(0, 08, 20, 0),
                                //color: parseColor(attribute.values[index].colorSquaresRgb),
                                decoration: BoxDecoration(
                                  border: _attrMap[attribute.id]
                                          .contains(attribute.values[index])
                                      ? Border.all(
                                          color: Colors.black,
                                          width: 1.5,
                                        )
                                      : Border.all(
                                          color: Colors.grey[300],
                                        ),
                                ),
                                padding: EdgeInsets.all(1.0),
                                child: ConstrainedBox(
                                  constraints: new BoxConstraints(
                                    minHeight: 39.0,
                                    minWidth: 39.0,
                                  ),
                                  child: Container(
                                      color: attribute.attributeControlType ==
                                              AttributeControlType.ColorSquares
                                          ? parseColor(attribute
                                              .values[index].colorSquaresRgb)
                                          : null,
                                      child: attribute.attributeControlType ==
                                              AttributeControlType.ColorSquares
                                          ? null
                                          : Center(
                                              child: Text(
                                                  attribute.values[index].name +
                                                      (attribute
                                                                  .values[index]
                                                                  .priceAdjustment
                                                                  ?.isNotEmpty ==
                                                              true
                                                          ? ' (${attribute.values[index].priceAdjustment})'
                                                          : ''),
                                                  style: TextStyle(),
                                                  textAlign:
                                                      TextAlign.center))),
                                )));
                      })),
              trailing: Icon(
                Icons.arrow_forward_ios_sharp,
                size: 15,
              ),
              onTap: () => {_settingModalBottomSheet(context, attribute)});
          break;

        case AttributeControlType.DropdownList:
        case AttributeControlType.ImageSquare:
          String subtitle = '';
          _attrMap[attribute.id].forEach((element) {
            subtitle = subtitle + ', ' + element.name;
          });
          subtitle = subtitle.replaceFirst(', ', '');

          attributeView = ListTile(
              contentPadding: EdgeInsets.only(right: 5.0),
              title: Row(
                children: [
                  Text(attribute.name),
                  if (attribute.isRequired)
                    SizedBox(
                      width: 10,
                    ),
                  if (attribute.isRequired)
                    Icon(
                      Icons.star,
                      size: 13,
                      color: Colors.red,
                    ),
                ],
              ),
              subtitle: (subtitle.isNotEmpty) ? Text(subtitle) : null,
              trailing: Icon(
                Icons.arrow_forward_ios_sharp,
                size: 15,
              ),
              onTap: () => {_settingModalBottomSheet(context, attribute)});
          break;

        case AttributeControlType.TextBox:
        case AttributeControlType.MultilineTextbox:
          // set initialValue to map
          if (attribute.defaultValue?.isNotEmpty == true) {
            _attrMap[attribute.id].add(
              AttributeValue(
                  id: KEY_TEXT_ATTRIBUTE, name: attribute.defaultValue),
            );
          }
          attributeView = TextFormField(
            initialValue: attribute.defaultValue ?? '',
            maxLines:
                attribute.attributeControlType == AttributeControlType.TextBox
                    ? 1
                    : 3,
            keyboardType: TextInputType.text,
            textInputAction:
                attribute.attributeControlType == AttributeControlType.TextBox
                    ? TextInputAction.done
                    : TextInputAction.newline,
            decoration: InputDecoration(labelText: attribute.name),
            onChanged: (value) {
              _attrMap[attribute.id].clear();
              _attrMap[attribute.id].add(
                AttributeValue(id: KEY_TEXT_ATTRIBUTE, name: value),
              );
            },
          );
          break;

        case AttributeControlType.Datepicker:
          // set initialValue to map
          if (attribute.selectedDay != null &&
              attribute.selectedMonth != null &&
              attribute.selectedYear != null) {
            _attrMap[attribute.id].add(
              AttributeValue(id: KEY_DATE_PICKER_ATTRIBUTE),
            );
            var date = DateTime(attribute.selectedYear, attribute.selectedMonth,
                attribute.selectedDay);
            _dateTimeMap[attribute.id] = date;
          }

          attributeView = TextFormField(
            key: UniqueKey(),
            keyboardType: TextInputType.text,
            autofocus: false,
            readOnly: true,
            initialValue: _dateTimeMap.containsKey(attribute.id)
                ? getFormattedDate(_dateTimeMap[attribute.id])
                : '',
            validator: (value) {
              return null;
            },
            onTap: () async {
              final DateTime pickedDate = await showDatePicker(
                context: context,
                initialDate: _dateTimeMap.containsKey(attribute.id)
                    ? _dateTimeMap[attribute.id]
                    : DateTime.now(),
                firstDate: DateTime(1950),
                lastDate: DateTime(2050),
              );

              if (pickedDate != null) {
                // To show selected date on TextField
                _attrMap[attribute.id].clear();
                _attrMap[attribute.id].add(
                  AttributeValue(id: KEY_DATE_PICKER_ATTRIBUTE),
                );
                _dateTimeMap[attribute.id] = pickedDate;
                onClick(false);
              }
            },
            textInputAction: TextInputAction.done,
            decoration: inputDecor(attribute.name, attribute.isRequired),
          );
          break;

        case AttributeControlType.FileUpload:
          String subtitle = _attrMap[attribute.id]?.safeFirst()?.name ?? '';

          attributeView = ListTile(
            contentPadding: EdgeInsets.only(right: 5.0),
            title: Row(
              children: [
                Text(attribute.name),
                if (attribute.isRequired)
                  SizedBox(
                    width: 10,
                  ),
                if (attribute.isRequired)
                  Icon(
                    Icons.star,
                    size: 13,
                    color: Colors.red,
                  ),
              ],
            ),
            subtitle: Text(subtitle),
            trailing: Icon(
              Icons.arrow_forward_ios_sharp,
              size: 15,
            ),
            onTap: () async {
              FilePickerResult result = await FilePicker.platform.pickFiles();

              if (result != null && onFileSelected != null) {
                PlatformFile file = result.files.single;

                // To show selected file as Subtitle
                _attrMap[attribute.id].clear();
                _attrMap[attribute.id].add(
                  AttributeValue(id: KEY_FILE_ATTRIBUTE, name: file.name),
                );
                onClick(false);

                onFileSelected(file, attribute.id);
              }
            },
          );
          break;
      }

      listings.add(attributeView);
    });

    return Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: listings),
    );
  }

  void _settingModalBottomSheet(context, CustomAttribute attribute) {
    List<Widget> listings = [];

    attribute.values.forEach((element) {
      Widget leading;
      if (attribute.attributeControlType == AttributeControlType.ColorSquares)
        leading = Container(
            width: 40, height: 40, color: parseColor(element.colorSquaresRgb));
      else if (attribute.attributeControlType ==
          AttributeControlType.ImageSquare)
        leading = CpImage(
            url: element.imageSquaresPictureModel.imageUrl,
            width: 50,
            height: 50);

      listings.add(ListTile(
        title: Text(
          element.name +
              (element.priceAdjustment?.isNotEmpty == true
                  ? ' (${element.priceAdjustment})'
                  : ''),
          style: TextStyle(),
        ),
        trailing: _attrMap[attribute.id].contains(element)
            ? Icon(
                Icons.check_sharp,
                size: 20,
              )
            : null,
        leading: leading,
        onTap: () {
          if (_attrMap[attribute.id].contains(element)) {
            _attrMap[attribute.id].remove(element);
          } else {
            if (!isMultipleSelectionAllowed(attribute.attributeControlType))
              _attrMap[attribute.id].clear();

            _attrMap[attribute.id].add(element);
          }

          var priceAdjNeeded = false;
          attribute.values.forEach((element) {
            if (element.priceAdjustment?.isNotEmpty == true) {
              priceAdjNeeded = true;
            }
          });
          Navigator.of(context).pop();

          onClick(priceAdjNeeded);
        },
        enabled: attribute.attributeControlType !=
            AttributeControlType.ReadonlyCheckboxes,
        selected: _attrMap[attribute.id].contains(element),
      ));
    });

    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(
              child: Wrap(
                children: listings,
              ),
            );
          });
        });
  }

  bool isMultipleSelectionAllowed(num attributeControlType) {
    switch (attributeControlType) {
      case AttributeControlType.DropdownList:
      case AttributeControlType.ImageSquare:
      case AttributeControlType.ColorSquares:
      case AttributeControlType.RadioList:
        return false;
    }
    return true;
  }

  List<FormValue> getSelectedAttributes(String attributePrefix) {
    List<FormValue> formValues = [];

    _attrMap?.forEach((mapKey, mapValue) {
      mapValue.forEach((element) {
        if (element.id == KEY_TEXT_ATTRIBUTE) {
          formValues.add(FormValue(
            key: '${attributePrefix}_${mapKey.toString()}',
            value: element.name,
          ));
        } else if (element.id == KEY_FILE_ATTRIBUTE) {
          var attributeValue =
              _fileGuidMap.containsKey(mapKey) ? _fileGuidMap[mapKey] : '';

          formValues.add(FormValue(
            key: '${attributePrefix}_${mapKey.toString()}',
            value: attributeValue,
          ));
        } else if (element.id == KEY_DATE_PICKER_ATTRIBUTE) {
          var date =
              _dateTimeMap.containsKey(mapKey) ? _dateTimeMap[mapKey] : null;

          if (date != null) {
            formValues.add(FormValue(
              key: '${attributePrefix}_${mapKey.toString()}_day',
              value: date.day.toString(),
            ));

            formValues.add(FormValue(
              key: '${attributePrefix}_${mapKey.toString()}_month',
              value: date.month.toString(),
            ));

            formValues.add(FormValue(
              key: '${attributePrefix}_${mapKey.toString()}_year',
              value: date.year.toString(),
            ));
          }
        } else {
          formValues.add(FormValue(
            key: '${attributePrefix}_${mapKey.toString()}',
            value: element.id.toString(),
          ));
        }
      });
    });

    return formValues;
  }

  String checkRequiredAttributes(List<CustomAttribute> attributes) {
    String errorMsg = '';
    attributes.forEach((attribute) {
      if (attribute.isRequired && _attrMap[attribute.id].isEmpty)
        errorMsg =
            '$errorMsg${attribute.name} ${GlobalService().getString(Const.IS_REQUIRED)}\n';
    });
    return errorMsg.trimRight();
  }

  void addUploadedFileGuid(num attributeId, String guid) {
    _fileGuidMap[attributeId] = guid;
  }
}
