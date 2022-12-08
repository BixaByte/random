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
    <?php $pagename="foodcategories"; ?>
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
         
         <?php  if(isset($error)){
			?> <div class="alert alert-danger" role="alert">
			  <?php echo $error ?>
			</div>
			<?php }?>
         
          <!-- Page Heading -->
          <h1 class="h3 mb-2 text-gray-800">All food Categories</h1>
         
         <button type="button" class="btn btn-primary btn-block mb-2" data-toggle="modal" data-target="#myModal">Add Food Category</button>
        
          
         <div class="modal" id="myModal">
			<div class="modal-dialog modal-lg">
			  <div class="modal-content">

				<!-- Modal Header -->
				<div class="modal-header">
				  <h4 class="modal-title">Fill all fields to Add data</h4>
				  <button type="button" class="close" data-dismiss="modal">&times;</button>
				</div>

				<!-- Modal body -->
				<div class="modal-body">
				 <div class="">
							<form action="foodcategories.php" method="post" enctype="multipart/form-data">
							<div class="row">
								<div class="col-lg-12">
									<div class="form-group">
										<label for="name">Category Name</label>
										<input type="text" class="form-control" id="catname" name="name" placeholder="e-g burgers" required>
									</div>
								</div>
								<div class="col-lg-12">
									<div class="form-group">
										<label for="catimage">Category Image(upload square)</label>
										<input type="file" class="form-control-file" id="catImage" name="catimage" required>
									</div>
								</div>
								<div class="col-lg-12">
									<div class="form-group">
										<label for="caticon">Category Icon(upload png square)</label>
										<input type="file" class="form-control-file" id="catIcon" name="caticon" required>
									</div>
								</div>
								<div class="col-lg-4">
									<div class="form-group">
										<label for="image">Choose Color (Hex #123456)</label>
										<input type="color" class="form-control-file" id="catcolorcode" name="image"  required>
									</div>
								</div>
								
								
								
								<div class="col-lg-12 mt-5">
									<div class="form-group">
									<button type="button" class="btn btn-block btn-success" name="submit" id="addcategory" >Add data</button>
										
									</div>
								</div>
							</div>
								
								
							</form>
						</div>
				</div>

				

			  </div>
			</div>
		  </div>
         
        
         
          <!-- DataTales -->
          <div class="card shadow mb-4">
            <div class="card-header py-3">
              <h6 class="m-0 font-weight-bold text-primary">food Category Record</h6>
            </div>
            <div class="card-body">
              <div class="table-responsive">
                <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
                  <thead>
                    <tr>
                      <th>ID</th>
                      <th>Category Name</th>
                      <th>Category Image</th>
                      <th>Category Icon</th>
                      <th>Color Code</th>
                      <th>Edit</th>
                      <th>Delete</th>
                    </tr>
                  </thead>
                  <tfoot>
                    <tr>
                      <th>ID</th>
                      <th>Category Name</th>
                      <th>Category Image</th>
                      <th>Category Icon</th>
                      <th>Color Code</th>
                      <th>Edit</th>
                      <th>Delete</th>
                    </tr>
                  </tfoot>
                  
                  
                  
                  <tbody id="tabledata">
                    
                  <tr class="text-center">
                     
                      <td colspan="7"><img src="images/loading.gif" alt="" height="50px"></td>
                      
                    </tr>
                  
                   
                  </tbody>
                </table>
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


 
<?php include('footerlinks.php'); ?>
  <!-- Page level plugins -->
  <script src="vendor/datatables/jquery.dataTables.min.js"></script>
  <script src="vendor/datatables/dataTables.bootstrap4.min.js"></script>

  <!-- Page level custom scripts -->
  <script src="js/demo/datatables-demo.js"></script>


<!-- Getting Categories -->
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
		var content = "";
		$('#tabledata').html(content);
		snapshot.forEach(function(childsnapshot){
			//var category = childsnapshot.child("title").val();
			content += '<tr>';
			
				content += '<td>'+childsnapshot.key+'</td>';
				content += '<td>'+childsnapshot.child("title").val()+'</td>';
				content += '<td><img src="'+childsnapshot.child("image").val()+'" alt="" height="50px"></td>';
				content += '<td><img src="'+childsnapshot.child("icon").val()+'" alt="" height="50px"></td>';
				content += '<td>'+childsnapshot.child("colorCode").val()+'</td>';
			
				content += '<td class="text-center"><a href="editfoodcat.php?foodcatid='+childsnapshot.key+'"  class="btn btn-info"> Edit </a></td>';
				
				
				content += '<td class="text-center "> <input type="text" hidden value="'+childsnapshot.key+'"  class="catname">  <button type="button" value="'+childsnapshot.child("timeCreated").val()+'"  class="btn btn-danger btn-delete" disabled >Delete </button></td>';
				content += '';
			
			
				
			content += '</tr>'
		});
		$('#tabledata').append(content);
		//dele_script();
		
		$(".btn-delete").on("click",function(){
			var dataid = $(this).attr("value");
			dataid = dataid+"";
			var name = $(this).parent().find(".catname").val();
			
			//alert(name);
			
        	if (confirm('Are you sure you want to Delete this Category and All Products related to this category? This action is non reversible.. ')) {
            
				//var products = databaseRef.child("Items");
				//alert(name);
				//return;
				//var rCategory = databaseRef.child("Categories/"+id);
				
				//alert(dataid);
				
				
				get(query(ref(database, 'Items/'), orderByChild('categoryId'), equalTo(dataid))).then((snapshot) =>{
					//alert(snapshot.child("categoryId").val());
					snapshot.forEach(function(childsnap)
						{ 
						//alert(child.key);
						remove(child(databaseRef, 'Items/'+childsnap.key));
							//databaseRef.child("Items/"+child.key).remove();
						}); 
				});
			
           		remove(child(databaseRef, 'Categories/'+name)).then((snapshot)=>{
					location.reload();
				});
           
			} else {

			}
		
    	});
		
		
		
		
	});
	/*function dele_script()
	{
			
		$(".btn-delete").on("click",function(){
		
		var id = $(this).attr("id");
			//var cn = document.getElementById("catname").value;
		var name = $(this).parent().find(".catname").val();
		
			
		if (confirm('Are you sure you want to Delete this Category and All Products related to this category? This action is non reversible.. ')) {
			//var products = databaseRef.child("Items");
			//alert(name);
			//return;
            //var rCategory = databaseRef.child("Categories/"+id);
			var dataid = $(this).attr("value");
			alert(dataid);
			get(query(ref(database, 'Items/'), orderByChild('categoryId'), equalTo(dataid))).then((snapshot) =>{
  				snapshot.forEach(function(child){
					
					//remove(child(databaseRef, 'Items/'+dataid));
					
					alert(child.child("Items/"+child.key));
					
					//databaseRef.child("Items/"+child.key).remove();
					}); 
			});
			
          	rCategory.remove();
			$(this).closest("tr").remove();
           
        } else {
            
        }
	});
	}*/


