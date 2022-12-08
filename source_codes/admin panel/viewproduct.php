<?php

session_start();

	$orderid = $_GET['productid'];
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
			<?php $pagename="products"; ?>
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
						<h1 class="h3 mb-2 text-gray-800">Product ID <strong><span class="text-uppercase orderid" ></span></strong>  </h1>
						
						<div class="row">
							
							<div class="col-xl-6 col-lg-6 mb-2">
							 	<div class="card shadow mb-4">
							 		<div class="card-header py-3">
								  		<h6 class="m-0 font-weight-bold text-primary">Product Image</h6>
									</div>
									<div class="card-body">
										<img src="images/loading.gif" height="300px" alt="" id="image" width="100%">
									</div>
							 	</div>
							 	
							 	
							 		<div class="card shadow mb-4">
							 		<div class="card-header py-3">
								  		<h6 class="m-0 font-weight-bold text-primary">Flavors</h6>
									</div>
									<div class="card-body">
										<div class="table-responsive">
											<table class="table table-bordered"  width="100%" cellspacing="0">
											  
											  
											  <tbody id="flavors">
												
											  </tbody>
											</table>
										 </div>
									</div>
							 	</div>
							 	
							 	
							 	<div class="card shadow mb-4">
							 		<div class="card-header py-3">
								  		<h6 class="m-0 font-weight-bold text-primary">Variations</h6>
									</div>
									<div class="card-body">
										<div class="table-responsive">
											<table class="table table-bordered"  width="100%" cellspacing="0">
											  
											  <thead class="thead-dark">
											  	<th>Name</th>
											  	<th>Price</th>
											  </thead>
											  
											  <tbody id="variations">
												
											  </tbody>
											</table>
										 </div>
									</div>
							 	</div>
							 	
							 	
								 
							</div>
							<div class="col-xl-6 col-lg-6 mb-2">
							 	<div class="card shadow mb-4">
							 		<div class="card-header py-3">
								  		<h6 class="m-0 font-weight-bold text-primary">Product Details</h6>
									</div>
									<div class="card-body">
										<div class="table-responsive">
											<table class="table table-bordered"  width="100%" cellspacing="0">
											  
											  
											  <tbody>
												
											  	<tr>
												  <td>Product ID</td>
												  <td class="orderid"></td>
												</tr>
												<tr>
												  <td>Title</td>
												  <td class="title"></td>
												</tr>
												<tr>
												  <td>Category</td>
												  <td class="categoryname"></td>
												</tr>
												<tr>
												  <td>Details</td>
												  <td class="details"></td>
												</tr>
												<tr>
												  <td>Price</td>
												  <td class="price"></td>
												</tr>
												<tr>
												  <td>Serve</td>
												  <td class="serves"></td>
												</tr>
												<tr>
												  <td>Views</td>
												  <td class="views"></td>
												</tr>
												<tr>
												  <td>Created Time</td>
												  <td class="time"></td>
												</tr>
												
												
											  </tbody>
											</table>
										 </div>
									</div>
							 	</div>
							 	
							 	
							 	<div class="card shadow mb-4">
							 		<div class="card-header py-3">
								  		<h6 class="m-0 font-weight-bold text-primary">Ingredients</h6>
									</div>
									<div class="card-body">
										<div class="table-responsive">
											<table class="table table-bordered"  width="100%" cellspacing="0">
											  
											  
											  <tbody id="ingredients">
												
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
	
	
	var ordernodeid = '<?php echo $orderid ?>';
	//alert(ordernodeid);
	
	
	import { initializeApp } from "https://www.gstatic.com/firebasejs/9.6.11/firebase-app.js";
		import { getAnalytics } from "https://www.gstatic.com/firebasejs/9.6.11/firebase-analytics.js";
		import { getDatabase, ref, get, set, onValue, child, remove, push, query, orderByChild, equalTo } from "https://www.gstatic.com/firebasejs/9.6.11/firebase-database.js";
		import { ref as sref, getStorage, uploadBytes, uploadBytesResumable, getDownloadURL, deleteObject } from "https://www.gstatic.com/firebasejs/9.6.11/firebase-storage.js";

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
		const storage = getStorage();
	
	get(child(databaseRef, 'Items/'+ordernodeid)).then((snapshot) =>{

		
			var timestamp =  snapshot.child("timeCreated").val();
			var months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
			var ts = new Date(timestamp*1);
			var o_date = ts.getDate();
			var o_year = ts.getFullYear();
  			var o_month = months[ts.getMonth()];
  			var o_hour = ts.getHours();
  			var o_min =ts.getMinutes();
		
		
			var uid = snapshot.key;
			
			$('.orderid').html(uid);
			var title = snapshot.child("title").val()+" SR";
			$('.title').html(title);
			var categoryname = snapshot.child("categoryId").val();
			$('.categoryname').html(categoryname);
		
			var details = snapshot.child("details").val();
			$('.details').html(details);
			var price = snapshot.child("price").val();
			$('.price').html(price);
		
			var no_of_serving = snapshot.child("no_of_serving").val();
			$('.serves').html(no_of_serving);
		
			var views = snapshot.child("viewsCount").val();
			$('.views').html(views);
		
			var image = snapshot.child("image").val();
			document.getElementById("image").src = image;
			//$('.image').src(image);
		
			var ordertime = o_hour+":"+o_min;
			$('.time').html(ts);
			
			
			get(child(databaseRef, "Items/"+ordernodeid+"/customizationForFlavours")).then((flavorSnapshot) =>{
				//alert();
				var content = "";
				$('#flavors').html(content);
				flavorSnapshot.forEach(function(flavors){
					content += '<tr>'
						content += '<td>'+flavors.val()+'</td>'
					content += '</tr>'
				});
				$('#flavors').append(content);
			});
		
		
			
			get(child(databaseRef, "Items/"+ordernodeid+"/customizationForVariations")).then((variationSnapshot) =>{
				//alert();
				var variation = "";
				$('#variations').html(variation);
				variationSnapshot.forEach(function(variationsnap){
					variation += '<tr>'
						variation += '<td>'+variationsnap.child("name").val()+'</td>'
						variation += '<td>'+variationsnap.child("price").val()+'</td>'
					variation += '</tr>'
				});
				$('#variations').append(variation);
			});
		
		
		get(child(databaseRef, "Items/"+ordernodeid+"/ingredients")).then((ingredientSnapshot) =>{
			
				//alert();
				var ingr = "";
				$('#ingredients').html(ingr);
				ingredientSnapshot.forEach(function(ingredient){
					ingr += '<tr>'
						ingr += '<td>'+ingredient.val()+'</td>'
					ingr += '</tr>'
				});
				$('#ingredients').append(ingr);
			});
	
			
			//var category = childsnapshot.child("title").val();
		
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