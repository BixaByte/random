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
          <h1 class="h3 mb-2 text-gray-800">All Users</h1>
          <p class="mb-4">This is the record of all users</p>

      
        
         
          <!-- DataTales Example -->
          <div class="card shadow mb-4">
            <div class="card-header py-3">
              <h6 class="m-0 font-weight-bold text-primary">Users Record</h6>
            </div>
            <div class="card-body">
              <div class="table-responsive">
                <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
                  <thead>
                    <tr>
                      <th>Image</th>
                      <th>Fullname</th>
					  <th>Email</th>
					  <th>Gender</th>
					  <th>Date of Birth</th>
                      <th>Phone Number</th>
                      <th>Username</th>
                      <th>View</th>
                      
                    </tr>
                  </thead>
                  <tfoot>
                    <tr>
                      <th>Image</th>
                      <th>Fullname</th>
					  <th>Email</th>
					  <th>Gender</th>
					  <th>Date of Birth</th>
                      <th>Phone Number</th>
                      <th>Username</th>
                      <th>View</th>
                    </tr>
                  </tfoot>
                  
                  
                  
                  <tbody id="tabledata">
                   
                  <tr>
                      <td><img src="images/loading.gif" height="50px" alt=""></td>
                      <td><img src="images/loading.gif" height="50px" alt=""></td>
                      <td><img src="images/loading.gif" height="50px" alt=""></td>
                      <td><img src="images/loading.gif" height="50px" alt=""></td>
                      <td><img src="images/loading.gif" height="50px" alt=""></td>
                      <td><img src="images/loading.gif" height="50px" alt=""></td>
                      <td><img src="images/loading.gif" height="50px" alt=""></td>
                      <td><img src="images/loading.gif" height="50px" alt=""></td>
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

<script src="js/restaurantdetails.js" type="module"></script>
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
	
	get(child(databaseRef, 'Users/')).then((snapshot) =>{
		var content = "";
		$('#tabledata').html(content);
		snapshot.forEach(function(childsnapshot){
			//var category = childsnapshot.child("title").val();
			content += '<tr>';
			
				content += '<td><img src="'+childsnapshot.child("profilePicture").val()+'" alt="" height="50px"></td>';
			
				content += '<td>'+childsnapshot.child("fullName").val()+'</td>';
				content += '<td>'+childsnapshot.child("email").val()+'</td>';
				content += '<td>'+childsnapshot.child("gender").val()+'</td>';
				content += '<td>'+childsnapshot.child("date_of_birth").val()+'</td>';
				content += '<td>'+childsnapshot.child("phoneNumber").val()+'</td>';
				content += '<td>'+childsnapshot.child("userName").val()+'</td>';
				content += '<td class="text-center"><a href="viewuser.php?userid='+childsnapshot.key+'"  class="btn btn-success"> View </a></td>';
			
				
				
			content += '</tr>'
		});
		$('#tabledata').append(content);
	});
	function deleteProduct(id)
    {
		
        if (confirm('Are you sure you want to Delete this Product?')) {
            
            var rCategory = databaseRef.child("Items/"+id);
            rCategory.remove();
            location.reload();
        } else {
            
        }
    }
    
</script>

</body>

</html>
<?php 
} else {
    header("location:login.php");
    exit;
  }
?>