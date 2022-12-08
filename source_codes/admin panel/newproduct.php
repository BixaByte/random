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
						
						
						<div class="">
							<form action="" method="post" enctype="multipart/form-data">
							<div class="row">
							
								
								<div class="col-lg-4">
									<div class="form-group">
										<label for="categoryname">Select Category</label>
										<select name="categoryname" id="categoryname" class="form-control" required>
											<option value="" selected>Choose Category</option>
											
										</select>
									</div>
								</div>
								<div class="col-lg-4">
									<div class="form-group">
										<label for="name">Product Name</label>
										<input type="text" id="name" class="form-control" name="name" required>
									</div>
								</div>
								
								<div class="col-lg-4">
									<div class="form-group">
										<label for="desc">Description</label>
										<textarea name="long" id="desc" class="form-control"></textarea>
									</div>
								</div>
								<div class="col-lg-4">
									<div class="form-group">
										<label for="price">Price</label>
										<input type="number" class="form-control" id="price" name="price" required>
									</div>
								</div>
								<div class="col-lg-4">
									<div class="form-group">
										<label for="noofserves">No of Serves</label>
										<input type="number" class="form-control" id="noofserves" name="noofserves" placeholder="e-g 2, 3 or 5" required>
									</div>
								</div>
								<div class="col-lg-4">
									<div class="form-group">
										<label for="image">Image</label>
										<input type="file" class="form-control-file" id="image" name="image" required>
									</div>
								</div>
								
								<div class="form-group col-lg-12">
									<h4>Product Flavors</h4>
								</div>
      					
      							<div id="flavors-dive" class="col-md-12">
      					    		<div class="row" >
										<div class="form-group col-lg-6">
											<label for="">Flavor</label>
											<input type="text" class="form-control" name="flavors[]" id="flavors[]" placeholder="e-g Fajita" required value="default">
										</div>
										
										
						    		</div>
								</div>
								<div class="form-group col-lg-12">
										
									<button id="add-more-flavors" class="btn btn-info">+</button>
								</div>
								
								
								<div class="form-group col-lg-12">
									<h4>Product Variations</h4>
								</div>
								<div id="variations-div" class="col-md-12">
      					    		<div class="row" >
										<div class="form-group col-lg-5">
											<label for="">Variation Name</label>
											<input type="text" class="form-control" name="variation-name[]" id="" placeholder="e-g Large or small" required value="default">
										</div>
										<div class="form-group col-lg-5">
											<label for="">Variation Price</label>
											<input type="text" class="form-control" name="variation-price[]" id="" placeholder="e-g 100" required value="default">
										</div>
									</div>
								</div>
       						<div class="form-group col-lg-12">
								<button id="add-more-variations" class="btn btn-info">+</button>
							</div>
							
							
							<div class="form-group col-lg-12">
									<h4>Ingredients E-g Coke, Sprite</h4>
								</div>
      					
      							<div id="ingredients-div" class="col-md-12">
      					    		<div class="row" >
										<div class="form-group col-lg-6">
											<label for="">Ingredients</label>
											<input type="text" class="form-control" name="ingredients[]" id="ingredients[]" placeholder="e-g Regular Coke" required value="default">
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
	
	<!-- Getting Categories-->
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
		
		
	
		get(child(databaseRef, 'Categories/')).then((snapshot) =>{
		var catcontent = "";
		
		$('#categoryname').html(catcontent);
		snapshot.forEach(function(childsnapshot){
			//var category = childsnapshot.child("title").val();
			
			catcontent +='<option value="'+childsnapshot.child("timeCreated").val()+'"> '+childsnapshot.child("title").val()+'</option>';
		
        });
			$('#categoryname').append(catcontent);
			
		});
		
	
		
		
		document.getElementById("submit").addEventListener('click', addproduct);
		function addproduct(){
			
			var catname = document.getElementById("categoryname").value;
			var productname = document.getElementById("name").value;
			var description= document.getElementById("desc").value;
			var pprice= document.getElementById("price").value;
			var noofserves= document.getElementById("noofserves").value;
			var viewcount = 0;
			//var flavorArray = $("#flavors[]").val();
			//alert(flavorArray.length);
			
			
			var flavors = [];
			var variations = [];
			var pingredients = [];
			
			$("input[name='flavors[]']").each(function() {
				flavors.push($(this).val());
			});
			$("input[name='ingredients[]']").each(function() {
				pingredients.push($(this).val());
			});
			
			var variationName = [];
			var variationPrice = [];
			
			$("input[name='variation-name[]']").each(function() {
				variationName.push($(this).val());
				
			});
			$("input[name='variation-price[]']").each(function() {
				variationPrice.push($(this).val());
				
			});
			for(var i=0;i<variationName.length;i++){
				variations.push({"name":variationName[i], "price":variationPrice[i]});
				
			}
			//console.log(variations);
			
			//alert(flavors.length);
			
			//return;
			var date = new Date();
			var timestamp = ""+date.getTime();
			
			const catimage = document.querySelector('#image').files[0];
			const imageName = (+new Date()) + '-' + catimage.name;
			const imageMetadata = {contentType: catimage.type};
			
			const catImagesStorageRef = sref(storage, "ProductsImages/"+imageName);
			const imageUptask = uploadBytesResumable(catImagesStorageRef, catimage, imageMetadata);
			
			imageUptask.on('state-changed', ()=>{
				getDownloadURL(imageUptask.snapshot.ref).then((imagedownloadURL)=>{
					push(ref(database, 'Items/'), {
						categoryId: catname,
						details: description,
						no_of_serving: noofserves,
						price: pprice,
						timeCreated: timestamp,
						image: imagedownloadURL,
						title: productname,
						viewsCount: viewcount,
						customizationForFlavours:flavors,
						customizationForVariations:variations,
						ingredients:pingredients,
						type:"item"
					});
					window.location = "products.php";
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

<!-- Add Variations -->	
<script>
    $("#add-more-variations").on("click",function(e){
        e.preventDefault();
        
        var r ='<div class="row" ><div class="form-group col-md-5">';
		    var r = r+ '<label for="">Variation Name</label>';
		    var r = r+ '<input type="text" class="form-control" name="variation-name[]" id="variation-name[]" placeholder="e-g Small" required>';
		    var r = r+ '</div>';
       	    var r = r+ '<div class="form-group col-md-5">';
		    var r = r+ '<label for="">Variation Price</label>';
		    var r = r+ '<input type="text" class="form-control" name="variation-price[]" id="variation-price[]" placeholder="e-g 200" required>';
		    var r = r+ '</div>';
       	    var r = r+ '<div class="form-group col-lg-2">';
		    var r = r+ '<label >Remove</label> <br>';
		    var r = r+ '<button class="btn-danger btn remove-variation">-</button>';
		    var r = r+ '</div></div>';
		    
		$("#variations-div").append(r);
		$(".remove-variation").click(function(e){
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
		    var r = r+ '<label for="">Add New Ingredient</label>';
		    var r = r+ '<input type="text" class="form-control" name="ingredients[]" id="ingredients[]" placeholder="e-g Coke Sprite" required>';
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