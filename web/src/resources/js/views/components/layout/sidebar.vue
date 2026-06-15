<template>
    <nav id="sidebar" class="sidebar js-sidebar">
        <div class="sidebar-content js-simplebar">
            <a class="sidebar-brand" :href="urlGenerator('dashboard')">
                <span class="align-middle">
                    <app-logo></app-logo>
                </span>
            </a>

            <ul class="sidebar-nav">

                <template v-for="(item, index) in data" :key="index">

                    <li class="sidebar-item" :class="{'active' : item.url === currentUrl}" v-if="item.permission">
                        <a class='sidebar-link' :href="item.id ? '#'+item.id : item.url" v-if="!item.subMenu">
                            <img class="sidebar_icon align-middle" :src="item.icon"/>
                            <span class="align-middle">{{ item.name }}</span>
                        </a>

                        <template v-if="item.subMenu">
                            <a :data-bs-target="`#${item.id}`" data-bs-toggle="collapse" class="sidebar-link"
                              >
                                <img class="sidebar_icon align-middle" :src="item.icon"/>
                                <span class="align-middle">{{ item.name }}</span>
                            </a>

                            <ul :id="`${item.id}`" class="sidebar-dropdown list-unstyled collapse"
                                data-bs-parent="#sidebar">
                                <template v-for="(submenuItem, index) in item.subMenu">
                                    <li class="sidebar-item" :class="{'active' : submenuItem.url === currentUrl}"
                                        v-if="submenuItem.permission === true || submenuItem.permission === ''">
                                        <a class='sidebar-link' :href='submenuItem.url'>{{ submenuItem.name }}</a>
                                    </li>
                                </template>
                            </ul>
                        </template>
                    </li>
                </template>

            </ul>

        </div>
    </nav>
</template>

<script setup>
import { onMounted, ref, defineProps } from "vue";
import {urlGenerator} from "@/utilities/urlGenerator.js";

const props = defineProps({
    data: Object
});

const currentUrl = ref(window.location.href);

const isItemActive = (item) => {
    if (item.url && item.url === currentUrl.value) {
        return true;
    }

    if (item.subMenu) {
        for (const submenuItem of item.subMenu) {
            if (submenuItem.url && submenuItem.url === currentUrl.value) {
                return true;
            }
        }
    }

    return false;
};

const activateParent = (element) => {
    const parentItem = element.closest('.sidebar-item');
    if (parentItem) {
        parentItem.classList.add('active');
        activateParent(parentItem); // Recursively activate the parent's parent
    }
};

onMounted(() => {
    const sidebarItems = document.querySelectorAll('.sidebar-item');

    sidebarItems.forEach(item => {
        if (isItemActive(item)) {
            item.classList.add('active');
            activateParent(item);
        }
    });

    const sidebarDropdowns = document.querySelectorAll('.sidebar-dropdown');

    sidebarDropdowns.forEach(item => {
        const submenuItems = item.querySelectorAll('.sidebar-item');

        submenuItems.forEach(submenuItem => {
            if (submenuItem.classList.contains('active')) {
                item.classList.add('show');
            }
        });

        item.addEventListener('click', (event) => {
            if (!event.target.closest('.sidebar-item')) {
                item.classList.toggle('show');
            }
        });
    });
});
</script>

