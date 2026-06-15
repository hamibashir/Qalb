<template>
    <div class="container-fluid pb-5 my-5 installer-container">
        <div class="row justify-content-center align-items-center">
            <div class="col-12 col-lg-7 mt-4 mb-4">
                <div class="card">
                    <div class="card-header">
                        <h4 class="mt-2 fw-bolder">
                            Database Configuration
                            <span class="text-danger">*</span>
                        </h4>
                    </div>
                    <div class="card-body">

                        <!-- Database Driver -->
                        <div class="mb-4">
                            <label class="form-label">Database Driver <span class="text-danger">*</span></label>
                            <select class="form-control" id="database_driver" v-model="formData.database_connection">
                                <option v-for="databaseProvider in databaseProviderList" :value="databaseProvider.id">
                                    {{ databaseProvider.name }}
                                </option>
                            </select>
                            <small class="text-danger"
                                   v-if="errors.database_connection">{{ errors.database_connection[0] }}</small>
                        </div>

                        <!-- Database Hostname -->
                        <div class="mb-4">
                            <label class="form-label">Database Hostname <span class="text-danger">*</span></label>
                            <input
                                type="text"
                                class="form-control"
                                id="database_hostname"
                                placeholder="Database hostname"
                                v-model="formData.database_hostname"
                            />
                            <small class="text-danger" v-if="errors.database_hostname">{{
                                    errors.database_hostname[0]
                                }}</small>
                        </div>

                        <!-- Database Port -->
                        <div class="mb-4">
                            <label class="form-label">Database Port <span class="text-danger">*</span></label>
                            <input
                                type="text"
                                class="form-control"
                                id="database_port"
                                placeholder="Database port"
                                v-model="formData.database_port"
                            />
                            <small class="text-danger" v-if="errors.database_port">{{ errors.database_port[0] }}</small>
                        </div>

                        <!-- Database Name -->
                        <div class="mb-4">
                            <label class="form-label">Database Name <span class="text-danger">*</span></label>
                            <input
                                type="text"
                                class="form-control"
                                id="database_name"
                                placeholder="Database name"
                                v-model="formData.database_name"
                            />
                            <small class="text-danger" v-if="errors.database_name">{{ errors.database_name[0] }}</small>
                        </div>

                        <!-- Database Username -->
                        <div class="mb-4">
                            <label class="form-label">Database Username <span class="text-danger">*</span></label>
                            <input
                                type="text"
                                class="form-control"
                                id="database_username"
                                placeholder="Database username"
                                v-model="formData.database_username"
                            />
                            <small class="text-danger" v-if="errors.database_username">{{
                                    errors.database_username[0]
                                }}</small>
                        </div>

                        <!-- Database Password -->
                        <div class="mb-4">
                            <label class="form-label">Database Password <span class="text-danger">*</span></label>
                            <input
                                type="password"
                                class="form-control"
                                id="database_password"
                                placeholder="Database password"
                                v-model="formData.database_password"
                            />
                            <small class="text-danger" v-if="errors.database_password">{{
                                    errors.database_password[0]
                                }}</small>
                        </div>

                        <!-- Note -->
                        <div class="mb-2">
                            <span class="m-0">Database name, username, and password must not contain <code>"#"</code> or <code>white spaces</code>!</span>
                        </div>

                        <!-- Continue Button -->
                        <div class="d-flex justify-content-center gap-3">
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
import mainAppFunction from "@/utilities/appFunction.js";
import Axios from "@/services/axios/index.js";
import {urlGenerator} from "@/utilities/urlGenerator.js";
import {toast} from "vue3-toastify";

const formData = ref({
    database_connection: "mysql",
});
const errors = ref({});
const databaseProviderList = ref([
    {id: "mysql", name: "Mysql"},
    {id: "sqlite", name: "Sqlite"},
    {id: "pgsql", name: "Pgsql"},
]);
const preloader = ref(false);
const submit = () => {
    const queryString = window.location.search;
    const urlParams = new URLSearchParams(queryString);
    const purchaseCode = urlParams.get('purchase_code')
    let data = {
        ...formData.value,
        app_url: mainAppFunction.baseUrl(),
        purchase_code: purchaseCode,
    };
    preloader.value = true;
    errors.value = {};
    Axios.post(`connect-database`, data).then((response) => {
        toast.success(response.data.message);
        location.replace(urlGenerator('user-information'))
    }).catch(({response}) => {
        if (response.status === 422) {
            errors.value = response.data.errors;
        } else {
            errors.value = {};
            toast.error(response.data.message);
        }
    }).finally(() => (preloader.value = false));
};
</script>
