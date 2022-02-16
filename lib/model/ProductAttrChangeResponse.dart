class ProductAttrChangeResponse {
  ProductAttrChangeResponse({
    this.data,
    this.message,
    this.errorList,
  });

  ProductAttrChangeData data;
  String message;
  List<String> errorList;

  factory ProductAttrChangeResponse.fromJson(Map<String, dynamic> json) => ProductAttrChangeResponse(
    data: json["Data"] == null ? null : ProductAttrChangeData.fromJson(json["Data"]),
    message: json["Message"] == null ? null : json["Message"],
    errorList: json["ErrorList"] == null ? null : List<String>.from(json["ErrorList"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "Data": data == null ? null : data.toJson(),
    "Message": message == null ? null : message,
    "ErrorList": errorList == null ? null : List<dynamic>.from(errorList.map((x) => x)),
  };
}

class ProductAttrChangeData {
  ProductAttrChangeData({
    this.gtin,
    this.mpn,
    this.sku,
    this.price,
    this.basePricePangv,
    this.stockAvailability,
    this.enabledAttributeMappingIds,
    this.disabledAttributeMappingIds,
    this.pictureFullSizeUrl,
    this.pictureDefaultSizeUrl,
    this.isFreeShipping,
  });

  String gtin;
  String mpn;
  String sku;
  String price;
  String basePricePangv;
  String stockAvailability;
  List<dynamic> enabledAttributeMappingIds;
  List<dynamic> disabledAttributeMappingIds;
  String pictureFullSizeUrl;
  String pictureDefaultSizeUrl;
  bool isFreeShipping;

  factory ProductAttrChangeData.fromJson(Map<String, dynamic> json) => ProductAttrChangeData(
    gtin: json["Gtin"] == null ? null : json["Gtin"],
    mpn: json["Mpn"] == null ? null : json["Mpn"],
    sku: json["Sku"] == null ? null : json["Sku"],
    price: json["Price"] == null ? null : json["Price"],
    basePricePangv: json["BasePricePangv"] == null ? null : json["BasePricePangv"],
    stockAvailability: json["StockAvailability"] == null ? null : json["StockAvailability"],
    enabledAttributeMappingIds: json["EnabledAttributeMappingIds"] == null ? null : List<dynamic>.from(json["EnabledAttributeMappingIds"].map((x) => x)),
    disabledAttributeMappingIds: json["DisabledAttributeMappingIds"] == null ? null : List<dynamic>.from(json["DisabledAttributeMappingIds"].map((x) => x)),
    pictureFullSizeUrl: json["PictureFullSizeUrl"] == null ? null : json["PictureFullSizeUrl"],
    pictureDefaultSizeUrl: json["PictureDefaultSizeUrl"] == null ? null : json["PictureDefaultSizeUrl"],
    isFreeShipping: json["IsFreeShipping"] == null ? null : json["IsFreeShipping"],
  );

  Map<String, dynamic> toJson() => {
    "Gtin": gtin == null ? null : gtin,
    "Mpn": mpn == null ? null : mpn,
    "Sku": sku == null ? null : sku,
    "Price": price == null ? null : price,
    "BasePricePangv": basePricePangv == null ? null : basePricePangv,
    "StockAvailability": stockAvailability == null ? null : stockAvailability,
    "EnabledAttributeMappingIds": enabledAttributeMappingIds == null ? null : List<dynamic>.from(enabledAttributeMappingIds.map((x) => x)),
    "DisabledAttributeMappingIds": disabledAttributeMappingIds == null ? null : List<dynamic>.from(disabledAttributeMappingIds.map((x) => x)),
    "PictureFullSizeUrl": pictureFullSizeUrl == null ? null : pictureFullSizeUrl,
    "PictureDefaultSizeUrl": pictureDefaultSizeUrl == null ? null : pictureDefaultSizeUrl,
    "IsFreeShipping": isFreeShipping == null ? null : isFreeShipping,
  };
}
