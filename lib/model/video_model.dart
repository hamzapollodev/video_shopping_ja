class VideoModel {
  int? id;
  String url;
  String? thumbnail;
  String? videoTitle;
  String? productName;
  String? productPermalink;
  String? stockStatus;
  int? likes;
  bool? liked;
  String? description;
  int? productId;
  int? storeId;
  String? image;
  List<dynamic>? attributes;
  Deal? deal;

  VideoModel({
    this.id,
    required this.url,
    this.thumbnail,
    this.videoTitle,
    this.productName,
    this.productPermalink,
    this.stockStatus,
    this.likes,
    this.liked,
    this.description,
    this.productId,
    this.storeId,
    this.image,
    this.attributes,
    this.deal,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) => VideoModel(
        id: json["id"],
        url: json["url"],
        thumbnail: json["thumbnail"],
        videoTitle: json["video_title"],
        productName: json["product_name"],
        productPermalink: json["product_permalink"],
        stockStatus: json["stock_status"],
        likes: json["likes"],
        liked: json["liked"],
        description: json["description"],
        productId: json["product_id"],
        storeId: json["store_id"],
        image: json["image"],
        attributes: json["attributes"] == null ? [] : List<dynamic>.from(json["attributes"]!.map((x) => x)),
        deal: json["deal"] == null ? null : Deal.fromJson(json["deal"]),
      );
}

class Deal {
  int? dealId;
  String? price;
  String? regularPrice;
  String? stockStatus;

  Deal({
    this.dealId,
    this.price,
    this.regularPrice,
    this.stockStatus,
  });

  factory Deal.fromJson(Map<String, dynamic> json) => Deal(
        dealId: json["deal_id"],
        price: json["price"],
        regularPrice: json["regular_price"],
        stockStatus: json["stock_status"],
      );
}
