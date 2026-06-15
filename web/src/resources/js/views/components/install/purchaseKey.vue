<template>
    <div class="container-fluid pb-5 my-5 installer-container d-flex align-items-center justify-content-center">
        <div class="col-12 col-lg-7 mt-4 mb-4">
            <div class="card">
                <div class="card-header">
                    <h4 class="mt-2 fw-bolder">
                        Purchase Code
                        <span class="text-danger">*</span>
                    </h4>
                </div>
                <div class="card-body">
                    <input
                        type="text"
                        class="form-control form-control"
                        id="purchases_code"
                        placeholder="Enter Purchase Code"
                        v-model="formData.purchase_code"
                    />
                    <small class="text-danger" v-if="errors.purchase_code">{{ errors.purchase_code[0] }}</small>
                </div>
                <div class="card-footer d-flex justify-content-center gap-3">
                    <a :href="urlGenerator('install')" class="btn btn-danger btn-lg px-4">
                        <span>Go Back</span>
                    </a>
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

const formData = ref({
    purchase_code: "",
});
const errors = ref({});
const preloader = ref(false);
const submit = () => {
    delete axios.defaults.headers.common["X-Requested-With"];
    delete axios.defaults.headers.common["X-CSRF-TOKEN"];
    preloader.value = true;

    Axios.post("purchase-key", formData.value).then((response) => {
        if (response?.data.message === "success") {
            preloader.value = true;
            axios.get(response?.data.url)
                .then((res) => {
                    if (res?.data?.message === "verified") {
                        toast.success('Purchase code verified successfully');
                        location.replace(urlGenerator(`environment-setup?purchase_code=${formData.value.purchase_code}`))
                    }
                }).catch(({response}) => {
                if (response?.status === 422) {
                    errors.value = response?.data?.errors;
                } else {
                    toast.error(response?.data?.message);
                }
            }).finally(() => (preloader.value = false));
        }
        errors.value = {};
    }).catch(({response}) => {
        if (response?.status === 422) {
            errors.value = response.data.errors;
        }
        preloader.value = false
    })
};
</script>
