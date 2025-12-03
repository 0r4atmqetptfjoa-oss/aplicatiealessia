package com.example.educationalapp.alphabet

import androidx.annotation.DrawableRes
import com.example.educationalapp.R

/**
 * Data class representing a single item in the alphabet game,
 * including the letter, an associated word, image, and optional sound resources.
 */
data class AlphabetItem(
    val letter: Char,
    val word: String,
    @DrawableRes val imageRes: Int,
    val soundLetterRes: Int? = null, // Future use
    val soundWordRes: Int? = null    // Future use
)

/**
 * Provides access to all alphabet items and helper functions.
 */
object AlphabetAssets {

    // A complete list of alphabet items from A to Z.
    val items: List<AlphabetItem> = listOf(
        AlphabetItem('A', "Albină", R.drawable.alphabet_a_albina),
        AlphabetItem('B', "Balon", R.drawable.alphabet_b_balon),
        AlphabetItem('C', "Cal", R.drawable.alphabet_c_cal),
        AlphabetItem('D', "Dinozaur", R.drawable.alphabet_d_dinozaur),
        AlphabetItem('E', "Elefant", R.drawable.alphabet_e_elefant),
        AlphabetItem('F', "Floare", R.drawable.alphabet_f_floare),
        AlphabetItem('G', "Girafă", R.drawable.alphabet_g_girafa),
        AlphabetItem('H', "Hipopotam", R.drawable.alphabet_h_hipopotam),
        AlphabetItem('I', "Iepure", R.drawable.alphabet_i_iepure),
        AlphabetItem('J', "Jucărie", R.drawable.alphabet_j_jucarie),
        AlphabetItem('K', "Koala", R.drawable.alphabet_k_koala),
        AlphabetItem('L', "Leu", R.drawable.alphabet_l_leu),
        AlphabetItem('M', "Mașină", R.drawable.alphabet_m_masina),
        AlphabetItem('N', "Nor", R.drawable.alphabet_n_nor),
        AlphabetItem('O', "Oaie", R.drawable.alphabet_o_oaie),
        AlphabetItem('P', "Pisică", R.drawable.alphabet_p_pisica),
        AlphabetItem('Q', "Quokka", R.drawable.alphabet_q_quokka),
        AlphabetItem('R', "Rață", R.drawable.alphabet_r_rata),
        AlphabetItem('S', "Soare", R.drawable.alphabet_s_soare),
        AlphabetItem('T', "Țestoasă", R.drawable.alphabet_t_testoasa),
        AlphabetItem('U', "Urs", R.drawable.alphabet_u_urs),
        AlphabetItem('V', "Veveriță", R.drawable.alphabet_v_veverita),
        // AlphabetItem('W', "Wapiti", R.drawable.alphabet_w_wapiti), // Temporarily removed, missing drawable
        AlphabetItem('X', "Xilofon", R.drawable.alphabet_x_xilofon),
        AlphabetItem('Y', "Yoyo", R.drawable.alphabet_y_yoyo),
        AlphabetItem('Z', "Zebră", R.drawable.alphabet_z_zebra)
    )

    /**
     * Helper function to find an AlphabetItem by its letter.
     */
    fun byLetter(letter: Char): AlphabetItem =
        items.first { it.letter.equals(letter, ignoreCase = true) }
}

/**
 * A centralized holder for all UI-related drawable resource IDs for the Alphabet game.
 */
object AlphabetUi {
    object Backgrounds {
        @DrawableRes val sky = R.drawable.bg_alphabet_sky
        @DrawableRes val city = R.drawable.bg_alphabet_city
        @DrawableRes val foreground = R.drawable.bg_alphabet_foreground
        @DrawableRes val menu = R.drawable.bg_alphabet_main3
    }
    object Mascot {
        @DrawableRes val normal = R.drawable.alphabet_mascot_fox
        @DrawableRes val happy = R.drawable.alphabet_mascot_happy
        @DrawableRes val surprised = R.drawable.alphabet_mascot_surprised
        @DrawableRes val thinking = R.drawable.alphabet_mascot_thinking
    }
    object Icons {
        @DrawableRes val correct = R.drawable.icon_alphabet_correct
        @DrawableRes val wrong = R.drawable.icon_alphabet_wrong
        @DrawableRes val star = R.drawable.icon_alphabet_star
        @DrawableRes val starAlt = R.drawable.icon_alphabet_star_alternativ
        @DrawableRes val home = R.drawable.icon_alphabet_home
        @DrawableRes val replay = R.drawable.icon_alphabet_replay
        @DrawableRes val soundOn = R.drawable.icon_alphabet_sound_on
    }
    object Effects {
        @DrawableRes val confetti = R.drawable.fx_confetti_spritesheet
        @DrawableRes val glow = R.drawable.fx_glow_particles
    }
    object Cards {
        @DrawableRes val main = R.drawable.alphabet_letter_card_blank
    }
}
