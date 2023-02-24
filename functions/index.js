const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();
const fcm = admin.messaging();

// // Create and deploy your first functions
// // https://firebase.google.com/docs/functions/get-started
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

exports.mondayNotif = functions.pubsub.schedule('0 17 * * *').onRun((context) => {
    const promises = []; 
      // Notification details.
    const payload = {
        notification: {
            title: "Time to add the one thing for today!",
            body:  "What is the one thing you need to accomplish that will make today a good day?",
        },
        data: {
            title: "Time to add the one thing for today!",
            body:  "What is the one thing you need to accomplish that will make today a good day?",
            click_action: "FLUTTER_NOTIFICATION_CLICK",
        }
    };
    promises.push(fcm.sendToTopic('/topics/reminder', payload)); 
    return Promise.all(promises);
});