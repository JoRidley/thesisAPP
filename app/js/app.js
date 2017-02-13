var userSelections = function (ids, userId) {
    $.ajax({
      url: '/image_check',
      method: 'POST',
      data: {authSelections: ids, userId: userId}
    }).then(function (err, result) {
      if (err) {
        throw('oh know!')
        console.log('alskd');
      }
      console.log(result);
    });
};

var triggerAlert = function (html) {
  $('.alert')
    .html(html)
    .fadeIn('fast', function () {
      setTimeout(function() {
        $('.alert').fadeOut('fast');
      }, 2000)
    });
};

var selected = function (html) {
  $('.selected')
    .html(html)
};

var getIds = function (selections) {
  return selections.map(function(s){return s.id;});
}

$( document ).ready(function() {
  var selections = [];
  $('img').on('click', function (e, item) {
    var id = $(this).attr('id');
    var src = $(this).attr('src');

    var selectionIds = getIds(selections);
    if (selectionIds.indexOf(id) === -1 ) {
      selections.push({id: id, src: src})
      var imgs = ''
      selections.forEach(function (i){
        imgs += '<img style="width:20px;height:20px" src=' + i.src + '/>';
      });
      selected('<div>Your selected images:<br/> ' + imgs + '</div>' );
    } else {
      triggerAlert('<p>You have already selected this image.<p>')
    }

    $('#progress').text(selections.length)

    if (selections.length === 5) {
      userSelections(getIds(selections), $('#user').attr('data-id'));
      selections = [];
    }
  });
});
