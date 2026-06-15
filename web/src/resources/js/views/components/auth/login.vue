<template>
    <div class="text-center mt-4">
        <app-logo></app-logo>
        <h1 class="h2 pt-3"><b>Sign In</b></h1>
        <h1 class="h3 pt-3">Welcome back please login here !</h1>
    </div>
    <div class="card">
        <div class="card-body">
            <div class="m-sm-5">
                <div class="mb-3" v-if="isDemoVersion === 'true'">
                    <label class="form-label">Role <span class="text-danger">*</span></label>
                    <select class="form-select form-select-lg" v-model="formData.role" @change="updateCredentials">
                        <option value="" selected>Choose one</option>
                        <option value="admin">Admin</option>
                    </select>
                </div>
                <div class="mb-3">
                    <label class="form-label">Email <span class="text-danger">*</span></label>
                    <input class="form-control form-control-lg"
                           type="email"
                           v-model="formData.email"
                           placeholder="Enter your email"/>
                    <small class="text-danger" v-if="errors.email">{{ errors.email[0] }}</small>
                </div>
                <div class="mb-3">
                    <label class="form-label">Password <span class="text-danger">*</span></label>
                    <input class="form-control form-control-lg"
                           type="password"
                           v-model="formData.password"
                           placeholder="Enter your password"/>
                    <small class="text-danger" v-if="errors.password">{{ errors.password[0] }}</small>
                </div>
                <div class="d-grid gap-2 mt-3">
                    <button type="submit" class="btn btn-lg btn-primary"
                            @click.prevent="submit"
                            :disabled="preloader">
                        <app-button-loader v-if="preloader"/>
                        Sign in
                    </button>
                </div>
            </div>
        </div>
    </div>
    <div class="text-center mb-3">
        <a :href="'forget-password'">Forget password</a>
    </div>
    <app-auth-footer></app-auth-footer>

</template>
<script setup>

import { onMounted, ref, watch, reactive} from "vue";
import Axios from "@/services/axios/index.js";

const errors = ref({});
const preloader = ref(false);
const formData = reactive({
    role: "",
    email: "",
    password: ""
});
const isDemoVersion = ref(process.env.IS_DEMO);

const updateCredentials = () => {
    // Update email and password based on selected role
    switch (formData.role) {
        case 'admin':
            formData.email = 'admin@demo.com';
            formData.password = '123456';
            break;
        default:
            formData.email = '';
            formData.password = '';
    }
};

// Trigger updateCredentials when the component is mounted
onMounted(updateCredentials);

// Watch for changes in the formData.role and trigger updateCredentials accordingly
watch(formData, (newValues, oldValues) => {
    if (newValues.role !== oldValues.role && isDemoVersion.value) {
        updateCredentials();
    }
});
const submit = () => {
    preloader.value = true;
    errors.value = {};
    Axios.post('login', formData).then(({ data }) => {
        if (data.status) {
            window.location.href = 'dashboard';
        }
    }).catch(({ response }) => {
        if (response.status === 422) {
            errors.value = response.data.errors;
        }
    }).finally(() => preloader.value = false);
};
</script>
