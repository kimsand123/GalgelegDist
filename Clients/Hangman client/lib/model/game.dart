class Game {
  List<dynamic> usedLetters;
  String numberOfWrongLetters;
  bool wasLastLetterCorrect;
  String word;
  String visibleWord;
  bool isGameWon;
  bool isGameLost;

  Game(
      {this.usedLetters,
      this.numberOfWrongLetters,
      this.wasLastLetterCorrect,
      this.word,
      this.visibleWord,
      this.isGameLost,
      this.isGameWon});

  String toString() =>
      '{\n' +
      'usedLetters: $usedLetters,\n' +
      'numberOfWrongLetters: $numberOfWrongLetters,\n' +
      'wasLastLetterCorrect: $wasLastLetterCorrect,\n' +
      'word: $word,\n' +
      'visibleWord: $visibleWord,\n' +
      'isGameWon: $isGameWon,\n' +
      'isGameLost: $isGameLost,\n' +
      '}';
}
