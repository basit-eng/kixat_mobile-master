import 'package:flutter/material.dart';
import 'package:schoolapp/bloc/address_bloc.dart';
import 'package:schoolapp/views/customWidget/CustomAppBar.dart';
import 'package:schoolapp/views/customWidget/CustomButton.dart';
import 'package:schoolapp/views/customWidget/NoDataText.dart';
import 'package:schoolapp/views/customWidget/error.dart';
import 'package:schoolapp/views/customWidget/loading.dart';
import 'package:schoolapp/views/customWidget/loading_dialog.dart';
import 'package:schoolapp/model/AddressListResponse.dart';
import 'package:schoolapp/networking/ApiResponse.dart';
import 'package:schoolapp/views/pages/account/address/add_edit_address_screen.dart';
import 'package:schoolapp/views/pages/account/address/address_list_item.dart';
import 'package:schoolapp/service/GlobalService.dart';
import 'package:schoolapp/utils/AppConstants.dart';
import 'package:schoolapp/utils/ButtonShape.dart';
import 'package:schoolapp/utils/Const.dart';
import 'package:schoolapp/utils/utility.dart';

class AddressListScreen extends StatefulWidget {
  static const routeName = '/address-list';
  const AddressListScreen({Key key}) : super(key: key);

  @override
  _AddressListScreenState createState() => _AddressListScreenState();
}

class _AddressListScreenState extends State<AddressListScreen> {
  GlobalService _globalService = GlobalService();
  AddressBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = AddressBloc();
    _bloc.fetchAddressList();

    _bloc.deleteAddressStream.listen((event) {
      if (event.status == Status.LOADING) {
        DialogBuilder(context).showLoader();
      } else if (event.status == Status.COMPLETED) {
        DialogBuilder(context).hideLoader();

        if (event.data) {
          showSnackBar(
              context, _globalService.getString(Const.COMMON_DONE), false);
        }
      } else {
        DialogBuilder(context).hideLoader();
        if (event.message?.isNotEmpty == true)
          showSnackBar(context, event.message, true);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _bloc?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(_globalService.getString(Const.ACCOUNT_CUSTOMER_ADDRESS)),
      ),
      body: StreamBuilder<ApiResponse<AddressListResponse>>(
        stream: _bloc.addressListStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
                return Loading(loadingMessage: snapshot.data.message);
                break;
              case Status.COMPLETED:
                return rootWidget(snapshot.data.data.data);
                break;
              case Status.ERROR:
                return Error(
                  errorMessage: snapshot.data.message,
                  onRetryPressed: () => _bloc.fetchAddressList(),
                );
                break;
            }
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  Widget rootWidget(AddressListData data) {
    var btnNewAddress = CustomButton(
      label: _globalService.getString(Const.ADD_NEW_ADDRESS).toUpperCase(),
      onClick: () => Navigator.of(context)
          .pushNamed(
        AddOrEditAddressScreen.routeName,
        arguments: AddOrEditAddressScreenArgs(isEditMode: false, addressId: -1),
      )
          .then((value) {
        if (value.toString() == AppConstants.keyRefreshContent) {
          _bloc.fetchAddressList();
        }
      }),
      shape: ButtonShape.RoundedTop,
    );

    return Stack(
      children: [
        // use AnimatedList
        ListView.builder(
          itemCount: (data.addresses?.length ?? 0) + 1,
          itemBuilder: (context, index) {
            if (index < data.addresses?.length ?? 0) {
              return ItemAddressList(
                address: data.addresses[index],
                onEditClicked: (address) {
                  Navigator.of(context)
                      .pushNamed(
                    AddOrEditAddressScreen.routeName,
                    arguments: AddOrEditAddressScreenArgs(
                        isEditMode: true, addressId: address.id),
                  )
                      .then((value) {
                    if (value.toString() == AppConstants.keyRefreshContent) {
                      _bloc.fetchAddressList();
                    }
                  });
                },
                onDeleteClicked: (address) {
                  showDialog(
                      context: context,
                      builder: (_) => getDeleteConfirmationDialog(address.id));
                },
              );
            } else {
              return SizedBox(height: 60);
            }
          },
        ),

        if ((data?.addresses?.isEmpty ?? true) == true)
          NoDataText(_globalService.getString(Const.COMMON_NO_DATA)),

        Align(
          alignment: Alignment.bottomCenter,
          child: btnNewAddress,
        )
      ],
    );
  }

  AlertDialog getDeleteConfirmationDialog(num addressId) {
    return AlertDialog(
      title: Text(_globalService.getString(Const.DELETE_ADDRESS)),
      content: Text(_globalService.getString(Const.CONFIRM_DELETE_ADDRESS)),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(_globalService.getString(Const.COMMON_NO))),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
              _bloc.deleteAddress(addressId);
            },
            child: Text(_globalService.getString(Const.COMMON_YES))),
      ],
    );
  }
}
