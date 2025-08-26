'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "38585880f47eb48125e4095d000cbf7e",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"index.html": "800b436e3fa5cfeae1910b6afd1455b2",
"/": "800b436e3fa5cfeae1910b6afd1455b2",
"manifest.json": "9185c2c5154608b96f8d7868a49bf927",
"assets/fonts/MaterialIcons-Regular.otf": "0e55a12f82c80364084842d243bddafd",
"assets/AssetManifest.bin.json": "d5d39f9271f5e41f00e65dedb604b7cf",
"assets/AssetManifest.bin": "26e935afbae63d70e71ec5378507cf51",
"assets/FontManifest.json": "732e335225cca91b06ab6e61e2394735",
"assets/assets/fonts/nunito/Nunito-Black.ttf": "27ee28fd596c0bd4235fa792d0d8b1ce",
"assets/assets/fonts/nunito/Nunito-Bold.ttf": "ba43cdecf9625c0dcec567ba29555e15",
"assets/assets/fonts/nunito/Nunito-Light.ttf": "7de99c591b88e33ceda578f9ee140263",
"assets/assets/fonts/nunito/Nunito-Medium.ttf": "d26cecc95cdc8327b337357e6c5c1f5b",
"assets/assets/fonts/nunito/Nunito-ExtraLight.ttf": "ef7ff1b92707646c2e02a39067aab385",
"assets/assets/logos/adawat.jpg": "1b4773675f8a6582c56f6c73a84b8d5e",
"assets/assets/images/login.png": "58a9e177ded0bd200328d602980e825d",
"assets/assets/images/zone_setup_instructions.gif": "bf27758c6a686fdb1568903d5fd7ed7c",
"assets/assets/images/dummy_customer_image.png": "d478d3eaddc77a957be1de85ba05c817",
"assets/assets/images/no_data.png": "4a326a39752580704d793c66a935e7bd",
"assets/assets/images/zone_setup_example.png": "4de19ccff5b59d561d3ff593345e55f3",
"assets/assets/images/image_placeholder.png": "da34a9c0dcda86d5566a5410406893eb",
"assets/assets/icons/user_details_section_heading.png": "ae55b80bf241d4a3ffb497b4edbca65b",
"assets/assets/icons/zone_management.png": "0f25577fc9b13bdbb9260e7af070f733",
"assets/assets/icons/servicemen.png": "dd3cabcbff955caf5658b3b995c4fc8a",
"assets/assets/icons/new_serviceman_request.png": "8bd4f6790dd98f750602d78a450faa53",
"assets/assets/icons/services_list.png": "49e462170f1d441dbd3818e13eccebf8",
"assets/assets/icons/customer_rating.png": "79872a28902023625e33bbfff1de2c51",
"assets/assets/icons/upload_file.png": "919b8885ce95eaa9b28fd00cb4e564ee",
"assets/assets/icons/ongoing_requests.png": "d646aa2f43f35f1a0e2a61d152daf4bf",
"assets/assets/icons/item.png": "92a9de16e170c872bce8ac7a1a002d6a",
"assets/assets/icons/accepted_requests.png": "227f17515009c9239680ce8c8f2dee9f",
"assets/assets/icons/sub_services_list.png": "69482ddaf4513ef7a877f525d88d0c98",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "b89674a97d932f9f79dfece6f820bc79",
"assets/NOTICES": "940d88fd9f5db966d4bb45816a3c6f9d",
"assets/AssetManifest.json": "27e1bf45cf5b780281926c458b721d50",
"main.dart.js": "0ea8bef80b61af6621ec33046077ac4b",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"version.json": "ec6a416472d986a48595e71736d75b64"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
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
        // Claim client to enable caching on first launch
        self.clients.claim();
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
      // Claim client to enable caching on first launch
      self.clients.claim();
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
