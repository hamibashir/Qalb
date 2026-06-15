<template>
    <app-loader v-if="pageLoader"/>
    <form v-else>
        <div class="row">
            <div class="col-md-12">
                <div class="form-group col-sm-12 mb-5" style="height: 300px">
                    <label for="privacy_policy"
                           class="col-form-label">Privacy Policy</label>
                    <app-input
                        v-model="formData.privacy_policy"
                        type="editor"
                    />
                </div>
            </div>

            <div class="col-md-12">
                <div class="form-group col-sm-12 mb-5 mt-5" style="height: 300px">
                    <label for="support"
                           class="col-form-label">Support</label>
                    <app-input
                        v-model="formData.support"
                        type="editor"
                    />
                </div>
            </div>
            <div class="col-md-12">
                <div class="form-group col-sm-12 mt-5" style="height: 300px">
                    <label for="terms_and_conditions"
                           class="col-form-label">Terms and Conditions</label>
                    <app-input
                        v-model="formData.terms_and_conditions"
                        type="editor"
                    />
                </div>
            </div>
            <div class="col-md-4 mt-5">
                <div class="form-group mt-5" v-if="$canAccess('update_setting')">
                    <button type="submit"
                            class="btn btn-primary action-btn py-2 px-3"
                            :disabled="preloader"
                            @click.prevent="submit">
                        <app-button-loader v-if="preloader"/>
                        Update
                    </button>
                </div>
            </div>
        </div>
    </form>
</template>

<script setup>
import {onMounted, ref} from "vue";
import Axios from "@/services/axios/index.js";
import _ from "lodash";
import {toast} from "vue3-toastify";

const preloader = ref(false);
const formData = ref({});
const errors = ref({});

const submit = () => {
    preloader.value = true
    errors.value = {};

    Axios.post('privacy-support', formData.value).then(({data}) => {
        toast.success(data.message);
    }).catch(({response}) => {
        if (response.status === 422) {
            errors.value = response.data.errors
        } else {
            toast.error(response.data.message)
        }
    }).finally(() => {
        preloader.value = false
    })
}


function setOrDeleteProperty(formData, key, value) {
    if (value) {
        formData[key] = value;
    } else {
        delete formData[key];
    }
}

const pageLoader = ref(false);
const getServerData = () => {
    pageLoader.value = true
    Axios.get('settings').then(({data}) => {
        if (!_.isEmpty(data)) {
            formData.value = data
        }
    }).finally(() => pageLoader.value = false)
}
onMounted(() => {
    getServerData();
})
</script>
