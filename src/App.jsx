import React, { Suspense, lazy, useEffect } from 'react';
import AnimatedBackground from './components/scenes/AnimatedBackground.jsx';
import MagicButton from './components/ui/MagicButton.jsx';
import { useAppStore } from './store/appStore.js';
import ErrorBoundary from './components/util/ErrorBoundary.jsx';
import { t } from './i18n/index.js';

// Lazy-load pages to improve initial load time.  Each import is
// resolved only when the user navigates to that page.
const MainMenu = lazy(() => import('./pages/MainMenu.jsx'));
const InstrumentsPage = lazy(() => import('./pages/InstrumentsPage.jsx'));
const SoundsPage = lazy(() => import('./pages/SoundsPage.jsx'));
const StoriesPage = lazy(() => import('./pages/StoriesPage.jsx'));
const SongsPage = lazy(() => import('./pages/SongsPage.jsx'));
const GamesPage = lazy(() => import('./pages/GamesPage.jsx'));

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
  const incrementPageCount = useAppStore((state) => state.incrementPageCount);
  const timeLimit = useAppStore((state) => state.timeLimit);

  // Track when the session started to enforce the optional time limit.
  // This will only reset when the app component remounts (i.e., on
  // page refresh).  If you need a persistent timer across sessions,
  // store the timestamp in localStorage.
  const sessionStartRef = React.useRef(Date.now());

  // On page change, record the visit in analytics and check the time limit.
  useEffect(() => {
    incrementPageCount(currentPage);
    // Check time limit on each navigation.  If the session exceeds
    // the configured limit, notify the user and reset to main menu.
    if (timeLimit) {
      const elapsedMinutes = (Date.now() - sessionStartRef.current) / 60000;
      if (elapsedMinutes > timeLimit) {
        alert('Aţi atins limita de timp pentru această sesiune. Pauză!');
        // Reset progress or navigate to main menu
        setCurrentPage('mainMenu');
      }
    }
  }, [currentPage, incrementPageCount, timeLimit, setCurrentPage]);

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
    <ErrorBoundary>
      {/* Global animated starfield background. */}
      <AnimatedBackground />
      {/* Navigation bar pinned to the top of the viewport.  Buttons
          trigger updates to the current page in the global store. */}
      <nav className="nav-bar">
        {/* Each navigation item uses the MagicButton component for a playful animated effect. */}
        <MagicButton onClick={() => setCurrentPage('mainMenu')}>{t('home')}</MagicButton>
        <MagicButton onClick={() => setCurrentPage('instruments')}>{t('instruments')}</MagicButton>
        <MagicButton onClick={() => setCurrentPage('sounds')}>{t('sounds')}</MagicButton>
        <MagicButton onClick={() => setCurrentPage('stories')}>{t('stories')}</MagicButton>
        <MagicButton onClick={() => setCurrentPage('songs')}>{t('songs')}</MagicButton>
        <MagicButton onClick={() => setCurrentPage('games')}>{t('games')}</MagicButton>
      </nav>
      {/* Container for page-specific content.  The z-index ensures it
          appears above the animated background. */}
      <div className="page-container">
        <Suspense fallback={<div style={{ padding: '2rem', color: 'white' }}>Se încarcă…</div>}>
          {renderPage()}
        </Suspense>
      </div>
    </ErrorBoundary>
  );
}