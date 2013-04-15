$.domReady(function() {
  function getFocus() {
    url = window.location.href;
    m = url.indexOf("key_pattern");
    if (m !== -1) {
      focus = url.slice(url.indexOf("=", m)+1, url.indexOf("&", m));
    } else {
      focus = false;
    }
    return focus;
  }
  function openNav(focus) {
    if (focus) {
      if (focus === '.') {
        items = ['.'];
      } else if (!focus.indexOf('.')) {
        items = ['ROOT',focus];
      } else {
        items = focus.split(/\./);
      }
      namespace = [];
      while (it = items.shift()) {
        namespace.push(it);
        join = namespace.join('.');
        it = $("#namespaces span[data-id='"+join+"']");
        if (it.length > 0) {
          $(it.selector).siblings("ul").toggleClass("view");
        }
      }
    }
    return;
  }
  var focus = getFocus();
  openNav(focus);
  function filterThat(s,start) {
    if (start) {
      $("#key_type").val("starts_with");
    } else {
      $("#key_type").val("contains");
    }
    $("#key_pattern_value").val(s);
    document.forms['filter_form'].submit();
  }
  $("#namespaces ul li").on("click", function(e) {
    e.preventDefault();
    e.stopPropagation();
    $(this).children("ul").toggleClass("view");
  });
  $("#namespaces ul li .display").on("click", function(e) {
    e.preventDefault();
    e.stopPropagation();
    filter = $(this).data("id");
    filterThat(filter,true);
  });
  $("#namespaces ul li.item").on("click", function(e) {
    e.preventDefault();
    e.stopPropagation();
    filter = $(this).data("id");
    filterThat(filter,false);
  });

});