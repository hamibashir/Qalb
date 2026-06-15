<template>
    <app-loader v-if="pageLoader"/>
    <form v-else>
        <div class="form-group row mb-3 mt-3">
            <label for="company_name" class="col-sm-3 col-form-label">Company
                Name <span class="text-danger">*</span></label>
            <div class="col-sm-5">
                <input type="text"
                       class="form-control"
                       id="company_name"
                       placeholder="Enter Company Name"
                       v-model="formData.company_name">
                <small class="text-danger" v-if="errors.company_name">{{ errors.company_name[0] }}</small>
            </div>
        </div>

        <div class="form-group row mb-3 mt-3">
            <label for="address" class="col-sm-3 col-form-label">Address <span
                class="text-danger">*</span></label>
            <div class="col-sm-5">
                <input type="text"
                       class="form-control"
                       id="address"
                       placeholder="Enter Address"
                       v-model="formData.address">
                <small class="text-danger" v-if="errors.address">{{ errors.address[0] }}</small>
            </div>
        </div>

        <div class="form-group row mb-3 mt-3">
            <label for="zakat_nisab" class="col-sm-3 col-form-label">Zakat Nisab
                <span
                    class="text-danger">*</span></label>
            <div class="col-sm-5">
                <input type="number"
                       class="form-control"
                       id="zakat_nisab"
                       placeholder="Enter Zakat Nisab"
                       v-model="formData.zakat_nisab">
                <small class="text-danger" v-if="errors.zakat_nisab">{{ errors.zakat_nisab[0] }}</small>
            </div>
        </div>

        <div class="form-group row mb-3 mt-3">
            <label for="currency_symbol" class="col-sm-3 col-form-label">Currency
                Symbol</label>
            <div class="col-sm-5">
                <input type="text"
                       class="form-control"
                       id="currency_symbol"
                       placeholder="Enter Currency Symbol"
                       v-model="formData.currency_symbol">
                <small class="text-danger" v-if="errors.currency_symbol">{{ errors.currency_symbol[0] }}</small>
            </div>
        </div>

        <!--        <div class="form-group row mb-3 mt-3">-->
        <!--            <label class="form-check-label col-sm-2" for="automatic_payer">Automatic payer time</label>-->
        <!--            <div class="col-sm-5">-->
        <!--                <div class="input-group">-->
        <!--                    <div class="form-check form-switch">-->
        <!--                        <input class="form-check-input" type="checkbox" id="automatic_payer"-->
        <!--                               v-model="formData.automatic_payer_time">-->
        <!--                    </div>-->
        <!--                </div>-->
        <!--            </div>-->
        <!--        </div>-->

        <!--        <div class="form-group row mb-3 mt-3">-->
        <!--            <label class="form-check-label col-sm-3" for="ramadan_schedule">Ramadan schedule</label>-->
        <!--            <div class="col-sm-5">-->
        <!--                <div class="input-group">-->
        <!--                    <div class="form-check form-switch">-->
        <!--                        <input class="form-check-input" type="checkbox" id="ramadan_schedule"-->
        <!--                               v-model="formData.ramadan_schedule">-->
        <!--                    </div>-->
        <!--                </div>-->
        <!--            </div>-->
        <!--        </div>-->

        <div class="form-group row mb-3 mt-3">
            <label for="web_logo" class="col-sm-3 col-form-label">Company
                logo</label>
            <div class="col-sm-5">
                <div class="input-group">
                    <div>
                        <div class="custom-image-upload-wrapper">
                            <div class="image-area d-flex">
                                <img id="web_logo_img"
                                     :src="formData.web_logo"
                                     alt="web logo"
                                     class="img-fluid mx-auto my-auto">
                            </div>
                            <div class="input-area">
                                <label
                                    id="upload-label"
                                    for="web_logo">
                                    Change Logo
                                </label>
                                <input
                                    id="web_logo"
                                    name="web_logo"
                                    type="file"
                                    class="form-control d-none"
                                    @change="changeWebLogo($event)">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="form-group row mb-3 mt-3">
            <label for="date_of_birth" class="col-sm-3 col-form-label">Company
                icon</label>
            <div class="col-sm-5">
                <div class="input-group">
                    <div>
                        <div class="custom-image-upload-wrapper">
                            <div class="image-area d-flex">
                                <img id="web_icon_img"
                                     :src="formData.web_icon"
                                     alt="Web Icon"
                                     class="img-fluid mx-auto my-auto">
                            </div>
                            <div class="input-area"><label
                                id="upload-label"
                                for="web_icon">
                                Change Icon
                            </label> <input
                                id="web_icon"
                                name="web_icon"
                                type="file"
                                class="form-control d-none"
                                @change="changeWebIcon($event)">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="form-group row mb-3 mt-3">
            <label for="date_of_birth" class="col-sm-3 col-form-label">App
                Banner</label>
            <div class="col-sm-5">
                <div class="input-group">
                    <div>
                        <div class="custom-image-upload-wrapper">
                            <div class="image-area d-flex">
                                <img id="app_logo_img"
                                     :src="formData.app_logo"
                                     alt="banner"
                                     class="img-fluid mx-auto my-auto">
                            </div>
                            <div class="input-area"><label
                                id="upload-label"
                                for="app_logo">
                                Change Banner
                            </label> <input
                                id="app_logo"
                                name="app_logo"
                                type="file"
                                class="form-control d-none"
                                @change="changeAppBanner($event)">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="form-group row mb-3 mt-3">
            <label for="date_of_birth" class="col-sm-3 col-form-label">Donation Banner</label>
            <div class="col-sm-5">
                <div class="input-group">
                    <div>
                        <div class="custom-image-upload-wrapper">
                            <div class="image-area d-flex">
                                <img id="app_donation_img"
                                     :src="formData.donation_banner"
                                     alt="banner"
                                     class="img-fluid mx-auto my-auto">
                            </div>
                            <div class="input-area"><label
                                id="upload-label"
                                for="app_donation_banner">
                                Change Banner
                            </label> <input
                                id="app_donation_banner"
                                name="app_donation_banner"
                                type="file"
                                class="form-control d-none"
                                @change="changeDonationBanner($event)">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="form-group row mb-3 mt-3">
            <label class="form-check-label col-sm-3" for="show_donation_banner">Show Donation Banner</label>
            <div class="col-sm-5">
                <div class="input-group">
                    <div class="form-check form-switch">
                        <input class="form-check-input" type="checkbox" id="show_donation_banner"
                               v-model="formData.show_donation_banner">
                    </div>
                </div>
            </div>
        </div>


        <div class="form-group row mb-3 mt-3">
            <label class="form-check-label col-sm-3" for="show_donation_icon">Show Donation Icon</label>
            <div class="col-sm-5">
                <div class="input-group">
                    <div class="form-check form-switch">
                        <input class="form-check-input" type="checkbox" id="show_donation_icon"
                               v-model="formData.show_donation_icon">
                    </div>
                </div>
            </div>
        </div>

        <div class="form-group row mb-3 mt-3">
            <label for="google_map_key" class="col-sm-3 col-form-label">Google Map API Key</label>
            <div class="col-sm-5">
                <input type="url"
                       class="form-control"
                       id="google_map_key"
                       placeholder="Enter google map api key"
                       v-model="formData.google_map_key">
                <small class="text-danger" v-if="errors.google_map_key">{{ errors.google_map_key[0] }}</small>
            </div>
        </div>
        <div class="form-group row mb-3 mt-3">
            <label for="play_store_url" class="col-sm-3 col-form-label">Play Store Url</label>
            <div class="col-sm-5">
                <input type="url"
                       class="form-control"
                       id="play_store_url"
                       placeholder="Enter play store link"
                       v-model="formData.play_store_url">
                <small class="text-danger" v-if="errors.play_store_url">{{ errors.play_store_url[0] }}</small>
            </div>
        </div>
        <div class="form-group row mb-3 mt-3">
            <label for="app_store_url" class="col-sm-3 col-form-label">App Store Url</label>
            <div class="col-sm-5">
                <input type="url"
                       class="form-control"
                       id="app_store_url"
                       placeholder="Enter app store link"
                       v-model="formData.app_store_url">
                <small class="text-danger" v-if="errors.app_store_url">{{ errors.app_store_url[0] }}</small>
            </div>
        </div>


        <div class="row">
            <div class="col-md-6">
                <div class="form-group col-sm-12 mb-3 mt-3">
                    <label for="zakat_description"
                           class="col-form-label">Zakat
                        Description</label>
                    <textarea class="form-control"
                              id="zakat_description"
                              cols="30"
                              rows="10"
                              v-model="formData.zakat_description"></textarea>

                    <small class="text-danger" v-if="errors.zakat_description">{{ errors.zakat_description[0] }}</small>
                </div>
            </div>
            <div class="col-md-6">
                <div class="form-group col-sm-12 mb-3 mt-3">
                    <label for="haram_description"
                           class="col-form-label">Haram
                        Description</label>
                    <textarea class="form-control"
                              id="haram_description"
                              cols="30"
                              rows="10"
                              v-model="formData.haram_description">

                    </textarea>

                    <small class="text-danger" v-if="errors.haram_description">{{ errors.haram_description[0] }}</small>
                </div>
            </div>
        </div>
        <div class="form-group row" v-if="$canAccess('update_setting')">
            <div class="col-sm-4">
                <button type="submit"
                        class="btn btn-primary action-btn py-2 px-3"
                        :disabled="preloader"
                        @click.prevent="submit">
                    <app-button-loader v-if="preloader"/>
                    Update
                </button>
            </div>
        </div>
    </form>
