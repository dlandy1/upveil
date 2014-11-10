// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
// = require bootstrap-sprockets
// = require bootstrap
//= require jquery_ujs
//= require_tree .
//= require jquery.infinitescroll

 jQuery(document).ready(function () {
        $('select[data-option-dependent=true]').each(function (i) {
            var observer_dom_id = $(this).attr('id');
            var observed_dom_id = $(this).data('option-observed');
            var url_mask = $(this).data('option-url');
            var key_method = $(this).data('option-key-method');
            var value_method = $(this).data('option-value-method');
            var prompt = $(this).has("option[value='']").size() ? $(this).find("option[value='']") : $('<option value=\"\">').text('Select a subcategory');
            var regexp = /:[0-9a-zA-Z_]+:/g;
            var observer = $('select#' + observer_dom_id);
            var observed = $('#' + observed_dom_id);

            if (!observer.val() && observed.size() > 1) {
                observer.attr('disabled', true);
            }
            observed.on('change', function () {
                observer.empty().append(prompt);
                if (observed.val()) {
                    url = url_mask.replace(regexp, observed.val());
                    $.getJSON(url, function (data) {
                        $.each(data, function (i, object) {
                            observer.append($('<option>').attr('value', object[key_method]).text(object[value_method]));
                            observer.attr('disabled', false);
                        });
                    });
                }
            });
        });
    $('product[category_id] select').click(function () {
    if ($(this).val() === '2') {
        $(".fash").show();
    }
})


    $(".male").on("click", function(){
         $(".male").css('background-color', 'rgb(249, 220, 73)');
         $(".female").css('background-color', 'white');
         $(".females").hide();
         $(".males").show();
     })
    $(".female").on("click", function(){
         $(".male").css('background-color', 'white');
         $(".female").css('background-color', 'rgb(249, 220, 73)');
         $(".males").hide();
         $(".females").show();
     })
    
    $(".newer").on("click", function(){
         $(".newer").hide();
         $(".hoter").show();
     })
    $(".hoter").on("click", function(){
         $(".hoter").hide();
         $(".newer").show();
     })
  var content = $('#page');    // where to load new content
  var viewMore = $('#view-more'); // tag containing the "View More" link

  var isLoadingNextPage = false;  // keep from loading two pages at once
  var lastLoadAt = null;          // when you loaded the last page
  var minTimeBetweenPages = 5000; // milliseconds to wait between loading pages
  var loadNextPageAt = 1000;      // pixels above the bottom

  var waitedLongEnoughBetweenPages = function() {
    return lastLoadAt == null || new Date() - lastLoadAt > minTimeBetweenPages;
  }

  var approachingBottomOfPage = function() {
    return document.documentElement.clientHeight +
        $(document).scrollTop() < document.body.offsetHeight - loadNextPageAt;
  }

  var nextPage = function() {
    var url = viewMore.find('a').attr('href');

    if (isLoadingNextPage || !url)
      return;

    viewMore.addClass('loading');
    isLoadingNextPage = true;
    lastLoadAt = new Date();

    $.ajax({
      url: url,
      method: 'GET',
      dataType: 'script',
      success: function() {
        viewMore.removeClass('loading');
        isLoadingNextPage = false;
        lastLoadAt = new Date();
      }
    })
  };

  // watch the scrollbar
  $(window).scroll(function() {
    if (approachingBottomOfPage() && waitedLongEnoughBetweenPages()) {
      nextPage();
    }
  });

  // failsafe in case the user gets to the bottom
  // without infinite scrolling taking affect.
  viewMore.find('a').click(function(e) {
    nextPage();
    e.preventDefaults();
  })
    });
    





