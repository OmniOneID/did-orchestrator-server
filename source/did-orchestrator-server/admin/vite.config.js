import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  server: {
    port: 3000,
    open: true,
    proxy: {
      '^/(?!.*\\.).*|^/static/.*': {
        target: 'http://localhost:9001',
        changeOrigin: true,
        bypass: (req, res, options) => {
          if (req.url.startsWith('/@') || 
              req.url.startsWith('/node_modules') ||
              req.url.startsWith('/src/') ||
              req.url === '/' ||
              req.url.startsWith('/__vite')) {
            return req.url
          }
        }
      }
    }
  },
  build: {
    outDir: 'build'
  }
})
