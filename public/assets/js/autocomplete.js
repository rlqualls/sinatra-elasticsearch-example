$(document).ready(function(){
  $('#search-form').submit(false);

  $("#title").keyup(function(){

    var filter = $(this).val();
    var movies = [];
    $.post( '/api/movie_search', { title: filter }).then(function (response) {
      movies = JSON.parse(response);
      $('#movies').empty();

      movies.forEach(function (item) {
        $("#movies").append("<div class='autococomplete-suggestion'>" + item + '</div>');
      });
    });
  });
});
