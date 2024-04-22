class PhotoSrcModel{
  String url;
  String photographer;
  String photographerUrl;
  int photographerId;
  SrcModel src;

  PhotoSrcModel({required this.url,required this.photographer,required this.photographerUrl,required this.photographerId,required this.src});

  factory PhotoSrcModel.fromMap(Map<String,dynamic>parsedJson) => PhotoSrcModel(
      url:parsedJson["url"],
      photographer: parsedJson["photographer"],
      photographerId: parsedJson["photographer_id"],
      photographerUrl: parsedJson["photographer_url"],
      src: SrcModel.fromMap(parsedJson["src"])
    );


  // Map<String, dynamic> toMap() {
  //   return {
  //     "url":url,
  //     "photographer":photographer,
  //     "photographer_url":photographerUrl,
  //     "photographer_id":photographerId,
  //     "src": src
  //   };
  // }
  Map<String, dynamic> toJson() => {
    "url" : url,
  "photographer": photographer,
  "photographer_url": photographerUrl,
  "photographer_id": photographerId,
  "Src":src.toJson(),
  };
}

class SrcModel{
  String large2x;
  String portrait;

  SrcModel({required this.portrait,required this.large2x});

  factory SrcModel.fromMap(Map<String,dynamic>srcJson)=> SrcModel(
        large2x:srcJson["large2x"],
        portrait: srcJson["portrait"],
    );


  // Map<String, dynamic> toMap() {
  //   return {
  //     "large2x":large2x,
  //     "portrait":portrait,
  //   };
  // }

  Map<String, dynamic> toJson() => {
    "large2x": large2x,
    "portrait": portrait,

  };
}