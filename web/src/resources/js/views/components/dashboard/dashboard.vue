<template>
    <main class="content">
        <div class="container-fluid p-0">
            <div class="row mb-2 mb-xl-3">
                <div class="col-auto d-none d-sm-block">
                    <h3>Dashboard</h3>
                </div>
                <app-loader v-if="chapterLoader"/>
                <div class="col-auto ml-auto" v-else>
                    <button type="button" class="btn btn-danger" v-if="!dataSetList.chapter"
                            @click="finishSetup">
                        Click Here To Finish (Quran, Dua, Dhikr , Allah Name) Setup
                    </button>
                </div>

                <app-loader v-if="transliterationLoader"/>
                <div class="col-auto ml-auto" v-else>
                    <button type="button" class="btn btn-danger" v-if="!dataSetList.isSetTransliteration && dataSetList.chapter > 0"
                            @click="finishTransliteration">
                        Click Here To Finish Quran Transliteration Setup
                    </button>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-3">
                    <div class="card">
                        <div class="card-body text-white">
                            <div class="row">
                                <div class="col mt-0">
                                    <h5 class="card-title">Total Dua</h5>
                                </div>
                                <div class="col-auto">
                                    <div class="stat text-primary">
                                        <img class="dashboard_icon align-middle"
                                             :src="urlGenerator('assets/img/icons/dua.svg')" alt="Dua">
                                    </div>
                                </div>
                            </div>
                            <h1 class="mt-1 mb-3">{{ dataSetList.dua }}</h1>
                        </div>
                    </div>
                </div>
                <div class="col-sm-3">
                    <div class="card">
                        <div class="card-body">
                            <div class="row">
                                <div class="col mt-0">
                                    <h5 class="card-title">Total Dhikr</h5>
                                </div>
                                <div class="col-auto">
                                    <div class="stat text-primary">
                                        <img class="align-middle"
                                             :src="urlGenerator('assets/img/icons/dhikr.svg')"
                                             alt="Dhikr">
                                    </div>
                                </div>
                            </div>
                            <h1 class="mt-1 mb-3">{{ dataSetList.dhikr }}</h1>
                        </div>
                    </div>
                </div>
                <div class="col-sm-3">
                    <div class="card">
                        <div class="card-body">
                            <div class="row">
                                <div class="col mt-0">
                                    <h5 class="card-title">Total Surah</h5>
                                </div>
                                <div class="col-auto">
                                    <div class="stat text-primary">
                                        <img class="align-middle"
                                             :src="urlGenerator('assets/img/icons/surah.svg')"
                                             alt="Dhikr">
                                    </div>
                                </div>
                            </div>
                            <h1 class="mt-1 mb-3">{{ dataSetList.chapter }}</h1>
                        </div>
                    </div>
                </div>
                <div class="col-sm-3">
                    <div class="card">
                        <div class="card-body">
                            <div class="row">
                                <div class="col mt-0">
                                    <h5 class="card-title">Total Allah Name</h5>
                                </div>
                                <div class="col-auto">
                                    <div class="stat text-primary">
                                        <img class="align-middle"
                                             :src="urlGenerator('assets/img/icons/allah_icon.svg')"
                                             alt="Allah Icon">
                                    </div>
                                </div>
                            </div>
                            <h1 class="mt-1 mb-3">{{ dataSetList.sifatName }}</h1>
                        </div>
                    </div>
                </div>
                <div class="col-sm-3">
                    <div class="card">
                        <div class="card-body">
                            <div class="row">
                                <div class="col mt-0">
                                    <h5 class="card-title">Total Haram Code</h5>
                                </div>
                                <div class="col-auto">
                                    <div class="stat text-primary">
                                        <img class="align-middle"
                                             :src="urlGenerator('assets/img/icons/haram.svg')"
                                             alt="Haram Code">
                                    </div>
                                </div>
                            </div>
                            <h1 class="mt-1 mb-3">{{ dataSetList.haramCode }}</h1>
                        </div>
                    </div>
                </div>
                <div class="col-sm-3">
                    <div class="card">
                        <div class="card-body">
                            <div class="row">
                                <div class="col mt-0">
                                    <h5 class="card-title">Total Users</h5>
                                </div>
                                <div class="col-auto">
                                    <div class="stat text-primary">
                                        <img class="align-middle"
                                             :src="urlGenerator('assets/img/icons/users.svg')"
                                             alt="Haram Code">
                                    </div>
                                </div>
                            </div>
                            <h1 class="mt-1 mb-3">{{ dataSetList.users }}</h1>
                        </div>
                    </div>
                </div>
                <div class="col-sm-3">
                    <div class="card">
                        <div class="card-body">
                            <div class="row">
                                <div class="col mt-0">
                                    <h5 class="card-title">Total Donation</h5>
                                </div>
                                <div class="col-auto">
                                    <div class="stat text-primary">
                                        <img class="align-middle"
                                             height="40"
                                             :src="urlGenerator('assets/img/icons/donation.svg')"
                                             alt="Donation">
                                    </div>
                                </div>
                            </div>
                            <h1 class="mt-1 mb-3">{{ dataSetList.donationAmount }}</h1>
                        </div>
                    </div>
                </div>
                <div class="col-sm-3">
                    <div class="card">
                        <div class="card-body">
                            <div class="row">
                                <div class="col mt-0">
                                    <h5 class="card-title">Total Payment Method</h5>
                                </div>
                                <div class="col-auto">
                                    <div class="stat text-primary">
                                        <img class="align-middle"
                                             :src="urlGenerator('assets/img/icons/payment-method.png')"
                                             alt="Payment Method">
                                    </div>
                                </div>
                            </div>
                            <h1 class="mt-1 mb-3">{{ dataSetList.paymentMethods }}</h1>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-md-8">
                    <div class="card p-2">
                        <h5 class="card-title p-2">Country Analysis</h5>
                        <div class="card-body d-flex flex-column">
                            <div style="height: 300px">
                                <Bar
                                    id="my-chart-id"
                                    :options="barChartOptions"
                                    :data="barChartData"
                                />
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card p-2">
                        <h5 class="card-title p-2">Operating System Analysis</h5>
                        <div class="card-body d-flex flex-column align-items-center justify-content-center">
                            <div>
                                <Doughnut
                                    id="my-chart-id"
                                    :options="doughnutChartOptions"
                                    :data="doughnutChartData"
                                />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
