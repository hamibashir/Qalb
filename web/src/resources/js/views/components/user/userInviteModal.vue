<template>
    <app-modal :modal-id="modalId"
               modal-size="large"
               title="Invite User"
               :preloader="preloader"
               @submit="submit"
               @close="closeModal">

        <template v-slot:body>
            <div class="mb-3">
                <label class="form-label">First Name <span class="text-danger">*</span></label>
                <input type="text"
                       v-model="formData.first_name"
                       class="form-control"
                       placeholder="Enter First Name">
                <small class="text-danger" v-if="errors.first_name">{{ errors.first_name[0] }}</small>
            </div>
            <div class="mb-3">
                <label class="form-label">Last Name <span class="text-danger">*</span></label>
                <input type="text"
                       v-model="formData.last_name"
                       class="form-control"
                       placeholder="Enter Last Name">
                <small class="text-danger" v-if="errors.last_name">{{ errors.last_name[0] }}</small>
            </div>
            <div class="mb-3">
                <label class="form-label">Email <span class="text-danger">*</span></label>
                <input type="email"
                       v-model="formData.email"
                       class="form-control"
                       placeholder="Enter email">
                <small class="text-danger" v-if="errors.email">{{ errors.email[0] }}</small>
            </div>
            <div class="mb-3">
                <label class="form-label">Role <span class="text-danger">*</span></label>
                <select class="form-control" v-model="formData.role">
                    <option value="" disabled selected>Select Role</option>
                    <option v-for="role in roles" :value="role.id">{{ role.name }}</option>
                </select>
                <small class="text-danger" v-if="errors.role">{{ errors.role[0] }}</small>
            </div>
        </template>
    </app-modal>
</template>

<script setup>
import {ref, computed, onMounted} from "vue";
import {useSubmitForm} from "@/composable/useSubmitForm.js";
import Axios from "@/services/axios/index.js";

const props = defineProps({
    modalId: String,
})

const emit = defineEmits(['close'])

const formData = ref({
    role: ''
})

const {preloader, errors, save, closeModal} = useSubmitForm(props, emit, 'no')
const submit = () => {
    save('user-invite', formData.value)
}

const roles = ref([])
const getServerRole = () => {
    Axios.get('roles').then(response => {
        roles.value = response.data
    })
}
onMounted(() => {
    getServerRole();
})


</script>
