import 'package:schoolapp/model/AddressFormResponse.dart';
import 'package:schoolapp/model/AddressListResponse.dart';
import 'package:schoolapp/model/BaseResponse.dart';
import 'package:schoolapp/networking/ApiBaseHelper.dart';
import 'package:schoolapp/networking/Endpoints.dart';
import 'package:schoolapp/repository/BaseRepository.dart';
import 'package:schoolapp/utils/AppConstants.dart';

class AddressRepository extends BaseRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<AddressListResponse> fetchCustomerAddresses() async {
    final response = await _helper.get(Endpoints.addressList);
    return AddressListResponse.fromJson(response);
  }

  Future<String> deleteAddressById(num addressId) async {
    final response = await _helper.post(
        '${Endpoints.deleteAddress}/$addressId', AppConstants.EMPTY_POST_BODY);
    return response.toString();
  }

  Future<AddressFormResponse> fetchNewAddressForm() async {
    final response = await _helper.get(Endpoints.addAddress);
    return AddressFormResponse.fromJson(response);
  }

  Future<BaseResponse> saveNewAddress(AddressFormResponse reqBody) async {
    final response = await _helper.post(Endpoints.addAddress, reqBody);
    return BaseResponse.fromJson(response);
  }

  Future<AddressFormResponse> fetchExistingAddress(num addressId) async {
    final response = await _helper.get('${Endpoints.editAddress}/$addressId');
    return AddressFormResponse.fromJson(response);
  }

  Future<BaseResponse> updateExistingAddress(
      num addressId, AddressFormResponse reqBody) async {
    final response =
        await _helper.post('${Endpoints.editAddress}/$addressId', reqBody);
    return BaseResponse.fromJson(response);
  }
}
