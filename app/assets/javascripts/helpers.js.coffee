do ($=jQuery) ->
  $(document).on("page:update", ->
    $('form :input:visible').first().focus()
  )

