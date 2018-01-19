const loginFailed = $('.login')[0].dataset.loginFailed;

showSuccessAnime = () => {
  $(this).find(".submit i").removeAttr('class').addClass("fa fa-check").css({"color":"#fff"});
  $(".submit").css({"background":"#2ecc71", "border-color":"#2ecc71"});
  $(".feedback-success").show().animate({"opacity":"1", "bottom":"-80px"}, 400);
  $("input").css({"border-color":"#2ecc71"});
}

showFailureAnime = () => {
  $(this).find(".submit i").removeAttr('class').addClass("fa fa-times").css({"color":"#fff"});
  $(".submit").css({"background":"#ff4444", "border-color":"#ff4444"});
  $(".feedback-success")
  .html("Login failed<br />Incorrect email or password")
  .removeClass('feedback-success')
  .addClass('feedback-fail')
  .show()
  .animate({"opacity":"1", "bottom":"-80px"}, 400);
  $("input").css({"border-color":"#ff4444"});
}

if (loginFailed) {
  showFailureAnime();
}

$( ".input" ).focusin(function() {
  $( this ).find( "span" ).animate({"opacity":"0"}, 200);
});

$( ".input" ).focusout(function() {
  $( this ).find( "span" ).animate({"opacity":"1"}, 300);
});

// $(".login").submit(function(event){
//   event.preventDefault();
//   const pwd = $('#pwd')[0].value;
//   const email = $('#email')[0].value;
//
//   $.ajax ({
//     type: "POST",
//     url: '/login',
//     async: 'false',
//     data: {email: email, password: pwd},
//     success: function(response){
//       if (response) {
//         showSuccessAnime();
//       } else {
//         showFailureAnime();
//       }
//     }
//   });
//
// });
