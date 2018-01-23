$(document).ready(function() {
  function toggleSidebar() {
    $(".sidebar-button").toggleClass("active");
    $(".sidebar").toggleClass("move-to-left");
    $(".sidebar-item").toggleClass("active");
  }
  $(".sidebar-button").on("click tap", function() {
    toggleSidebar();
  });
});
