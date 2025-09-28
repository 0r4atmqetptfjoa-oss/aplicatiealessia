# Asset Pack Usage Guide

This asset pack contains all of the 2D resources used throughout the **Lumea Alesiei** application.  Assets are organised by category to simplify imports and reduce build size when tree‑shaking unused assets.

## Folder structure

```
Asset_Pack/
│
├── ui/           # Icons and UI elements used across the app
├── progress/     # Assets representing progression (crown, rewards)
├── backgrounds/  # Background images for day, sunset, night and winter scenes
├── games/        # Assets used in mini‑games
│   ├── memory/   # Memory card illustrations
│   ├── puzzle/   # Number tiles for the sliding puzzle
│   ├── simon/    # Colored buttons for the Simon game
│   ├── shapes/   # Colored and silhouette shapes for matching games
│   ├── letters/  # Alphabet cards for the letters game
│   └── numbers/  # Number cards for sorting games
├── ASSETS_MANIFEST.json  # Description of every asset and its purpose
└── USAGE.md      # This document
```

## Importing in React

When importing images in a React/Vite project you can reference the relative path from `src/assets`.  For example, to import the home icon:

```javascript
import homeIcon from '../assets/Asset_Pack/ui/home.png';

const HomeButton = () => (
  <img src={homeIcon} alt="Home" />
);
```

For background images in a Three.js scene you can load them with `TextureLoader`:

```javascript
import { TextureLoader } from 'three';

const texture = useMemo(() => new TextureLoader().load('/assets/Asset_Pack/backgrounds/day.png'), []);
```

## Notes

- All icons are provided at 1× resolution.  For high‑DPI devices you can scale them using CSS or supply your own high‑resolution versions.
- The backgrounds are provided as **PNG** files and can be converted to **WebP** during the build process for further optimisation.
- The manifest file (`ASSETS_MANIFEST.json`) contains descriptions for each asset to help developers understand where and how to use them.
- Feel free to extend the asset pack with additional images following the same structure.