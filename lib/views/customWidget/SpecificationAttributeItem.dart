import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:kixat/model/ProductDetailsResponse.dart';
import 'package:kixat/utils/extensions.dart';

class SpecificationAttributeItem extends StatelessWidget {
  final SpecificationAttr attribute;

  const SpecificationAttributeItem({Key key, @required this.attribute})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var titleStyle = Theme.of(context).textTheme.subtitle1.copyWith(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic,
    );

    return Row(
      children: [
        Expanded(
            flex: 3,
            child: Text(attribute.name ?? '', style: titleStyle),
        ),
        Expanded(
            flex: 7,
            child: Html(data: attribute.values?.safeFirst()?.valueRaw ?? ''),
        ),
      ],
    );
  }
}
