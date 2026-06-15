<template>
    <div class="container-fluid pb-5 my-5 installer-container">
        <div class="row justify-content-center align-items-center">
            <div class="col-12 col-lg-7 mt-4 mb-4">
            <div class="card">
                <div class="card-header">
                    <h4 class="mt-2 fw-bolder">
                        Email Configuration
                        <span class="text-danger">*</span>
                    </h4>
                </div>
                <div class="card-body">

                    <!-- Provider -->
                    <div class="mb-4">
                        <label for="provider" class="col-form-label">Provider<span class="text-danger">*</span></label>
                        <select class="form-control" id="provider" v-model="formData.provider">
                            <option value="smtp">Smtp</option>
                        </select>
                        <small class="text-danger" v-if="errors.provider">{{ errors.provider[0] }}</small>
                    </div>

                    <!-- From Name -->
                    <div class="mb-4">
                        <label for="from_name" class="col-form-label">From Name<span class="text-danger">*</span></label>
                        <input
                            type="text"
                            id="from_name"
                            class="form-control"
                            placeholder="From Name"
                            v-model="formData.from_name"
                        />
                        <small class="text-danger" v-if="errors.from_name">{{ errors.from_name[0] }}</small>
                    </div>

                    <!-- From Email -->
                    <div class="mb-4">
                        <label for="from_email" class="col-form-label">From Email<span class="text-danger">*</span></label>
                        <input
                            type="email"
                            id="from_email"
                            class="form-control"
                            placeholder="From Email"
                            v-model="formData.from_email"
                        />
                        <small class="text-danger" v-if="errors.from_email">{{ errors.from_email[0] }}</small>
                    </div>

                    <!-- Smtp Host -->
                    <div class="mb-4">
                        <label for="host" class="col-form-label">Smtp Host<span class="text-danger">*</span></label>
                        <input
                            type="text"
                            id="host"
                            class="form-control"
                            placeholder="Smtp Host"
                            v-model="formData.smtp_host"
                        />
                        <small class="text-danger" v-if="errors.smtp_host">{{ errors.smtp_host[0] }}</small>
                    </div>

                    <!-- Smtp Port -->
                    <div class="mb-4">
                        <label for="smtp_port" class="col-form-label">Smtp Port<span class="text-danger">*</span></label>
                        <input
                            type="text"
                            class="form-control"
                            id="smtp_port"
                            placeholder="Smtp Port"
                            v-model="formData.smtp_port"
                        />
                        <small class="text-danger" v-if="errors.smtp_port">{{ errors.smtp_port[0] }}</small>
                    </div>

                    <!-- Smtp Username -->
                    <div class="mb-4">
                        <label for="smtp_username" class="col-form-label">Smtp Username<span class="text-danger">*</span></label>
                        <input
                            type="text"
                            id="smtp_username"
                            class="form-control"
                            placeholder="Smtp Username"
                            v-model="formData.smtp_username"
                        />
                        <small class="text-danger" v-if="errors.smtp_username">{{ errors.smtp_username[0] }}</small>
                    </div>

                    <!-- Email Password -->
                    <div class="mb-4">
                        <label for="email_password" class="col-form-label">Email Password<span class="text-danger">*</span></label>
                        <input
                            type="text"
                            class="form-control"
                            id="email_password"
                            placeholder="Email Password"
                            v-model="formData.email_password"
                        />
                        <small class="text-danger" v-if="errors.email_password">{{ errors.email_password[0] }}</small>
                    </div>

                    <!-- Encryption Type -->
                    <div class="mb-4">
                        <label for="encryption_type" class="col-form-label">Encryption Type<span class="text-danger">*</span></label>
                        <input
                            type="text"
                            class="form-control"
                            id="encryption_type"
                            placeholder="Encryption Type"
                            v-model="formData.encryption_type"
                        />
                        <small class="text-danger" v-if="errors.encryption_type">{{ errors.encryption_type[0] }}</small>
                    </div>

                    <!-- Skip and Finish Buttons -->
                    <div class="d-flex justify-content-center gap-3">
                        <button
                            type="button"
                            class="btn btn-info btn-lg px-4"
                            :disabled="skipLoader"
                            @click.prevent="skip"
                        >
                            <app-button-loader v-if="skipLoader" />
                            <span>Skip</span>
                        </button>
                        <button
                            type="button"
                            class="btn btn-primary btn-lg px-4"
                            :disabled="preloader"
                            @click.prevent="submit"
                        >
                            <app-button-loader v-if="preloader" />
                            <span>Finish</span>
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
import {ref} from "vue"
import Axios from "@/services/axios/index.js";
import {urlGenerator} from "@/utilities/urlGenerator.js";

const formData = ref({
    provider: 'smtp',
})
const errors = ref({})
const preloader = ref(false)

const submit = () => {
    preloader.value = true
    Axios.post('email-store', formData.value).then((response) => {
        location.replace(urlGenerator('/login'))
    }).catch(({response}) => {
        if (response.status === 422) {
            errors.value = response.data.errors;
        }
    }).finally(() => preloader.value = false)
}

const skipLoader = ref(false)
const skip = () => {
    skipLoader.value = true
    Axios.post('setup-skip', formData.value).then((response) => {
        location.replace(urlGenerator('/login'))
    }).catch(({response}) => {
        if (response.status === 422) {
            errors.value = response.data.errors;
        }
    }).finally(() => skipLoader.value = false)
}


</script>