</template>

<script setup>
import {onMounted, ref, watch} from "vue";
import Axios from "@/services/axios/index.js";
import _ from "lodash";
import {urlGenerator} from "@/utilities/urlGenerator.js";
import {toast} from "vue3-toastify";

const preloader = ref(false);
const formData = ref({});
const errors = ref({});

const handleFileChange = (fileRef, formDataKey) => (event) => {
    const file = event.target.files[0];
    fileRef.value = file;
    formData.value[formDataKey] = URL.createObjectURL(file);
};

const webLogo = ref(null);
const changeWebLogo = handleFileChange(webLogo, 'web_logo');

const webIcon = ref(null);
const changeWebIcon = handleFileChange(webIcon, 'web_icon');

const appBanner = ref(null);
const changeAppBanner = handleFileChange(appBanner, 'app_logo');

const donationBanner = ref(null);
const changeDonationBanner = handleFileChange(donationBanner, 'donation_banner');


const submit = () => {
    preloader.value = true
    errors.value = {};

    setOrDeleteProperty(formData.value, 'web_logo', webLogo.value);
    setOrDeleteProperty(formData.value, 'web_icon', webIcon.value);
    setOrDeleteProperty(formData.value, 'app_logo', appBanner.value);
    setOrDeleteProperty(formData.value, 'donation_banner', donationBanner.value);
    formData.value.show_donation_banner = formData.value.show_donation_banner === true ? 1 : 0
    formData.value.show_donation_icon = formData.value.show_donation_icon === true ? 1 : 0
    // formData.value.ramadan_schedule = formData.value.ramadan_schedule === true ? 1 : 0

    Axios.post('settings', formData.value, {
            headers:
                {'Content-Type': 'multipart/form-data'}
        }
    ).then(({data}) => {
        toast.success(data.message);
        location.reload()
    }).catch(({response}) => {
        if (response.status === 422) {
            errors.value = response.data.errors
        } else {
            toast.error(response.data.message)
        }
    }).finally(() => {
        preloader.value = false
    })
}


