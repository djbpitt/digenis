"use strict";
window.addEventListener('DOMContentLoaded', function () {
  const annotations = document.getElementsByClassName('note');
  for (var i = 0, len = annotations.length; i < len; i++) {
    annotations[i].addEventListener('mouseover', overlay, false);
    annotations[i].addEventListener('mouseout', clear, false);
  }
  const ws = document.getElementsByClassName('w');
  for (var i = 0, len = ws.length; i < len; i++) {
    ws[i].addEventListener('mouseover', grammar, false);
  }
},
false)
function overlay(event) {
  this.getElementsByClassName('annotation')[0].style.visibility = 'visible';
}
function clear(event) {
  this.getElementsByClassName('annotation')[0].style.visibility = 'hidden';
}
function grammar(event) {
  hide_grammars();
  document.getElementById('grammar-' + this.firstElementChild.innerText).style.display = 'block';
}
function hide_grammars() {
  Array. from (document.getElementsByClassName('grammar')).forEach((element) => {
    element.style.display = 'none';
  });
}
