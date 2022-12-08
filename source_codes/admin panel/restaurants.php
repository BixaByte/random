<?php

session_start();
	
if(isset($_SESSION['email'], $_SESSION['password'])) {
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
    <?php $pagename="restaurants"; ?>
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
          <h1 class="h3 mb-2 text-gray-800"></h1>
          
          <!-- DataTales Example -->
          <div class="card shadow mb-4">
            <div class="card-header py-3">
              <h6 class="m-0 font-weight-bold text-primary">Restaurant Details</h6>
            </div>
            <div class="card-body">
				
				<div class="detailsalert"></div>
              	<form class="row">
              		<div class="form-group col-lg-6">
              			<label for="">Address</label>
              			<input type="text" class="form-control" id="address" value="">
              		</div>
              		<div class="form-group col-lg-6">
              			<label for="">Restaurant Latitude</label>
              			<input type="text" class="form-control" id="lat" value="">
              		</div>
              		<div class="form-group col-lg-6">
              			<label for="">Restaurant Longitude</label>
              			<input type="text" class="form-control" id="lng" value="">
              		</div>
              		<div class="form-group col-lg-6">
              			<label for="">Restaurant Name</label>
              			<input type="text" class="form-control" id="resname" value="">
              		</div>
              		<div class="form-group col-lg-6">
              			<label for="">Restaurant Phonenumber</label>
              			<input type="text" class="form-control" id="phonenumber" value="">
              		</div>
              		<div class="form-group col-lg-6">
              			<label for="">Logo URL</label>
              			<textarea name="" class="form-control" id="logourl" value=""></textarea>
              			
              		</div>
              		<div class="form-group col-lg-12">
              			<button type="button" name="submit" id="submit"  class="btn btn-success btn-block">Update Details</button>
              		</div>
              	</form>
            </div>
          </div>
          
          
          <div class="card shadow mb-4">
            <div class="card-header py-3">
              <h6 class="m-0 font-weight-bold text-primary">Taxes and Charges</h6>
            </div>
            <div class="card-body">
				<div class="chargesalert"></div>
              	<form class="row">
              		<div class="form-group col-lg-6">
              			<label for="">Delivery Fee Per Kilometer</label>
              			<input type="number" class="form-control" id="deliveryfee" value="">
              		</div>
              		<div class="form-group col-lg-6">
              			<label for="">Free Delivery in Kilometers</label>
              			<input type="number" class="form-control" id="freedelivery" value="">
              		</div>
              		<div class="form-group col-lg-6">
              			<label for="">Maximum Radius of Delivery</label>
              			<input type="number" class="form-control" id="maxradius" value="">
              		</div>
              		<div class="form-group col-lg-6">
              			<label for="">Tax in percentage eg 20 </label>
              			<input type="number" class="form-control" id="tax" value="">
              		</div>
              		
              		<div class="form-group col-lg-12">
              			<button type="button" name="updatecharges" id="updatecharges" onClick="updateCharges()" class="btn btn-success btn-block">Update Charges</button>
              		</div>
              	</form>
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

<?php include('footerlinks.php'); ?>



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

const app = initializeApp(firebaseConfig);
  const analytics = getAnalytics(app);
  const database = getDatabase(app);

var databaseRef=ref(database);
	
	get(child(databaseRef, 'RestaurantDetails/')).then((datasnapshot) =>{
		
		var address = datasnapshot.child("address").val();
			var lat = datasnapshot.child("lat").val();
			var lng = datasnapshot.child("lng").val();
			var phonenumber = datasnapshot.child("phoneNumber").val();
			var resname = datasnapshot.child("name").val();
			var logo = datasnapshot.child("logo").val();
			//alert(restName);
			document.getElementById("address").value = address;
			document.getElementById("lat").value = lat;
			document.getElementById("lng").value = lng;
			document.getElementById("phonenumber").value = phonenumber;
			document.getElementById("resname").value = resname;
			document.getElementById("logourl").value = logo;
		
			//var restlogo = datasnapshot.child("logo").val();
			//var logohtml = '<img class="img-profile rounded-circle" src="'+restlogo+'">'
			//document.getElementById("restaurantlogo").innerHTML = logohtml ;
	});
	
	get(child(databaseRef, 'Charges/')).then((datasnapshot) =>{
		var deliveryFeePerKm = datasnapshot.child("deliveryFeePerKm").val();
			var freeDeliveryRadius = datasnapshot.child("freeDeliveryRadius").val();
			var maxRadius = datasnapshot.child("maxRadius").val();
			var tax = datasnapshot.child("taxes").val();
			
			//alert(restName);
			document.getElementById("deliveryfee").value = deliveryFeePerKm;
			document.getElementById("freedelivery").value = freeDeliveryRadius;
			document.getElementById("maxradius").value = maxRadius;
			document.getElementById("tax").value = tax;
			
			//var restlogo = datasnapshot.child("logo").val();
			//var logohtml = '<img class="img-profile rounded-circle" src="'+restlogo+'">'
			//document.getElementById("restaurantlogo").innerHTML = logohtml ;
	});
	

	$("#submit").on('click', function(){ 
		
		var r_address = document.getElementById("address").value;
		var r_lat = document.getElementById("lat").value;
		var r_lng = document.getElementById("lng").value;
		var r_phonenumber = document.getElementById("phonenumber").value;
		var r_resname = document.getElementById("resname").value;
		var r_logo = document.getElementById("logourl").value;
		 
		
		update(ref(database, 'RestaurantDetails/' ), {
			
			address: r_address,
			lat: r_lat,
			lng: r_lng,
			name: r_resname,
			logo: r_logo,
			phoneNumber: r_phonenumber,
		}).then(()=>{
			$(".detailsalert").html('<div class="alert alert-success alert-dismissible"><a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a><strong>Success!</strong> Data updated Successfully</div>');
		}).catch(()=>{
			$(".detailsalert").html('<div class="alert alert-danger alert-dismissible"><a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a><strong>Error!</strong> Data not updated</div>');
		});
		
	});
	
	$("#updatecharges").on('click', function(){
		var r_deliveryfee = parseFloat(document.getElementById("deliveryfee").value);
		var r_freeradius = parseFloat(document.getElementById("freedelivery").value);
		var r_maxradius = parseFloat(document.getElementById("maxradius").value);
		var r_tax = parseFloat(document.getElementById("tax").value);
		
		update(ref(database, 'Charges/' ), {
			
			deliveryFeePerKm: r_deliveryfee,
			freeDeliveryRadius: r_freeradius,
			maxRadius: r_maxradius,
			taxes: r_tax
		}).then(()=>{
			$(".chargesalert").html('<div class="alert alert-success alert-dismissible"><a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a><strong>Success!</strong> Data updated Successfully</div>');
		}).catch(()=>{
			$(".chargesalert").html('<div class="alert alert-danger alert-dismissible"><a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a><strong>Error!</strong> Data not updated</div>');
		});
		
	});
	 
	
</script>

 <script type="module" src="js/restaurantdetails.js"></script>


</body>

</html>
<?php 
} else {
    header("location:login.php");
    exit;
  }
?>