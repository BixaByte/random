
      
      <ul class="navbar-nav bg-gradient-primary sidebar sidebar-dark accordion" id="accordionSidebar">

      <!-- Sidebar - Brand -->
      <a class="sidebar-brand d-flex align-items-center justify-content-center" href="index.php">
        <div class="sidebar-brand-icon rotate-n-15">
          <i class="fa fa-hamburger"></i>
        </div>
        <div class="sidebar-brand-text mx-3">Foodizm Flutter</div>
      </a>

      <!-- Divider -->
      <hr class="sidebar-divider my-0">

      <!-- Nav Item - Dashboard -->
      <li class="nav-item <?php if($pagename=="dashboard"){echo "active";} ?>">
        <a class="nav-link" href="index.php">
          <i class="fas fa-fw fa-tachometer-alt"></i>
          <span>Dashboard</span></a>
      </li>
      <li class="nav-item <?php if($pagename=="restaurants"){echo "active";} ?>">
        <a class="nav-link" href="restaurants.php">
          <i class="fas fa-fw fa-hotel"></i>
          <span>Restaurant</span></a>
      </li>
      
      
       <hr class="sidebar-divider">
      <div class="sidebar-heading">
        Orders
      </div>
      <li class="nav-item <?php if($pagename=="neworders"){echo "active";} ?>">
        <a class="nav-link" href="neworders.php">
          <i class="fas fa-fw fa-shopping-cart"></i>
          <span>New Orders</span></a>
      </li>
      <li class="nav-item <?php if($pagename=="ontheway"){echo "active";} ?>">
        <a class="nav-link" href="ordersontheway.php">
          <i class="fas fa-fw fa-shopping-cart"></i>
          <span>On the Way Orders</span></a>
      </li>
	<li class="nav-item <?php if($pagename=="delivered"){echo "active";} ?>">
        <a class="nav-link" href="deliveredorders.php">
          <i class="fas fa-fw fa-shopping-cart"></i>
          <span>Delivered Orders</span></a>
      </li>
      <li class="nav-item <?php if($pagename=="orders"){echo "active";} ?>">
        <a class="nav-link" href="completedorders.php">
          <i class="fas fa-fw fa-shopping-cart"></i>
          <span>Completed Orders</span></a>
      </li>
      

      <!-- Divider -->
      <hr class="sidebar-divider">

 
      <!-- Heading -->
      <div class="sidebar-heading">
        Users
      </div>

     <!-- Nav Item - Classes -->
      <li class="nav-item <?php if($pagename=="users"){echo "active";} ?>">
        <a class="nav-link" href="users.php">
          <i class="fas fa-fw fa-users"></i>
          <span>All Users</span></a>
      </li>
      
      
      
      <hr class="sidebar-divider">
      <div class="sidebar-heading">
        Food
      </div>
     
       <li class="nav-item <?php if($pagename=="foodcategories"){echo "active";} ?>">
        <a class="nav-link" href="foodcategories.php">
          <i class="fas fa-fw fa-apple-alt"></i>
          <span>Food Categories</span></a>
      </li>
      
      <li class="nav-item <?php if($pagename=="products"){echo "active";} ?>">
        <a class="nav-link" href="products.php">
          <i class="fas fa-fw fa-shopping-cart"></i>
          <span>Products</span></a>
      </li>
      <li class="nav-item <?php if($pagename=="deals"){echo "active";} ?>">
        <a class="nav-link" href="deals.php">
          <i class="fas fa-fw fa-percent"></i>
          <span>Deals</span></a>
      </li>
      

      <!-- Sidebar Toggler (Sidebar) -->
      <div class="text-center d-none d-md-inline">
        <button class="rounded-circle border-0" id="sidebarToggle"></button>
      </div>

    </ul>