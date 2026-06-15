<template>
    <app-modal :modal-id="modalId"
               modal-size="large"
               :title="selectedUrl ? 'Update Sura' : 'Add Sura'"
               :preloader="preloader"
               @submit="submit"
               @close="closeModal">

        <template v-slot:body>
            <app-loader v-if="pageLoader"/>
            <form v-else>
                <!-- Sura Name -->
                <div class="mb-3">
                    <label class="name">Sura Name <span class="text-danger">*</span></label>
                    <Select2
                        v-model="formData.name"
                        :placeholder="'Enter Sura Name'"
                        :options="selectOptions"
                        v-if="!selectedUrl"
                    />
                    <input v-else type="text" readonly v-model="formData.name" class="form-control">
                    <small class="text-danger" v-if="errors.name">{{ errors.name[0] }}</small>
                </div>

                <!-- Sura Number -->
                <div class="mb-3">
                    <label class="number">Sura Number <span class="text-danger">*</span></label>
                    <input type="number"
                           id="number"
                           v-model="formData.number"
                           class="form-control"
                           autocomplete
                           placeholder="Enter number">
                    <small class="text-danger" v-if="errors.number">{{ errors.number[0] }}</small>
                </div>
                <div class="mb-3">
                    <label class="duration">Duration <span class="text-danger">*</span> <code>{{ durationText }}</code> </label>
                    <input type="number"
                           id="duration"
                           v-model="formData.duration"
                           class="form-control"
                           disabled
                           autocomplete="false"
                           placeholder="Enter duration">
                    <small class="text-danger" v-if="errors.duration">{{ errors.duration[0] }}</small>
                </div>

                <!-- Revealed Place -->
                <div class="mb-3">
                    <label class="sura_number">Revealed place <span class="text-danger">*</span></label>
                    <Select2
                        v-model="formData.revealed_place"
                        :placeholder="'Enter Revealed Place'"
                        :options="revealedPlaces"
                        v-if="!selectedUrl"
                    />
                    <input v-else type="text" readonly v-model="formData.revealed_place" class="form-control">
                    <small class="text-danger" v-if="errors.revealed_place">{{ errors.revealed_place[0] }}</small>
                </div>

                <div class="mb-3">
                    <label class="sura_number">Audio File <span class="text-danger">*</span></label>
                    <input type="file" class="form-control" @change="handleFileUpload">
                    <small class="text-danger" v-if="errors.audio_file">{{ errors.audio_file[0] }}</small>
                    <div v-if="progress > 0">Upload Progress: {{ progress }}%</div>
                </div>
            </form>
        </template>
    </app-modal>
</template>

<script setup>
import {useSubmitForm} from "@/composable/useSubmitForm.js";
import {computed, ref, watch} from "vue";
import Axios from "@/services/axios/index.js";
import {toast} from "vue3-toastify";
import Select2 from "@/components/select/select2.vue";

const props = defineProps({
    modalId: String,
    selectedUrl: String,
    reciterId: String,
    reciterName: String
});

const emit = defineEmits(['close']);

const {
    preloader,
    pageLoader,
    errors,
    afterSuccess,
    afterError,
    afterFinalResponse,
    closeModal
} = useSubmitForm(props, emit);

const formData = ref({
    name: '',
    number: '',
    duration: '',
    durationText: '',
    revealed_place: '',
    audio_file: null,
    reciter_name : props.reciterName
});
const CHUNK_SIZE = 1024 * 1000; // 2 MB
const MAX_FILE_SIZE = 250 * 1024 * 1024; // 100 MB

const file = ref(null);
const progress = ref(0);

// const handleFileUpload = (event) => {
//     const selectedFile = event.target.files[0];
//     if (selectedFile && selectedFile.size <= MAX_FILE_SIZE) {
//         formData.value.audio_file = selectedFile; // Save the file for later use during form submission
//     } else {
//         console.error("Invalid file or file too large");
//     }
// };


