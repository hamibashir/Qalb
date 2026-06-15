<template>
    <app-modal :modal-id="modalId"
               modal-size="large"
               :title="selectedUrl ? 'Update HaramCode' : 'Add HaramCode'"
               :preloader="preloader"
               @submit="submit"
               @close="closeModal">

        <template v-slot:body>
            <app-loader v-if="pageLoader"/>
            <form v-else>
            <div class="mb-3">
                <label class="name">Name <span class="text-danger">*</span></label>
                <input type="text"
                       id="name"
                       v-model="formData.name"
                       class="form-control"
                       placeholder="Enter name">
                <small class="text-danger" v-if="errors.name">{{ errors.name[0] }}</small>
            </div>
            <div class="mb-3">
                <label class="code">Code <span class="text-danger">*</span></label>
                <input type="text"
                       id="code"
                       v-model="formData.code"
                       class="form-control"
                       placeholder="Enter code">
                <small class="text-danger" v-if="errors.code">{{ errors.code[0] }}</small>
            </div>

            <div class="mb-3">
                <label class="description">Description <span class="text-danger">*</span></label>

                <textarea id="description" class="form-control" v-model="formData.description"></textarea>
                <small class="text-danger" v-if="errors.description">{{ errors.description[0] }}</small>
            </div>

            <div class="mb-3">
                <label class="status_info">Status info</label>
                <textarea id="status_info" class="form-control" v-model="formData.status_info"></textarea>
                <small class="text-danger" v-if="errors.status_info">{{ errors.status_info[0] }}</small>
            </div>
            </form>
        </template>
    </app-modal>
</template>

<script setup>
import {useSubmitForm} from "@/composable/useSubmitForm.js";

const props = defineProps({
    modalId: String,
    selectedUrl: String,
})

const emit = defineEmits(['close'])


const {preloader, pageLoader, errors, save, formData, closeModal} = useSubmitForm(props, emit)
const submit = () => {
    save(props.selectedUrl ? props.selectedUrl : 'haram-codes', formData.value)
}
</script>
