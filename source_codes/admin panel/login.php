<?php
session_start();
	
	
if(isset($_POST['login'])) {

    $email = $_POST['email'];
    $pword = $_POST['password'];

      $_SESSION['email'] = $email;
      $_SESSION['password'] = $pword;

      header("location:index.php");
      exit;

  }

  if(!isset($_SESSION['email'], $_SESSION['password'])) {

?>

<!DOCTYPE html>
<html lang="en">

<head>

  <?php include('head.php'); ?>
  
  

</head>

<body class="loginbg">

  <div class="container">

    <!-- Outer Row -->
    <div class="row justify-content-center">

      <div class="col-xl-10 col-lg-12 col-md-9">

        <div class="card o-hidden border-0 shadow-lg my-5">
          <div class="card-body p-0">
            <!-- Nested Row within Card Body -->
            <div class="row">
              <div class="col-lg-6 d-none d-lg-block bg-login-image" id="restaurantlogo">
              	<img src="img/logo.png" class="loginlogo" alt="">
              </div>
              <div class="col-lg-6">
                <div class="p-5">
                  <div class="text-center">
                    <h1 class="h4 text-gray-900 mb-4">Welcome Back!</h1>
                  </div>
                  <form class="user" method="post"  action="login.php" id="loginform">
                    <div class="form-group">
                      <input type="email" class="form-control form-control-user" id="InputEmail" placeholder="Enter Email Address..." name="email" value="admin@admin.com">
                    </div>
                    <div class="form-group">
                      <input type="password" class="form-control form-control-user" id="InputPassword" placeholder="Password" name="password" value="123456">
                    </div>
                   <input type="hidden" name="login" value="login">
                   <button type="button" class="btn btn-primary btn-user btn-block" name="submit" id="submit" >Login</button>
                    
                    <input type="" hidden="" id="submitlogin" name="login" value="login">

                    <hr>
                   
                  </form>
                  
                 
                </div>
              </div>
            </div>
          </div>
        </div>

      </div>

    </div>

  </div>


  <!-- Bootstrap core JavaScript-->
	
	
	
<?php include('footerlinks.php'); ?>
	

<script type="module">
	// Import the functions you need from the SDKs you need
  import { initializeApp } from "https://www.gstatic.com/firebasejs/9.6.11/firebase-app.js";
  import { getAnalytics } from "https://www.gstatic.com/firebasejs/9.6.11/firebase-analytics.js";
  import { getDatabase, ref, get, set, onValue, child } from "https://www.gstatic.com/firebasejs/9.6.11/firebase-database.js";

  
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

  // Initialize Firebase
  const app = initializeApp(firebaseConfig);
  const analytics = getAnalytics(app);
  const database = getDatabase(app);
	
		
	//var firebaseConfig
	$("#submit").on('click', function(){
		//alert("ok");
	
		var useremail = document.getElementById("InputEmail").value;
		var userpass = document.getElementById("InputPassword").value;
		//alert(useremail);
		var databaseRef = ref(database);
		
		
		get(child(databaseRef, 'Admin/')).then((snapshot) => {
			
			var adminemail = snapshot.child("email").val();
			var adminpass = snapshot.child("password").val();
			if(useremail==adminemail && userpass==adminpass){
				
				$("#submitlogin").attr("type","submit");
				$("#submitlogin").click();
				
				//window.location = "index.php?login=true";
			}
			else{
				alert("Email or Password is incorrect");
			}
			
			
			}).catch((error) => {
			  console.error(error);
		});
		
//		adminTable.on('value', function(datasnapshot){
//			var adminemail = datasnapshot.child("email").val();
//			var adminpass = datasnapshot.child("password").val();
//			alert(adminemail);
//			if(useremail==adminemail && userpass==adminpass){
//				
//				$("#submitlogin").attr("type","submit");
//				$("#submitlogin").click();
//				
//				//window.location = "index.php?login=true";
//			}
//			else{
//				alert("Email or Password is incorrect");
//			}
//			
//			//alert(adminemail);
//			//alert(adminpass);
//			
//		});
		
	});
	
	
</script>
 
<!--<script src="js/restaurantdetails.js"></script>-->
</body>

</html>
<?php 
  }else{
		header("location:index.php?login=access");
	  
    	exit; 
	 }

	  ?>