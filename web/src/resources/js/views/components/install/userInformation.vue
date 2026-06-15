<template>
    <div class="container-fluid pb-5 my-5 installer-container">
        <div class="row justify-content-center align-items-center">
            <div class="col-12 col-lg-7 mt-4 mb-4">
                <div class="card">
                    <div class="card-header">
                        <h4 class="mt-2 fw-bolder">
                            User Information
                            <span class="text-danger">*</span>
                        </h4>
                    </div>
                    <div class="card-body">

                        <!-- First Name -->
                        <div class="mb-4">
                            <label class="form-label">First Name <span class="text-danger">*</span></label>
                            <input
                                type="text"
                                class="form-control"
                                id="first_name"
                                placeholder="First Name"
                                v-model="formData.first_name"
                            />
                            <small class="text-danger" v-if="errors.first_name">{{ errors.first_name[0] }}</small>
                        </div>

                        <!-- Last Name -->
                        <div class="mb-4">
                            <label class="form-label">Last Name <span class="text-danger">*</span></label>
                            <input
                                type="text"
                                class="form-control"
                                placeholder="Last Name"
                                v-model="formData.last_name"
                            />
                            <small class="text-danger" v-if="errors.last_name">{{ errors.last_name[0] }}</small>
                        </div>

                        <!-- Email -->
                        <div class="mb-4">
                            <label class="form-label">Email <span class="text-danger">*</span></label>
                            <input
                                type="email"
                                class="form-control"
                                id="email"
                                placeholder="Email"
                                v-model="formData.email"
                            />
                            <small class="text-danger" v-if="errors.email">{{ errors.email[0] }}</small>
                        </div>

                        <!-- Password -->
                        <div class="mb-4">
                            <label class="form-label">Password <span class="text-danger">*</span></label>
                            <input
                                type="password"
                                class="form-control"
                                id="password"
                                placeholder="Password"
                                v-model="formData.password"
                            />
                            <small class="text-danger" v-if="errors.password">{{ errors.password[0] }}</small>
                        </div>

                        <!-- Password User Guide Message -->
                        <div class="mb-2">
                            <span class="text-danger">* Password must be at least 8 characters</span>
                        </div>

                        <!-- Continue Button -->
                        <div class="d-flex justify-content-center gap-3">
                            <button
                                type="button"
                                class="btn btn-primary btn-lg px-4 text-center finish-btn"
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
import {ref} from "vue"
import Axios from "@/services/axios/index.js";
import {urlGenerator} from "@/utilities/urlGenerator.js";
import {toast} from "vue3-toastify";

const formData = ref({})
const errors = ref({})
const preloader = ref(false)
const submit = () => {
    preloader.value = true
    Axios.post(`user-store`, formData.value).then((response) => {
        toast.success(response.data.message);
        window.location.replace(urlGenerator('company-information'))
    }).catch(({response}) => {
        if (response?.status === 422) {
            errors.value = response.data.errors;
        }
    }).finally(() => preloader.value = false)
}

</script>

