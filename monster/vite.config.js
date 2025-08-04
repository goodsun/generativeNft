import { defineConfig } from 'vite';

export default defineConfig({
  root: '.',
  build: {
    outDir: 'dist',
    rollupOptions: {
      input: {
        main: 'index.html',
        mint: 'mint.html',
        story: 'story.html',
        essays: 'essays.html'
      }
    }
  },
  server: {
    port: 3000,
    open: true
  }
});