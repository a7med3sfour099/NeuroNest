class QuestionCategories {
  // Mapping of question numbers to their respective categories
  static const Map<int, String> categoryMap = {
    // ===== Social Interaction =====
    3: 'social',
    8: 'social',
    10: 'social',
    11: 'social',
    14: 'social',
    15: 'social',
    18: 'social',
    
    // ===== Communication =====
    1: 'communication',
    6: 'communication',
    7: 'communication',
    9: 'communication',
    16: 'communication',
    17: 'communication',
    19: 'communication',
    
    // ===== Repetitive Behaviors =====
    2: 'repetitive',
    4: 'repetitive',
    5: 'repetitive',
    12: 'repetitive',
    13: 'repetitive',
    20: 'repetitive',
  };

  static String getCategory(int questionNumber) {
    return categoryMap[questionNumber] ?? 'other';
  }

  static String getTitle(String category, bool isAr) {
    switch (category) {
      case 'social':
        return isAr ? 'التفاعل الاجتماعي' : 'Social Interaction';
      case 'communication':
        return isAr ? 'التواصل' : 'Communication';
      case 'repetitive':
        return isAr ? 'السلوكيات المتكررة' : 'Repetitive Behaviors';
      default:
        return isAr ? 'أخرى' : 'Other';
    }
  }

  static String getImage(String category) {
    switch (category) {
      case 'social':
        return 'assets/ques/ques_image.png';
      case 'communication':
        return 'assets/ques/ques_image_2.png';
      case 'repetitive':
        return 'assets/ques/ques_image_3.png';
      default:
        return 'assets/ques/ques_image.png';
    }
  }

  static int getOrder(String category) {
    switch (category) {
      case 'social':
        return 0;
      case 'communication':
        return 1;
      case 'repetitive':
        return 2;
      default:
        return 999;
    }
  }
}