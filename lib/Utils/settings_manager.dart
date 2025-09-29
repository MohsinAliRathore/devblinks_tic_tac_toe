import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import '../bloc/game_state.dart';

class SettingsManager {
  static const String _difficultyKey = 'ai_difficulty';
  static const String _soundKey = 'sound_enabled';

  // Singleton instance
  static final SettingsManager _instance = SettingsManager._internal();

  factory SettingsManager() {
    return _instance;
  }

  SettingsManager._internal();

  // ValueNotifier for sound setting
  final ValueNotifier<bool> soundEnabled = ValueNotifier<bool>(true);

  // Initialize the sound setting from SharedPreferences
  Future<void> init() async {
    await _loadSoundSetting();
    await _loadDifficulty();
  }

  // Load difficulty from SharedPreferences
  Future<void> _loadDifficulty() async {
    Difficulty difficulty = await getDifficulty();
    _selectedDifficulty = difficulty;
  }

  // Load sound setting from SharedPreferences
  Future<void> _loadSoundSetting() async {
    final prefs = await SharedPreferences.getInstance();
    soundEnabled.value = prefs.getBool(_soundKey) ?? true;
  }

  // Get difficulty
  static Future<Difficulty> getDifficulty() async {
    final prefs = await SharedPreferences.getInstance();
    final difficultyString = prefs.getString(_difficultyKey);
    switch (difficultyString) {
      case 'medium':
        return Difficulty.medium;
      case 'hard':
        return Difficulty.hard;
      default:
        return Difficulty.easy;
    }
  }

  // Set difficulty
  static Future<void> setDifficulty(Difficulty difficulty) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_difficultyKey, difficulty.toString().split('.').last);
    _instance._selectedDifficulty = difficulty;
  }

  // Get sound enabled status
  bool getSoundEnabled() {
    return soundEnabled.value;
  }

  // Set sound enabled status
  Future<void> setSoundEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_soundKey, enabled);
    soundEnabled.value = enabled;
  }

  // Store selected difficulty
  Difficulty _selectedDifficulty = Difficulty.easy;

  // Get current difficulty
  Difficulty get selectedDifficulty => _selectedDifficulty;
}