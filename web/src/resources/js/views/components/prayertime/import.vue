<script setup>
import { ref } from 'vue';
import Axios from "@/services/axios/index.js";
import { toast } from "vue3-toastify";
import {urlGenerator} from "@/utilities/urlGenerator.js";

const preloader = ref(false);
const file = ref(null);
const fileInputEvent = ref(null);
const onFileChanged = (e) => {
    fileInputEvent.value = e;
    file.value = e.target.files[0];
};
const onsubmit = (e) => {
    preloader.value = true;

    if (!file.value) {
        toast.error('Please select a file');
        preloader.value = false;
        return;
    }

    // Validate file type
    const allowedExtensions = ['xlsx', 'xls', 'csv'];
    const fileExtension = file.value.name.split('.').pop().toLowerCase();
    if (!allowedExtensions.includes(fileExtension)) {
        toast.error('Only .xlsx, .xls, or .csv files are allowed');
        preloader.value = false;
        return;
    }

    // Validate file size (70 KB = 70 * 1024 bytes)
    const maxFileSize = 150 * 1024; // 70 KB
    if (file.value.size > maxFileSize) {
        toast.error('File size must not exceed 150 KB');
        preloader.value = false;
        return;
    }

    const formData = new FormData();
    formData.append('file', file.value);

    Axios.post('prayertime-import', formData, {
        headers: {
            "Content-Type": "multipart/form-data",
        },
    }).then((data) => {
        toast.success(data.data.message);
        file.value = null;
        fileInputEvent.value.target.value = null;
    }).catch(({response}) => {
        toast.error(response.data.message);
    }).finally(() => preloader.value = false);
};

// Example file download URL (replace with your actual file URL)
const exampleFileUrl = urlGenerator('assets/prayer_times_example.xlsx');
</script>
<template>
    <main class="content py-5">
        <div class="container p-4 shadow-sm rounded bg-white">
            <h1 class="mb-4 text-center">Prayer Time Import</h1>
                        <!-- Special Note -->
            <div class="instruction-box mb-4 p-3 rounded">
                <strong>Instructions for the Excel File:</strong>
                <ul class="mb-0">
                    <li>Date format should be <code>DD/MM/YYYY</code> (e.g., 01/01/2025).</li>
                    <li>Ensure the <b>Column</b> names are correct: <b>"Time"</b>, <b>"City"</b>, and other necessary columns.</li>
                    <li>File size should not exceed 150 KB.</li>
                    <li>
                        <span class="form-text mt-2">
                    <a :href="exampleFileUrl" download="prayer_times_example.xlsx" class="text-primary text-decoration-underline">
                        Download Example File
                    </a>
                </span>
                    </li>
                </ul>

            </div>
            <form enctype="multipart/form-data" @submit.prevent="onsubmit" class="needs-validation">
                <div class="mb-3">
                    <label for="file" class="form-label fw-bold">Upload File</label>
                    <input
                        id="file"
                        class="form-control form-control-lg"
                        type="file"
                        @change="onFileChanged($event)"
                        accept=".xlsx, .xls, .csv"
                    >
                </div>
                <div class="text-center">
                    <button
                        :disabled="preloader"
                        type="submit"
                        class="btn btn-primary btn-lg w-100">
                        <span v-if="preloader" class="spinner-border spinner-border-sm me-2"></span>
                        Submit
                    </button>
                </div>
            </form>
        </div>
    </main>
</template>


<style scoped>
.content {
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    background-color: #f8f9fa;
}

.container {
    max-width: 700px;
}
.instruction-box {
    background-color: #eaf4fb;
    border-left: 4px solid #007bff;
    color: #0056b3;
}
ul {
    padding-left: 20px;
    margin-top: 8px;
}
.instruction-box strong {
    display: block;
    margin-bottom: 4px;
}
</style>
