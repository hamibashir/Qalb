<template>
    <div class="container-fluid pb-5 my-5 installer-container">
        <div class="row justify-content-center align-items-center">
            <div class="col-12 col-lg-7 mt-4 mb-4">
                <div class="card">
                    <div class="card-header">
                        <h4 class="mt-2 fw-bolder">
                            Company Information
                            <span class="text-danger">*</span>
                        </h4>
                    </div>
                    <div class="card-body">

                        <!-- Company Name -->
                        <div class="mb-4">
                            <label class="company_name">Company Name <span class="text-danger">*</span></label>
                            <input
                                type="text"
                                class="form-control"
                                id="company_name"
                                placeholder="Company Name"
                                v-model="formData.company_name"
                            />
                            <small class="text-danger" v-if="errors.company_name">{{ errors.company_name[0] }}</small>
                        </div>

                        <!-- Company Address -->
                        <div class="mb-4">
                            <label class="address">Address</label>
                            <input
                                type="text"
                                class="form-control"
                                id="address"
                                placeholder="Company Address"
                                v-model="formData.address"
                            />
                            <small class="text-danger" v-if="errors.address">{{ errors.address[0] }}</small>
                        </div>

                        <!-- Zakat Nisab -->
                        <div class="mb-4">
                            <label class="zakat_nisab">Zakat Nisab <span class="text-danger">*</span></label>
                            <input
                                type="number"
                                class="form-control"
                                id="zakat_nisab"
                                placeholder="Zakat Nisab"
                                v-model="formData.zakat_nisab"
                            />
                            <small class="text-danger" v-if="errors.zakat_nisab">{{ errors.zakat_nisab[0] }}</small>
                        </div>

                        <!-- Currency Symbol -->
                        <div class="mb-4">
                            <label class="form-label">Currency Symbol <span class="text-danger">*</span></label>
                            <input
                                type="text"
                                class="form-control"
                                id="currency_symbol"
                                placeholder="Currency Symbol"
                                v-model="formData.currency_symbol"
                            />
                            <small class="text-danger" v-if="errors.currency_symbol">{{
                                    errors.currency_symbol[0]
                                }}</small>
                        </div>

                        <!-- Continue Button -->
                        <div class="d-flex justify-content-center gap-3">
                            <button
                                type="button"
                                class="btn btn-primary btn-lg px-4"
                                :disabled="preloader"
                                @click.prevent="submit"
                            >
                                <app-button-loader v-if="preloader"/>
                                <span>Next</span>
                            </button>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
</template>
<style scoped>
.form-control {
    height: 36px;
    font-size: 18px;
}
</style>

<script setup>
import {ref} from "vue";
import Axios from "@/services/axios/index.js";
import {urlGenerator} from "@/utilities/urlGenerator.js";
import {toast} from "vue3-toastify";

const formData = ref({});
const errors = ref({});
const preloader = ref(false);
const changeCompanyLogo = (file) => {
    formData.value.company_logo = file;
};
const changeCompanyIcon = (file) => {
    formData.value.company_icon = file;
};
const changeCompanyBanner = (file) => {
    formData.value.company_banner = file;
};
const submit = () => {
    preloader.value = true;
    Axios.post("company-store", formData.value)
        .then((response) => {
            toast.success(response.data.message);
            location.replace(urlGenerator('email-setup'))
        })
        .catch(({response}) => {
            if (response?.status === 422) {
                errors.value = response.data.errors;
            }
        })
        .finally(() => (preloader.value = false));
};
</script>
