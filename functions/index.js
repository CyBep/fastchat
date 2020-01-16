'use strict';

const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

// Create and Deploy Your First Cloud Functions
// https://firebase.google.com/docs/functions/write-firebase-functions

exports.helloWorld = functions.https.onRequest((request, response) => {
 response.send("Hello from Firebase!");
});

exports.helloWorld = functions.https.onRequest((request, response) => {
 response.send("Hello from Firebase!");
});
exports.touch = functions.database.ref('/chat/{message}').onWrite(
    (change, context) => admin.database().ref('/lastmodified').set(context.timestamp));

// Keeps track of the length of the 'likes' child list in a separate property.
exports.checkChat = functions.https.onRequest((req, res) => {
 const uid = "8Nvguhd247WlnXZFt1rZwu82gGY2";
 const keyChat = functions.database.ref("chats").push().key;
 functions.database.ref('/chats/' + keyChat).set({
  uid: uid,
  messages: [],
 });

 // functions.database.ref('/users/' + userId).once('value').then(function(snapshot) {
 //  var username = (snapshot.val() && snapshot.val().username) || 'Anonymous';
 //  // ...
 // });
 // functions.database.ref('/chats/').onWrite(
 //     async (change) => {
 //      // A post entry.
 //      var user = {uid: uid};
 //      const collectionRef = change.after.ref.parent;
 //      const countRef = collectionRef.parent.child('likes_count');
 //
 //      let increment;
 //      if (change.after.exists() && !change.before.exists()) {
 //       increment = 1;
 //      } else if (!change.after.exists() && change.before.exists()) {
 //       increment = -1;
 //      } else {
 //       return null;
 //      }
 //
 //      // Return the promise from countRef.transaction() so our function
 //      // waits for this async event to complete before it exits.
 //      await countRef.transaction((current) => {
 //       return (current || 0) + increment;
 //      });
 //      console.log('Counter updated.');
 //      return null;
 //     });
 // return cors(req, res, async () => {
 //  // // Authentication requests are POSTed, other requests are forbidden
 //  // if (req.method !== 'POST') {
 //  //  return handleResponse(username, 403);
 //  // }
 //  // username = req.body.username;
 //  // if (!username) {
 //  //  return handleResponse(username, 400);
 //  // }
 //  // const password = req.body.password;
 //  // if (!password) {
 //  //  return handleResponse(username, 400);
 //  // }
 //  //
 //  // // TODO(DEVELOPER): In production you'll need to update the `authenticate` function so that it authenticates with your own credentials system.
 //  // const valid = await authenticate(username, password)
 //  // if (!valid) {
 //  //  return handleResponse(username, 401); // Invalid username/password
 //  // }
 //
 //  checkUserAdd("8Nvguhd247WlnXZFt1rZwu82gGY2");
 //  return handleResponse("asd", 200, { token: 'asd' });
 // });
});

/*functions.database.ref('/users/{postid}/likes/{likeid}').onWrite(
async (change) => {
 const collectionRef = change.after.ref.parent;
 const countRef = collectionRef.parent.child('likes_count');

 let increment;
 if (change.after.exists() && !change.before.exists()) {
  increment = 1;
 } else if (!change.after.exists() && change.before.exists()) {
  increment = -1;
 } else {
  return null;
 }

 // Return the promise from countRef.transaction() so our function
 // waits for this async event to complete before it exits.
 await countRef.transaction((current) => {
  return (current || 0) + increment;
 });
 console.log('Counter updated.');
 return null;
});*/