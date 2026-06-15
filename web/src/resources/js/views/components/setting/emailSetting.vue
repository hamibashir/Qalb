<template>
    <app-loader v-if="preloader"/>
    <form v-else>
        <div class="form-group row mt-3 mb-3">
            <label for="provider" class="col-sm-2 col-form-label">Provider<span
                class="text-danger">*</span>
            </label>
            <div class="col-sm-10">
                <select class="form-control" id="provider" v-model="formData.provider">
                    <option value="smtp" selected>Smtp</option>
                </select>
                <small class="text-danger" v-if="errors.provider">{{ errors.provider[0] }}</small>
            </div>
        </div>

        <div class="form-group row mt-3 mb-3">
            <label for="form_name" class="col-sm-2 col-form-label">Form name<span
                class="text-danger">*</span></label>
            <div class="col-sm-10">
                <input type="text"
                       v-model="formData.from_name"
                       id="form_name"
                       class="form-control "
                       placeholder="Enter from name">
                <small class="text-danger" v-if="errors.from_name">{{ errors.from_name[0] }}</small>
            </div>
        </div>

        <div class="form-group row mt-3 mb-3">
            <label for="form_email" class="col-sm-2 col-form-label">From email<span
                class="text-danger">*</span></label>
            <div class="col-sm-10">
                <input type="email"
                       v-model="formData.from_email"
                       id="form_email"
                       class="form-control "
                       placeholder="Enter from email">
                <small class="text-danger" v-if="errors.from_email">{{ errors.from_email[0] }}</small>
            </div>
        </div>

        <div class="form-group row mt-3 mb-3">
            <label for="smtp_host" class="col-sm-2 col-form-label">Smtp host<span
                class="text-danger">*</span></label>
            <div class="col-sm-10">
                <input type="text"
                       id="smtp_host"
                       v-model="formData.smtp_host"
                       class="form-control "
                       placeholder="Enter smtp host">
                <small class="text-danger" v-if="errors.smtp_host">{{ errors.smtp_host[0] }}</small>
            </div>
        </div>

        <div class="form-group row mt-3 mb-3">
            <label for="smtp_port" class="col-sm-2 col-form-label">Smtp port<span
                class="text-danger">*</span></label>
            <div class="col-sm-10">
                <input type="number"
                       id="smtp_port"
                       v-model="formData.smtp_port"
                       class="form-control "
                       placeholder="Enter smtp port">
                <small class="text-danger" v-if="errors.smtp_port">{{ errors.smtp_port[0] }}</small>
            </div>
        </div>

        <div class="form-group row mt-3 mb-3">
            <label for="encryption_type" class="col-sm-2 col-form-label">Encryption type<span
                class="text-danger">*</span></label>
            <div class="col-sm-10">
                <input type="text"
                       id="encryption_type"
                       v-model="formData.encryption_type"
                       class="form-control "
                       placeholder="Enter encryption type">
                <small class="text-danger" v-if="errors.encryption_type">{{ errors.encryption_type[0] }}</small>
            </div>
        </div>
        <div class="form-group row mt-3 mb-3">
            <label for="smtp_username" class="col-sm-2 col-form-label">Smtp username<span
                class="text-danger">*</span></label>
            <div class="col-sm-10">
                <input type="text"
                       id="smtp_username"
                       v-model="formData.smtp_username"
                       class="form-control "
                       placeholder="Enter username">
                <small class="text-danger" v-if="errors.smtp_username">{{ errors.smtp_username[0] }}</small>
            </div>
        </div>
        <div class="form-group row mt-3 mb-3">
            <label for="email_password" class="col-sm-2 col-form-label">Smtp password<span
                class="text-danger">*</span></label>
            <div class="col-sm-10">
                <input type="text"
                       id="email_password"
                       v-model="formData.email_password"
                       class="form-control "
                       placeholder="Enter password">
                <small class="text-danger" v-if="errors.email_password">{{ errors.email_password[0] }}</small>
            </div>
        </div>

        <div class="form-group row row mt-3 mb-3" v-if="$canAccess('update_email_setting')">
            <div class="offset-sm-2 col-sm-10">
                <button type="button" @click.prevent="submit"
                        class="btn btn-primary action-btn update_btn"
                        :disabled="buttonLoader">
                    <app-button-loader v-if="buttonLoader"/>
                    Update
                </button>
            </div>
        </div>
    </form>

</template>

<script setup>

import {onMounted, ref} from "vue";
import Axios from "@/services/axios/index.js";
import _ from 'lodash'
import {toast} from "vue3-toastify";

const formData = ref({
    provider: 'smtp',
});
const errors = ref({});
const buttonLoader = ref(false);
const submit = () => {
    buttonLoader.value = true
    Axios.post('email-settings', formData.value).then(({data}) => {
        toast.success(data.message);
        getServerData()

    }).catch(({response}) => {
        if (response.status === 422) {
            errors.value = response.data.errors;
        }else {
            toast.error(response.data.message);
        }
    }).finally(() => buttonLoader.value = false)
}
const preloader = ref(false);
const getServerData = () => {
    preloader.value = true
    Axios.get('email-settings').then(({data}) => {
        if (!_.isEmpty(data)) {
            formData.value = data
        }
    }).finally(() => preloader.value = false)
}
onMounted(() => {
    getServerData();
})
</script>