</template>
<style scoped>
/* Add custom styles for the alert and adjust as needed */
.alert {
    display: inline-block;
    margin-left: 10px; /* Adjust the spacing between the button and the alert */
}
</style>
<script setup>
import {onMounted, ref} from "vue";
import Axios from "@/services/axios/index.js";
import {urlGenerator} from "@/utilities/urlGenerator.js";
import {Doughnut, Bar} from 'vue-chartjs'
import {Chart as ChartJS, Title, Tooltip, Legend, ArcElement, CategoryScale, LinearScale, BarElement,} from 'chart.js'
import {toast} from "vue3-toastify";

ChartJS.register(ArcElement, Tooltip, Legend, CategoryScale, LinearScale, BarElement, Title, Tooltip, Legend)
const finishPreloader = ref(false)
const finishSetup = () => {
    window.location = urlGenerator(`finish-setup`)
}
// Doughnut Chart Start
const
    doughnutChartData = ref({
        labels: [],
        datasets: [
            {
                backgroundColor: [],
                data: []
            }
        ]
    })
const doughnutChartOptions = {
    responsive: true
}

const getRegionData = () => {
    Axios.get(urlGenerator('api/get-region-info')).then((response) => {
        doughnutChartData.value = {
            labels: response.data.data.labels,
            datasets: [
                {
                    backgroundColor: ['#F54900', '#F6BC00', '#49A84C', '#4D86F9'],
                    data: response.data.data.series
                }
            ]
        };
    });
}
//Doughnut Chart End

//Bar Chart Start
const barChartData = ref({
    labels: [],
    datasets: [
        {
            label: 'Country',
            backgroundColor: ['#49A84C', '#F6BC00', '#4D86F9', '#F54900'],
            data: []
        }
    ]
})

const barChartOptions = ref({
    responsive: true,
    maintainAspectRatio: false
})

const getCountryData = () => {
    Axios.get(urlGenerator('api/get-country-info')).then((response) => {
        barChartData.value = {
            labels: response.data.data.labels,
            datasets: [
                {
                    label: 'Country',
                    backgroundColor: ['#49A84C', '#F6BC00', '#4D86F9', '#F54900'],
                    data: response.data.data.series
                }
            ]
        };
    });
}

//Bar Chart End

const chapterLoader = ref(false)
const getServerData = () => {
    chapterLoader.value = true
    Axios.get(`api/dashboard`).then((data) => {
        dataSetList.value = data.data.data
    }).finally(() => chapterLoader.value = false)
}

//set transliteration
const transliterationLoader = ref(false)
const finishTransliteration = () => {
    window.location = urlGenerator(`finish-transliteration`)
}


const dataSetList = ref({})
onMounted(() => {
    getServerData()
    getCountryData()
    getRegionData()
});


</script>

