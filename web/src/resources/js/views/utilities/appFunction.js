export default class appFunction {
    static baseUrl() {
        const app_url = window.localStorage.getItem('base_url');
        return app_url || window.location.origin;
    }

    static getAppUrl(path) {
        return `${this.baseUrl()}/${path}`;
    }

    static getQueryStringValue(key) {
        const urlParams = new URLSearchParams(window.location.search);
        return urlParams.get(key);
    }

    static isFunction(func) {
        return typeof func === "function";
    }

    static isUndefined(obj) {
        return typeof obj === "undefined";
    }

    static splitNameBySlas(item) {

        if (item.includes("/")) {

            let itemArr = item.split("/");
            return itemArr[itemArr.length - 1];
        }
        return item;
    }
}
