import '../config/env.dart';

class Url {
  static String get baseUrl {
    switch (ENV) {
      case 'development':
        return 'https://testsgmj.linkon.me/huantiyun';
      case 'local':
        return 'http://192.168.19.156:9987';
      case 'product':
        return 'https://sgmj.linkon.me';
      default:
        return 'https://testsgmj.linkon.me/huantiyun';
    }
  }
}