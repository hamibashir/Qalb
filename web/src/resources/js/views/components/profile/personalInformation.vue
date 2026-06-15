<template>
    <app-loader v-if="pageLoader"/>
    <form v-else class="form-horizontal" method="POST" enctype="multipart/form-data">
        <div class="form-group row mb-3 mt-3">
            <label for="first_name" class="col-sm-2 col-form-label">First
                Name <span class="text-danger">*</span></label>
            <div class="col-sm-10">
                <input type="text" class="form-control"
                       v-model="formData.first_name"
                       id="first_name"
                       placeholder="Enter Name">
                <small class="text-danger" v-if="errors.first_name">{{ errors.first_name[0] }}</small>
            </div>
        </div>
        <div class="form-group row mb-3 mt-3">
            <label for="last_name" class="col-sm-2 col-form-label">Last
                Name <span class="text-danger">*</span></label>
            <div class="col-sm-10">
                <input type="text" class="form-control"
                       v-model="formData.last_name"
                       id="last_name"
                       placeholder="Enter Last Name">
                <small class="text-danger" v-if="errors.last_name">{{ errors.last_name[0] }}</small>
            </div>
        </div>
        <div class="form-group row mb-3 mt-3">
            <label for="email" class="col-sm-2 col-form-label">Email <span
                class="text-danger">*</span></label>
            <div class="col-sm-10">
                <input type="email" class="form-control"
                       id="email"
                       placeholder="Enter Email"
                       v-model="formData.email">
                <small class="text-danger" v-if="errors.email">{{ errors.email[0] }}</small>
            </div>
        </div>
        <div class="form-group row mb-3 mt-3">
            <label for="phone_number"
                   class="col-sm-2 col-form-label">Phone</label>
            <div class="col-sm-10">
                <input type="text" class="form-control"
                       id="phone_number"
                       placeholder="Enter Phone"
                       v-model="formData.phone_number">

                <small class="text-danger" v-if="errors.phone_number">{{ errors.phone_number[0] }}</small>
            </div>
        </div>
        <div class="form-group row mb-3 mt-3">
            <label for="date_of_birth" class="col-sm-2 col-form-label">Date Of
                Birth</label>
            <div class="col-sm-10">
                <div class="input-group date">
                    <input type="date"
                           class="form-control"
                           id="date_of_birth"
                           v-model="formData.date_of_birth"
                           placeholder="Enter Date Of Birth"
                    />
                </div>
                <small class="text-danger" v-if="errors.date_of_birth">{{ errors.date_of_birth[0] }}</small>
            </div>
        </div>
        <div class="form-group row mb-3 mt-3">
            <label for="inputEmail"
                   class="col-sm-2 col-form-label">Gender</label>
            <div class="col-sm-10">
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="gender"
                           id="male" value="male" v-model="formData.gender">
                    <label class="form-check-label" for="male">Male</label>
                </div>
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="gender"
                           id="female" value="female"
                           v-model="formData.gender"
                    >
                    <label class="form-check-label" for="female">Female</label>
                </div>
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="gender"
                           id="others" value="other"
                           v-model="formData.gender">
                    <label class="form-check-label" for="others">Others</label>
                </div>

                <small class="text-danger" v-if="errors.gender">{{ errors.gender[0] }}</small>
            </div>
        </div>
        <div class="form-group row mb-3 mt-3">
            <label for="image" class="col-sm-2 col-form-label">Profile
                Picture</label>
            <div class="col-sm-10">
                <div>
                    <div class="custom-image-upload-wrapper">
                        <div class="image-area d-flex">
                            <img id="bruh"
                                 :src="profileAvatar"
                                 alt="profile picture"
                                 class="img-fluid mx-auto my-auto">
                        </div>
                        <div class="input-area"><label
                            id="upload-label"
                            for="profile_picture">
                            Change Avatar
                        </label>
                            <input
                                id="profile_picture"
                                name="profile_picture"
                                type="file"
                                class="form-control d-none"
                                @change="onFileChange($event)">
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="form-group row">
            <div class="offset-sm-2 col-sm-10">
                <button type="submit"
                        class="btn btn-primary action-btn py-2 px-3"
                        :disabled="preloader"
                        @click.prevent="submit">
                    <app-button-loader v-if="preloader"/>
                    Update
                </button>
            </div>
        </div>
    </form>
</template>

<script setup>
import {onMounted, ref} from "vue";
import {toast} from "vue3-toastify";
import Axios from "@/services/axios/index.js";
import {urlGenerator} from "@/utilities/urlGenerator.js";
import {formDataAssigner} from "@/utilities/helper.js";

const preloader = ref(false);
const errors = ref({});
const formData = ref({});
const file = ref(null);
const onFileChange = (event) => {
    file.value = event.target.files[0];
    profileAvatar.value = URL.createObjectURL(file.value);
}
const submit = () => {
    preloader.value = true;
    errors.value = {};
    delete formData.value?.profile;
    if (file.value) {
        formData.value.profile_picture = file.value
    } else {
        delete formData.value?.profile_picture
    }
    if (formData.value.date_of_birth === null || formData.value.date_of_birth === '') {
        formData.value.date_of_birth = ''
    }
    if (formData.value.phone_number === null || formData.value.phone_number === '') {
        formData.value.phone_number = ''
    }

    let data = formDataAssigner(new FormData(), formData.value);
    Axios.post('profile-update', data, {
        headers: {
            "Content-Type": "multipart/form-data",
        },
    }).then((response) => {
        toast.success(response.data.message)
        window.location.reload()
        getMyProfile()
    }).catch(({response}) => {
        if (response?.status === 422) {
            errors.value = response.data.errors
        } else {
            toast.error(response.data.message)
        }
    }).finally(() => preloader.value = false)
}


const profileAvatar = ref('');
const pageLoader = ref(false);
const getMyProfile = () => {
    pageLoader.value = true;
    Axios.get('profile').then((response) => {
        formData.value = response.data
        if (response.data.profile) {
            const profileData = response.data.profile
            formData.value.phone_number = profileData.phone_number
            formData.value.date_of_birth = profileData.date_of_birth
            formData.value.gender = profileData.gender
            profileAvatar.value = urlGenerator(profileData.profile_picture)
        }
    }).finally(() => pageLoader.value = false)
}
onMounted(() => {
    getMyProfile();
})

</script>
