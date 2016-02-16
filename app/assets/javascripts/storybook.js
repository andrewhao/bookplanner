(function($) {
  $(document).on("page:update", function() {
    $('.table').tablesorter({
      theme: "bootstrap",
      headerTemplate: '{content} {icon}',
      cssIconAsc: "glyphicon glyphicon-chevron-up",
      cssIconDesc: "glyphicon glyphicon-chevron-down",
      cssIconNone: "glyphicon glyphicon-sort",
    });

    $('a[disabled=disabled]').on('click', function(e) {
      e.preventDefault();
      e.stopPropagation();
    });
  });

  $(document).on('click', 'a', function(e) {
    var $link = $(e.target);
    var hasDisabledParent = $link.closest('.disabled').length > 0
    var isDisabledElement = $link.is('[disabled=disabled]');
    if (hasDisabledParent || isDisabledElement) {
      e.preventDefault();
      e.stopPropagation();
    }
  });
})(jQuery)