function setOrDeleteProperty(formData, key, value) {
    if (value) {
        formData[key] = value;
    } else {
        delete formData[key];
    }
}

const pageLoader = ref(false);
const getServerData = () => {
    pageLoader.value = true
    Axios.get('settings').then(({data}) => {
        if (!_.isEmpty(data)) {
            console.log(Number(data.show_donation_banner))
            formData.value = data
            formData.value.web_logo = data.web_logo ? urlGenerator(data.web_logo) : null
            formData.value.web_icon = data.web_icon ? urlGenerator(data.web_icon) : null
            formData.value.app_logo = data.app_logo ? urlGenerator(data.app_logo) : null
            formData.value.donation_banner = data.donation_banner ? urlGenerator(data.donation_banner) : null
            formData.value.show_donation_banner = Number(data.show_donation_banner) === 1
            formData.value.show_donation_icon = Number(data.show_donation_icon) === 1

            // 👇 Setup original key after it's loaded
            formData.value.google_map_key = data.google_map_key || '';
            originalGoogleMapKey.value = data.google_map_key || '';
            isInitialLoadComplete.value = true;

        }
    }).finally(() => pageLoader.value = false)
}

const originalGoogleMapKey = ref(null);
const isInitialLoadComplete = ref(false);

// Only watch after initial data load
watch(
    () => formData.value.google_map_key,
    (newVal) => {
        if (!isInitialLoadComplete.value) return;

        if (newVal !== originalGoogleMapKey.value) {
            formData.value.is_typed_g_map = true;
        } else {
            delete formData.value.is_typed_g_map;
        }
    }
);


onMounted(() => {
    getServerData();
})
</script>
