class VideoApiResponse {
  final bool? isLive;
  final VideoData? video;
  final String? updatedAt;

  VideoApiResponse({this.isLive, this.video, this.updatedAt});

  factory VideoApiResponse.fromJson(Map<String, dynamic> json) {
    return VideoApiResponse(
      isLive: json['isLive'],
      video: json['video'] != null ? VideoData.fromJson(json['video']) : null,
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() => {
    'isLive': isLive,
    'video': video?.toJson(),
    'updatedAt': updatedAt,
  };
}

class VideoData {
  final String? kind;
  final String? etag;
  final String? nextPageToken;
  final List<VideoItem>? items;
  final PageInfo? pageInfo;

  VideoData({
    this.kind,
    this.etag,
    this.nextPageToken,
    this.items,
    this.pageInfo,
  });

  factory VideoData.fromJson(Map<String, dynamic> json) {
    return VideoData(
      kind: json['kind'],
      etag: json['etag'],
      nextPageToken: json['nextPageToken'],
      items: (json['items'] as List?)
          ?.map((e) => VideoItem.fromJson(e))
          .toList(),
      pageInfo: json['pageInfo'] != null
          ? PageInfo.fromJson(json['pageInfo'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'kind': kind,
    'etag': etag,
    'nextPageToken': nextPageToken,
    'items': items?.map((e) => e.toJson()).toList(),
    'pageInfo': pageInfo?.toJson(),
  };
}

class VideoItem {
  final String? kind;
  final String? etag;
  final VideoId? id;
  final Snippet? snippet;

  VideoItem({this.kind, this.etag, this.id, this.snippet});

  factory VideoItem.fromJson(Map<String, dynamic> json) {
    return VideoItem(
      kind: json['kind'],
      etag: json['etag'],
      id: json['id'] != null ? VideoId.fromJson(json['id']) : null,
      snippet: json['snippet'] != null
          ? Snippet.fromJson(json['snippet'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'kind': kind,
    'etag': etag,
    'id': id?.toJson(),
    'snippet': snippet?.toJson(),
  };
}

class VideoId {
  final String? videoId;

  VideoId({this.videoId});

  factory VideoId.fromJson(Map<String, dynamic> json) {
    return VideoId(videoId: json['videoId']);
  }

  Map<String, dynamic> toJson() => {'videoId': videoId};
}

class Snippet {
  final String? publishedAt;
  final String? channelId;
  final String? title;
  final String? description;
  final Thumbnails? thumbnails;
  final String? channelTitle;
  final String? playlistId;
  final int? position;
  final ResourceId? resourceId;
  final String? videoOwnerChannelTitle;
  final String? videoOwnerChannelId;

  Snippet({
    this.publishedAt,
    this.channelId,
    this.title,
    this.description,
    this.thumbnails,
    this.channelTitle,
    this.playlistId,
    this.position,
    this.resourceId,
    this.videoOwnerChannelTitle,
    this.videoOwnerChannelId,
  });

  factory Snippet.fromJson(Map<String, dynamic> json) {
    return Snippet(
      publishedAt: json['publishedAt'],
      channelId: json['channelId'],
      title: json['title'],
      description: json['description'],
      thumbnails: json['thumbnails'] != null
          ? Thumbnails.fromJson(json['thumbnails'])
          : null,
      channelTitle: json['channelTitle'],
      playlistId: json['playlistId'],
      position: json['position'],
      resourceId: json['resourceId'] != null
          ? ResourceId.fromJson(json['resourceId'])
          : null,
      videoOwnerChannelTitle: json['videoOwnerChannelTitle'],
      videoOwnerChannelId: json['videoOwnerChannelId'],
    );
  }

  Map<String, dynamic> toJson() => {
    'publishedAt': publishedAt,
    'channelId': channelId,
    'title': title,
    'description': description,
    'thumbnails': thumbnails?.toJson(),
    'channelTitle': channelTitle,
    'playlistId': playlistId,
    'position': position,
    'resourceId': resourceId?.toJson(),
    'videoOwnerChannelTitle': videoOwnerChannelTitle,
    'videoOwnerChannelId': videoOwnerChannelId,
  };
}

class Thumbnails {
  final ThumbnailItem? defaultThumb;
  final ThumbnailItem? medium;
  final ThumbnailItem? high;
  final ThumbnailItem? standard;
  final ThumbnailItem? maxres;

  Thumbnails({
    this.defaultThumb,
    this.medium,
    this.high,
    this.standard,
    this.maxres,
  });

  factory Thumbnails.fromJson(Map<String, dynamic> json) {
    return Thumbnails(
      defaultThumb: json['default'] != null
          ? ThumbnailItem.fromJson(json['default'])
          : null,
      medium: json['medium'] != null
          ? ThumbnailItem.fromJson(json['medium'])
          : null,
      high: json['high'] != null ? ThumbnailItem.fromJson(json['high']) : null,
      standard: json['standard'] != null
          ? ThumbnailItem.fromJson(json['standard'])
          : null,
      maxres: json['maxres'] != null
          ? ThumbnailItem.fromJson(json['maxres'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'default': defaultThumb?.toJson(),
    'medium': medium?.toJson(),
    'high': high?.toJson(),
    'standard': standard?.toJson(),
    'maxres': maxres?.toJson(),
  };
}

class ThumbnailItem {
  final String? url;
  final int? width;
  final int? height;

  ThumbnailItem({this.url, this.width, this.height});

  factory ThumbnailItem.fromJson(Map<String, dynamic> json) {
    return ThumbnailItem(
      url: json['url'],
      width: json['width'],
      height: json['height'],
    );
  }

  Map<String, dynamic> toJson() => {
    'url': url,
    'width': width,
    'height': height,
  };
}

class ResourceId {
  final String? kind;
  final String? videoId;

  ResourceId({this.kind, this.videoId});

  factory ResourceId.fromJson(Map<String, dynamic> json) {
    return ResourceId(kind: json['kind'], videoId: json['videoId']);
  }

  Map<String, dynamic> toJson() => {'kind': kind, 'videoId': videoId};
}

class PageInfo {
  final int? totalResults;
  final int? resultsPerPage;

  PageInfo({this.totalResults, this.resultsPerPage});

  factory PageInfo.fromJson(Map<String, dynamic> json) {
    return PageInfo(
      totalResults: json['totalResults'],
      resultsPerPage: json['resultsPerPage'],
    );
  }

  Map<String, dynamic> toJson() => {
    'totalResults': totalResults,
    'resultsPerPage': resultsPerPage,
  };
}

//  recent video and news model class ------

class NewsResponse {
  final bool? success;
  final int? page;
  final int? limit;
  final int? total;
  final List<NewsItem>? items;

  NewsResponse({this.success, this.page, this.limit, this.total, this.items});

  factory NewsResponse.fromJson(Map<String, dynamic>? json) {
    return NewsResponse(
      success: json?['success'],
      page: json?['page'],
      limit: json?['limit'],
      total: json?['total'],
      items: (json?['items'] as List?)
          ?.map((e) => NewsItem.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'page': page,
    'limit': limit,
    'total': total,
    'items': items?.map((e) => e.toJson()).toList(),
  };
}

class NewsItem {
  final TitleModel? title;
  final SummaryModel? summary;
  final ContentModel? content;
  final FeaturedImage? featuredImage;
  final Meta? meta;
  final Location? location;
  final String? id;
  final Author? author;
  final String? category;
  final List<String>? tags;
  final String? language;
  final bool? isBreaking;
  final String? status;
  final String? youtubeVideoId;
  final String? publishAt;
  final int? views;
  final int? readingTimeMinutes;
  final List<dynamic>? images;
  final String? slug;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  NewsItem({
    this.title,
    this.summary,
    this.content,
    this.featuredImage,
    this.meta,
    this.location,
    this.id,
    this.author,
    this.category,
    this.tags,
    this.language,
    this.isBreaking,
    this.status,
    this.youtubeVideoId,
    this.publishAt,
    this.views,
    this.readingTimeMinutes,
    this.images,
    this.slug,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory NewsItem.fromJson(Map<String, dynamic>? json) {
    return NewsItem(
      title: TitleModel.fromJson(json?['title']),
      summary: SummaryModel.fromJson(json?['summary']),
      content: ContentModel.fromJson(json?['content']),
      featuredImage: FeaturedImage.fromJson(json?['featuredImage']),
      meta: Meta.fromJson(json?['meta']),
      location: Location.fromJson(json?['location']),
      id: json?['_id'],
      author: Author.fromJson(json?['author']),
      category: json?['category'],
      tags: (json?['tags'] as List?)?.map((e) => e.toString()).toList(),
      language: json?['language'],
      isBreaking: json?['isBreaking'],
      status: json?['status'],
      youtubeVideoId: json?['youtubeVideoId'],
      publishAt: json?['publishAt'],
      views: json?['views'],
      readingTimeMinutes: json?['readingTimeMinutes'],
      images: json?['images'],
      slug: json?['slug'],
      createdAt: json?['createdAt'],
      updatedAt: json?['updatedAt'],
      v: json?['__v'],
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title?.toJson(),
    'summary': summary?.toJson(),
    'content': content?.toJson(),
    'featuredImage': featuredImage?.toJson(),
    'meta': meta?.toJson(),
    'location': location?.toJson(),
    '_id': id,
    'author': author?.toJson(),
    'category': category,
    'tags': tags,
    'language': language,
    'isBreaking': isBreaking,
    'status': status,
    'youtubeVideoId': youtubeVideoId,
    'publishAt': publishAt,
    'views': views,
    'readingTimeMinutes': readingTimeMinutes,
    'images': images,
    'slug': slug,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    '__v': v,
  };
}

class TitleModel {
  final String? en;
  final String? hi;

  TitleModel({this.en, this.hi});

  factory TitleModel.fromJson(Map<String, dynamic>? json) =>
      TitleModel(en: json?['en'], hi: json?['hi']);

  Map<String, dynamic> toJson() => {'en': en, 'hi': hi};
}

class SummaryModel {
  final String? en;
  final String? hi;

  SummaryModel({this.en, this.hi});

  factory SummaryModel.fromJson(Map<String, dynamic>? json) =>
      SummaryModel(en: json?['en'], hi: json?['hi']);

  Map<String, dynamic> toJson() => {'en': en, 'hi': hi};
}

class ContentModel {
  final String? en;
  final String? hi;

  ContentModel({this.en, this.hi});

  factory ContentModel.fromJson(Map<String, dynamic>? json) =>
      ContentModel(en: json?['en'], hi: json?['hi']);

  Map<String, dynamic> toJson() => {'en': en, 'hi': hi};
}

class FeaturedImage {
  final String? url;
  final String? alt;

  FeaturedImage({this.url, this.alt});

  factory FeaturedImage.fromJson(Map<String, dynamic>? json) =>
      FeaturedImage(url: json?['url'], alt: json?['alt']);

  Map<String, dynamic> toJson() => {'url': url, 'alt': alt};
}

class Meta {
  final List<String>? keywords;

  Meta({this.keywords});

  factory Meta.fromJson(Map<String, dynamic>? json) => Meta(
    keywords: (json?['keywords'] as List?)?.map((e) => e.toString()).toList(),
  );

  Map<String, dynamic> toJson() => {'keywords': keywords};
}

class Location {
  final String? district;
  final String? country;
  final String? state;
  final String? city;

  Location({this.district, this.country, this.state, this.city});

  factory Location.fromJson(Map<String, dynamic>? json) => Location(
    district: json?['district'],
    country: json?['country'],
    state: json?['state'],
    city: json?['city'],
  );

  Map<String, dynamic> toJson() => {
    'district': district,
    'country': country,
    'state': state,
    'city': city,
  };
}

class Author {
  final String? name;
  final String? email;

  Author({this.name, this.email});

  factory Author.fromJson(Map<String, dynamic>? json) =>
      Author(name: json?['name'], email: json?['email']);

  Map<String, dynamic> toJson() => {'name': name, 'email': email};
}
