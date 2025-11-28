package com.example.educationalapp.features.mainmenu

import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.layout.ContentScale
import coil.compose.AsyncImage
import com.example.educationalapp.R

@Composable
fun AnimatedBackground() {
    Box(modifier = Modifier.fillMaxSize()) {
        AsyncImage(
            model = R.drawable.background_meniu_principal,
            contentDescription = null,
            contentScale = ContentScale.Crop,
            modifier = Modifier.fillMaxSize()
        )
    }
}