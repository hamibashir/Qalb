<?php

namespace Database\Seeders\Quran\Settings;

use App\Models\Quran\Settings\Setting;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class SettingsSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        Setting::query()->insert(config('settings.app'));

    }
}
