var V='sd-v1';
var CORE=['/','/manifest.json','/app/icon-192.png','/app/icon-512.png','/offline.html'];
self.addEventListener('install',function(e){e.waitUntil(caches.open(V).then(function(c){return c.addAll(CORE)}).then(function(){return self.skipWaiting()}))});
self.addEventListener('activate',function(e){e.waitUntil(caches.keys().then(function(k){return Promise.all(k.filter(function(x){return x!==V}).map(function(x){return caches.delete(x)}))}).then(function(){return self.clients.claim()}))});
self.addEventListener('fetch',function(e){
  var r=e.request,u=new URL(r.url);
  if(r.method!=='GET'||u.origin!==location.origin||u.pathname.indexOf('/api/')===0)return;
  if(r.mode==='navigate'){
    e.respondWith(fetch(r).then(function(res){var c=res.clone();caches.open(V).then(function(x){x.put(r,c)});return res}).catch(function(){return caches.match(r).then(function(m){return m||caches.match('/offline.html')})}));
    return;
  }
  e.respondWith(caches.match(r).then(function(m){
    var f=fetch(r).then(function(res){if(res.ok){var c=res.clone();caches.open(V).then(function(x){x.put(r,c)})}return res}).catch(function(){return m});
    return m||f;
  }));
});
