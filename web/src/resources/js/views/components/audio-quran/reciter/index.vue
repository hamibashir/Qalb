<template>
    <main class="content">
        <div class="container-fluid p-0">
            <div class="mb-3">
                <h1 class="h3 d-inline align-middle"><strong>Reciter List</strong></h1>
                <a href="" v-if="$canAccess('create_reciter')" @click.prevent="isModalActive= true"
                   class="btn bg-primary text-white float-end">
                    Add Reciter
                </a>
            </div>
        </div>

        <div class="search-container d-flex justify-content-end align-items-center">
            <input type="text" class="form-control" v-model="search" @input="getSearchValue()"
                   placeholder="Search...">
        </div>

        <div class="row">
            <div class="col-12">
                <div class="card">
                    <app-loader v-if="preloader"/>
                    <div v-else class="table-responsive">
                        <table class="table mb-3">
                            <thead>
                            <tr>
                                <th scope="col" style="width: 65%;">Reciter</th>
                                <th scope="col" style="width: 10%;">Total Sura</th>
                                <th scope="col" style="width: 20%;">Position</th>
                                <th scope="col" class="text-end" style="width: 5%;">Action</th>
                            </tr>
                            </thead>
                            <tbody>

                            <tr v-for="dataObj in dataSetList.data">
                                <td width="30%">
                                    <div class="d-flex align-items-center">
                                        <img class="profile-picture"
                                             :src="dataObj.profile_picture ? urlGenerator(dataObj.profile_picture) : urlGenerator('assets/img/avatar.png')"
                                             alt="Profile Picture"/>
                                        <div class="ms-3">
                                            <span class="fw-bold">{{ dataObj.name }}</span>
                                        </div>
                                    </div>
                                </td>
                                <td><span class="badge badge-info-light">{{ dataObj.suras_count }}</span></td>
                                <td>{{ dataObj.position }}</td>

                                <td class="table-action">
                                    <div class="action-icons d-flex justify-content-center">
                                        <div v-if="$canAccess('view_reciter_sura')">
                                            <a :href="urlGenerator('audio/reciter/sura/list')+'/'+dataObj.id">
                                                <img class="action_icon"
                                                     :src="urlGenerator('assets/img/icons/audio.svg')"
                                                     alt="Roles Icon"/>
                                            </a>
                                        </div>
                                        <div v-if="$canAccess('update_reciter')">
                                            <a @click.prevent="editData(dataObj)">
                                                <img class="action_icon"
                                                     :src="urlGenerator('assets/img/icons/edit.svg')" alt="Edit Icon"/>
                                            </a>
                                        </div>
                                        <div v-if="$canAccess('delete_reciter')">
                                            <a @click.prevent="deleteData(dataObj)">
                                                <img class="action_icon"
                                                     :src="urlGenerator('assets/img/icons/trash.svg')"
                                                     alt="Trash Icon"/>
                                            </a>
                                        </div>
                                    </div>
                                </td>
                            </tr>

                            </tbody>
                        </table>
                    </div>
                    <bootstrap5-pagination :data="dataSetList"
                                           @pagination-change-page="getServerData"
                    />
                </div>
            </div>
        </div>
        <add-reciter-modal v-if="isModalActive"
                           modal-id="reciter-modal"
                           :selected-url="selectedData"
                           @close="closeModal"/>

        <app-delete-modal v-if="isDeleteModal"
                          :selected-url="deleteUrl"
                          @cancelled="cancelled"/>
    </main>
</template>

<script setup>

import {onMounted, ref} from "vue";
import Axios from "@/services/axios/index.js";
import useEmitter from "@/composable/useEmitter.js";
import {useOpenModal} from "@/composable/useOpenModal.js";
import {useDeleteModal} from "@/composable/useDeleteModal.js";
import {Bootstrap5Pagination} from 'laravel-vue-pagination';
import {urlGenerator} from "@/utilities/urlGenerator.js";
import AddReciterModal from "@/components/audio-quran/reciter/reciterModal.vue";

const {isModalActive, selectedData, closeModal} = useOpenModal();
const {deleteUrl, isDeleteModal, cancelled} = useDeleteModal()
import {debounce as _debounce} from "lodash";


const dataSetList = ref({})
const preloader = ref(false)
const search = ref("")

const getSearchValue = _debounce(() => {
    if (search.value) {
        getServerData(1, search.value)
    } else {
        getServerData(1)
    }
}, 500);
const getServerData = (page = 1, search = "") => {
    preloader.value = true
    Axios.get(`reciter?page=${page}&search=${search}`).then((data) => {
        dataSetList.value = data.data
    }).finally(() => preloader.value = false)
}

const editData = (row) => {
    isModalActive.value = true
    selectedData.value = `reciter/${row.id}`
}
const deleteData = (row) => {
    isDeleteModal.value = true
    deleteUrl.value = `reciter/${row.id}`
}
const emitter = useEmitter();
const reloadDataTable = () => {
    emitter.on("reload-table", (value = true) => {
        console.log('value')
        if (value) {
            getServerData();
        }
    });
};


onMounted(() => {
    getServerData();
    reloadDataTable()
})
</script>

<style scoped>
.profile-picture {
    width: 50px;
    height: 50px;
    border-radius: 50%;
    object-fit: cover;
}

.fw-bold {
    font-weight: 600;
}
</style>
