import { useEffect } from 'react';
import { useAppStore } from '../store/appStore.js';

/**
 * Custom hook that mirrors the completedActivities array from the global
 * store and persists it to localStorage.  It also exposes helper
 * functions for adding a completed activity and resetting progress.
 *
 * Components can import and call these helpers instead of reaching
 * directly into the Zustand store.  When the list of completed
 * activities changes, the hook writes the updated list to
 * localStorage so progress survives page refreshes.
 */
export default function useProgressTracker() {
  const completedActivities = useAppStore((state) => state.completedActivities);
  const addCompletedActivity = useAppStore((state) => state.addCompletedActivity);
  const resetProgress = useAppStore((state) => state.resetProgress);

  // Persist completed activities to localStorage whenever they change.
  useEffect(() => {
    try {
      localStorage.setItem('completedActivities', JSON.stringify(completedActivities));
    } catch (err) {
      console.warn('Could not persist progress:', err);
    }
  }, [completedActivities]);

  return {
    completedActivities,
    addCompletedActivity,
    resetProgress,
  };
}