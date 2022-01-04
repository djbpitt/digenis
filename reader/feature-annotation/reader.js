"use strict";
/*
 * Word-level annotations at bottom are controlled by js
 * Highlighting by feature is also controlled by js
 * Popup in-place annotations and fly-out menu overlay are pure css
 */
window.addEventListener('DOMContentLoaded', function () {
  /* All words show grammar at bottom on mouseover */
  const ws = document.querySelectorAll('.w');
  ws.forEach(w => w.addEventListener('mouseover', grammar, false));
  /* Radio buttons highlight by category */
  const radios = document.querySelectorAll('input[type="radio"]');
  radios.forEach(radio => radio.addEventListener('change', highlight, false));
},
false);
function grammar(event) {
  hide_grammars();
  document.getElementById('grammar-' + this.firstElementChild.innerText).style.display = 'block';
}
function hide_grammars() {
  Array. from (document.getElementsByClassName('grammar')).forEach((element) => {
    element.style.display = 'none';
  });
}
function highlight() {
  var targets;
  /* dereference targets, then highlight */
  switch (this.id.normalize()) {
    case 'adjective':
    targets = document.querySelectorAll('.adjective');
    break;
    case 'poss_adj':
    targets = document.querySelectorAll('.adjective.poss');
    break;
    case 'noun':
    targets = document.querySelectorAll('.noun');
    break;
    case 'jo-ja':
    targets = document.querySelectorAll('.jo, .ja');
    break;
    case 'minor':
    targets = document.querySelectorAll('.noun.i, .noun.u, .noun.s, .noun.t, .noun.n, .noun.r, .noun.nt, .noun.u-long');
    break;
    case 'verb':
    targets = document.querySelectorAll('.verb');
    break;
    case 'pt':
    targets = document.querySelectorAll('.aor, .ipf, .impf_aor');
    break;
    case 'pf':
    targets = document.querySelectorAll('.pf, .cond, .pf_neg');
    break;
    case 'I':
    targets = document.querySelectorAll('.I');
    break;
    case 'IV':
    targets = document.querySelectorAll('.IVA, .IVB');
    break;
    case 'V':
    targets = document.querySelectorAll('.V');
    break;
    case 'participle':
    targets = document.querySelectorAll('.participle');
    break;
    case 'pronoun':
    targets = document.querySelectorAll('.pronoun');
    break;
    case 'pers':
    targets = document.querySelectorAll('.pronoun.pers');
    break;
    case 'poss_pron':
    targets = document.querySelectorAll('.pronoun.poss');
    break;
    case 'dem':
    targets = document.querySelectorAll('.pronoun.dem');
    break;
    case 'interrog':
    targets = document.querySelectorAll('.pronoun.interrog');
    break;
    case 'rel':
    targets = document.querySelectorAll('.pronoun.rel');
    break;
    case 'adverb':
    targets = document.querySelectorAll('.adverb');
    break;
    case 'number':
    targets = document.querySelectorAll('.number');
    break;
    case 'dual':
    targets = document.querySelectorAll('.du');
    break;
    default:
    targets = null;
    break;
  }
  /* Unhighlight everything, then highlight targets */
  document.querySelectorAll('.w').forEach((t) => t.classList.remove('highlight'));
  if (targets) {
    targets.forEach((t) => t.classList.add('highlight'));
  }
}