import {defineAsyncComponent} from 'vue'

export const defineGlobalComponents = (app) => {
    app.component('app-button-loader', defineAsyncComponent(() => import("@/components/loader/buttonLoader.vue")));
    app.component('app-loader', defineAsyncComponent(() => import("@/components/loader/loaderSpin.vue")));
    app.component('app-delete-modal', defineAsyncComponent(() => import("@/components/modal/deleteModal.vue")));
    app.component('app-modal', defineAsyncComponent(() => import("@/components/modal/modal.vue")));
    app.component('app-input', defineAsyncComponent(() => import("@/components/input/FormInput.vue")));
    //Installer
    app.component('app-install', defineAsyncComponent(() => import("@/components/install/index.vue")));
    app.component('app-purchase-key', defineAsyncComponent(() => import("@/components/install/purchaseKey.vue")));
    app.component('app-environment-setup', defineAsyncComponent(() => import("@/components/install/environmentSetup.vue")));
    app.component('app-user-information', defineAsyncComponent(() => import("@/components/install/userInformation.vue")));
    app.component('app-company-setup', defineAsyncComponent(() => import("@/components/install/companySetup.vue")));
    app.component('app-email-setup', defineAsyncComponent(() => import("@/components/install/emailSetup.vue")));

    // Auth User
    app.component('app-logo', defineAsyncComponent(() => import("@/components/auth/header.vue")));
    app.component('app-auth-footer', defineAsyncComponent(() => import("@/components/auth/footer.vue")));
    app.component('app-login', defineAsyncComponent(() => import("@/components/auth/login.vue")));
    app.component('app-forget-password', defineAsyncComponent(() => import("@/components/auth/forgetPassword.vue")));
    app.component('app-reset-password', defineAsyncComponent(() => import("@/components/auth/resetPassword.vue")));
    app.component('app-join-user', defineAsyncComponent(() => import("@/components/auth/joinUser.vue")));



    //App Components
    app.component('app-settings', defineAsyncComponent(() => import("@/components/setting/index.vue")));
    app.component('app-email-setting', defineAsyncComponent(() => import("@/components/setting/emailSetting.vue")));
    app.component('app-privacy-and-support', defineAsyncComponent(() => import("@/components/setting/privacySupport.vue")));
    app.component('app-setting', defineAsyncComponent(() => import("@/components/setting/index.vue")));
    app.component('app-roles', defineAsyncComponent(() => import("@/components/role/index.vue")));
    app.component('app-users', defineAsyncComponent(() => import("@/components/user/index.vue")));

    app.component('app-haramcode', defineAsyncComponent(() => import("@/components/haramcode/index.vue")));
    app.component('app-sifat', defineAsyncComponent(() => import("@/components/sifat/index.vue")));
    app.component('app-dhikr', defineAsyncComponent(() => import("@/components/dhikr/index.vue")));
    app.component('app-dua', defineAsyncComponent(() => import("@/components/dua/index.vue")));
    app.component('app-prayer-time', defineAsyncComponent(() => import("@/components/prayertime/index.vue")));
    app.component('app-prayer-create', defineAsyncComponent(() => import("@/components/prayertime/create.vue")));
    app.component('app-prayer-import', defineAsyncComponent(() => import("@/components/prayertime/import.vue")));
    app.component('app-dashboard', defineAsyncComponent(() => import("@/components/dashboard/dashboard.vue")));
    app.component('app-category', defineAsyncComponent(() => import("@/components/category/index.vue")));
    app.component('app-donation', defineAsyncComponent(() => import("@/components/donation-list/index.vue")));
    app.component('app-payment-method', defineAsyncComponent(() => import("@/components/payment-method/index.vue")));

    // Profile

    app.component('app-personal-info', defineAsyncComponent(() => import("@/components/profile/personalInformation.vue")));
    app.component('app-password-change', defineAsyncComponent(() => import("@/components/profile/changePassword.vue")));
    app.component('app-sidebar', defineAsyncComponent(() => import("@/components/layout/sidebar.vue")));
    app.component('app-navbar', defineAsyncComponent(() => import("@/components/layout/navbar.vue")));

    //Audio Quran Module
    app.component('app-audio-reciter', defineAsyncComponent(() => import("@/components/audio-quran/reciter/index.vue")));
    app.component('add-reciter-modal', defineAsyncComponent(() => import("@/components/audio-quran/reciter/reciterModal.vue")));
    app.component('app-audio-sura', defineAsyncComponent(() => import("@/components/audio-quran/reciter-audio/index.vue")));
    app.component('add-audio-sura-modal', defineAsyncComponent(() => import("@/components/audio-quran/reciter-audio/addSuraModal.vue")));


}
