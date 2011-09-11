// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//

/*
 * returns unescaped html string from value passed in.
 *
 * value - escaped html string value
 */
function htmlSafe(value) {
  return $('<div>' + value + '</div>').html();
}

/*
 * translates given text value from original language to new language and
 * displays translation in provided element.
 *
 * element - the element which the translated text should be displayed in (e.g. input element)
 * text - the text to be translated
 * fromLang - the locale/language that represents the text parameter (e.g. en)
 * toLang - the locale/language the text should be translated to (e.g. es)
 */
function translate(element, text, fromLang, toLang) {
  var $element = $(element);
  
  google.language.translate(text.trim(), fromLang, toLang, function(result) {
    var translatedText = (result.error) ? '' : htmlSafe(result.translation);
    
    if ($element.is(':input'))
      $element.val(translatedText);
    else
      $element.html(translatedText);
  });
}

$(document).ready(function() {
  $('div.translation a').click(function() {
    var $parent = $(this).parents('div.translation');
    var $input = $(':input', $parent);
    
    var textToTranslate = $('p.translation-text', $parent).html(); 
    var fromLang = $('#from_locale').val();
    var toLang = $('#to_locale').val();
    
    translate($input, textToTranslate, fromLang, toLang);
  });
  
  $('div.translation').hover(
    function() {
      $(this)
        .addClass('selected')
        .children('.translation-text')
        .addClass('focus-text');
    },
    function() {
      $(this)
        .removeClass('selected')
        .children('.translation-text')
        .removeClass('focus-text');
    }
  );
});
