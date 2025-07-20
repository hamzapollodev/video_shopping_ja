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
  Map<String, dynamic>? deal;

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
        deal: json["deal"] == null ? null : Map<String, dynamic>.from(json["deal"]),
      );
}
