<template>
    <div class="text-center mt-4">
        <app-logo></app-logo>
        <h1 class="h2 p-3">Join User</h1>
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
                    <input class="form-control form-control-lg email"
                           type="password"
                           v-model="formData.confirm_password"
                           placeholder="Enter Confirm Password"/>
                    <div class="text-danger" v-if="errors.confirm_password">{{ errors.confirm_password[0] }}</div>
                </div>
                <div class="mb-2">
                    <small class="text-danger">
                       <i> * Password must be at least 8 characters  least one uppercase and one lowercase letter and one symbol and one number </i>
                    </small>
                </div>
                <div class="d-grid gap-2 mt-3">
                    <button type="button" class="btn btn-lg btn-primary"
                            @click.prevent="submit"
                            :disabled="preloader">
                        <app-button-loader v-if="preloader"/>
                        Confirm
                    </button>
                </div>
            </div>
        </div>
    </div>
    <app-auth-footer></app-auth-footer>
</template>

<script setup>

import {ref} from "vue";
import Axios from "@/services/axios/index.js";
import {toast} from "vue3-toastify";

const props = defineProps({
    user: {
        required: true
    }
})
const errors = ref({});
const preloader = ref(false);
const formData = ref({});

const submit = () => {
    preloader.value = true;
    errors.value = {};
    const propsDataParse = JSON.parse(props.user);
    formData.value.invitation_token = propsDataParse.invitation_token
    formData.value.email = propsDataParse.email
    Axios.post('join/user', formData.value).then((response) => {
        toast.success(response.data.message)
        window.location.href = '/login'
    }).catch(({response}) => {
        if (response.status === 422) {
            errors.value = response.data.errors;
            if (response.data.message) {
                toast.error(response.data.message)
            }
        } else {
            toast.error(response.data.message)
        }
    }).finally(() => preloader.value = false)
}
</script>


