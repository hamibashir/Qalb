<template>
    <div class="text-center mt-4">
        <app-logo></app-logo>
        <h1 class="h2 p-3">Forget Password!</h1>
    </div>
    <div class="card">
        <div class="card-body">
            <div class="m-sm-6">
                <div class="mb-3">
                    <label class="form-label">Email <span class="text-danger">*</span></label>
                    <input class="form-control form-control-lg email"
                           type="email"
                           v-model="formData.email"
                           placeholder="Enter your email"/>
                    <small class="text-danger" v-if="errors.email">{{ errors.email[0] }}</small>
                </div>
                <div class="d-grid gap-2 mt-3">
                    <button type="button"
                            class="btn btn-lg btn-primary reset_password_btn"
                            @click.prevent="submit"
                            :disabled="preloader">
                        <app-button-loader v-if="preloader"/>
                        Reset Password
                    </button>
                </div>
            </div>
        </div>
    </div>
    <div class="text-center mb-3">
        <a :href="'login'">Login Here</a>
    </div>
    <app-auth-footer></app-auth-footer>
</template>

<script setup>
import {ref} from "vue";
import Axios from "@/services/axios/index.js";
import {toast} from "vue3-toastify";

const errors = ref({});
const preloader = ref(false);
const formData = ref({});

const submit = () => {
    preloader.value = true;
    errors.value = {};
    Axios.post('forget-password', formData.value).then((response) => {
        toast.success(response.data.message)
        formData.value.email = ''
    }).catch(({response}) => {
        if (response.status === 422) {
            errors.value = response.data.errors;
        } else {
            toast.error(response.data.message)
        }
    }).finally(() => preloader.value = false)
}

</script>
