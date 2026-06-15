<template>
    <div class="text-center mt-4">
        <app-logo></app-logo>
        <h1 class="h2 p-3">Reset Password</h1>
    </div>
    <div class="card">
        <div class="card-body">
            <div class="m-sm-3">
                <div class="mb-3">
                    <label class="form-label">Password <span class="text-danger">*</span></label>
                    <input class="form-control form-control-lg email"
                           type="password"
                           v-model="formData.password"
                           placeholder="Enter New Password"/>
                    <div class="text-danger" v-if="errors.password">{{ errors.password[0] }}</div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Confirm Password <span class="text-danger">*</span></label>
                    <input class="form-control form-control-lg email" type="password"
                           v-model="formData.confirm_password"
                           placeholder="Enter Confirm Password"/>
                    <div class="text-danger" v-if="errors.confirm_password">{{ errors.confirm_password[0] }}</div>
                </div>
                <div class="mb-2">
                    <span class="text-danger">* Password must be at least 8 characters  least one uppercase and one lowercase letter and one symbol and one number</span>
                </div>
                <div class="d-grid gap-2 mt-3">
                    <button type="button" class="btn btn-lg btn-primary" @click.prevent="submit" :disabled="preloader">
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

const props = defineProps({
    token: {
        required: true
    }
})
const errors = ref({});
const preloader = ref(false);
const formData = ref({});

const submit = () => {
    preloader.value = true;
    errors.value = {};
    const propsDataParse = JSON.parse(props.token);
    formData.value.token = propsDataParse.token
    formData.value.email = propsDataParse.email
    Axios.post('password/reset', formData.value).then((response) => {
        toast.success(response.data.message)
        window.location.href = '/dashboard'
    }).catch(({response}) => {
        if (response.status === 422) {
            errors.value = response.data.errors;
        } else {
            toast.error(response.data.message)
        }
    }).finally(() => preloader.value = false)
}

</script>
