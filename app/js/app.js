var userLoginSelections = function (ids, userId) {
  console.log(userId)
    $.ajax({
        url: '/image_check',
        method: 'POST',
        data: {
          authSelections: ids,
          userId: userId
        },
        success: function(){
          window.location = '/success'
        },
        error: function () {
          triggerAlert('<p>That was the wrong items or order</p>')
        }
    });
};

var createUserRequest = function (username, imageIds) {
  $.ajax({
    method: 'POST',
    url: '/user/create',
    data: {
      username: username,
      imageIds: imageIds
    }
  }).then(function(resp) {
    console.log('happy')
  }, function(err) {
    console.log('sad')
  });
}

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

var persistSelectedItemsInPreview = function (selections) {
  var imgs = ''
  selections.forEach(function (i){
    imgs += '<img style="width:20px;height:20px" src=' + i.src + '/>';
  });
  selected('<div>Your selected images:<br/> ' + imgs + '</div>' );
};

var updateCountForProgessTacker = function (selections) {
  $('#progress').text(selections.length);
}

$( document ).ready(function() {
  var selections = [];

  $('#submit-signup').on('click', function (e) {
    e.preventDefault();
    createUserRequest($('#signup-un').val(), getIds(selections))
    selections = [];
  });

  $('img.login, img.signup').on('click', function (e) {
    var id = $(this).attr('id');
    var src = $(this).attr('src');

    // Checking if selection is a dupicate
    if (getIds(selections).indexOf(id) === -1 ) {
      // If NOT duplicate
      selections.push({id: id, src: src});
      persistSelectedItemsInPreview(selections);
    } else {
      // If IS duplicate
      triggerAlert('<p>You have already selected this image.<p>')
    }

    updateCountForProgessTacker(selections);

    // WHEN selections is length 5 we need to handle the ids
    var path = window.location.pathname;
    if (selections.length === 5 && path === '/signin/images') {
      userLoginSelections(getIds(selections), $('#user').attr('data-id'));
      selections = [];
    }

  });
});
