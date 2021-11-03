const functions = require("firebase-functions");
const admin = require('firebase-admin');
const { firebaseConfig } = require("firebase-functions");

admin.initializeApp();


    exports.NewBigtilt = functions.firestore
    .document('bigtilts/{uid}')
    .onCreate(async (snappshot) => {
        const database = admin.firestore();
        const messaging = admin.messaging();
        const token = [];
        const bigtilt = snappshot.data();

        const user = await database
        .collection('users');

        user.get().then( snapshot => {
              snapshot.forEach( async doc => {  
                const payload = {
                  notification: {
                      title: 'Nouvelle Bigtilt !',
                      body: 'La Bigtilt '+bigtilt.id+' à été ajoutée.',
                     
                  }
                }
                const notifBtatelier = {
                  notification: {
                      title: 'Nouvelle Bigtilt : '+bigtilt.id+' !',
                      body: 'Allez lui renseigner une date de sortie d\'atelier',
                     
                  }
                }
                if (doc.data().token != '0'){
                  console.log('notification envoyée a ' + doc.data().name)
                  return await  messaging.sendToDevice(doc.data().token, doc.data().State == '2' ? notifBtatelier : payload);
                }
               
            });
          
          });

       
    });



    exports.NewDateExp = functions.firestore
    .document('bigtilts/{uid}')
    .onUpdate(async (snapshot1) => {
      const monthNames = ["Janvier", "Février", "Mars", "Avril", "Mai", "Juin", "Juillet", "Aout", "Septembre", "Octobre", "Novembre", "Decembre"];
      const database = admin.firestore();
      const messaging = admin.messaging();
      const after = snapshot1.after.data()
      const before = snapshot1.before.data()
      const oldStatus = before.date_exp
      const newStatus = after.date_exp
      const btid = after.id
      date = new Date(newStatus)
      console.log(`expédition le ${date.getDate()} ${monthNames[date.getMonth()]}\n`)
     
      const user = await database
        .collection('users');
        user.get().then( snapshot => {
          snapshot.forEach( async doc => {  
            const payload = {
              notification: {
                  title: 'Nouvelle date d\'expédition',
                  body: 'La Bigtilt '+btid+' partira le '+date.getDate()+' '+monthNames[date.getMonth()],
                 
              }
            } 
            if (before.date_exp!=after.date_exp && doc.data().token != '0'){
              console.log('notification envoyée a ' + doc.data().name)
              return await  messaging.sendToDevice(doc.data().token, payload);
            }
           
        });
      
      });
    });

    /*exports.DirectFunc = (message, context) => {
      const name = message.data
        ? Buffer.from(message.data, 'base64').toString()
        : 'World';
    
      console.log(`Hello, ${name}!`);
    };*/


