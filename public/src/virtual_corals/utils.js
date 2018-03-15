/*
    Promise wrapper around XMLHttpRequest
*/
function request_promise(url, method, responseType) {
    return new Promise(function (resolve, reject) {
        var xhr = new XMLHttpRequest();
        xhr.open(method, url, true);
        xhr.responseType = responseType
        xhr.onload = function () {
            if (this.status >= 200 && this.status < 300) {
                resolve(xhr.response);
            } else {
                reject({
                    status: this.status,
                    statusText: xhr.statusText
                });
            }
        };
        xhr.onerror = function () {
            reject({
                status: this.status,
                statusText: xhr.statusText
            });
        };
        xhr.send();
    });
}

/*
    Load typed array from URL.
*/
function array_promise(url, arraytype) {
    return new Promise(function (resolve, reject) {
        request_promise(url, 'GET', 'arraybuffer').then(function(response) {
            resolve(new arraytype(response))
        }).catch(reject)
    })
}
