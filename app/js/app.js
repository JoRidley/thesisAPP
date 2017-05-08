var userLoginSelections = function (ids, data) {
    $.ajax({
        url: '/image_check',
        method: 'POST',
        data: {
          authSelections: ids,
          userId: data.id,
          version: data.version
        },
        success: function(){
          window.location = '/success'
        },
        error: function () {
          triggerAlert('<p>That was the wrong items or order</p>')
        }
    });
};

var uniqueUser = function (username, imageIds, type, allIds) {
  $.ajax({
    method: 'POST',
    url: '/user/create',
    data: {
      username: username,
      imageIds: imageIds,
      type: type,
      allIds: JSON.stringify(allIds)
    },
    success: function(){
      window.location = '/survey'
    },
    error: function (a, b) {
      console.log('sad')
      console.log(a, b)
      triggerAlert('<p>Something went wrong</p>')
    }
  });
}

var createUserRequest = function (username, imageIds, type, allIds) {
  $.ajax({
    method: 'POST',
    url: '/api/username',
    data: {
      username: username,
    }, 
    success: function () {
      uniqueUser(username, imageIds, type, allIds);
    }, 
    error: function () {
      triggerAlert('<p>This username is already taken. Please select a different one.</p>')
    }

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
    imgs += '<img style="width:75px;height:75px" src=' + i.src + '/>';
  });
  selected('<div>Your selected images:<br/> ' + imgs + '</div>' );
};

var updateCountForProgessTacker = function (selections) {
  $('#progress').text(selections.length);
}

var toggleRemoveState = function (selections) {
  if (selections.length > 0) {
    $('.remove-last').show()
  } else {
    $('.remove-last').hide()
  }
};

$( document ).ready(function() {
  var selections = [];

  $('#submit-signup').on('click', function (e) {
    e.preventDefault();
    if (selections.length === 5) {
      createUserRequest(
        $('#signup-un').val(),
        getIds(selections), 
        $('.type').data('type'),
        $('.type').data('ids')
      );
      selections = []; 
    } else {
      triggerAlert('<p>Please select at least 5 images.</p>')
    }
  });

  $('.remove-last').on('click', function (e) {
    selections.splice((selections.length - 1), 1);
    persistSelectedItemsInPreview(selections);
    updateCountForProgessTacker(selections);
    toggleRemoveState(selections);
  });


  $('img.login, img.signup').on('click', function (e) {
    var id = $(this).attr('id');
    var src = $(this).attr('src');

    // Checking if selection is a dupicate
    if (getIds(selections).indexOf(id) === -1 ) {
      // If NOT duplicate
      selections.push({id: id, src: src});
      toggleRemoveState(selections)
      persistSelectedItemsInPreview(selections);
    } else {
      // If IS duplicate
      triggerAlert('<p>You have already selected this image.<p>')
    }

    updateCountForProgessTacker(selections);

    // WHEN selections is length 5 we need to handle the ids
    var path = window.location.pathname;
    if (selections.length === 5 && path === '/signin/images') {
      var $user = $('#user');
      var _data = { id: $user.attr('data-id'), version: $user.attr('data-version') };

      userLoginSelections(getIds(selections), _data);
      selections = [];
    }

  });
});
