window.addEventListener('DOMContentLoaded', init, false);
function init() {
    var checkboxes = document.querySelectorAll('input');
    for (var i = 0, length = checkboxes.length; i < length; i++) {
        checkboxes[i].addEventListener('click', columnToggle, false);
    }
    var control = document.querySelectorAll('#controls')[0];
    control.addEventListener('mouseover', controlToggle, true);
    control.addEventListener('mouseout', controlToggle, true);
}
function columnToggle() {
    // this.checked will have the value after clicking
    var trigger = this.id;
    var target = trigger.slice(3);
    // console.log('Value after clicking is ' + this.checked);
    if (this.checked == true) {
        document.getElementById(target).style.display = 'block';
    } else {
        document.getElementById(target).style.display = 'none';
    }
}
function controlToggle() {
    console.log('hit');
    var labels = document.querySelectorAll('label');
    for (i = 0, length = labels.length; i < length; i++) {
        if (labels[i].style.display !== 'block') {
            labels[i].style.display = 'block';
        } else {
            labels[i].style.display = 'none';
        }
    }
}