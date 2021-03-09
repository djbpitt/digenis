window.addEventListener('DOMContentLoaded', function () {
    var annotations = document.getElementsByClassName('note');
    for (i = 0, len = annotations.length; i < len; i++) {
        annotations[i].addEventListener('mouseover', overlay, false);
        annotations[i].addEventListener('mouseout', clear, false);
    };
},
false)
function overlay(event) {
    this.getElementsByClassName('annotation')[0].style.visibility = 'visible';
}
function clear(event) {
    this.getElementsByClassName('annotation')[0].style.visibility = 'hidden';
}