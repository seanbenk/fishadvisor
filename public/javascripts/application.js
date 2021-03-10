hamburgerIcon = document.querySelector('.hamburger');

hamburgerIcon.addEventListener('click', function (){
    console.log('test')
    document.querySelector('UL').classList.toggle('show-menu');
    hamburgerIcon.classList.toggle('toggle');
});
