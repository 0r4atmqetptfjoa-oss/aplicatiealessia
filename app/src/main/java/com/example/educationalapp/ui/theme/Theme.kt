package com.example.educationalapp.ui.theme

import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import com.example.educationalapp.ui.theme.PastelPink
import com.example.educationalapp.ui.theme.PastelBlue
import com.example.educationalapp.ui.theme.PastelYellow

private val DarkColorScheme = darkColorScheme(
    primary = PastelPink,
    secondary = PastelBlue,
    tertiary = PastelYellow
)

// Use a light pastel palette to create a soft, child‑friendly appearance.
private val LightColorScheme = lightColorScheme(
    primary = PastelPink,
    onPrimary = Color.Black,
    secondary = PastelBlue,
    onSecondary = Color.Black,
    tertiary = PastelYellow,
    onTertiary = Color.Black,
    background = Color(0xFFFFFBFE),
    onBackground = Color.Black,
    surface = Color.White,
    onSurface = Color.Black
)

@Composable
fun EducationalAppTheme(
    darkTheme: Boolean = false,
    content: @Composable () -> Unit
) {
    val colors = if (darkTheme) DarkColorScheme else LightColorScheme
    MaterialTheme(
        colorScheme = colors,
        typography = Typography,
        content = content
    )
}