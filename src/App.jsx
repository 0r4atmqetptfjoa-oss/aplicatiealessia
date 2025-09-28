import React from 'react';
import AnimatedBackground from './components/scenes/AnimatedBackground.jsx';
import MagicButton from './components/ui/MagicButton.jsx';
import MainMenu from './pages/MainMenu.jsx';
import InstrumentsPage from './pages/InstrumentsPage.jsx';
import SoundsPage from './pages/SoundsPage.jsx';
import StoriesPage from './pages/StoriesPage.jsx';
import SongsPage from './pages/SongsPage.jsx';
import GamesPage from './pages/GamesPage.jsx';
import { useAppStore } from './store/appStore.js';

/*
 * Root application component.
 *
 * This file wires together the global animated Three.js backdrop, a simple
 * navigation bar, and conditional rendering of page content based on the
 * current page stored in Zustand.  Each page is represented by a stub
 * component for now; these will be fleshed out in later phases.  The
 * navigation updates the store via setCurrentPage, allowing the app to
 * respond reactively.  The AnimatedBackground component renders behind
 * everything else with a negative z-index, giving the impression of a
 * persistent, living world regardless of which page the user visits.
 */

// No SettingsPage here; settings are handled via a modal in MainMenu.

export default function App() {
  // Pull current page and setter from the global store.
  const currentPage = useAppStore((state) => state.currentPage);
  const setCurrentPage = useAppStore((state) => state.setCurrentPage);

  // Helper to render the appropriate page component.  As new pages are
  // implemented they should be imported and added here.
  const renderPage = () => {
    switch (currentPage) {
      case 'instruments':
        return <InstrumentsPage />;
      case 'sounds':
        return <SoundsPage />;
      case 'stories':
        return <StoriesPage />;
      case 'songs':
        return <SongsPage />;
      case 'games':
        return <GamesPage />;
      case 'mainMenu':
      default:
        return <MainMenu />;
    }
  };

  return (
    <>
      {/* Global animated starfield background. */}
      <AnimatedBackground />
      {/* Navigation bar pinned to the top of the viewport.  Buttons
          trigger updates to the current page in the global store. */}
      <nav className="nav-bar">
        {/* Each navigation item uses the MagicButton component for a playful animated effect. */}
        <MagicButton onClick={() => setCurrentPage('mainMenu')}>Acasă</MagicButton>
        <MagicButton onClick={() => setCurrentPage('instruments')}>Instrumente</MagicButton>
        <MagicButton onClick={() => setCurrentPage('sounds')}>Sunete</MagicButton>
        <MagicButton onClick={() => setCurrentPage('stories')}>Povești</MagicButton>
        <MagicButton onClick={() => setCurrentPage('songs')}>Cântece</MagicButton>
        <MagicButton onClick={() => setCurrentPage('games')}>Jocuri</MagicButton>
      </nav>
      {/* Container for page-specific content.  The z-index ensures it
          appears above the animated background. */}
      <div className="page-container">
        {renderPage()}
      </div>
    </>
  );
}