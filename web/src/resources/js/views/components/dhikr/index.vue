<template>
    <main class="content">
        <div class="container-fluid p-0">
            <div class="mb-3">
                <h1 class="h3 d-inline align-middle"><strong>Dhikrs List</strong></h1>
                <a href="" v-if="$canAccess('create_dhikrs')" @click.prevent="isModalActive= true"
                   class="btn bg-primary text-white float-end">
                    Add Dhikr
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
                                <th scope="col" style="width: 10%;">Short name (En)</th>
                                <th scope="col" style="width: 10%;">Short name (Ar)</th>
                                <th scope="col" style="width: 40%;">Full name (En)</th>
                                <th scope="col" style="width: 40%;">Full name (Ar)</th>
                                <th scope="col" style="width: 40%;">Position</th>
                                <th scope="col" class="text-end" style="width: 10%;">Action</th>
                            </tr>
                            </thead>
                            <tbody>

                            <tr v-for="dataObj in dataSetList.data">
                                <td>{{ dataObj.en_short_name }}</td>
                                <td>{{ dataObj.ar_short_name }}</td>
                                <td>{{ dataObj.en_full_name }}</td>
                                <td>{{ dataObj.ar_full_name }}</td>
                                <td>{{ dataObj.position }}</td>

                                <td class="table-action">
                                    <div class="row">
                                        <div class="col-md-6" v-if="$canAccess('update_dhikrs')">
                                            <a @click.prevent="editData(dataObj)">
                                                <img class="action_icon"
                                                     :src="urlGenerator('assets/img/icons/edit.svg')" alt="Icon"/>
                                            </a>
                                        </div>
                                        <div class="col-md-6 pull-left" v-if="$canAccess('delete_dhikrs')">
                                            <a @click.prevent="deleteData(dataObj)">
                                                <img class="action_icon"
                                                     :src="urlGenerator('assets/img/icons/trash.svg')" alt="Icon"/>
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
        <dikr-modal v-if="isModalActive"
                    modal-id="dhikr-modal"
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
import DikrModal from "@/components/dhikr/dhikrModal.vue";
import {urlGenerator} from "@/utilities/urlGenerator.js";

const {isModalActive, selectedData, closeModal} = useOpenModal();
const {deleteUrl, isDeleteModal, cancelled} = useDeleteModal()
import { debounce as _debounce } from "lodash";


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
    Axios.get(`dhikrs?page=${page}&search=${search}`).then((data) => {
        dataSetList.value = data.data
    }).finally(() => preloader.value = false)
}

const editData = (row) => {
    isModalActive.value = true
    selectedData.value = `dhikrs/${row.id}`
}
const deleteData = (row) => {
    isDeleteModal.value = true
    deleteUrl.value = `dhikrs/${row.id}`
}
const emitter = useEmitter();
const reloadDataTable = () => {
    emitter.on("reload-table", (value = true) => {
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

