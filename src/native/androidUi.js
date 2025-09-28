// src/native/androidUi.js
import { SplashScreen } from '@capacitor/splash-screen';
import { StatusBar, Style } from '@capacitor/status-bar';

/** Configure Android UI: fullscreen, dark status bar text, and hide splash. */
export async function setupAndroidUi() {
  try { await StatusBar.setStyle({ style: Style.Dark }); } catch {}
  try { await StatusBar.hide(); } catch {}
  try { await SplashScreen.hide({ fadeOutDuration: 300 }); } catch {}
}
