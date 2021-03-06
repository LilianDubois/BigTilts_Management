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
                      body: 'La Bigtilt '+bigtilt.id+' à été ajoutée par l\'atelier.',
                      sound: 'notifSong.wav',//sound: 'notifSong',
                     
                  }
                }
                const notifBtatelier = {
                  notification: {
                      title: 'Nouvelle Bigtilt : '+bigtilt.id+' !',
                      body: 'Allez lui renseigner une date de sortie d\'atelier',
                      sound: 'notifSong.wav',//sound: 'notifSong',
                     
                  }
                }
                if (doc.data().token != '0' && doc.data().State == '3'){
                  console.log('notification envoyée a ' + doc.data().name)
                  return await  messaging.sendToDevice(doc.data().token, doc.data().State == '2' ? notifBtatelier : payload);
                }
                else if (doc.data().token != '0' && doc.data().State == '1'){
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
                  sound: 'notifSong.wav',//sound: 'notifSong',
                 
              }
            } 
            if (before.date_exp!=after.date_exp && doc.data().token != '0'){
              console.log('notification envoyée a ' + doc.data().name)
              return await  messaging.sendToDevice(doc.data().token, payload);
            }
           
        });
      
      });
    });

    exports.NewBigtiltVendue = functions.firestore
    .document('bigtilts/{uid}')
    .onUpdate(async (snapshot1) => {
  
      const database = admin.firestore();
      const messaging = admin.messaging();
      const after = snapshot1.after.data()
      const before = snapshot1.before.data()
      const oldStatus = before.status
      const newStatus = after.status
      const btid = after.id
     
      console.log(`Nouvelle bigtilt vendue ! ${before.status} ${after.status}\n`)
     
      const user = await database
        .collection('users');
        user.get().then( snapshot => {
          snapshot.forEach( async doc => {  
            const payload = {
              notification: {
                  title: 'Nouvelle bigtilt vendue !',
                  body: 'La Bigtilt '+btid+' est vendue !',
                  sound: 'notifSong.wav',//sound: 'notifSong',
                 
              }
            } 
            if (before.status!='Vendue' && after.status=='Vendue' && doc.data().token != '0'){
              console.log('notification envoyée a ' + doc.data().name)
              return await  messaging.sendToDevice(doc.data().token, payload);
            }
           
        });
      
      });
    });

    exports.NewTailleAtelier = functions.firestore
    .document('bigtilts/{uid}')
    .onUpdate(async (snapshot1) => {
  
      const database = admin.firestore();
      const messaging = admin.messaging();
      const after = snapshot1.after.data()
      const before = snapshot1.before.data()
      const oldStatus = before.taille
      const newTaille = after.taille.substring(0,1)
      const btid = after.id
     
      console.log(`Nouvelle taille ! ${before.taille} ${after.taille}\n`)
     
      const user = await database
        .collection('users');
        user.get().then( snapshot => {
          snapshot.forEach( async doc => {  
            const payload = {
              notification: {
                  title: 'Nouvelle taille BT : '+btid+'',
                  body: 'La Bigtilt '+btid+' sera une '+newTaille+'m',
                  sound: 'notifSong.wav',//sound: 'notifSong',
                 
              }
            } 
            if (before.taille!=after.taille && doc.data().token != '0' && doc.data().State == '2'){//&& doc.data().name == 'Lilian'
              console.log('notification envoyée a ' + doc.data().name)
              return await  messaging.sendToDevice(doc.data().token, payload);
            }
           
        });
      
      });
    });

    exports.Check1Valid = functions.firestore
    .document('checkLists/{uid}')
    .onWrite(async (snapshot2) => {
        const database = admin.firestore();
        const messaging = admin.messaging();
        const after = snapshot2.after.data()
        const before = snapshot2.before.data()
        const checkafter = after.check1.S
        const token = [];
        console.log(`expédition le ${before.check1} et ${after.check1}\n`)

        const user = await database
        .collection('users');

        user.get().then( snapshot => {
              snapshot.forEach( async doc => {  
                const payload = {
                  notification: {
                      title: 'Premier Check Bt '+after.id+' validé ',
                      body: 'Allez vérifier pour valider le deuxième Check',
                      sound: 'default',
                     
                  }
                }  
                if (before.check1==false && after.check1==true && doc.data().token != '0' && doc.data().State == '2'){
                  console.log('notification envoyée a ' + doc.data().name)
                  return await  messaging.sendToDevice(doc.data().token, payload);
                }
               
            });
          
          });

       
    });

    exports.sendHttpPushNotification = functions.https.onRequest(async(req, res) => {
        const database = admin.firestore();
        const messaging = admin.messaging();
        const titre = req.query.titre;
        const contenu = req.query.contenu;
      
        
        const user = await database
        .collection('users');
        user.get().then( snapshot => {
          snapshot.forEach( async doc => {  
            const payload = {
              notification: {
                  title: titre,
                  body: contenu,
                  sound: 'default',
                 
              }
            } 
            if (doc.data().token != '0'){
              console.log('notification envoyée a ' + doc.data().name)
              return await  messaging.sendToDevice(doc.data().token, payload);
            }
           
        });
      
      });//get params like this
    
      })




exports.sendHttpPushNotificationToUser = functions.https.onRequest(async(req, res) => {
    const database = admin.firestore();
    const messaging = admin.messaging();
    const titre = req.query.titre;
    const contenu = req.query.contenu;
    const nameuser = req.query.name
    
    const user = await database
    .collection('users');
    user.get().then( snapshot => {
      snapshot.forEach( async doc => {  
        const payload = {
          notification: {
              title: titre,
              body: contenu,
              sound: 'notifSong.wav',//sound: 'notifSong',
              click_action: "FLUTTER_NOTIFICATION_CLICK",
          },
          data: {
            status: "done",
    screen: "screenA",
        },
          
        } 
        if (doc.data().name == nameuser && doc.data().token != '0'){
          console.log('notification envoyée a ' + doc.data().name)
          return await  messaging.sendToDevice(doc.data().token, payload);
        }
       
    });
  
  });//http://us-central1-bigtilts-management-fc45e.cloudfunctions.net/sendHttpPushNotificationToUser?titre=test%20son&contenu=test&name=Test%20user

  })