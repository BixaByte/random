<?php

session_start();


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
			<?php $pagename="deals"; ?>
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
						
						
						<div class="">
							<form action="" method="post" enctype="multipart/form-data">
							<div class="row">
							
								
								
								<div class="col-lg-4">
									<div class="form-group">
										<label for="name">Deal Name</label>
										<input type="text" id="name" class="form-control" name="name" placeholder="Jumbo Burger Deal">
									</div>
								</div>
								
								<div class="col-lg-4">
									<div class="form-group">
										<label for="desc">Deal Details</label>
										<textarea name="desc" id="desc" class="form-control" placeholder="e-g 2 burgers 1 drink"></textarea>
									</div>
								</div>
								<div class="col-lg-4">
									<div class="form-group">
										<label for="oldprice">Old Price</label>
										<input type="number" class="form-control" id="oldprice" name="oldprice" placeholder="Old Price E-g 300">
									</div>
								</div>
								<div class="col-lg-4">
									<div class="form-group">
										<label for="newprice">New Price</label>
										<input type="number" class="form-control" id="newprice" name="newprice" placeholder="New Price e-g 200">
									</div>
								</div>
								<div class="col-lg-4">
									<div class="form-group">
										<label for="noofserves">No of Serving</label>
										<input type="number" class="form-control" id="noofserves" name="noofserves" placeholder="e-g 2, 3 or 5">
									</div>
								</div>
								<div class="col-lg-4">
									<div class="form-group">
										<label for="image">Image</label>
										<input type="file" class="form-control-file" id="image" name="image">
									</div>
								</div>
								<div class="col-lg-4">
									<div class="form-group">
										<label for="startdate">Start Date</label>
										<input type="date" class="form-control" id="startdate" name="startdate">
									</div>
								</div>
								<div class="col-lg-4">
									<div class="form-group">
										<label for="startdate">End Date</label>
										<input type="date" class="form-control" id="enddate" name="enddate">
									</div>
								</div>
								
								<div class="form-group col-lg-12">
									<h4>Drinks</h4>
								</div>
      					
      							<div id="drinks-div" class="col-md-12">
      					    		<div class="row" >
										<div class="form-group col-lg-6">
											<label for="">Drinks</label>
											<input type="text" class="form-control" name="drinks[]" id="drinks[]" placeholder="e-g Fajita" value="default">
										</div>
										
										
						    		</div>
								</div>
								<div class="form-group col-lg-12">
										
									<button id="add-more-drinks" class="btn btn-info">+</button>
								</div>
								
								<div class="form-group col-lg-12">
									<h4>Flavors</h4>
								</div>
      					
      							<div id="flavors-dive" class="col-md-12">
      					    		<div class="row" >
										<div class="form-group col-lg-6">
											<label for="">Flavor</label>
											<input type="text" class="form-control" name="flavors[]" id="flavors[]" placeholder="e-g Fajita" value="default">
										</div>
										
										
						    		</div>
								</div>
								<div class="form-group col-lg-12">
										
									<button id="add-more-flavors" class="btn btn-info">+</button>
								</div>
								
								
								
							
							
							<div class="form-group col-lg-12">
									<h4>Items included E-g 2 Large pizza, Coke</h4>
								</div>
      					
      							<div id="ingredients-div" class="col-md-12">
      					    		<div class="row" >
										<div class="form-group col-lg-6">
											<label for="">Items included in deal</label>
											<input type="text" class="form-control" name="ingredients[]" id="ingredients[]" placeholder="e-g Large pizza, Coke" required value="default">
										</div>
										
										
						    		</div>
								</div>
								<div class="form-group col-lg-12">
									<button id="add-more-ingredients" class="btn btn-info">+</button>
								</div>
								
								
								
								
							
								<div class="col-lg-12 mt-5">
									<div class="form-group">
									<button type="button" class="btn btn-block btn-success" name="submit" id="submit">Add</button>
										
									</div>
								</div>
							</div>
								
								
							</form>
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
	
	
	<!-- Add product to database -->
	<script type="module">
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
		
		
		
		
		document.getElementById("submit").addEventListener('click', addproduct);
		function addproduct(){
			var productname = document.getElementById("name").value;
			var description= document.getElementById("desc").value;
			var oldprice= parseFloat(document.getElementById("oldprice").value) ;
			var newprice= parseFloat( document.getElementById("newprice").value);
			var noofserves= document.getElementById("noofserves").value;
			var startdate= document.getElementById("startdate").value;
			var enddate= document.getElementById("enddate").value;
			var viewcount = 0;
			
			
			var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
			var date    = new Date(startdate),
    		yr      = date.getFullYear(),
    		month   = date.getMonth(),
    		day     = date.getDate();
			
			var date1    = new Date(enddate),
    		yr1      = date1.getFullYear(),
    		month1   = date1.getMonth(),
    		day1     = date1.getDate();
			
    		var sDate =day  + '-' + months[month] + '-' +yr ;
    		var eDate =day1  + '-' + months[month1] + '-' +yr1 ;
			
			if(oldprice>newprice){
				var percent1 = ((oldprice - newprice) / oldprice) * 100;
				var percent = Math.round(percent1);
			}
			else{
				alert("Old price should be greater than new price");
				return;
			}
			
			
			//var flavorArray = $("#flavors[]").val();
			//alert(flavorArray.length);
			
			
			var flavors = [];
			var ingredients = [];
			var drinks = [];
			
			$("input[name='flavors[]']").each(function() {
				flavors.push($(this).val());
			});
			$("input[name='ingredients[]']").each(function() {
				ingredients.push($(this).val());
			});
			$("input[name='drinks[]']").each(function() {
				drinks.push($(this).val());
			});
			
			
			//console.log(variations);
			
			//alert(flavors.length);
			
			//return;
			var date = new Date();
			var timestamp = ""+date.getTime();
			
			const catimage = document.querySelector('#image').files[0];
			const imageName = (+new Date()) + '-' + catimage.name;
			const imageMetadata = {contentType: catimage.type};
			
			const catImagesStorageRef = sref(storage, "DealImages/"+imageName);
			const imageUptask = uploadBytesResumable(catImagesStorageRef, catimage, imageMetadata);
			
			imageUptask.on('state-changed', ()=>{
				getDownloadURL(imageUptask.snapshot.ref).then((imagedownloadURL)=>{
				//var imageurl = url;
				push(ref(database, 'Deals/'), {
							customizationForDrinks: drinks,
							customizationForFlavours: flavors,
							details: description,
							discount: percent+"%",
							expiryDate:eDate,
							image: imagedownloadURL,
							itemsIncluded:ingredients,
							newPrice: newprice,
							oldPrice: oldprice,
							no_of_serving: noofserves,
							timeCreated: timestamp,
							title:productname,
							validDate:sDate,
							type:"deal",
							viewsCount: viewcount
							
						});
						window.location = "deals.php";
				});
			});
		}
	</script>
	
	<script src="js/restaurantdetails.js" type="module"></script>