// Computed property to format duration
const durationText = computed(() => {
    const durationInSeconds = formData.value.duration;

    // If the duration is 0 or not set, return an empty string
    if (!durationInSeconds) return '';

    const hours = Math.floor(durationInSeconds / 3600);
    const minutes = Math.floor((durationInSeconds % 3600) / 60);
    const seconds = durationInSeconds % 60;

    // If hours exist, show hh:mm:ss format; otherwise show mm:ss format
    return hours > 0
        ? `${hours}:${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`
        : `${minutes}:${seconds.toString().padStart(2, '0')}`;
});

// Watch the file upload and calculate duration
const handleFileUpload = (event) => {
    const selectedFile = event.target.files[0];
    if (!selectedFile) return;

    formData.value.audio_file = selectedFile; // Save the file for submission

    // Create a temporary URL for the selected file
    const fileUrl = URL.createObjectURL(selectedFile);

    // Create an audio element to load the file and get its duration
    const audio = new Audio(fileUrl);
    audio.addEventListener('loadedmetadata', () => {
        const durationInSeconds = Math.round(audio.duration); // Get duration in seconds
        formData.value.duration = durationInSeconds; // Set the duration
        URL.revokeObjectURL(fileUrl); // Revoke the object URL to free up memory
    });

    audio.addEventListener('error', () => {
        console.error("Failed to load audio metadata");
    });
};



const submit = async () => {
    preloader.value = true;

    try {
        const submitData = new FormData();
        submitData.append('reciter_id', props.reciterId);
        submitData.append('name', formData.value.name);
        submitData.append('number', formData.value.number);
        submitData.append('duration', formData.value.duration);
        submitData.append('revealed_place', formData.value.revealed_place);
        let audioFilePath; // Variable to hold the file path

        if (formData.value.audio_file) {
            // File is too large, upload in chunks
            if (formData.value.audio_file.size > CHUNK_SIZE) {
                audioFilePath = await uploadInChunks(formData.value.audio_file, props.reciterName);
                // You can use the path returned from uploadInChunks
            } else {
                // Regular upload if file is small
                submitData.append('audio_file', formData.value.audio_file);
            }
        }

        // If we uploaded the audio file in chunks, append the file path
        if (audioFilePath) {
            submitData.append('audio_file', audioFilePath);
        }

        if (props.selectedUrl) {
            submitData.append('id', formData.value.id);
            submitData.append('_method', 'PATCH')
        }

        // Ensure that this request is always triggered, regardless of file size
        await Axios.post(props.selectedUrl || 'reciter-sura', submitData, {
            headers: {
                'Content-Type': 'multipart/form-data'
            }
        }).then((response) => {
            afterSuccess(response)
        }).catch(({response}) => {
            afterError(response)
        }).finally(() => afterFinalResponse())

    } catch (error) {
        console.error("Submission Error:", error);
        afterError(error.response);
    } finally {
        afterFinalResponse();
    }
};


const uploadInChunks = async (file, reciterName) => {
    const totalChunks = Math.ceil(file.size / CHUNK_SIZE);
    let start = 0;

    for (let chunkNumber = 0; chunkNumber < totalChunks; chunkNumber++) {
        const chunk = file.slice(start, start + CHUNK_SIZE);
        const chunkForm = new FormData();

        chunkForm.append('file', chunk, `${file.name}.part`);
        chunkForm.append('chunkNumber', chunkNumber + 1);
        chunkForm.append('totalChunks', totalChunks);
        chunkForm.append('fileName', file.name);
        chunkForm.append('reciterName', reciterName);  // Send reciter name here

        try {
            const response = await Axios.post('upload-chunk', chunkForm, {
                headers: {
                    'Content-Type': 'multipart/form-data'
                },
            });

            if (chunkNumber + 1 === totalChunks) {
                const filePath = response.data.filePath;
                return filePath;
            }

            start += CHUNK_SIZE;
            progress.value = Math.round(((chunkNumber + 1) / totalChunks) * 100);

        } catch (error) {
            console.error("Error uploading chunk:", error);
            throw error;
        }
    }
};


const revealedPlaces = ref([
    {id: 'Makka', name: "Makka"},
    {id: 'Madina', name: "Madina"}
]);

