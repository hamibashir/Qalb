<template>
    <nav class="navbar navbar-expand navbar-light navbar-bg">
        <a class="sidebar js-sidebar" id="sidebar" v-if="sidebarStatus" @click.prevent="toggleSidebar('open')">
            <img class="nav_arrow_icon" :src="urlGenerator('assets/img/icons/collapse-arrow.svg')" alt="">
        </a>
        <a class="sidebar js-sidebar" id="sidebar" v-else @click.prevent="toggleSidebar('close')">
            <img class="nav_arrow_icon" :src="urlGenerator('assets/img/icons/open-arrow.svg')" alt="">
        </a>
        <app-loader v-if="pageLoader"/>
        <div v-else class="navbar-collapse collapse">
            <ul class="navbar-nav navbar-align">
                <li class="nav-item dropdown">
                    <a class="nav-icon dropdown-toggle d-inline-block d-sm-none" href="#" data-bs-toggle="dropdown">
                        <i class="align-middle" data-feather="settings"></i>
                    </a>

                    <a class="nav-link dropdown-toggle d-none d-sm-inline-block" href="#" data-bs-toggle="dropdown">
                        <img :src="profilePicture" class="avatar img-fluid rounded me-1"
                             alt="User profile"/>
                        <span class="text-dark">{{ myProfile.full_name }}</span>
                    </a>
                    <div class="dropdown-menu dropdown-menu-end">
                        <a class="dropdown-item" :href="urlGenerator('my-profile')">
                            <i class="align-middle me-1" data-feather="user"></i>
                            Profile
                        </a>

                        <template v-if="$canAccess('view_setting')">
                            <div class="dropdown-divider"></div>
                            <a class="dropdown-item" :href="urlGenerator('setting')">Settings</a>
                        </template>
                        <div class="dropdown-divider"></div>
                        <a href="" class="dropdown-item" @click.prevent="logout">
                            <i class="align-middle me-1"
                               data-feather="log-out"> </i> Logout
                        </a>

                    </div>
                </li>
            </ul>
        </div>
    </nav>

</template>

<script setup>
import {urlGenerator} from "@/utilities/urlGenerator.js";
import Axios from "@/services/axios/index.js";
import {onMounted, ref} from "vue";

const logout = () => {
    Axios.post('logout').then(({data}) => {
        window.location.href = urlGenerator('login');
    })
}

const sidebarStatus = ref(true);
const toggleSidebar = (param) => {
    const sidebar = document.querySelector('.sidebar');
    if (param === 'open') {
        sidebar.classList.add('collapsed');
        sidebarStatus.value = false
    } else {
        sidebar.classList.remove('collapsed');
        sidebarStatus.value = true
    }
}

const myProfile = ref({});
const profilePicture = ref(null);
const pageLoader = ref(false);
const getMyProfile = () => {
    pageLoader.value = true
    Axios.get('profile').then(({data}) => {
        myProfile.value = data
        profilePicture.value = data.profile && data.profile.profile_picture ? urlGenerator(data.profile.profile_picture) : urlGenerator('assets/img/avatar.png')
    }).finally(() => pageLoader.value = false)
}

onMounted(() => {
    getMyProfile();
})
</script>

<style>
.sidebar, body[data-theme=dark] .sidebar {
    background: none !important;
}
</style>


