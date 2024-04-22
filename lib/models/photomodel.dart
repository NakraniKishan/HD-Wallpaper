class PhotoModel{
  String? url;
  String? photographer;
  String? photographerUrl;
  int? photographerId;
  // SrcModel? src;

  PhotoModel({this.url,this.photographer,this.photographerUrl,this.photographerId});

  factory PhotoModel.fromMap(Map<String,dynamic>parsedJson){
    return PhotoModel(
      url:parsedJson["url"],
      photographer: parsedJson["photographer"],
      photographerId: parsedJson["photographer_id"],
      photographerUrl: parsedJson["photographer_url"],

    );
  }

  Map<String, dynamic> toMap() {
    return {
      "url":url,
      "photographer":photographer,
      "photographer_url":photographerUrl,
      "photographer_id":photographerId,
    };
    // final Map<String, dynamic> _data = <String, dynamic>{};
    // _data["name"] = name;
    // _data["number"] = number;
    // return _data;
  }

}

