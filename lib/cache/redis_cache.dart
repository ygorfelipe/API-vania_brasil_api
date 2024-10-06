//* trabalhando diretamente com singleton, onde ele só tera uma unica instancia do redis
import 'package:shorebird_redis_client/shorebird_redis_client.dart';

class RedisCache {
  static RedisCache? _instance;

  //* chegando no redis de forma correta
  late final RedisClient _redisClient;

  //* initializando no disgner pater singleton
  RedisCache._() {
    //! AQUI SE FOR ANALISAR E A MSM CONEXAO COMO BANCO DE DADOS UTILIZANDO ODIO
    _redisClient = RedisClient(
      socket: RedisSocketOptions(
        host: 'localhost',
        port: 6379,
        password: 'root',
      ),
    );
  }
  static RedisCache get instance => _instance ??= RedisCache._();

  //* TTL - TIME TO LIVE (tempo de vida)
  Future<void> put(String key, String value, Duration ttl) async {
    //* o proprio redis abre e fecha a conexão de forma correta
    await _redisClient.connect();
    await _redisClient.set(key: key, value: value, ttl: ttl);
  }

  //* a String pode conter os dados do cache ou não, por isso que ele pode ser null
  Future<String?> get(String key) async {
    await _redisClient.connect();
    return await _redisClient.get(key: key);
  }
}
