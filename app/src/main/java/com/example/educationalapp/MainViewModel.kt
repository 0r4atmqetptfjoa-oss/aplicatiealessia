package com.example.educationalapp

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.educationalapp.data.ProgressRepository
import com.example.educationalapp.data.UserPreferences
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class MainViewModel @Inject constructor(
    private val progressRepository: ProgressRepository
) : ViewModel() {

    val uiState: StateFlow<UserPreferences> = progressRepository.userPreferencesFlow
        .stateIn(
            scope = viewModelScope,
            started = SharingStarted.WhileSubscribed(5_000),
            initialValue = UserPreferences(0, true, true, false, false) // Initial default values
        )

    fun updateStars(newStars: Int) {
        viewModelScope.launch {
            progressRepository.updateStars(newStars)
        }
    }

    fun updateSoundEnabled(enabled: Boolean) {
        viewModelScope.launch {
            progressRepository.updateSoundEnabled(enabled)
        }
    }

    fun updateMusicEnabled(enabled: Boolean) {
        viewModelScope.launch {
            progressRepository.updateMusicEnabled(enabled)
        }
    }

    fun updateHardMode(enabled: Boolean) {
        viewModelScope.launch {
            progressRepository.updateHardMode(enabled)
        }
    }

    fun updateDarkTheme(enabled: Boolean) {
        viewModelScope.launch {
            progressRepository.updateDarkTheme(enabled)
        }
    }
}
