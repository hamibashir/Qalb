<template>
    <div class="container pb-5 my-5 installer-container">
        <!-- Installation Notice Card -->
        <div class="mt-5">
            <div class="card shadow installation-notice-card">
                <div class="card-header bg-warning text-white">
                    <h5 class="mb-0 text-white"><strong>Installation Notice</strong></h5>
                </div>
                <div class="card-body px-5">
                    <p class="lead mb-0">
                        Before proceeding with the installation, make sure your server meets the required PHP version,
                        necessary extensions, and proper file permissions. Refer to the
                        <a href="https://zabi.theme29.com/documentation" target="_blank" rel="noopener noreferrer">
                            documentation
                        </a> for details.
                    </p>
                </div>
            </div>
        </div>

        <!-- Requirements Table -->
        <div class="mt-5 card border-info">
            <div class="card-body">
                <div class="mt-5 table-responsive custom-scrollbar">
                    <table class="table table-bordered table-hover table-sm">
                        <thead class="table-warning">
                        <tr>
                            <th>Requirement</th>
                            <th>Required</th>
                            <th>Current</th>
                            <th>Status</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr v-if="checkPhpVersion">
                            <td>PHP version</td>
                            <td>{{ checkPhpVersion.minimum_version }}</td>
                            <td>{{ checkPhpVersion.current_version }}</td>
                            <td>
                                <span v-if="checkPhpVersion.status" class="badge bg-success">Success</span>
                                <span v-else class="badge bg-danger">Failed</span>
                            </td>
                        </tr>

                        <tr v-if="checkMysqlVersion">
                            <td>MySQL version</td>
                            <td>{{ checkMysqlVersion.minimum_version }}</td>
                            <td>{{ checkMysqlVersion.current_version }}</td>
                            <td>
                                <span v-if="checkMysqlVersion.status" class="badge bg-success">Success</span>
                                <span v-else class="badge bg-danger">Failed</span>
                            </td>
                        </tr>

                        <template v-if="phpRequirements">
                            <tr v-for="(phpRequirement, index) in phpRequirements" :key="index">
                                <td>{{ index }}</td>
                                <td>Enabled</td>
                                <td>
                                    <span v-if="phpRequirement" class="text-success">Enabled</span>
                                    <span v-else class="text-danger">Disabled</span>
                                </td>
                                <td>
                                    <span v-if="phpRequirement" class="badge bg-success">Success</span>
                                    <span v-else class="badge bg-danger">Failed</span>
                                </td>
                            </tr>
                        </template>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Folder Permissions Table -->
        <div class="mt-5 card border-info">
            <div class="card-body">
                <div class="mt-5 table-responsive custom-scrollbar">
                    <table class="table table-bordered table-hover table-sm">
                        <thead class="table-warning">
                        <tr>
                            <th>File/Path Permission</th>
                            <th>Required</th>
                            <th>Status</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr v-for="folderPermission in folderPermissions" :key="folderPermission.folder">
                            <td>{{ folderPermission.folder }}</td>
                            <td>{{ folderPermission.permission }}</td>
                            <td>
                                <span v-if="folderPermission.isSet" class="badge bg-success">Success</span>
                                <span v-else class="badge bg-danger">Failed</span>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Continue/Retry Buttons -->
        <div class="mt-5 d-flex justify-content-center">
            <button v-if="hasNext" class="btn btn-primary btn-lg px-4" @click.prevent="next">Continue
            </button>
            <button v-else class="btn btn-secondary btn-lg px-4 btn-danger" @click.prevent="retry">Retry</button>
        </div>
    </div>
</template>

<script setup>
import {ref, onMounted, computed} from "vue";
import Axios from "@/services/axios/index.js";
import {urlGenerator} from "@/utilities/urlGenerator.js";

const checkPhpVersion = ref({});
const checkMysqlVersion = ref({});
const phpRequirements = ref({});
const phpRequirementsErrors = ref({});
const folderPermissions = ref({});
const folderPermissionsErrors = ref({});
const getRequirement = () => {
    Axios.get(`installation/requirements`)
        .then((response) => {
            if (
                !response?.data?.checkPhpVersion &&
                !response?.data?.requirements?.requirements?.php
            ) {
                //router.push("/login");
            } else {
                checkPhpVersion.value = response?.data?.checkPhpVersion;
                checkMysqlVersion.value = response?.data?.mysqlVersion;
                phpRequirements.value =
                    response?.data?.requirements?.requirements?.php;
                phpRequirementsErrors.value = response?.data?.requirements?.errors
                folderPermissions.value =
                    response?.data.permissions?.permissions;

                folderPermissionsErrors.value = response?.data.permissions?.errors
            }
        })
};

const hasNext = computed(() => {
    if (phpRequirements.value) {
        let isRequired = true;
        for (const key in phpRequirements.value) {
            if (!phpRequirements.value[key]) {
                isRequired = false;
            }
            return (
                checkPhpVersion.value.status &&
                checkMysqlVersion.value.status &&
                folderPermissionsErrors.value === null &&
                !phpRequirementsErrors.value
            );
        }
    }
    return false;
});

const next = () => {
    location.replace(urlGenerator('/purchase-code'))
}
const retry = () => {
    location.replace(urlGenerator('/install'))
}

onMounted(() => {
    getRequirement();
});
</script>
