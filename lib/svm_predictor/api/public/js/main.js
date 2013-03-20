// ICanHaz / Mustache Templates loaded
$.getJSON('/templates.json', function(templates){
  $.each(templates, function (i,template) {
    ich.addTemplate(template.name, template.template);
  });
  $(window).trigger('templates-loaded');
});

// Helper to properly serialize a from
$.fn.serializeObject = function()
{
    var o = {};
    var a = this.serializeArray();
    $.each(a, function() {
        if (o[this.name] !== undefined) {
            if (!o[this.name].push) {
                o[this.name] = [o[this.name]];
            }
            o[this.name].push(this.value || '');
        } else {
            o[this.name] = this.value || '';
        }
    });
    return o;
};


$(window).on('templates-loaded', function(){
  $(".main-container").replaceWith(ich.main())
  $.getJSON('/settings.json', function(settings) {
    $('#settings').replaceWith(ich.settings(settings));
  })
  $('form').submit(function() {
    $.post('/predict', JSON.stringify($("form").serializeObject()), function(data){
      $('#results').replaceWith(ich.results(data));
    });
    return false;
  });
});