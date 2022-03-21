import 'package:softify/model/CustomerReviewResponse.dart';
import 'package:softify/model/PostHelpfulnessResponse.dart';
import 'package:softify/model/ProductReviewResponse.dart';
import 'package:softify/model/requestbody/FormValuesRequestBody.dart';
import 'package:softify/model/requestbody/PostReviewReqBody.dart';
import 'package:softify/networking/ApiBaseHelper.dart';
import 'package:softify/networking/Endpoints.dart';

class ReviewRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<ProductReviewResponse> fetchProductReviews(num productId) async {
    final response =
        await _helper.get('${Endpoints.productReviews}/$productId');
    return ProductReviewResponse.fromJson(response);
  }

  Future<ProductReviewResponse> postProductReview(
      num productId, PostReviewReqBody reqBody) async {
    final response =
        await _helper.post('${Endpoints.addProductReview}/$productId', reqBody);
    return ProductReviewResponse.fromJson(response);
  }

  Future<CustomerReviewResponse> fetchMyReviews(num pageNumber) async {
    final response =
        await _helper.get('${Endpoints.productReviews}?pageNumber=$pageNumber');
    return CustomerReviewResponse.fromJson(response);
  }

  Future<PostHelpfulnessResponse> postReviewHelpfulness(
      num reviewId, FormValuesRequestBody reqBody) async {
    final response = await _helper.post(
        '${Endpoints.addReviewHelpfulness}/$reviewId', reqBody);
    return PostHelpfulnessResponse.fromJson(response);
  }
}
