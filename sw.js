// 화면 파일은 네트워크 우선(새 버전 바로 반영), 인터넷이 없으면 저장본으로 실행. 날씨·지도는 항상 네트워크.
const CACHE = 'skyglass-desk-v1';
const SHELL = ['./', './index.html', './manifest.webmanifest', './icon.png', './icon-192.png',
  './vendor/maplibre-gl.js', './vendor/maplibre-gl.css',
  './fonts/outfit-latin-300-normal.woff2', './fonts/outfit-latin-600-normal.woff2', './fonts/outfit-latin-700-normal.woff2', './fonts/PretendardVariable.woff2',
  './tex/moon.png', './tex/cloud0.png', './tex/cloud1.png', './tex/cloud2.png'];
self.addEventListener('install', e => { e.waitUntil(caches.open(CACHE).then(c => c.addAll(SHELL))); self.skipWaiting(); });
self.addEventListener('activate', e => {
  e.waitUntil(caches.keys().then(ks => Promise.all(ks.filter(k => k !== CACHE).map(k => caches.delete(k)))).then(() => self.clients.claim()));
});
self.addEventListener('fetch', e => {
  const u = new URL(e.request.url);
  if (e.request.method !== 'GET' || u.origin !== location.origin) return;
  e.respondWith(fetch(e.request).then(r => { if (r.ok) { const cp = r.clone(); caches.open(CACHE).then(c => c.put(e.request, cp)); } return r; })
    .catch(() => caches.match(e.request)));
});
