<script setup>
import {onBeforeMount} from "@vue/runtime-core";
import {ref} from "vue";

const companyName = ref('')
const getCompanyName = () => {
    const storedName = window.localStorage.getItem('company_name')
    if (storedName) {
        companyName.value = storedName
        return storedName
    } else {
        return null
    }
}
const currentYear = ref('')
const getYear = () => {
    return currentYear.value = new Date().getFullYear();
}
onBeforeMount(() => {
    getYear()
    getCompanyName()
});
</script>

<template>
    <div>
        <div class="copyright">
            &copy; {{ currentYear }} {{ companyName }}. All rights reserved.
        </div>

        <div class="links mb-5">
            <a :href="'privacy-policy'" class="link">Privacy Policy</a>
            <span class="separator">|</span>
            <a :href="'terms-and-conditions'" class="link">Terms & Conditions</a>
            <span class="separator">|</span>
            <a :href="'support'" class="link">Support</a>
        </div>
    </div>
</template>

<style scoped>
.copyright {
    text-align: center;
    margin-bottom: 20px;
    font-size: 14px;
    color: #555;
}

.links {
    text-align: center;
}

.link {
    text-decoration: none;
    color: #3498db;
    font-weight: bold;
    transition: color 0.3s ease-in-out;
}

.link:hover {
    color: #1f618d;
}

.separator {
    margin: 0 10px;
    color: #555;
}
</style>
