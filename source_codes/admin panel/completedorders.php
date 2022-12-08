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
			
          <h1 class="h3 mb-2 text-gray-800">All Delivered Orders</h1>
          
          
          
          
          <!-- DataTales Example -->
          <div class="card shadow mb-4">
            <div class="card-header py-3">
              <h6 class="m-0 font-weight-bold text-primary">Orders Record</h6>
            </div>
            <div class="card-body">
             
            
             
              <div class="table-responsive">
                <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
                  <thead>
                    <tr>
                      <th>Orderid</th>
                      <th>Status</th>
					  <th>Order Time</th>
					  <th>Order Date</th>
					  <th>Price</th>
                      <th>View</th>
                      <th>Delete</th>
                    </tr>
                  </thead>
                  <tfoot>
                    <tr>
                      <th>Orderid</th>
                      <th>Status</th>
					  <th>Order Time</th>
					  <th>Order Date</th>
					  <th>Total Bill</th>
                      <th>View</th>
                      <th>Delete</th>
                    </tr>
                  </tfoot>
                  
                  
                  
                  <tbody id="tabledata">
                    
                  <tr class="text-center">
                      
                      <td class="" ><img src="images/loading.gif" height="50px" alt=""></td>
                      <td class="" ><img src="images/loading.gif" height="50px" alt=""></td>
                      <td class="" ><img src="images/loading.gif" height="50px" alt=""></td>
                      <td class="" ><img src="images/loading.gif" height="50px" alt=""></td>
                      <td class="" ><img src="images/loading.gif" height="50px" alt=""></td>
                      
                      
                      <td class="text-center"><a href="vieworder.php?orderid=<?php echo $record['id']?>" id=""  class="btn btn-info"> View </a></td>
                   
                      <td class="text-center"><a href="delete.php?productid=<?php echo $record['id']?>" id=""  class="btn btn-danger" onClick="return confirm('Are you sure you want to delete record?')">Delete </a></td>
                      
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
	
	
	get(ref(database, 'Delivered_Orders/')).then((snapshot) =>{
		var content = "";
		$('#tabledata').html(content);
		snapshot.forEach(function(childsnapshot){
			
			
			
			var timestamp =  childsnapshot.child("timeRequested").val();
			//let timestamp =  1594032390;
			
			
			
			var months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
			var ts = new Date(timestamp*1);
			var o_date = ts.getDate();
			var o_year = ts.getFullYear();
  			var o_month = months[ts.getMonth()];
  			var o_hour = ts.getHours();
  			var o_min =ts.getMinutes();
			//var category = childsnapshot.child("title").val();
			content += '<tr>';
			
				content += '<td>'+childsnapshot.child("orderId").val()+'</td>';
				content += '<td>'+childsnapshot.child("status").val()+'</td>';
				content += '<td>'+o_hour+":"+o_min+'</td>';
				content += '<td>'+o_date+"-"+o_month+"-"+o_year+'</td>';
				content += '<td>'+childsnapshot.child("totalPrice").val()+'</td>';
				
				content += '<td class="text-center"><a href="vieworder.php?orderid='+childsnapshot.key+'"  class="btn btn-success"> View </a></td>';
			
			
				content += '<td class="text-center"><button type="button" id="delete" class="btn btn-danger" value='+childsnapshot.key+'>Delete </button></td>';
				content += '';
				
			content += '</tr>'
		});
		$('#tabledata').append(content);
		$("#delete").on('click', function(){
			if (confirm('Are you sure you want to Delete this Product?')) {
				var dataid = $(this).attr("value");
				remove(child(databaseRef, 'Delivered_Orders/'+dataid)).then(()=>{
					location.reload();
				});
			}
		});	
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