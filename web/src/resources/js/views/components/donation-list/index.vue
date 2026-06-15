<template>
    <main class="content">
        <div class="container-fluid p-0">
            <div class="mb-3">
                <h1 class="h3 d-inline align-middle"><strong>Donation List</strong></h1>
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
                                <th scope="col">Payment Method</th>
                                <th scope="col">Email</th>
                                <th scope="col">Category</th>
                                <th scope="col">Date</th>
                                <th scope="col">Amount</th>
                            </tr>
                            </thead>
                            <tbody>

                            <tr v-for="dataObj in dataSetList.data">
                                <td><img height="25" :src="urlGenerator(`assets/img/icons/${dataObj.payment_method.type}.svg`)" alt=""> {{ dataObj.payment_method.name }}</td>
                                <td>{{ dataObj.email }}</td>
                                <td>{{ dataObj.category.name }}</td>
                                <td>{{ dataObj.transaction.date }}</td>
                                <td>{{ dataObj.transaction.amount }}</td>
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

    </main>
</template>

<script setup>

import {onMounted, ref} from "vue";
import Axios from "@/services/axios/index.js";
import useEmitter from "@/composable/useEmitter.js";
import {Bootstrap5Pagination} from 'laravel-vue-pagination';

import {debounce as _debounce} from "lodash";
import {urlGenerator} from "@/utilities/urlGenerator.js";

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
    Axios.get(`donation-list?page=${page}&search=${search}`).then((data) => {
        dataSetList.value = data.data
    }).finally(() => preloader.value = false)
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

