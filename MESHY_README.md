# Integrare Meshy – Lumea Alesiei

1) Pune modelul optimizat în `public/assets/models/alessia.mobile.glb`.
2) În `src/pages/MainMenu.jsx` importă:
   `import Alessia from '../components/characters/Alessia.jsx';`
3) În Canvas, înlocuiește placeholder-ul personajului cu:
   `<Alessia position={[0,-1,0]} scale={1.2} action="idle" toon />`
4) (Opțional) Accesează `CharacterViewer.jsx` pentru QA.
5) Recomandare optimizare: `gltf-transform metalrough/uastc/meshopt/draco`.

Acest kit include:
- `src/components/characters/Alessia.jsx`
- `src/pages/CharacterViewer.jsx`
- `public/assets/models/.gitkeep`