// Fetch data when URL is selected and populate form
const fetchFormData = async () => {
    if (props.selectedUrl) {
        try {
            const response = await Axios.get(props.selectedUrl);
            formData.value.id = response.data.id;
            formData.value.name = response.data.name;
            formData.value.number = response.data.number;
            formData.value.duration = response.data.duration;
            formData.value.revealed_place = response.data.revealed_place;
        } catch (error) {
            toast.error("Failed to fetch sura details");
        }
    }
};

const selectOptions = ref([
    {id: 'Al-Fatihah', name: 'Al-Fatihah'},
    {id: 'Al-Baqarah', name: 'Al-Baqarah'},
    {id: 'Aal-E-Imran', name: 'Aal-E-Imran'},
    {id: 'An-Nisa', name: 'An-Nisa'},
    {id: 'Al-Maidah', name: 'Al-Maidah'},
    {id: 'Al-Anam', name: 'Al-Anam'},
    {id: 'Al-Araf', name: 'Al-Araf'},
    {id: 'Al-Anfal', name: 'Al-Anfal'},
    {id: 'At-Tawbah', name: 'At-Tawbah'},
    {id: 'Yunus', name: 'Yunus'},
    {id: 'Hud', name: 'Hud'},
    {id: 'Yusuf', name: 'Yusuf'},
    {id: 'Ar-Rad', name: 'Ar-Rad'},
    {id: 'Ibrahim', name: 'Ibrahim'},
    {id: 'Al-Hijr', name: 'Al-Hijr'},
    {id: 'An-Nahl', name: 'An-Nahl'},
    {id: 'Al-Isra', name: 'Al-Isra'},
    {id: 'Al-Kahf', name: 'Al-Kahf'},
    {id: 'Maryam', name: 'Maryam'},
    {id: 'Taha', name: 'Taha'},
    {id: 'Al-Anbiya', name: 'Al-Anbiya'},
    {id: 'Al-Hajj', name: 'Al-Hajj'},
    {id: 'Al-Muminun', name: 'Al-Muminun'},
    {id: 'An-Nur', name: 'An-Nur'},
    {id: 'Al-Furqan', name: 'Al-Furqan'},
    {id: 'Ash-Shuara', name: 'Ash-Shuara'},
    {id: 'An-Naml', name: 'An-Naml'},
    {id: 'Al-Qasas', name: 'Al-Qasas'},
    {id: 'Al-Ankabut', name: 'Al-Ankabut'},
    {id: 'Ar-Rum', name: 'Ar-Rum'},
    {id: 'Luqman', name: 'Luqman'},
    {id: 'As-Sajda', name: 'As-Sajda'},
    {id: 'Al-Ahzab', name: 'Al-Ahzab'},
    {id: 'Saba', name: 'Saba'},
    {id: 'Fatir', name: 'Fatir'},
    {id: 'Ya-Sin', name: 'Ya-Sin'},
    {id: 'As-Saffat', name: 'As-Saffat'},
    {id: 'Sad', name: 'Sad'},
    {id: 'Az-Zumar', name: 'Az-Zumar'},
    {id: 'Ghafir', name: 'Ghafir'},
    {id: 'Fussilat', name: 'Fussilat'},
    {id: 'Ash-Shura', name: 'Ash-Shura'},
    {id: 'Az-Zukhruf', name: 'Az-Zukhruf'},
    {id: 'Ad-Dukhan', name: 'Ad-Dukhan'},
    {id: 'Al-Jathiyah', name: 'Al-Jathiyah'},
    {id: 'Al-Ahqaf', name: 'Al-Ahqaf'},
    {id: 'Muhammad', name: 'Muhammad'},
    {id: 'Al-Fath', name: 'Al-Fath'},
    {id: 'Al-Hujurat', name: 'Al-Hujurat'},
    {id: 'Qaf', name: 'Qaf'},
    {id: 'Adh-Dhariyat', name: 'Adh-Dhariyat'},
    {id: 'At-Tur', name: 'At-Tur'},
    {id: 'An-Najm', name: 'An-Najm'},
    {id: 'Al-Qamar', name: 'Al-Qamar'},
    {id: 'Ar-Rahman', name: 'Ar-Rahman'},
    {id: 'Al-Waqiah', name: 'Al-Waqiah'},
    {id: 'Al-Hadid', name: 'Al-Hadid'},
    {id: 'Al-Mujadila', name: 'Al-Mujadila'},
    {id: 'Al-Hashr', name: 'Al-Hashr'},
    {id: 'Al-Mumtahina', name: 'Al-Mumtahina'},
    {id: 'As-Saff', name: 'As-Saff'},
    {id: 'Al-Jumuah', name: 'Al-Jumuah'},
    {id: 'Al-Munafiqun', name: 'Al-Munafiqun'},
    {id: 'At-Taghabun', name: 'At-Taghabun'},
    {id: 'At-Talaq', name: 'At-Talaq'},
    {id: 'At-Tahrim', name: 'At-Tahrim'},
    {id: 'Al-Mulk', name: 'Al-Mulk'},
    {id: 'Al-Qalam', name: 'Al-Qalam'},
    {id: 'Al-Haqqah', name: 'Al-Haqqah'},
    {id: 'Al-Maarij', name: 'Al-Maarij'},
    {id: 'Nuh', name: 'Nuh'},
    {id: 'Al-Jinn', name: 'Al-Jinn'},
    {id: 'Al-Muzzammil', name: 'Al-Muzzammil'},
    {id: 'Al-Muddaththir', name: 'Al-Muddaththir'},
    {id: 'Al-Qiyamah', name: 'Al-Qiyamah'},
    {id: 'Al-Insan', name: 'Al-Insan'},
    {id: 'Al-Mursalat', name: 'Al-Mursalat'},
    {id: 'An-Naba', name: 'An-Naba'},
    {id: 'An-Naziat', name: 'An-Naziat'},
    {id: 'Abasa', name: 'Abasa'},
    {id: 'At-Takwir', name: 'At-Takwir'},
    {id: 'Al-Infitar', name: 'Al-Infitar'},
    {id: 'Al-Mutaffifin', name: 'Al-Mutaffifin'},
    {id: 'Al-Inshiqaq', name: 'Al-Inshiqaq'},
    {id: 'Al-Buruj', name: 'Al-Buruj'},
    {id: 'At-Tariq', name: 'At-Tariq'},
    {id: 'Al-Ala', name: 'Al-Ala'},
    {id: 'Al-Ghashiyah', name: 'Al-Ghashiyah'},
    {id: 'Al-Fajr', name: 'Al-Fajr'},
    {id: 'Al-Balad', name: 'Al-Balad'},
    {id: 'Ash-Shams', name: 'Ash-Shams'},
    {id: 'Al-Lail', name: 'Al-Lail'},
    {id: 'Ad-Duha', name: 'Ad-Duha'},
    {id: 'Ash-Sharh', name: 'Ash-Sharh'},
    {id: 'At-Tin', name: 'At-Tin'},
    {id: 'Al-Alaq', name: 'Al-Alaq'},
    {id: 'Al-Qadr', name: 'Al-Qadr'},
    {id: 'Al-Bayyinah', name: 'Al-Bayyinah'},
    {id: 'Az-Zalzalah', name: 'Az-Zalzalah'},
    {id: 'Al-Adiyat', name: 'Al-Adiyat'},
    {id: 'Al-Qariah', name: 'Al-Qariah'},
    {id: 'At-Takathur', name: 'At-Takathur'},
    {id: 'Al-Asr', name: 'Al-Asr'},
    {id: 'Al-Humazah', name: 'Al-Humazah'},
    {id: 'Al-Fil', name: 'Al-Fil'},
    {id: 'Quraish', name: 'Quraish'},
    {id: 'Al-Maun', name: 'Al-Maun'},
    {id: 'Al-Kawthar', name: 'Al-Kawthar'},
    {id: 'Al-Kafirun', name: 'Al-Kafirun'},
    {id: 'An-Nasr', name: 'An-Nasr'},
    {id: 'Al-Masad', name: 'Al-Masad'},
    {id: 'Al-Ikhlas', name: 'Al-Ikhlas'},
    {id: 'Al-Falaq', name: 'Al-Falaq'},
    {id: 'An-Nas', name: 'An-Nas'}

]);

// Watch for URL change to trigger data fetch
watch(() => props.selectedUrl, fetchFormData, {immediate: true});
</script>
