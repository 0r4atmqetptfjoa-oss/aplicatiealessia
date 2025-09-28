const translations = {
  ro: require('./ro.json'),
};

let currentLang = 'ro';

/**
 * Set the active language.  Defaults to 'ro'.
 * @param {string} lang
 */
export function setLanguage(lang) {
  if (translations[lang]) {
    currentLang = lang;
  }
}

/**
 * Translate a key.  If the key is missing it returns the key itself.
 * @param {string} key
 */
export function t(key) {
  const dict = translations[currentLang] || {};
  return dict[key] || key;
}

/**
 * Get the current language code.
 */
export function getLanguage() {
  return currentLang;
}