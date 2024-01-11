class InstagramConstant {


  static InstagramConstant? _instance;
  static InstagramConstant get instance {
    _instance ??= InstagramConstant._init();
    return _instance!;
  }

  InstagramConstant._init();

  static const String clientID = '986382338613256';
  static const String appSecret = '3ec6dfe01a1f95495dd40b898e4410cf';
  static const String redirectUri = 'https://cheerzclub.com/';
  static const String scope = 'user_profile,user_media';
  static const String responseType = 'code';
  final String url = 'https://api.instagram.com/oauth/authorize?client_id=$clientID&redirect_uri=$redirectUri&scope=user_profile,user_media&response_type=$responseType';
}
