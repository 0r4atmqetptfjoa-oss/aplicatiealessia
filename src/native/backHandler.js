// src/native/backHandler.js
import { App } from '@capacitor/app';

/**
 * Registers Android back button handler.
 * Expects: { canCloseModal, closeModal, canGoBack, goBack }
 */
export function registerBackHandler({ canCloseModal, closeModal, canGoBack, goBack }) {
  const sub = App.addListener('backButton', () => {
    try {
      if (canCloseModal?.()) { closeModal?.(); return; }
      if (canGoBack?.()) { goBack?.(); return; }
      App.exitApp();
    } catch {
      App.exitApp();
    }
  });
  return () => { try { sub?.remove(); } catch {} };
}