<!-- Add Flavors -->		
<script>
    $("#add-more-flavors").on("click",function(e){
        e.preventDefault();
        
        var r ='<div class="row" ><div class="form-group col-md-6">';
		    var r = r+ '<label for="">Add New Flavor</label>';
		    var r = r+ '<input type="text" class="form-control" name="flavors[]" id="flavors[]" placeholder="e-g Tikka" required>';
		    var r = r+ '</div>';

       	    var r = r+ '<div class="form-group col-md-1">';
		    var r = r+ '<label >Remove</label>';
		    var r = r+ '<button class="btn-danger btn remove-spec">-</button>';
		    var r = r+ '</div></div>';
		    
		$("#flavors-dive").append(r);
		$(".remove-spec").click(function(e){
		    e.preventDefault();
		    $(this).closest(".row").remove();
		});
    });
</script>

<!-- Add Drinks -->	
<script>
    $("#add-more-drinks").on("click",function(e){
        e.preventDefault();
        
        var r ='<div class="row" ><div class="form-group col-md-6">';
		    var r = r+ '<label for="">Add New Drink</label>';
		    var r = r+ '<input type="text" class="form-control" name="drinks[]" id="drinks[]" placeholder="e-g Coke" required>';
		    var r = r+ '</div>';

       	    var r = r+ '<div class="form-group col-md-1">';
		    var r = r+ '<label >Remove</label>';
		    var r = r+ '<button class="btn-danger btn remove-drink">-</button>';
		    var r = r+ '</div></div>';
		    
		$("#drinks-div").append(r);
		$(".remove-drink").click(function(e){
		    e.preventDefault();
		    $(this).closest(".row").remove();
		});
    });
</script>

<!-- Add Ingredients -->	
<script>
    $("#add-more-ingredients").on("click",function(e){
        e.preventDefault();
        
        var r ='<div class="row" ><div class="form-group col-md-6">';
		    var r = r+ '<label for="">Items included in deal</label>';
		    var r = r+ '<input type="text" class="form-control" name="ingredients[]" id="ingredients[]" placeholder="e-g Large pizza, Coke" required>';
		    var r = r+ '</div>';

       	    var r = r+ '<div class="form-group col-md-1">';
		    var r = r+ '<label >Remove</label>';
		    var r = r+ '<button class="btn-danger btn remove-ingredient">-</button>';
		    var r = r+ '</div></div>';
		    
		$("#ingredients-div").append(r);
		$(".remove-ingredient").click(function(e){
		    e.preventDefault();
		    $(this).closest(".row").remove();
		});
    });
</script>

</body>

</html> 
	<?php

} else {
	header( "location:login.php" );
	exit;
}
?>