# White Screen Diagnose & Fix Kit

Acest kit te ajută să elimini ecranul alb provocat de:
- referințe greșite în `index.html` (scripturi manuale precum /@react-refresh, /index.js),
- lipsa lui `main.jsx/tsx` sau calea greșită,
- 404 la manifest PWA (opțional).

## Pași

1) **Backup**: salvează `index.html` și `src/main.*` din proiectul tău.

2) Copiază din acest kit:
   - `index.html` în rădăcina proiectului;
   - `src/main.jsx` (dacă proiectul tău e JS) **sau** `src/main.tsx` (dacă e TS);
   - (opțional) `public/manifest.webmanifest` + `public/icon-*.png` dacă păstrezi PWA.

3) În `index.html`, ai exact **un singur** `<script type="module" src="/src/main.jsx">`.
   Dacă folosești TypeScript, schimbă în `/src/main.tsx`.

4) **NU** include manual scripturi precum:
   - `<script type="module" src="/@react-refresh">` sau importuri către `@react-refresh`,
   - `<script src="/index.js">` sau alte fișiere din `public/` care folosesc `require(...)`,
   - `pwa-entry-point-loaded` fără fișiere reale.
   Vite + pluginul React gestionează HMR automat.

5) Test „sanity” (opțional):
   - În `index.html`, schimbă temporar scriptul în:
     ```html
     <script type="module" src="/src/main_sanity.jsx"></script>
     ```
     Dacă vezi mesajul „✔️ React a pornit corect.”, problema e în `App.jsx`/rutele tale, nu în bootstrap.

6) Dependențe 3D (recomandare):
   - Conflictul din log privind `three` vs `@react-three/drei`: actualizează `three` la minim `0.159.0`:
     ```bash
     npm i three@^0.159.0
     ```
     (sau sincronizează `three`, `@react-three/fiber`, `@react-three/drei` pe ultimele versiuni compatibile).

7) Caută `require(` în surse (în afară de `node_modules`):
   - Dacă găsești fișiere proprii care folosesc `require`, convertește la ESM:
     ```js
     // înainte
     const mod = require('zustand');
     // după
     import { create } from 'zustand';
     ```

8) Rulează:
   ```bash
   npm install
   npm run dev
   ```

Dacă încă apare ecran alb:
- verifică consola pentru un *exact* „index.js:2 require is not defined” și găsește sursa click‑ind pe fișierul din tab‑ul „Sources”;
- trimite-mi 20–30 de rânduri din fișierul indicat și îți dau patch-ul exact.
