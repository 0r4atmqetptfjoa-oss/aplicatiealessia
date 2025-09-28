# Android Upgrade Kit — Lumea Alesiei

Acest pachet adaugă optimizări și integrare Android fără să schimbe ce ai deja.

## Ce conține
- `src/lib/glbLoader.js` — loader GLB cu KTX2 + DRACO (optimizat pentru mobil)
- `src/native/androidUi.js` — fullscreen + status bar + splash
- `src/native/backHandler.js` — buton Back cu ieșire din app pe Home
- `src/native/haptics.js` — Haptics pentru feedback tactil
- `src/hooks/useAudioUnlock.js` — deblochează audio la prima interacțiune
- `src/components/util/Loader.jsx` — loader % pentru modele mari
- `public/basis/` și `public/draco/` — foldere pentru transcodere (adaugi fișierele tale)

## Pași de integrare

### 1) Copiere fișiere
Copiază conținutul acestui kit peste proiectul tău fără a șterge nimic (păstrează structura).

### 2) Dependențe Capacitor
```bash
npm i @capacitor/core @capacitor/app @capacitor/haptics @capacitor/status-bar @capacitor/splash-screen
```

### 3) Integrare în App.jsx (exemplu minim)
```jsx
// importuri noi
import { useEffect } from 'react';
import { setupAndroidUi } from './native/androidUi';
import { registerBackHandler } from './native/backHandler';
import Loader from './components/util/Loader.jsx';

function App() {
  useEffect(() => { setupAndroidUi(); }, []);
  useEffect(() => {
    const cleanup = registerBackHandler({
      canCloseModal: () => false,   // leagă la starea ta reală (SettingsModal)
      closeModal: () => {},
      canGoBack: () => false,       // sau comparați cu router-ul/starea paginii
      goBack: () => {}
    });
    return cleanup;
  }, []);

  return (
    // Unde ai deja <Canvas> și <Suspense>, folosește fallback-ul loaderului:
    // <Suspense fallback={<Loader/>}> ... </Suspense>
    null
  );
}
```

### 4) Folosirea loaderului GLB optimizat
```jsx
import { useOptimizedGLB } from './lib/glbLoader';
function Castle() {
  const { scene } = useOptimizedGLB('/assets/models/castle.mobile.glb');
  return <primitive object={scene} position={[0,-1,-5]} />;
}
```

### 5) Transcodere
Copiază fișierele DRACO în `public/draco/` și fișierele KTX2 în `public/basis/` (sau folosește un pipeline care le copiază automat în build).

### 6) Android build
```bash
npm run build
npx cap copy
npx cap open android
# semnare și build release din Android Studio
```

### 7) Tips performanță
- `gl.setPixelRatio(Math.min(window.devicePixelRatio, 2));`
- dezactivează ploaia/particulele când FPS scade (folosește PerfGuard dacă îl ai)
- preferă KTX2 pentru texturi, Draco/Meshopt pentru geometrii
- menține numărul de draw calls mic (instancing unde se poate)
