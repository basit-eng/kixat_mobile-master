import 'package:softify/model/AddressFormResponse.dart';
import 'package:softify/model/AddressListResponse.dart';
import 'package:softify/model/BaseResponse.dart';
import 'package:softify/networking/ApiBaseHelper.dart';
import 'package:softify/networking/Endpoints.dart';
import 'package:softify/repository/BaseRepository.dart';
import 'package:softify/utils/AppConstants.dart';

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
