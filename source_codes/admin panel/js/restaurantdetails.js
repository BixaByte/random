
  import { initializeApp } from "https://www.gstatic.com/firebasejs/9.4.1/firebase-app.js";
  import { getAnalytics } from "https://www.gstatic.com/firebasejs/9.4.1/firebase-analytics.js";
  import { getDatabase, ref, get, set, onValue, child, update } from "https://www.gstatic.com/firebasejs/9.4.1/firebase-database.js";

  
  //replace your code here
		const firebaseConfig = {
			apiKey: "",
			authDomain: "",
			databaseURL: "",
			projectId: "",
			storageBucket: "",
			messagingSenderId: "",
			appId: "",
			measurementId: ""
		 };

const app = initializeApp(firebaseConfig);
  const analytics = getAnalytics(app);
  const database = getDatabase(app);

var databaseRef=ref(database);


get(child(databaseRef, 'RestaurantDetails/')).then((datasnapshot) =>{
	var restName = datasnapshot.child("name").val();
	document.getElementById("restaurantname").innerHTML = restName;
	var restlogo = datasnapshot.child("logo").val();
	var logohtml = '<img class="img-profile rounded-circle" src="'+restlogo+'">'
	document.getElementById("restaurantlogo").innerHTML = logohtml ;
	
	});
