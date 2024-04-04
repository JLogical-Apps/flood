import * as admin from "firebase-admin";
import * as functions from "firebase-functions";

admin.initializeApp();

export const addAdminClaim = functions.firestore
  .document("admin/{adminId}")
  .onCreate(async (snapshot, context) => {
    const adminData = snapshot.data();
    const uid = adminData.uid;

    try {
      await admin.auth().setCustomUserClaims(uid, {admin: true});
      console.log(`Admin claim added to user with UID: ${uid}`);

      // Update the document with "complete: true"
      await snapshot.ref.update({complete: true});
      console.log(`Document updated with "complete: true" for UID: ${uid}`);
    } catch (error) {
      console.error(`Error adding admin claim to user with UID: ${uid}`, error);
    }
  });
