(function($) {
  $(document).on("page:update", function() {
    $('.table').tablesorter({
      theme: "bootstrap",
      headerTemplate: '{content} {icon}',
      cssIconAsc: "glyphicon glyphicon-chevron-up",
      cssIconDesc: "glyphicon glyphicon-chevron-down",
      cssIconNone: "glyphicon glyphicon-sort",
    });
  });
})(jQuery)
