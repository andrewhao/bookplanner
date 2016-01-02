var ValidationDeduper = {
  updateFormState: function($form) {
    var _selects = this.findSelects($form)
    var errorValues = this.findErrors($form).value()
    _selects
      .each(function(el) { el.parent().find('.validation-message').remove() })
      .filter(function(s) { return _.includes(errorValues, $(s).val()) })
      .each(function(el) {
        var errMessage = $('<span class="validation-message text-danger">This is a duplicate book bag.</span>');
        errMessage.insertAfter(el);
      })
      .value()
  },

  findSelects: function($form) {
    var $selects = $form.find('select');
    return _($selects).map($)
  },

  findErrors: function($form) {
    return this.findSelects($form)
      .map(function(s) { return [s, s.val()] })
      .countBy(function(arr) { return arr[1] })
      .pick(function(count, val) { return count > 1 })
      .keys()
  },

  isValid: function($form) {
    return this.findErrors($form).isEmpty()
  }
}
