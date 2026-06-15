<template>
    <form>
        <div class="form-group row mt-3 mb-3">
            <label for="current_password" class="col-sm-2 col-form-label">Old
                Password <span
                    class="text-danger">*</span></label>
            <div class="col-sm-10">
                <input type="password" class="form-control current_password"
                       v-model="formData.current_password"
                       id="current_password" placeholder="********">
                <small class="text-danger" v-if="errors.current_password">{{ errors.current_password[0] }}</small>
            </div>
        </div>
        <div class="form-group row row mt-3 mb-3">
            <label for="password" class="col-sm-2 col-form-label">New
                Password <span
                    class="text-danger">*</span></label>
            <div class="col-sm-10">
                <input type="password" class="form-control new_password"
                       v-model="formData.password"
                       id="password" placeholder="********">
                <small class="text-danger" v-if="errors.password">{{ errors.password[0] }}</small>
            </div>
        </div>
        <div class="form-group row row mt-3 mb-3">
            <label for="confirm_password" class="col-sm-2 col-form-label">Confirm
                Password <span
                    class="text-danger">*</span></label>
            <div class="col-sm-10">
                <input type="password" class="form-control password_confirmation"
                       id="confirm_password"
                       v-model="formData.confirm_password"
                       name="confirm_password" placeholder="********">
                <small class="text-danger" v-if="errors.confirm_password">{{ errors.confirm_password[0] }}</small>
            </div>
        </div>
        <div class="form-group row row mt-3 mb-3">
            <div class="offset-sm-2 col-sm-10">
                <button type="button"
                        class="btn btn-primary"
                        :disabled="preloader"
                        @click.prevent="updatePassword">
                    <app-button-loader v-if="preloader"/>
                    Update
                </button>
            </div>
        </div>
    </form>
</template>
<script setup>
import {ref} from "vue";
import {toast} from "vue3-toastify";
import Axios from "@/services/axios/index.js";

const preloader = ref(false);
const errors = ref({});
const formData = ref({});

const updatePassword = () => {
    preloader.value = true;
    errors.value = {};
    Axios.post('password-change', formData.value).then((response) => {
        toast.success(response.data.message)
        formData.value = {};
    }).catch(({response}) => {
        if (response?.status === 422) {
            errors.value = response.data.errors
        } else {
            toast.error(response.data.message)
        }
    }).finally(() => preloader.value = false)
}

</script>

