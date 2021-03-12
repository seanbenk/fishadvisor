formMessage = document.querySelector('#form-message');
formValues = document.querySelectorAll('FORM INPUT');

function isValidEntry(){
    for (let i = 0; i < formValues.length; i++){
        if (formValues[i].value == ''){
            formMessage.innerHTML = 'please enter all fields'
            return false;
        }
    }
}