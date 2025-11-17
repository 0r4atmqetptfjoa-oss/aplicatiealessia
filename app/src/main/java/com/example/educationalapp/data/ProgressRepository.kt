package com.example.educationalapp.data

import android.content.Context
import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.booleanPreferencesKey
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.intPreferencesKey
import androidx.datastore.preferences.preferencesDataStore
import dagger.hilt.android.qualifiers.ApplicationContext
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map
import javax.inject.Inject
import javax.inject.Singleton

private val Context.dataStore: DataStore<Preferences> by preferencesDataStore(name = "settings")

data class UserPreferences(
    val stars: Int,
    val soundEnabled: Boolean,
    val musicEnabled: Boolean,
    val hardModeEnabled: Boolean,
    val darkTheme: Boolean
)

@Singleton
class ProgressRepository @Inject constructor(@ApplicationContext private val context: Context) {

    private object PreferenceKeys {
        val STARS = intPreferencesKey("stars")
        val SOUND_ENABLED = booleanPreferencesKey("sound_enabled")
        val MUSIC_ENABLED = booleanPreferencesKey("music_enabled")
        val HARD_MODE_ENABLED = booleanPreferencesKey("hard_mode_enabled")
        val DARK_THEME = booleanPreferencesKey("dark_theme")
    }

    val userPreferencesFlow: Flow<UserPreferences> = context.dataStore.data
        .map { preferences ->
            val stars = preferences[PreferenceKeys.STARS] ?: 0
            val soundEnabled = preferences[PreferenceKeys.SOUND_ENABLED] ?: true
            val musicEnabled = preferences[PreferenceKeys.MUSIC_ENABLED] ?: true
            val hardModeEnabled = preferences[PreferenceKeys.HARD_MODE_ENABLED] ?: false
            val darkTheme = preferences[PreferenceKeys.DARK_THEME] ?: false
            UserPreferences(stars, soundEnabled, musicEnabled, hardModeEnabled, darkTheme)
        }

    suspend fun updateStars(newStars: Int) {
        context.dataStore.edit {
            it[PreferenceKeys.STARS] = newStars
        }
    }

    suspend fun updateSoundEnabled(enabled: Boolean) {
        context.dataStore.edit {
            it[PreferenceKeys.SOUND_ENABLED] = enabled
        }
    }

    suspend fun updateMusicEnabled(enabled: Boolean) {
        context.dataStore.edit {
            it[PreferenceKeys.MUSIC_ENABLED] = enabled
        }
    }

    suspend fun updateHardMode(enabled: Boolean) {
        context.dataStore.edit {
            it[PreferenceKeys.HARD_MODE_ENABLED] = enabled
        }
    }

    suspend fun updateDarkTheme(enabled: Boolean) {
        context.dataStore.edit {
            it[PreferenceKeys.DARK_THEME] = enabled
        }
    }
}
