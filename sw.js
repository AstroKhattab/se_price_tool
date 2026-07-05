/* Service worker: cache-first app shell so the tool loads offline after first visit.
   Bump CACHE_VERSION on every deploy to invalidate old caches. */
const CACHE_VERSION = 'pi-v5';
const SHELL = [
  './',
  './index.html',
  './manifest.webmanifest',
  './vendor/xlsx.min.js',
  './vendor/supabase.js',
  './icons/icon-192.png',
  './icons/icon-512.png',
  './icons/apple-touch-icon.png'
];

self.addEventListener('install', e => {
  e.waitUntil(caches.open(CACHE_VERSION).then(c => c.addAll(SHELL)).then(() => self.skipWaiting()));
});

self.addEventListener('activate', e => {
  e.waitUntil(
    caches.keys()
      .then(keys => Promise.all(keys.filter(k => k !== CACHE_VERSION).map(k => caches.delete(k))))
      .then(() => self.clients.claim())
  );
});

self.addEventListener('fetch', e => {
  const url = new URL(e.request.url);
  // Never intercept Supabase API traffic
  if (url.origin !== self.location.origin || e.request.method !== 'GET') return;
  e.respondWith(
    caches.match(e.request).then(hit =>
      hit ||
      fetch(e.request).then(res => {
        if (res.ok) {
          const copy = res.clone();
          caches.open(CACHE_VERSION).then(c => c.put(e.request, copy));
        }
        return res;
      }).catch(() => caches.match('./index.html'))
    )
  );
});
