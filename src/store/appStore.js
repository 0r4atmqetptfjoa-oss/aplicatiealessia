import create from 'zustand';

// Global application store managed with Zustand.  The store tracks the
// currently displayed page and a list of completed activity IDs.  These
// values will persist in memory throughout the application session.

export const useAppStore = create((set) => ({
  currentPage: 'mainMenu',
  completedActivities: [],
  setCurrentPage: (page) => set({ currentPage: page }),
  addCompletedActivity: (id) =>
    set((state) => {
      // Avoid duplicates
      if (state.completedActivities.includes(id)) return state;
      return { completedActivities: [...state.completedActivities, id] };
    })
  ,
  // Resets all completed activities (used in the parental gate settings)
  resetProgress: () => set({ completedActivities: [] })
}));