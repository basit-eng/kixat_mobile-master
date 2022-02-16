import 'package:kixat/model/AllVendorsResponse.dart';
import 'package:kixat/model/ContactVendorResponse.dart';
import 'package:kixat/networking/ApiBaseHelper.dart';
import 'package:kixat/networking/Endpoints.dart';

class VendorRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<AllVendorsResponse> fetchVendorList() async {
    final response = await _helper.get(Endpoints.allVendors);
    return AllVendorsResponse.fromJson(response);
  }

  Future<ContactVendorResponse> fetchFormData(num vendorId) async {
    final response = await _helper.get('${Endpoints.contactVendor}/$vendorId');
    return ContactVendorResponse.fromJson(response);
  }

  Future<ContactVendorResponse> postEnquiry(ContactVendorResponse reqBody) async {
    final response = await _helper.post(Endpoints.contactVendor, reqBody);
    return ContactVendorResponse.fromJson(response);
  }
}