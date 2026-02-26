class ApiEndpoint {
  //  Base API URL (for all API requests)
  static const String baseUrl = "https://ap-news-b.onrender.com/api/";

  //  AUTHENTICATION ENDPOINTS

  static const String youtubelive = "youtube/live";
  static const String recentvideo = "youtube/recent-videos";
  static const String businessCategory = "articles/category/Business";
  static const String bhojpuriCategory = "articles/category/Bhojpuri";
  static const String technologyCategory = "articles/category/Technology";
  static const String sportsCategory = "articles/category/Sports";
  static const String electionCategory = "articles/category/Elections";
  static const String allArticlesPageOne = "articles/all?page=1";

  //  Helper — automatically combines base URL + endpoint
  static String getUrl(String endpoint) {
    return "$baseUrl$endpoint";
  }
}
