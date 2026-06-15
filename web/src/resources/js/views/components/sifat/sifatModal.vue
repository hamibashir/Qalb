<template>
    <app-modal :modal-id="modalId"
               modal-size="large"
               :title="selectedUrl ? 'Update Sifat' : 'Add Sifat'"
               :preloader="preloader"
               @submit="submit"
               @close="closeModal">

        <template v-slot:body>
            <app-loader v-if="pageLoader"/>
            <form v-else>
            <div class="mb-3">
                <label class="name">Name (En) <span class="text-danger">*</span></label>
                <input type="text"
                       id="name"
                       v-model="formData.name"
                       class="form-control"
                       placeholder="Enter english name">
                <small class="text-danger" v-if="errors.name">{{ errors.name[0] }}</small>
            </div>
            <div class="mb-3">
                <label class="ar_name">Name (Ar) <span class="text-danger">*</span></label>
                <input type="text"
                       id="ar_name"
                       v-model="formData.ar_name"
                       class="form-control"
                       placeholder="Enter arabic name">
                <small class="text-danger" v-if="errors.ar_name">{{ errors.ar_name[0] }}</small>
            </div>

            <div class="mb-3">
                <label class="translated_name">Translated Name (Ar) <span class="text-danger">*</span></label>
                <input type="text"
                       id="translated_name"
                       v-model="formData.translated_name"
                       class="form-control"
                       placeholder="Enter translated name (Ar)">
                <small class="text-danger" v-if="errors.translated_name">{{ errors.translated_name[0] }}</small>
            </div>

            <div class="mb-3">
                <label class="meaning">Meaning (En)</label>
                <input type="text"
                       id="meaning"
                       v-model="formData.meaning"
                       class="form-control"
                       placeholder="Enter meaning">
                <small class="text-danger" v-if="errors.meaning">{{ errors.meaning[0] }}</small>
            </div>
            <div class="mb-3">
                <label class="name_benefits">Name Benefits</label>
                <input type="text"
                       id="name_benefits"
                       v-model="formData.name_benefits"
                       class="form-control"
                       placeholder="Enter name benefits">
                <small class="text-danger" v-if="errors.name_benefits">{{ errors.name_benefits[0] }}</small>
            </div>
            <div class="mb-3">
                <label class="position">Position</label>
                <input type="text"
                       id="position"
                       v-model="formData.position"
                       class="form-control"
                       placeholder="Enter position">
                <small class="text-danger" v-if="errors.position">{{ errors.position[0] }}</small>
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


const {preloader, errors, save, formData, closeModal, pageLoader} = useSubmitForm(props, emit)
const submit = () => {
    save(props.selectedUrl ? props.selectedUrl : 'sifats', formData.value)
}
</script>
