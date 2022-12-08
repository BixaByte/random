<?php

session_start();

	$orderid = $_GET['orderid'];
if ( isset( $_SESSION[ 'email' ], $_SESSION[ 'password' ] ) ) {
	?>

	<!DOCTYPE html>
	<html lang="en">

	<head>

		<?php include('head.php'); ?>
		<!-- Custom styles for this page -->
		<link href="vendor/datatables/dataTables.bootstrap4.min.css" rel="stylesheet">

	</head>

	<body id="page-top">

		<!-- Page Wrapper -->
		<div id="wrapper">

			<!-- Sidebar -->
			<?php $pagename="orders"; ?>
			<?php include('sidebar.php'); ?>
			<!-- End of Sidebar -->

			<!-- Content Wrapper -->
			<div id="content-wrapper" class="d-flex flex-column">

				<!-- Main Content -->
				<div id="content">

					<!-- Topbar -->
					<?php include('topnavbar.php'); ?>
					<!-- End of Topbar -->

					<!-- Begin Page Content -->
					<div class="container-fluid">

						
						<!-- Page Heading -->
						<h1 class="h3 mb-2 text-gray-800 float-left">Order # <strong><span class="text-uppercase orderid" ></span></strong>  </h1>
						
						<div class="float-right orderactions">
							<!--<button class="btn btn-success">Accept order</button>-->
						</div>
						<br><br><br>
						<div class="row float-left">
							
							<div class="col-xl-6 col-lg-6 mb-2">
						 	
							 	<div class="card shadow mb-2">
							 		<div class="card-header py-3">
								  		<h6 class="m-0 font-weight-bold text-primary">Order Details</h6>
									</div>
									<div class="card-body">
										<div class="table-responsive">
											<table class="table table-bordered"  width="100%" cellspacing="0">
											  
											  <tbody>
												
											  	<tr>
												  <td>Order ID</td>
												  <td><span class="orderid"></span></td>
												</tr>
												<tr>
												  <td>Total Bill</td>
												  <td><span class="totalbill"></span></td>
												</tr>
												<tr>
												  <td>Current Status</td>
												  <td><span class="currentstatus"></span></td>
												</tr>
												<tr>
												  <td>Order Time</td>
												  <td><span class="ordertime"></span></td>
												</tr>
												
												<tr>
												  <td>Order Date</td>
												  <td><span class="orderdate"></span></td>
												</tr>
											  </tbody>
											</table>
										 </div>
									</div>
							 	</div>
								
								 
							</div>
							<div class="col-xl-6 col-lg-6 mb-2">
							 	<div class="card shadow">
							 		<div class="card-header py-3">
								  		<h6 class="m-0 font-weight-bold text-primary">User Details</h6>
									</div>
									<div class="card-body">
										<div class="table-responsive">
											<table class="table table-bordered"  width="100%" cellspacing="0">
											  
											  
											  <tbody>
												
											  	<tr>
												  <td>User ID</td>
												  <td class="userid"></td>
												</tr>
												<tr>
												  <td>Full Name</td>
												  <td class="fullname"></td>
												</tr>
												<tr>
												  <td>Phone</td>
												  <td class="phone"></td>
												</tr>
												<tr>
												  <td>Email</td>
												  <td class="email"></td>
												</tr>
												<tr>
												  <td>Gender</td>
												  <td class="gender"></td>
												</tr>
												
												
											  </tbody>
											</table>
										 </div>
									</div>
							 	</div>
								 
							</div>
							
							<div class="col-xl-12 col-lg-12 mb-2">
							 	<div class="card shadow">
							 		<div class="card-header py-3">
								  		<h6 class="m-0 font-weight-bold text-primary">Ordered Items</h6>
									</div>
									<div class="card-body">
										<div class="orderedproducts itemdata row mb-4">
											<img src="images/loading.gif" height="50px" alt="">
										</div>
										
										<div class="orderedproducts dealdata row">
											
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
				<?php include('footer.php') ?>
				<!-- End of Footer -->

			</div>
			<!-- End of Content Wrapper -->

		</div>
		<!-- End of Page Wrapper -->

		<!-- Scroll to Top Button-->
		<a class="scroll-to-top rounded" href="#page-top">
    <i class="fas fa-angle-up"></i>
  </a>
	



<?php include('footerlinks.php') ?>
		<!-- Page level plugins -->
		<script src="vendor/datatables/jquery.dataTables.min.js"></script>
		<script src="vendor/datatables/dataTables.bootstrap4.min.js"></script>

		<!-- Page level custom scripts -->
		<script src="js/demo/datatables-demo.js"></script>


<script type="module">
	
	import { initializeApp } from "https://www.gstatic.com/firebasejs/9.6.11/firebase-app.js";
	import { getAnalytics } from "https://www.gstatic.com/firebasejs/9.6.11/firebase-analytics.js";
	import { getDatabase, ref, get, set, onValue, child, update } from "https://www.gstatic.com/firebasejs/9.6.11/firebase-database.js";

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
	const databaseRef=ref(database);
	
	var ordernodeid = '<?php echo $orderid ?>';
	//alert(ordernodeid);
	
	//var products = databaseRef.child("Orders/"+ordernodeid);
	
	get(child(databaseRef, 'Orders/'+ordernodeid)).then((snapshot)=>{
		var content = "";
		
			var timestamp =  snapshot.child("timeRequested").val();
			var months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
			var ts = new Date(timestamp*1);
			var o_date = ts.getDate();
			var o_year = ts.getFullYear();
  			var o_month = months[ts.getMonth()];
  			var o_hour = ts.getHours();
  			var o_min =ts.getMinutes();
		
		
			var uid = snapshot.child("uid").val();
			$('.userid').html(uid);
		
			var orderid = snapshot.child("orderId").val();
			$('.orderid').html(orderid);
			var totalbill = snapshot.child("totalPrice").val()+" SR";
			$('.totalbill').html(totalbill);
			var currentstatus = snapshot.child("status").val();
			$('.currentstatus').html(currentstatus);
			var ordertime = o_hour+":"+o_min;
			$('.ordertime').html(ordertime);
			var orderdate = o_date+"-"+o_month+"-"+o_year;
			$('.orderdate').html(orderdate);
			
			var orderactions  = "";
			if(currentstatus=="requested"){
				orderactions += '<button class="btn btn-success mr-3" id="acceptorder">Accept order</button>';
				orderactions += '<button class="btn btn-danger" id="rejectorder">Reject order</button>';
			}
			if(currentstatus=="accepted"){
				orderactions += '<button class="btn btn-success mr-3" id="preparing">Start Preparing</button>';
			}
			if(currentstatus=="preparing"){
				orderactions += '<button class="btn btn-success mr-3" id="onTheWay">On The Way</button>';
			}
			
		
			$('.orderactions').html(orderactions);
		
			$("#acceptorder").on('click', function(){
				var date = new Date();
				var timestamp = ""+date.getTime();

				update(ref(database, 'Orders/'+ordernodeid ), {
					timeAccepted: timestamp,
					status: "accepted"
				});

				location.reload();
			});
			$("#rejectorder").on('click', function(){
				if (confirm('Are you sure you want to Reject This order?')) {
					var date = new Date();
					var timestamp = ""+date.getTime();

					update(ref(database, 'Orders/'+ordernodeid ), {
						timeAccepted: timestamp,
						status: "rejected"
					});

					location.reload();
				}
				
			});
			$("#preparing").on('click', function(){
				
					var date = new Date();
					var timestamp = ""+date.getTime();

					update(ref(database, 'Orders/'+ordernodeid ), {
						timeAccepted: timestamp,
						status: "preparing"
					});

					location.reload();
			});
			$("#onTheWay").on('click', function(){
					var date = new Date();
					var timestamp = ""+date.getTime();

					update(ref(database, 'Orders/'+ordernodeid ), {
						timeAccepted: timestamp,
						status: "onTheWay"
					});
					window.location = "ordersontheway.php";
			});
		
			//var usersref = databaseRef.child("Users/"+uid);
			
			get(child(databaseRef, 'Users/'+uid)).then((userSnapshot)=>{
				var u_fullname = userSnapshot.child("fullName").val();
				$('.fullname').html(u_fullname);
				var u_email = userSnapshot.child("email").val();
				$('.email').html(u_email);
				var u_phone = userSnapshot.child("phoneNumber").val();
				$('.phone').html(u_phone);
				var u_gender = userSnapshot.child("gender").val();
				$('.gender').html(u_gender);
			});
		
		
	});
	
	
	get(child(databaseRef, "Orders/"+ordernodeid+"/items")).then((itemsSnapshot)=>{
		var content = "";
			var dealcontent = "";
			$('.itemdata').html(content);
			$('.dealdata').html(dealcontent);
			itemsSnapshot.forEach(function(itemchilds){
				
				if(itemchilds.child("type").val()=="item"){
					
					
					content += '<div class="col-lg-4">';
						content+= '<div class="itempicture">';
							content += '<img src="'+itemchilds.child("image").val()+'" alt="">';
						content+= '</div>';
						content += '<h4>'+itemchilds.child("title").val()+'</h4>';
					
					
						var flavors = itemchilds.child("customizationForFlavours").val();
						for(var i=0; i<flavors.length; i++){
							content += '<h5>Flavor: '+flavors[i]+'</h5>';
						}
						var variations = itemchilds.child("customizationForVariations").val();
						
						jQuery.each(variations, function(index, item) {
							content += '<h5>Size: '+variations[index].name+'</h5>'
							content += '<h5>price: '+variations[index].price+'</h5>'
						});
					
						content += '<h4> Quantity: '+itemchilds.child("quantity").val()+'</h4>';
						content += '<h4> Type: '+itemchilds.child("type").val()+'</h4>';
					content += '</div>';
				
					
				}
				
				if(itemchilds.child("type").val()=="deal"){
					
					
					dealcontent += '<div class="col-lg-4">';
						dealcontent+= '<div class="itempicture">';
							dealcontent += '<img src="'+itemchilds.child("image").val()+'" alt="">';
						dealcontent+= '</div>';
						dealcontent += '<h4>'+itemchilds.child("title").val()+'</h4>';
						
					
						var dealflavors = itemchilds.child("customizationForFlavours").val();
						
						for(var y=0; y<dealflavors.length; y++){
							dealcontent += '<h5>Flavor: '+dealflavors[y]+'</h5>';
						}
						
						var dealdrinks = itemchilds.child("customizationForDrinks").val();
						
						for(var z=0; z<dealdrinks.length; z++){
							dealcontent += '<h5>Drink: '+dealdrinks[z]+'</h5>';
						}
						
						
					dealcontent += '<h4> Quantity: '+itemchilds.child("quantity").val()+'</h4>';
					dealcontent += '<h4> Type: '+itemchilds.child("type").val()+'</h4>';
					
					
				dealcontent += '</div>';
				
					
				}
				
				//alert(itemchilds.child("categoryName").val());
			});
			$('.itemdata').append(content);
			$('.dealdata').append(dealcontent);
	});
		

	
	function preparing(){
		var date = new Date();
		var timestamp = ""+date.getTime();
		
		var acceptorder = products.update({
			timeStartPreparing: timestamp,
			status: "preparing"
		}).acceptorder;
		location.reload();
	}
	function onTheWay(){
		var date = new Date();
		var timestamp = ""+date.getTime();
		
		var acceptorder = products.update({
			timeOnTheWay: timestamp,
			status: "onTheWay"
		}).acceptorder;
		window.location = "ordersontheway.php";
	}
	function rejectorder(){
		 if (confirm('Are you sure you want to Reject This order?')) {
			 	var date = new Date();
				var timestamp = ""+date.getTime();
				
				var acceptorder = products.update({
					status: "rejected"
				}).acceptorder;
				location.reload();
		 }
		
	}
</script>

<script src="js/restaurantdetails.js" type="module"></script>
	</body>

	</html> 
	<?php
} else {
	header( "location:login.php" );
	exit;
}
?>