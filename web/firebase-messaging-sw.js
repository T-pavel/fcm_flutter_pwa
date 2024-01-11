importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

firebase.initializeApp({
    apiKey: "AIzaSyBqYAWHzo5qXoFRHCtFsCI1qH_00GaSXvc",
    authDomain: "test-9af84.firebaseapp.com",
    projectId: "test-9af84",
    storageBucket: "test-9af84.appspot.com",
    messagingSenderId: "98328623532",
    appId: "1:98328623532:web:69bb560be609e2a2d32209",
});

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
    console.log("onBackgroundMessage", message);    
});