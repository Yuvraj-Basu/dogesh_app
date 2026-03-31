import '../models/service_provider.dart';

abstract class ProviderRepository {
  /// Fetches a list of service providers from the data source
  Future<List<ServiceProvider>> getNearbyProviders();
}
