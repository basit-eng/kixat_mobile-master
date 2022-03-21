import 'package:flutter/material.dart';
import 'package:softify/bloc/estimate_shipping_bloc.dart';
import 'package:softify/model/AvailableOption.dart';
import 'package:softify/model/EstimateShipping.dart';
import 'package:softify/model/EstimateShippingResponse.dart';
import 'package:softify/model/requestbody/FormValue.dart';
import 'package:softify/networking/ApiResponse.dart';
import 'package:softify/service/GlobalService.dart';
import 'package:softify/utils/Const.dart';
import 'package:softify/utils/ValidationMixin.dart';
import 'package:softify/utils/extensions.dart';
import 'package:softify/utils/utility.dart';
import 'package:softify/views/customWidget/CustomAppBar.dart';
import 'package:softify/views/customWidget/CustomDropdown.dart';

class EstimateShippingDialog extends StatefulWidget {
  final EstimateShipping estimateShipping;
  final List<FormValue> formValues;
  final bool estimationForProduct;

  const EstimateShippingDialog(
    this.estimateShipping,
    this.estimationForProduct, {
    this.formValues,
    Key key,
  }) : super(key: key);

  @override
  _EstimateShippingDialogState createState() =>
      _EstimateShippingDialogState(this.estimateShipping);
}

class _EstimateShippingDialogState extends State<EstimateShippingDialog>
    with ValidationMixin {
  EstimateShippingBloc _bloc;
  GlobalService _globalService = GlobalService();
  final EstimateShipping estimateShipping;
  final _formKey = GlobalKey<FormState>();

  _EstimateShippingDialogState(this.estimateShipping);

  @override
  void initState() {
    super.initState();
    _bloc = EstimateShippingBloc(estimateShipping);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leading: InkWell(
          child: Icon(Icons.close),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        title:
            Text('${_globalService.getString(Const.ESTIMATE_SHIPPING_TITLE)}'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 12, 10, 12),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Country Dropdown
                CustomDropdown<AvailableOption>(
                  onChanged: (country) {
                    estimateShipping.countryId =
                        int.tryParse(country.value) ?? -1;
                    _bloc.fetchStates(country);
                  },
                  onSaved: (newValue) {
                    estimateShipping.countryId =
                        int.tryParse(newValue.value) ?? -1;
                  },
                  validator: (value) {
                    if (value == null || value.value == '0')
                      return _globalService.getString(Const.COUNTRY_REQUIRED);
                    return null;
                  },
                  preSelectedItem:
                      estimateShipping.availableCountries.safeFirstWhere(
                    (element) => element.selected ?? false,
                    orElse: () =>
                        estimateShipping.availableCountries?.safeFirst(),
                  ),
                  items: estimateShipping.availableCountries
                          ?.map<DropdownMenuItem<AvailableOption>>((e) =>
                              DropdownMenuItem<AvailableOption>(
                                  value: e, child: Text(e.text)))
                          ?.toList() ??
                      List.empty(),
                ),

                // States Dropdown
                StreamBuilder<ApiResponse<List<AvailableOption>>>(
                    stream: _bloc.statesStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData &&
                          snapshot.data.status == Status.COMPLETED) {
                        var statesList = snapshot.data?.data ?? [];
                        return CustomDropdown<AvailableOption>(
                          onChanged: (value) {
                            estimateShipping.stateProvinceId =
                                int.tryParse(value.value) ?? -1;
                          },
                          onSaved: (newValue) {
                            estimateShipping.stateProvinceId =
                                int.tryParse(newValue.value) ?? -1;
                          },
                          validator: (value) {
                            if (value == null || value.value == '-1')
                              return _globalService
                                  .getString(Const.STATE_REQUIRED);
                            return null;
                          },
                          preSelectedItem: statesList.safeFirstWhere(
                            (element) => element.selected ?? false,
                            orElse: () => statesList.safeFirst(),
                          ),
                          items: statesList
                                  ?.map<DropdownMenuItem<AvailableOption>>(
                                      (e) => DropdownMenuItem<AvailableOption>(
                                          value: e, child: Text(e.text)))
                                  ?.toList() ??
                              List.empty(),
                        );
                      } else {
                        return CircularProgressIndicator(
                          strokeWidth: 3,
                        );
                      }
                    }),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: TextFormField(
                    keyboardType: TextInputType.streetAddress,
                    autofocus: false,
                    initialValue: estimateShipping.useCity
                        ? estimateShipping.city ?? ''
                        : estimateShipping.zipPostalCode ?? '',
                    textInputAction: TextInputAction.next,
                    decoration: inputDecor(
                        estimateShipping.useCity
                            ? _globalService.getString(Const.CITY)
                            : _globalService
                                .getString(Const.ESTIMATE_SHIPPING_ZIP),
                        false),
                    onSaved: (newValue) {
                      if (estimateShipping.useCity) {
                        estimateShipping.city = newValue;
                      } else {
                        estimateShipping.zipPostalCode = newValue;
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return _globalService.getString(estimateShipping.useCity
                            ? Const.CITY
                            : Const.ZIP_REQUIRED);
                      }
                      return null;
                    },
                  ),
                ),

                SizedBox(height: 5),

                OutlinedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();

                      if (widget.estimationForProduct) {
                        _bloc.estimateShippingForProduct(
                          estimateShipping,
                          widget.formValues,
                        );
                      } else {
                        _bloc.estimateShippingForCart(estimateShipping);
                      }
                    }
                    removeFocusFromInputField(context);
                    // Navigator.of(context).pop();
                  },
                  child: Text(
                      _globalService.getString(Const.ESTIMATE_SHIPPING_APPLY)),
                ),

                SizedBox(height: 5),

                StreamBuilder<ApiResponse<EstimateShippingData>>(
                    stream: _bloc.resultStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data.status == Status.COMPLETED) {
                          var options =
                              snapshot.data.data.shippingOptions ?? [];

                          if (options.isEmpty)
                            return Text(_globalService
                                .getString(Const.ESTIMATE_SHIPPING_NO_OPTION));
                          else {
                            return ListView.builder(
                                primary: false,
                                shrinkWrap: true,
                                itemCount: options?.length ?? 0,
                                itemBuilder: (context, index) {
                                  return CheckboxListTile(
                                    title: Text(
                                        '${options[index].name} (${options[index].price})'),
                                    subtitle: Text(options[index].description),
                                    value: _bloc.selectedMethod ==
                                        options[index].name,
                                    onChanged: (bool value) {
                                      setState(() {
                                        _bloc.selectedMethod =
                                            options[index].name;
                                      });
                                    },
                                  );
                                });
                          }
                        } else if (snapshot.data.status == Status.LOADING) {
                          return CircularProgressIndicator();
                        } else {
                          // error
                          return Text(snapshot.data.message);
                        }
                      } else {
                        return SizedBox.shrink();
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
