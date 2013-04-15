$.domReady(function() {
  $("#namespaces ul li").on("click", function(e) {
    e.preventDefault();
    e.stopPropagation();
    $(this).children("ul").toggleClass("view");
  });
  $("#namespaces ul li .display").on("click", function(e) {
    e.preventDefault();
    e.stopPropagation();
    filter = $(this).data("id");
    alert(filter);
  });
  $("#namespaces ul li.item").on("click", function(e) {
    e.preventDefault();
    e.stopPropagation();
    filter = $(this).data("id");
    alert(filter);
  });

});