# Vite Blank Screen Fix Kit

Acest pachet repară erorile:
- 404 la `main.tsx` / `main.jsx`
- 404 la `manifest.webmanifest`
- Uncaught SyntaxError: `/@react-refresh` nu are `injectIntoGlobalHook`
- 404 `pwa-entry-point-loaded`

## Ce trebuie să faci
1) **Backup** la fișierele tale curente `index.html` și `src/main.*`.
2) Copiază din acest kit:
   - `index.html` în rădăcina proiectului.
   - `src/main.jsx` (sau `src/main.tsx` dacă ești pe TypeScript; ajustează `<script src>`).
   - `public/manifest.webmanifest` și `public/icon-*.png` **doar** dacă vrei să păstrezi manifestul.
3) În `index.html`, ai implicit:
   ```html
   <script type="module" src="/src/main.jsx"></script>
   ```
   Dacă ai TypeScript, schimbă în:
   ```html
   <script type="module" src="/src/main.tsx"></script>
   ```
4) **Nu importa manual** `/@react-refresh` în `index.html`. Vite + pluginul React se ocupă.
5) Dacă folosești `vite-plugin-pwa`:
   - Verifică să ai fișierul `public/manifest.webmanifest` și icoanele.
   - Dacă vrei să dezactivezi temporar, comentează pluginul din `vite.config.*`.
6) `npm run dev` și verifică consola. Dacă mai apare o eroare, caută un import greșit sau o cale invalidă.

## Observații
- `index.html` trebuie să fie simplu. Elimină snippet-uri custom pentru HMR sau PWA dacă nu ai fișierele necesare.
- `main.jsx/.tsx` trebuie să facă doar `ReactDOM.createRoot(...).render(<App/>)`.
