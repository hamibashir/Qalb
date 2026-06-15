<template>
    <main class="content">
        <div class="container-fluid p-0">
            <div class="mb-3">
                <h1 class="h3 d-inline align-middle"><strong>Prayer Times</strong></h1>
                <div class="row">
                    <div class="col-md-2"></div>
                    <div class="col-md-4">
                        <select class="form-select float-end" v-model="selectedCity" @change="filterByCity">
                            <option value="">Select City</option>
                            <option v-for="city in cities" :value="city">{{ city }}</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <button class="btn btn-danger float-end" @click.prevent="deleteCityPrayerTime" v-if="selectedCity && $canAccess('delete_prayer_times')">
                            Delete {{ selectedCity }} prayer time
                        </button>
                    </div>
                    <div class="col-md-2">
                        <a :href="urlGenerator('prayer-time/create')" class="btn btn-primary float-end"
                           v-if="$canAccess('create_prayer_times')">Add Prayer Time</a>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-md-2">
                <ul class="nav nav-pills flex-column">
                    <li class="nav-item" v-for="(month, index) in Object.keys(dataSetList)">
                        <a :class="`nav-link ${moment().format('MMMM') === month ? 'active' : ''}`"
                           :id="`${month}-tab`" data-bs-toggle="pill" :href="`#${month}-content`">
                            {{ month }}
                        </a>
                    </li>
                </ul>
            </div>

            <div class="col-md-10">
                <div class="tab-content mt-2">
                    <template v-for="(monthData, index) in Object.keys(dataSetList)">
                        <div :class="`tab-pane fade ${moment().format('MMMM') === monthData ? 'active show' : ''}`"
                             :id="`${monthData}-content`">
                            <h3 class="mb-3">{{ monthData }} Prayer Time</h3>

                            <div class="card">
                                <div class="table-responsive">
                                    <table class="table mb-3">
                                        <thead>
                                        <tr>
                                            <th>City</th>
                                            <th style="width: 10%">Date</th>
                                            <th>Imsak</th>
                                            <th>Sunrise</th>
                                            <th>Fajr Start</th>
                                            <th>Zuhr Start</th>
                                            <th>Asr Start</th>
                                            <th>Maghrib Start</th>
                                            <th>Isha Start</th>
                                            <th>Action</th>
                                        </tr>
                                        </thead>
                                        <tbody>


                                        <template v-for="prayerTime in dataSetList[monthData]">
                                            <tr :class="`${moment(prayerTime.date).format('YYYY-MM-DD')  === moment().format('YYYY-MM-DD') ? 'table-info' : ''}`">

                                                <td>{{ prayerTime.city }}</td>
                                                <td>{{ moment(prayerTime.date).format('DD.MM.YYYY') }}</td>
                                                <td>{{ prayerTime.imsak }}</td>
                                                <td>{{ prayerTime.sunrise }}</td>
                                                <td>{{ prayerTime.fajr_start }}</td>
                                                <td>{{ prayerTime.zuhr_start }}</td>
                                                <td>{{ prayerTime.asr_start }}</td>
                                                <td>{{ prayerTime.maghrib_start }}</td>
                                                <td>{{ prayerTime.isha_start }}</td>
                                                <td>
                                                    <a :href="urlGenerator('prayer-time/' + prayerTime.id + '/edit')"
                                                       class="text-decoration-none"
                                                       v-if="$canAccess('update_prayer_times')">
                                                        <img class="action_icon"
                                                             :src="urlGenerator('assets/img/icons/edit.svg')"
                                                             alt="Icon"/>
                                                    </a>
                                                    <a href="javascript:void(0)" @click="deletePrayerTime(prayerTime)"
                                                       class="text-decoration-none"
                                                       v-if="$canAccess('delete_prayer_times')">
                                                        <img class="action_icon"
                                                             :src="urlGenerator('assets/img/icons/trash.svg')"
                                                             alt="Icon"/>
                                                    </a>
                                                </td>
                                            </tr>
                                        </template>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </template>
                </div>
            </div>
            <div class="col-md-10" v-if="preloader">
                <span v-if="preloader" class="spinner-border spinner-border-sm me-2"></span>
            </div>
        </div>
        <app-delete-modal v-if="isDeleteModal"
                          :selected-url="deleteUrl"
                          @cancelled="cancelled"
                          @confirmSuccess="handleDeleteSuccess"
                          :call-back-emit="true"
        />
    </main>
</template>


<script setup>
import {onMounted, ref} from "vue";
import Axios from "@/services/axios/index.js";
import useEmitter from "@/composable/useEmitter.js";
import moment from 'moment'
import {urlGenerator} from "@/utilities/urlGenerator.js";
import {useDeleteModal} from "@/composable/useDeleteModal.js";

const {isDeleteModal, deleteUrl, cancelled} = useDeleteModal()

const dataSetList = ref({})
const preloader = ref(false)

// Get Prayer Times based on the selected city
const getServerData = () => {
    preloader.value = true
    Axios.get(`prayer-times?city=${selectedCity.value}`).then((data) => {
        dataSetList.value = data.data
    }).finally(() => preloader.value = false)
}
const deleteType = ref("");  // Tracks the type of delete

const deletePrayerTime = (row) => {
    isDeleteModal.value = true
    deleteUrl.value = `prayer-times/${row.id}`
    deleteType.value = "single";  // Mark this as a single entry delete
}
const deleteCityPrayerTime = () => {
    isDeleteModal.value = true;
    deleteUrl.value = `delete-prayer-times?city=${selectedCity.value}`;
    deleteType.value = "city";  // Mark this as a city-wise delete
};

const handleDeleteSuccess = () => {
    if (deleteType.value === "city") {
        getCities();  // Refresh cities after deletion
        selectedCity.value = cities.value.length > 0 ? cities.value[0] : '';  // Reset selection for city-wise delete
        filterByCity();
    } else {
        getServerData();  // Reload current data for single delete
    }
    isDeleteModal.value = false;  // Close the modal state
    deleteType.value = "";  // Reset delete type
};


const emitter = useEmitter();
const reloadDataTable = () => {
    emitter.on("reload-table", (value = true) => {
        if (value) {
            getServerData();
        }
    });
};

const cities = ref([]);
const selectedCity = ref("");

// Get the list of cities
const getCities = () => {
    Axios.get('get-cities')
        .then(response => {
            cities.value = response.data;
            if (cities.value.length > 0) {
                selectedCity.value = cities.value[0];
                filterByCity();
            }
        });
};

// Filter Prayer Times based on the selected city
const filterByCity = () => {
    if (selectedCity.value) {
        Axios.get(`prayer-times?city=${selectedCity.value}`).then((data) => {
            dataSetList.value = data.data;
        });
    } else {
        getServerData();
    }
};

onMounted(() => {
    getCities();
    reloadDataTable();
});
</script>

