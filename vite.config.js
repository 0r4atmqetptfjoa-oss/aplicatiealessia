import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

// Basic Vite configuration enabling the React plugin and defining a simple
// alias so that modules can be imported with '@/path'.

export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: {
      '@': '/src'
    }
  }
});