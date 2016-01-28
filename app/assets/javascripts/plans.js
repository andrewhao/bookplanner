$(document).on("page:update", function() {
  $('body').on('change', '[js-validate-dedupe]', function(e) {
    $formEl = $(e.currentTarget);
    ValidationDeduper.updateFormState($formEl);
  });

  $('body').on('submit', '[js-validate-dedupe]', function(e) {
    var $form = $(e.target);
    ValidationDeduper.updateFormState($form);

    if (!ValidationDeduper.isValid($form)) {
      alert('There are duplicate book bags in this plan. Please fix them before proceeding.');
      e.stopPropagation();
      e.preventDefault();
    }
  });
});
