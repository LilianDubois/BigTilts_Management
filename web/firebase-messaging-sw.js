importScripts("https://www.gstatic.com/firebasejs/8.6.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.6.1/firebase-messaging.js");

firebase.initializeApp({
    apiKey: "AIzaSyBDM-L5Ne_Gzp1_vVNXkdEU8lI2vsW_CNk",
  authDomain: "bigtilts-management-fc45e.firebaseapp.com",
  projectId: "bigtilts-management-fc45e",
  storageBucket: "bigtilts-management-fc45e.appspot.com",
  messagingSenderId: "878530511748",
  appId: "1:878530511748:web:f8ece002185156b11813d1"
});
// Necessary to receive background messages:
const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((m) => {
  console.log("onBackgroundMessage", m);
});