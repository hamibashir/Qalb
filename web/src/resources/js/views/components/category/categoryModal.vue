<template>
    <app-modal :modal-id="modalId"
               modal-size="small"
               :title="selectedUrl ? 'Update Category' : 'Add Category'"
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
    save(props.selectedUrl ? props.selectedUrl : 'category', formData.value)
}
</script>
