'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "canvaskit/canvaskit.wasm": "3de12d898ec208a5f31362cc00f09b9e",
"canvaskit/canvaskit.js": "97937cb4c2c2073c968525a3e08c86a3",
"canvaskit/profiling/canvaskit.wasm": "371bc4e204443b0d5e774d64a046eb99",
"canvaskit/profiling/canvaskit.js": "c21852696bc1cc82e8894d851c01921a",
"index.html": "4e9fca61c1276f6617481394758cd9b2",
"/": "4e9fca61c1276f6617481394758cd9b2",
"manifest.json": "1422a79d92121b23233fe3822c8376b6",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/AssetManifest.json": "a2ec30016594dd4ba67b57f89fa12037",
"assets/assets/images/03d.png": "8621a91e65ff543f9bb77fbb1848ddf6",
"assets/assets/images/50d.png": "cab19004c5beaec9a7a730695414ebb4",
"assets/assets/images/11d.png": "aa590aa0cb8aec05ec6a8c0153f23b50",
"assets/assets/images/09d.png": "e85e9228da07e2d04e79c6138c6424aa",
"assets/assets/images/logo_white_cropped.png": "54752bbba2a3fca6ffc404c05178366c",
"assets/assets/images/01n.png": "6693bdf685ae981975be5fa266250456",
"assets/assets/images/02n.png": "36be1cbcb95a119365e00862ecb303d7",
"assets/assets/images/pc_300.png": "243e89d1f39e6fb2394c229bd65c7b46",
"assets/assets/images/10d.png": "126cd52cc45cc4071de18dc074e127ad",
"assets/assets/images/09n.png": "e85e9228da07e2d04e79c6138c6424aa",
"assets/assets/images/google-maps-logo.png": "92ecbcfa6880da24a57d156ea5092d7c",
"assets/assets/images/50n.png": "cab19004c5beaec9a7a730695414ebb4",
"assets/assets/images/02d.png": "85bacbaf387366adc4b0ca81b4c7cdca",
"assets/assets/images/10n.png": "105df06468669236b0f877652280c6a4",
"assets/assets/images/01d.png": "ed22e08c4aafb6ac3afa98e002abd5a3",
"assets/assets/images/03n.png": "8621a91e65ff543f9bb77fbb1848ddf6",
"assets/assets/images/13n.png": "999e2b5d67490237e26f787e39586120",
"assets/assets/images/04n.png": "533a26f80a181eedfdc8dc0ad3add84f",
"assets/assets/images/04d.png": "533a26f80a181eedfdc8dc0ad3add84f",
"assets/assets/images/13d.png": "999e2b5d67490237e26f787e39586120",
"assets/assets/images/11n.png": "aa590aa0cb8aec05ec6a8c0153f23b50",
"assets/dotenv": "6f54f86702a680cdf4ce9b91d1d9c782",
"assets/shaders/ink_sparkle.frag": "2627f6dfe0bf4e6565672feb6354338a",
"assets/FontManifest.json": "2c292430d9f25fd45668e794b70ebd8d",
"assets/fonts/Roboto-Bold.ttf": "9ece5b48963bbc96309220952cda38aa",
"assets/fonts/MaterialIcons-Regular.otf": "e7069dfd19b331be16bed984668fe080",
"assets/fonts/Roboto-Regular.ttf": "f36638c2135b71e5a623dca52b611173",
"assets/fonts/MyIcons.ttf": "3c250ef062e0bdab2f33775da09b0230",
"assets/fonts/Koulen-Regular.ttf": "f4ca7b52e1cc9fe0df9958deaafe0cc7",
"assets/NOTICES": "fd245808aa4c2fb1c421f3dcd14dfb12",
"pc_100.png": "d8bd09aeba9dbc70c114e4e83b8c89bf",
"flutter.js": "1cfe996e845b3a8a33f57607e8b09ee4",
"favicon.png": "0b2557679bb5643320e749e193baaa2e",
"version.json": "8a43535f7f10cc5d3f1ae59c8bc75bc7",
"main.dart.js": "c1b395de49a966b2d8f9f7ab1f438009",
"icons/Icon-512.png": "454983506563ec8b4abcddeec88ceaa1",
"icons/Icon-192.png": "ee8e46ac7b5c4bad4c2ae4284cf5ac0c",
"icons/Icon-maskable-192.png": "3705feee227a9bd119c13956ff16615e",
"icons/Icon-maskable-512.png": "89f49f79a33a0c7660e83346a8491996"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
