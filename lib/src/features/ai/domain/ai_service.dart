/// AI service for design assistance (Pro only)
/// Fair use: 10 requests per day per device
abstract class AiDesignService {
  /// Generate design suggestions based on event type
  Future<List<DesignSuggestion>> suggestDesigns({
    required String eventType,
    required String colorScheme,
    int maxSuggestions = 3,
  });
  
  /// Generate color combinations
  Future<List<ColorCombination>> suggestColors({
    required String eventType,
    required String primaryColor,
  });
  
  /// Get remaining AI requests for today
  Future<int> getRemainingRequests(String deviceId);
  
  /// Check if AI is available for user
  Future<bool> isAiAvailable(String deviceId);
}

/// Design suggestion from AI
class DesignSuggestion {
  final String name;
  final String description;
  final List<String> elements;
  final Map<String, dynamic> specifications;
  
  const DesignSuggestion({
    required this.name,
    required this.description,
    required this.elements,
    required this.specifications,
  });
}

/// Color combination suggestion
class ColorCombination {
  final String name;
  final List<String> colors;
  final String description;
  
  const ColorCombination({
    required this.name,
    required this.colors,
    required this.description,
  });
}

/// AI usage tracker
class AiUsageTracker {
  final String deviceId;
  final DateTime date;
  int requestCount;
  
  AiUsageTracker({
    required this.deviceId,
    required this.date,
    this.requestCount = 0,
  });
  
  bool canMakeRequest({int maxPerDay = 10}) {
    return requestCount < maxPerDay;
  }
  
  void incrementUsage() {
    requestCount++;
  }
}
