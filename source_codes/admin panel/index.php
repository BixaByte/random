<?php

session_start();
if(isset($_SESSION['email'], $_SESSION['password'])){
?>


<!DOCTYPE html>
<html lang="en">

<head>
 <?php include('head.php') ?>
</head>

<body id="page-top">

  <!-- Page Wrapper -->
  <div id="wrapper">

    <!-- Sidebar -->
    <?php $pagename = "dashboard" ?>
    <?php include('sidebar.php'); ?>
    <!-- End of Sidebar -->

    <!-- Content Wrapper -->
    <div id="content-wrapper" class="d-flex flex-column">

      <!-- Main Content -->
      <div id="content">

        <!-- Topbar -->
        <?php include('topnavbar.php') ?>
        <!-- End of Topbar -->

        <!-- Begin Page Content -->
        <div class="container-fluid">

          <!-- Page Heading -->
          <div class="d-sm-flex align-items-center justify-content-between mb-4">
            <h1 class="h3 mb-0 text-gray-800">Dashboard</h1>
            
          </div>

          <!-- Content Row -->
          <div class="row">

            <!-- Earnings (Monthly) Card Example -->
            <div class="col-xl-3 col-md-6 mb-4">
              <div class="card border-left-primary shadow h-100 py-2">
                <div class="card-body">
                  <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                      <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">Total Users</div>
                      <div class="h5 mb-0 font-weight-bold text-gray-800 users"></div>
                    </div>
                    <div class="col-auto">
                      <i class="fas fa-users fa-2x text-gray-300"></i>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            

            <!-- Earnings (Monthly) Card Example -->
            <div class="col-xl-3 col-md-6 mb-4">
              <div class="card border-left-info shadow h-100 py-2">
                <div class="card-body">
                  <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                      <div class="text-xs font-weight-bold text-info text-uppercase mb-1">Total Orders</div>
                      <div class="row no-gutters align-items-center">
                        <div class="col-auto">
                          <div class="h5 mb-0 mr-3 font-weight-bold text-gray-800 totalorders" ></div>
                        </div>
                      </div>
                    </div>
                    <div class="col-auto">
                      <i class="fas fa-shopping-cart fa-2x text-gray-300"></i>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Pending Requests Card Example -->
            <div class="col-xl-3 col-md-6 mb-4">
              <div class="card border-left-warning shadow h-100 py-2">
                <div class="card-body">
                  <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                      <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">Total Products</div>
                      <div class="h5 mb-0 font-weight-bold text-gray-800 products"></div>
                    </div>
                    <div class="col-auto">
                      <i class="fas fa-dolly-flatbed fa-2x text-gray-300"></i>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            
            <div class="col-xl-3 col-md-6 mb-4">
              <div class="card border-left-success shadow h-100 py-2">
                <div class="card-body">
                  <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                      <div class="text-xs font-weight-bold text-success text-uppercase mb-1">Total Deals</div>
                      <div class="h5 mb-0 font-weight-bold text-gray-800 deals"></div>
                    </div>
                    <div class="col-auto">
                      <i class="fas fa-dolly-flatbed fa-2x text-gray-300"></i>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

       

          
        </div>
        <!-- /.container-fluid -->

      </div>
      <!-- End of Main Content -->

      <!-- Footer -->
     <?php include('footer.php'); ?>
      <!-- End of Footer -->

    </div>
    <!-- End of Content Wrapper -->

  </div>
  <!-- End of Page Wrapper -->

  <!-- Scroll to Top Button-->
  <a class="scroll-to-top rounded" href="#page-top">
    <i class="fas fa-angle-up"></i>
  </a>

  <!-- Logout Modal-->
  

  <!-- Bootstrap core JavaScript-->
  <?php include('footerlinks.php'); ?>

<script type="module" >
	
	//alert(database);
	
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
	
	
	var databaseRef=ref(database);
	
	
	get(child(databaseRef, 'Users/')).then((usersnap) =>{
		var usercount = 0;
		   usersnap.forEach(function() {
			   usercount++;
		   });
		
		//alert(count);
		$(".users").html(usercount);
	});
	
	get(child(databaseRef, 'Orders/')).then((ordersnap) =>{
		var ordercount = 0;
		ordersnap.forEach(function() {
			ordercount++;
		});
		get(child(databaseRef, 'Delivered_Orders/')).then((delordersnap) =>{
			delordersnap.forEach(function() {
			   ordercount++;
		   });
			$(".totalorders").html(ordercount);
		});
		//alert(count);
	});
	
	get(child(databaseRef, 'Items/')).then((itemsnap) =>{
		var prodcount = 0;
		   itemsnap.forEach(function() {
			   prodcount++;
		   });
		
		//alert(count);
		$(".products").html(prodcount);
	});
	
	get(child(databaseRef, 'Deals/')).then((dealsnap) =>{
		var dealcount = 0;
		   dealsnap.forEach(function() {
			   dealcount++;
		   });
		//alert(count);
		$(".deals").html(dealcount);
	});
	
	
	
	
</script>

<script src="js/restaurantdetails.js" type="module"></script>
</body>

</html>


<?php 
} else {
    header("location:login.php");
    exit;
  }
?>