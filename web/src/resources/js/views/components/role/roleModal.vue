<template>
    <app-modal :modal-id="modalId"
               modal-size="large"
               :title="selectedUrl ? 'Edit Role' : 'Add Role'"
               :preloader="preloader"
               @submit="submit"
               @close="closeModal">

        <template v-slot:body>
            <app-loader v-if="pageLoader"/>
            <form v-else>
                <div class="row mb-3">
                    <div class="col-md-12">
                        <label class="form-label">Name <span class="text-danger">*</span></label>
                        <input type="text"
                               v-model="formData.name"
                               class="form-control beautiful-input"
                               placeholder="Enter Name"
                               required>
                        <small class="text-danger beautiful-error" v-if="errors.name">{{ errors.name[0] }}</small>
                    </div>
                    <div class="col-md-4 d-flex align-items-center">
                        <div class="form-check mt-4">
                            <label class="form-check-label mx-2" for="all">Select All</label>
                            <input id="all"
                                   class="form-check-input beautiful-checkbox"
                                   type="checkbox"
                                   :checked="formData.permissions.length === permissionLength"
                                   @click="selectAll($event)"
                                   name="all_check">
                        </div>
                    </div>
                    <small class="text-danger beautiful-error" v-if="errors.permissions">{{
                            errors.permissions[0]
                        }}</small>
                </div>

                <div class="row" v-if="Object.keys(data.permissions).length">
                    <div class="col-md-4" v-for="permissionGroupName in Object.keys(data.permissions)">
                        <div class="roles beautiful-role">
                            <div class="title-bar rounded-default shadow-sm bg-gray-300">
                                <input :id="`single-checkbox-${permissionGroupName}`"
                                       class="form-check-input me-2 beautiful-checkbox"
                                       type="checkbox"
                                       :checked="groupIsChecked(data.permissions[permissionGroupName])"
                                       @click="selectGroup($event)"
                                       :name="permissionGroupName">
                                <label :for="`single-checkbox-${permissionGroupName}`">{{ handlePermissionName(permissionGroupName) }}</label>
                            </div>

                            <div class="content p-3">
                                <div class="my-3" v-for="permission in data.permissions[permissionGroupName]">
                                    <input :id="permission.id"
                                           type="checkbox"
                                           class="form-check-input beautiful-checkbox"
                                           name="permissions"
                                           v-model="formData.permissions"
                                           :value="permission.id">
                                    <label class="ms-2 beautiful-label" :for="permission.id">
                                        {{ handlePermissionName(permission.name) }}
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </form>
        </template>
    </app-modal>
</template>

<style scoped>
/* Custom styles for improved aesthetics */

.beautiful-input {
    border: 1px solid #3498db;
    border-radius: 5px;
    padding: 10px;
    font-size: 16px;
}

.beautiful-error {
    color: #e74c3c;
    font-size: 14px;
    margin-top: 4px;
}

.beautiful-checkbox {
    margin-top: 2px;
    margin-right: 4px;
}

.beautiful-role {
    margin-bottom: 20px;
    border: 1px solid #dcdcdc;
    border-radius: 8px;
    overflow: hidden;
}

.title-bar {
    background-color: #0A3D34;
    padding: 8px;
    font-weight: bold;
    color: #FFFFFF;
}

.content {
    background-color: #ffffff;
    border-top: 1px solid #dcdcdc;
    padding: 10px;
}

.beautiful-label {
    font-size: 14px;
    color: #333333;
}

.beautiful-checkbox {
    transition: transform 0.3s ease-in-out;
}
</style>


<script setup>
import {ref, computed, onMounted} from "vue";
import {useSubmitForm} from "@/composable/useSubmitForm.js";
import Axios from "@/services/axios/index.js";

const props = defineProps({
    modalId: String,
    selectedUrl: String,
    data: {
        default: function () {
            return {
                permissions: {}
            };
        }
    }
})
const handlePermissionName = (param) => {
    return param.replace(/_/g, ' ').replace(/^\w/, (c) => c.toUpperCase());
}

const emit = defineEmits(['close'])

const formData = ref({
    permissions: []
})

const {preloader, errors, save, closeModal} = useSubmitForm(props, emit, 'no')
const submit = () => {
    save(props.selectedUrl ? props.selectedUrl : 'roles', formData.value)
}

const permissionLength = computed(() => {
    let i = 0;
    for (let permissionGroup in props.data.permissions) {
        i += props.data.permissions[permissionGroup].length;
    }
    return i;
})

const selectAll = (event) => {
    if (event.target.checked) {
        for (let permissionGroup in props.data.permissions) {
            for (let permission in props.data.permissions[
                permissionGroup
                ]) {
                formData.value.permissions.push(props.data.permissions[permissionGroup][permission].id);
            }
        }
    } else {
        formData.value.permissions = [];
    }
}

const selectGroup = (event) => {
    let groupName = event.target.name;
    if (event.target.checked) {
        assignGroupPermission(getPermissionValues(props.data.permissions[groupName], "id"));
    } else {
        detachGroupPermission(
            getPermissionValues(
                props.data.permissions[groupName],
                "id"
            )
        );
    }
}

const getPermissionValues = (data, key) => {
    let value = [];
    for (let index in data) {
        value.push(data[index][key]);
    }
    return value;
}
const assignGroupPermission = (permissions) => {
    for (let index in permissions) {
        if (!formData.value.permissions.includes(permissions[index])) {
            formData.value.permissions.push(permissions[index]);
        }
    }
}
const detachGroupPermission = (permissions) => {
    for (let index in permissions) {
        let indexOf = formData.value.permissions.indexOf(
            permissions[index]
        );
        formData.value.permissions.splice(indexOf, 1);
    }
}
const groupIsChecked = (groupPermissions) => {
    let groupPermissionCheck = true;
    groupPermissions.forEach(item => {
        if (!formData.value.permissions.includes(item.id)) {
            groupPermissionCheck = false;
        }
    });
    return groupPermissionCheck;
}

const pageLoader = ref(false)
const getEditData = () => {
    if (props.selectedUrl) {
        pageLoader.value = true
        Axios.get(props.selectedUrl).then(({data}) => {
            formData.value = data
            formData.value.permissions = data.permissions.map(item => item.id);
        }).finally(() => pageLoader.value = false)
    }
}
onMounted(() => {
    if (props.selectedUrl) {
        getEditData()
    }
})
</script>
<style scoped>

</style>
