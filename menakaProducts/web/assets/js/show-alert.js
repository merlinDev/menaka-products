
function showAlert(note) {
    switch (note) {
        case "added@cart" :
            Snackbar.show({text: 'product added to cart',
                pos: 'bottom-right', showAction: false,
                backgroundColor: 'yellowgreen', duration: 3000});
            break;

        case "qty@0" :
            Snackbar.show({text: 'quantity not available',
                pos: 'bottom-right', showAction: false,
                backgroundColor: 'red', duration: 3000});
            break;

        case "input@0" :
            Snackbar.show({text: 'inputs are wrong',
                pos: 'bottom-right', showAction: false,
                backgroundColor: 'red', duration: 3000});
            break;

        case "inv@close" :
            Snackbar.show({text: 'delivery marked done',
                pos: 'bottom-right', showAction: false,
                backgroundColor: 'green', duration: 3000});
            break;

        case "nophoto" :
            Snackbar.show({text: 'upload customer signed invoice first',
                pos: 'bottom-right', showAction: false,
                backgroundColor: 'red', duration: 3000});
            break;

        case "qty@updated" :
            Snackbar.show({text: 'cart quantity updated',
                pos: 'bottom-right', showAction: false,
                backgroundColor: 'green', duration: 3000});
            break;

        case "max@4" :
            Snackbar.show({text: 'you can only buy 4 packages from each package.',
                pos: 'bottom-right', showAction: false,
                backgroundColor: 'red', duration: 3000});
            break;

        case "min@0" :
            Snackbar.show({text: 'inputs are wrong',
                pos: 'bottom-right', showAction: false,
                backgroundColor: 'red', duration: 3000});
            break;

        case "password@1" :
            Snackbar.show({text: 'password changed',
                pos: 'bottom-right', showAction: false,
                backgroundColor: 'green', duration: 3000});
            break;

        case "location@1" :
            Snackbar.show({text: 'loation changed',
                pos: 'bottom-right', showAction: false,
                backgroundColor: 'green', duration: 3000});
            break;

        case "location@0" :
            Snackbar.show({text: 'please select a delivery location',
                pos: 'bottom-right', showAction: false,
                backgroundColor: '#d35400', duration: 3000});
            break;

        case "zip@0" :
            Snackbar.show({text: 'plese enter a valid zipcode',
                pos: 'bottom-right', showAction: false,
                backgroundColor: '#e67e22', duration: 3000});
            break;

        case "removed@1" :
            Snackbar.show({text: 'item removed',
                pos: 'bottom-right', showAction: false,
                backgroundColor: '#d35400', duration: 3000});
            break;

        case "location@saved" :
            Snackbar.show({text: 'location saved',
                pos: 'bottom-right', showAction: false,
                backgroundColor: 'green', duration: 3000});
            break;

        case "error@1" :
            Snackbar.show({text: 'something went wrong. plesase try again',
                pos: 'bottom-right', showAction: false,
                backgroundColor: 'red', duration: 3000});
            break;


        default :
            Snackbar.show({text: note,
                pos: 'bottom-right', showAction: false,
                backgroundColor: '#e67e22', duration: 3000});
            break;

    }

    return true;
}