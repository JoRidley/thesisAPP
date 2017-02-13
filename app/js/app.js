var userSelections = function (ids) {
    $.ajax({
      url: '/accept',
      method: 'POST',
      data: {authSelections: ids}
    }).then(function (err, result) {
      if (err) {
        throw('oh know!')
        console.log('alskd');
      }
      console.log(result);
    });
};

$( document ).ready(function() {
  var selections = [];
  $('img').on('click', function (e, item) {
    var id = $(this).attr('id');
    selections.push(id)
    console.log(selections);
    if (selections.length === 5) {
      userSelections(selections);
    }
  });
});
