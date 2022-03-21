import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:softify/bloc/vendor_bloc.dart';
import 'package:softify/views/customWidget/CustomAppBar.dart';
import 'package:softify/views/customWidget/cached_image.dart';
import 'package:softify/views/customWidget/error.dart';
import 'package:softify/views/customWidget/loading.dart';
import 'package:softify/model/AllVendorsResponse.dart';
import 'package:softify/networking/ApiResponse.dart';
import 'package:softify/views/pages/more/contact_vendor_screen.dart';
import 'package:softify/views/pages/product-list/product_list_screen.dart';
import 'package:softify/service/GlobalService.dart';
import 'package:softify/utils/Const.dart';
import 'package:softify/utils/GetBy.dart';
import 'package:softify/utils/styles.dart';
import 'package:softify/utils/utility.dart';

class VendorListScreen extends StatefulWidget {
  static const routeName = '/vendor-list';
  const VendorListScreen({Key key}) : super(key: key);

  @override
  _VendorListScreenState createState() => _VendorListScreenState();
}

class _VendorListScreenState extends State<VendorListScreen> {
  GlobalService _globalService = GlobalService();
  VendorBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = VendorBloc();

    _bloc.fetchAllVendors();
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
        title: Text(_globalService.getString(Const.PRODUCT_VENDOR)),
      ),
      body: StreamBuilder<ApiResponse<List<VendorDetails>>>(
        stream: _bloc.vendorListStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
                return Loading(loadingMessage: snapshot.data.message);
                break;
              case Status.COMPLETED:
                return rootWidget(snapshot.data?.data ?? []);
                break;
              case Status.ERROR:
                return Error(
                  errorMessage: snapshot.data.message,
                  onRetryPressed: () => _bloc.fetchAllVendors(),
                );
                break;
            }
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  Widget rootWidget(List<VendorDetails> data) {
    return ListView.builder(
      itemCount: data?.length ?? 0,
      itemBuilder: (context, index) {
        return vendorItem(data[index]);
      },
    );
  }

  Widget vendorItem(VendorDetails item) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () =>
            Navigator.of(context).pushNamed(ProductListScreen.routeName,
                arguments: ProductListScreenArguments(
                  id: item.id,
                  name: item.name,
                  type: GetBy.VENDOR,
                )),
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: CpImage(
                  url: item.pictureModel.imageUrl,
                  width: 120.0,
                  fit: BoxFit.fitWidth,
                ),
              ),
              SizedBox(width: 10),
              Flexible(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: 120.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.name ?? '',
                        style: Styles.productNameTextStyle(context),
                      ),
                      Html(
                        data: item.description ?? '',
                        shrinkWrap: true,
                        style: htmlNoPaddingStyle(fontSize: 15),
                      ),
                      //OutlinedButton(
                      //onPressed: () => Navigator.of(context).pushNamed(
                      // ContactVendorScreen.routeName,
                      // arguments: ContactVendorScreenArgs(item.id),
                      //),
                      //child: Text(_globalService.getString(Const.VENDOR_CONTACT_VENDOR)),
                      //),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
