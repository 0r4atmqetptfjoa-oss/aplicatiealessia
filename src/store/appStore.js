import create from 'zustand';

// Global application store managed with Zustand.  The store tracks the
// currently displayed page and a list of completed activity IDs.  These
// values will persist in memory throughout the application session.

export const useAppStore = create((set) => ({
  // Currently displayed page.  Defaults to the main menu.
  currentPage: 'mainMenu',
  // Array of completed activity IDs.  Used to populate the crown gems.
  completedActivities: [],
  // Tracks how many times each page has been visited.  Useful for
  // analytics and parental reporting.
  pageCounts: {},
  // Daily quest state.  Contains an id and whether it's completed.
  dailyQuest: { id: null, completed: false },
  // Global mute flag to disable all audio in the app.
  globalMute: false,
  // Optional session time limit in minutes.  When set, the app can
  // enforce a maximum playtime per session.
  timeLimit: null,

  // Set the current page.
  setCurrentPage: (page) => set({ currentPage: page }),
  // Mark an activity as completed.  Avoids duplicates.
  addCompletedActivity: (id) =>
    set((state) => {
      if (state.completedActivities.includes(id)) return state;
      return { completedActivities: [...state.completedActivities, id] };
    }),
  // Reset all progress and analytics.
  resetProgress: () => set({
    completedActivities: [],
    pageCounts: {},
    dailyQuest: { id: null, completed: false },
  }),
  // Increment page visit count for analytics.
  incrementPageCount: (page) => set((state) => {
    const counts = { ...state.pageCounts };
    counts[page] = (counts[page] || 0) + 1;
    return { pageCounts: counts };
  }),
  // Set a new daily quest (object with id and completed flag).  Overwrites existing quest.
  setDailyQuest: (quest) => set({ dailyQuest: quest }),
  // Mark the current daily quest as completed.
  completeDailyQuest: () => set((state) => ({ dailyQuest: { ...state.dailyQuest, completed: true } })),
  // Enable or disable all audio.
  setGlobalMute: (value) => set({ globalMute: value }),
  // Set a session time limit in minutes.
  setTimeLimit: (minutes) => set({ timeLimit: minutes }),
}));