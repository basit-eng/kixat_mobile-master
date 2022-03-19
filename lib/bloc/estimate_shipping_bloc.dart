import 'dart:async';

import 'package:schoolapp/bloc/base_bloc.dart';
import 'package:schoolapp/model/AvailableOption.dart';
import 'package:schoolapp/model/EstimateShipping.dart';
import 'package:schoolapp/model/EstimateShippingResponse.dart';
import 'package:schoolapp/model/requestbody/EstimateShippingReqBody.dart';
import 'package:schoolapp/model/requestbody/FormValue.dart';
import 'package:schoolapp/networking/ApiResponse.dart';
import 'package:schoolapp/repository/BaseRepository.dart';
import 'package:schoolapp/utils/utility.dart';

class EstimateShippingBloc extends BaseBloc {
  BaseRepository _repository;
  StreamController _scStates, _scResult;
  String selectedMethod;

  StreamSink<ApiResponse<List<AvailableOption>>> get statesSink =>
      _scStates.sink;
  Stream<ApiResponse<List<AvailableOption>>> get statesStream =>
      _scStates.stream;

  StreamSink<ApiResponse<EstimateShippingData>> get resultSink =>
      _scResult.sink;
  Stream<ApiResponse<EstimateShippingData>> get resultStream =>
      _scResult.stream;

  EstimateShippingBloc(EstimateShipping estimateShipping) {
    selectedMethod = '';
    _repository = BaseRepository();
    _scStates = StreamController<ApiResponse<List<AvailableOption>>>();
    _scResult = StreamController<ApiResponse<EstimateShippingData>>();
    statesSink
        .add(ApiResponse.completed(estimateShipping?.availableStates ?? []));
  }

  fetchStates(AvailableOption country) async {
    int countryId = int.tryParse(country.value) ?? -1;

    if (countryId == -1) return;

    statesSink.add(ApiResponse.loading());
    var statesList = await fetchStatesList(countryId);
    statesSink.add(ApiResponse.completed(statesList));
  }

  estimateShippingForCart(EstimateShipping estimateShipping) async {
    EstimateShippingReqBody reqBody = EstimateShippingReqBody(
        data: estimateShipping
            .copyWith(availableCountries: [], availableStates: []),
        formValues: []);

    resultSink.add(ApiResponse.loading());

    try {
      var response = await _repository.estimateShipping(reqBody);
      resultSink.add(ApiResponse.completed(response.data));
    } catch (e) {
      resultSink.add(ApiResponse.error(e.toString()));
    }
  }

  void estimateShippingForProduct(
    EstimateShipping estimateShipping,
    List<FormValue> productFormValues,
  ) async {
    EstimateShippingReqBody reqBody = EstimateShippingReqBody(
        data: estimateShipping
            .copyWith(availableCountries: [], availableStates: []),
        formValues: productFormValues);

    resultSink.add(ApiResponse.loading());

    try {
      var response = await _repository.productEstimateShipping(reqBody);
      resultSink.add(ApiResponse.completed(response.data));
    } catch (e) {
      resultSink.add(ApiResponse.error(e.toString()));
    }
  }

  @override
  void dispose() {
    _scStates?.close();
    _scResult?.close();
  }
}
