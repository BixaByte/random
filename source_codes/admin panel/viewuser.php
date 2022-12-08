<?php

session_start();

	$orderid = $_GET['userid'];
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
			<?php $pagename="users"; ?>
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
						
						<div class="row">
							
							<div class="col-xl-6 col-lg-6 mb-2">
							 	<div class="card shadow">
							 		<div class="card-header py-3">
								  		<h6 class="m-0 font-weight-bold text-primary">User Profile Image</h6>
									</div>
									<div class="card-body profileimage">
										<img src="images/loading.gif" height="50px" alt="">
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
												  <td class="userid"><?php echo $orderid ?></td>
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
												<tr>
												  <td>Date of Birth</td>
												  <td class="dob"></td>
												</tr>
												<tr>
												  <td>Username</td>
												  <td class="username"></td>
												</tr>
												
												
											  </tbody>
											</table>
										 </div>
									</div>
							 	</div>
								 
							</div>
							
							
							<div class="col-xl-12 col-lg-6 mb-2">
							 	<div class="card shadow">
							 		<div class="card-header py-3">
								  		<h6 class="m-0 font-weight-bold text-primary">User Address</h6>
									</div>
									<div class="card-body">
										<div class="table-responsive">
											<table class="table table-bordered"  width="100%" cellspacing="0">
											  
											  <thead class="thead-dark">
											  	<tr>
											  		<th>Address</th>
											  		<th>Latitude</th>
											  		<th>Longitude</th>
											  		<th>Status</th>
											  		<th>Title</th>
											  		<th>Zipcode</th>
											  	</tr>
											  </thead>
											  
											  <tbody id="tabledata">
											
												
											  </tbody>
											</table>
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
		import { getDatabase, ref, get, set, onValue, child, orderByChild, equalTo, query  } from "https://www.gstatic.com/firebasejs/9.6.11/firebase-database.js";

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
	
	var uid = '<?php echo $orderid ?>';
	//alert(ordernodeid);
	
	
	get(child(databaseRef, 'Users/'+uid)).then((snapshot) =>{
		var content = "";
			
		
				//alert(uid);
				var u_fullname = snapshot.child("fullName").val();
				$('.fullname').html(u_fullname);
				var u_email = snapshot.child("email").val();
				$('.email').html(u_email);
				var u_phone = snapshot.child("phoneNumber").val();
				$('.phone').html(u_phone);
				var u_gender = snapshot.child("gender").val();
				$('.gender').html(u_gender);
				var u_dob = snapshot.child("date_of_birth").val();
				$('.dob').html(u_dob);
				var u_username = snapshot.child("userName").val();
				$('.username').html(u_username);
				
				var u_image = snapshot.child("profilePicture").val();
				$('.profileimage').html('<img src="'+u_image+'" height="300px" class="img-circle">');
				
			
	});
	
	
	//var useraddress = databaseRef.child("User_Address/"+uid);
	
	get(child(databaseRef, 'User_Address/'+uid)).then((snapshot) =>{
		var content = "";
		$('#tabledata').html(content);
		snapshot.forEach(function(childsnapshot){
			//var category = childsnapshot.child("title").val();
			content += '<tr>';
			
				content += '<td>'+childsnapshot.child("address").val()+'</td>';
				content += '<td>'+childsnapshot.child("lat").val()+'</td>';
				content += '<td>'+childsnapshot.child("lng").val()+'</td>';
				content += '<td>'+childsnapshot.child("status").val()+'</td>';
				content += '<td>'+childsnapshot.child("title").val()+'</td>';
				content += '<td>'+childsnapshot.child("zipCode").val()+'</td>';
				
			content += '</tr>'
		});
		$('#tabledata').append(content);
	});
	
	
	
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