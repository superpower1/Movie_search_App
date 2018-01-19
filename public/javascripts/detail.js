const userId = $('main.container')[0].dataset.userId;
const movieId = $('main.container')[0].dataset.movieId;

$("#like-btn").click(function(){
  $.ajax({
    url:"/session",
    success: function(response){
      const result = $.parseJSON(response);
      console.log(result.login);
      if (result.login) {
        sendRequest("/like");
        if ($('#like-btn>i').hasClass('fa-heart')) {
          $('#like-btn>i').removeClass('fa-heart').addClass('fa-heart-o');
        } else {
          $('#like-btn>i').removeClass('fa-heart-o').addClass('fa-heart');
        }
      } else {
        showAlert();
      }
    }
  });
});

$("#save-btn").click(function(){
  $.ajax({
    url:"/session",
    success: function(response){
      const result = $.parseJSON(response);
      console.log(result.login);
      if (result.login) {
        sendRequest("/save");
        if ($('#save-btn>i').hasClass('fa-bookmark')) {
          $('#save-btn>i').removeClass('fa-bookmark').addClass('fa-bookmark-o');
        } else {
          $('#save-btn>i').removeClass('fa-bookmark-o').addClass('fa-bookmark');
        }
      } else {
        showAlert();
      }
    }
  });
});

$("#share-btn").click(function(){

});

$('.popup-close').click(function(e) {
  $('.popup-wrap').fadeOut(500);
  $('.popup-box').removeClass('transform-in').addClass('transform-out');
  e.preventDefault();
});

showAlert = () => {
  $('.popup-wrap').fadeIn(250);
  $('.popup-box').removeClass('transform-out').addClass('transform-in');
}

sendRequest = (url) => {
  $.ajax ({
    type: "POST",
    url: url,
    data: {user_id: userId, movie_id: movieId},
    success: function(response){
        console.log(response);
        }
    });
}
