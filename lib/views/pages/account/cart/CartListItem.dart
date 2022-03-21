import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:softify/views/customWidget/CustomDropdown.dart';
import 'package:softify/views/customWidget/RoundButton.dart';
import 'package:softify/views/customWidget/cached_image.dart';
import 'package:softify/model/AvailableOption.dart';
import 'package:softify/model/ShoppingCartResponse.dart';
import 'package:softify/service/GlobalService.dart';
import 'package:softify/utils/Const.dart';
import 'package:softify/utils/styles.dart';
import 'package:softify/utils/utility.dart';
import 'package:softify/utils/extensions.dart';

class CartListItem extends StatelessWidget {
  CartListItem({this.item, this.onClick, this.editable});

  final CartItem item;
  final Function(Map<String, String>) onClick;
  final bool editable;

  @override
  Widget build(BuildContext context) {
    var sku = Column(
      children: [
        SizedBox(
          height: 3,
        ),
        Text(
          "${GlobalService().getString(Const.SKU)}: ${item.sku}",
          style: TextStyle(fontSize: 14.0),
        ),
      ],
    );

    var customAttributes = Column(
      children: [
        SizedBox(
          height: 3,
        ),
        Html(
          data: item.attributeInfo ?? '',
          style: htmlNoPaddingStyle(fontSize: 15),
          shrinkWrap: true,
        ),
      ],
    );

    String warnings = '';
    if (item.warnings?.isNotEmpty == true) {
      item.warnings.forEach((element) {
        warnings = (warnings + element + '\n');
      });
      warnings.trimRight();
    }

    var quantityButton = Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        // RoundButton(radius: 35, icon: icon, onClick: onClick)
        RoundButton(
          radius: 45,
          onClick: () => onClick({'action': 'minus'}),
          icon: Icon(
            Icons.remove,
            size: 18.0,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text('${item.quantity}'),
        ),
        RoundButton(
          radius: 45,
          onClick: () => onClick({'action': 'plus'}),
          icon: Icon(
            Icons.add,
            size: 18.0,
          ),
        ),
      ],
    );

    var allowedQuantityDropdown = CustomDropdown<AvailableOption>(
      onChanged: (value) {
        onClick({'action': 'setQuantity', 'quantity': value.value});
      },
      preSelectedItem: item.allowedQuantities?.safeFirstWhere(
        (element) => element.selected ?? false,
        orElse: () => item.allowedQuantities?.safeFirst(),
      ),
      items: item?.allowedQuantities
              ?.map<DropdownMenuItem<AvailableOption>>((e) =>
                  DropdownMenuItem<AvailableOption>(
                      value: e, child: Text(e.text)))
              ?.toList() ??
          List.empty(),
    );

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: CpImage(
                url: item.picture.imageUrl,
                width: 120,
                fit: BoxFit.fitWidth,
              ),
            ),
            SizedBox(width: 10),
            Flexible(
              child: Padding(
                padding: EdgeInsets.fromLTRB(5, 0, 3, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 9,
                          child: Text(
                            item.productName,
                            style: Styles.productNameTextStyle(context),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: (editable /*&& item.allowItemEditing*/)
                              ? InkWell(
                                  onTap: () => onClick({'action': 'remove'}),
                                  child: Icon(Icons.close_outlined),
                                )
                              : SizedBox.shrink(),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "${GlobalService().getString(Const.TOTAL)}: ${item.subTotal}\n" +
                          "${GlobalService().getString(Const.PRICE)}: ${item.unitPrice}",
                      style: Styles.productPriceTextStyle(context),
                    ),
                    if (item.sku?.isNotEmpty == true) sku,
                    if (item.attributeInfo?.isNotEmpty == true)
                      customAttributes,
                    SizedBox(
                      height: 3,
                    ),
                    if (editable && (item.allowedQuantities ?? []).isEmpty)
                      quantityButton,
                    if (editable && (item.allowedQuantities ?? []).isNotEmpty)
                      allowedQuantityDropdown,
                    if (warnings.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: Text(
                          warnings,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