// Add New Category 

	document.getElementById("addcategory").addEventListener('click', addcategory);
	function addcategory(){
		//alert("i am in");
		
		//var imageurl="";
		
		var catname = document.getElementById("catname").value;
		var catcolorcode = document.getElementById("catcolorcode").value;
		var date = new Date();
		var timestamp = ""+date.getTime();
		const catimage = document.querySelector('#catImage').files[0];
		const caticon = document.querySelector('#catIcon').files[0];
		
		if(catname=='' || catcolorcode=='' || catimage=='' || caticon==''){
			alert("Fields can not be empty");
			return;
		}
		
		const imageName = (+new Date()) + '-' + catimage.name;
		const catIconName = (+new Date()) + '-' + caticon.name;
		
		const imageMetadata = {contentType: catimage.type};
		const iconMetadata = {contentType: caticon.type};
		
		//const imageUptask = storageRefImage.child(imageName).put(catimage, imageMetadata);
		//const iconUptask = storageRefIcon.child(catIconName).put(caticon, iconMetadata);
		
		
		const catImagesStorageRef = sref(storage, "CategoriesImages/"+imageName);
		const catIconsStorageRef = sref(storage, "CategoriesIcons/"+catIconName);
		
		const imageUptask = uploadBytesResumable(catImagesStorageRef, catimage, imageMetadata);
		const iconUptask = uploadBytesResumable(catIconsStorageRef, caticon, iconMetadata);
		iconUptask.on('state-changed', ()=>{
			getDownloadURL(iconUptask.snapshot.ref).then((icondownloadURL)=>{
				//alert(imagedownloadURL);
				
				imageUptask.on('state-changed', ()=>{
					getDownloadURL(imageUptask.snapshot.ref).then((imagedownloadURL)=>{
						push(ref(database, 'Categories/'), {
							colorCode: catcolorcode,
							icon: icondownloadURL,
							image: imagedownloadURL,
							timeCreated: timestamp,
							title: catname
						});
						location.reload();
					});
				});
				
			});
		});
		
		
	}
	
	
	//document.getElementById("addcategory").addEventListener('click', deleteCategory);
	
	
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