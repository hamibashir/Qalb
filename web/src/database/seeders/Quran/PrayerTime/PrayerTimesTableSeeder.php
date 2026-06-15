<?php

namespace Database\Seeders\Quran\PrayerTime;

use App\Models\Quran\Prayer\PrayerTime;
use Illuminate\Database\Seeder;

class PrayerTimesTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run()
    {
        $startDate = now()->startOfYear();
        $numberOfDays = $this->isLeapYear($startDate->year) ? 366 : 365;

        for ($i = 0; $i < $numberOfDays; $i++) {
            $date = $startDate->copy()->addDays($i);

            // Set specific prayer times for each day
            $prayerTimes = [
                'imsak' => '4:00',
                'sunrise' => '06:50',
                'fajr_azan' => '05:30',
                'fajr_jamat' => '06:00',
                'zuhr_azan' => '12:45',
                'zuhr_jamat' => '13:15',
                'asr_azan' => '15:45',
                'asr_jamat' => '16:15',
                'maghrib_azan' => '17:45',
                'maghrib_jamat' => '18:00',
                'isha_azan' => '19:45',
                'isha_jamat' => '20:15',
            ];

            // Create a prayer time record for each day
            PrayerTime::create([
                'date' => $date,
                'imsak' => $prayerTimes['imsak'],
                'city' => 'Makkah',
                'sunrise' => $prayerTimes['sunrise'],
                'sunset' => $this->generateRandomTime(),
                'fajr_start' => $prayerTimes['fajr_azan'],
                'fajr_azan' => $prayerTimes['fajr_azan'],
                'fajr_jamat' => $prayerTimes['fajr_jamat'],
                'fajr_end' => $this->generateRandomTime(),
                'zuhr_start' => $this->generateRandomTime(),
                'zuhr_azan' => $prayerTimes['zuhr_azan'],
                'zuhr_jamat' => $prayerTimes['zuhr_jamat'],
                'zuhr_end' => $this->generateRandomTime(),
                'asr_start' => $this->generateRandomTime(),
                'asr_azan' => $prayerTimes['asr_azan'],
                'asr_jamat' => $prayerTimes['asr_jamat'],
                'asr_end' => $this->generateRandomTime(),
                'maghrib_start' => $this->generateRandomTime(),
                'maghrib_azan' => $prayerTimes['maghrib_azan'],
                'maghrib_jamat' => $prayerTimes['maghrib_jamat'],
                'maghrib_end' => $this->generateRandomTime(),
                'isha_start' => $this->generateRandomTime(),
                'isha_azan' => $prayerTimes['isha_azan'],
                'isha_jamat' => $prayerTimes['isha_jamat'],
                'isha_end' => $this->generateRandomTime(),
                'sehri_start' => $this->generateRandomTime(),
                'sehri_end' => $this->generateRandomTime(),
                'iftar_start' => $this->generateRandomTime(),
                'iftar_notification' => false,
                'sehri_notification' => false,
                'second' => $this->generateRandomTime(),
                'se_notify' => $this->generateRandomTime(),
            ]);
        }
    }

    // Helper method to generate a random time in HH:MM format
    private function generateRandomTime()
    {
        $hour = rand(0, 23);
        $minute = rand(0, 59);

        return sprintf('%02d:%02d', $hour, $minute);
    }

    // Helper method to check if the given year is a leap year
    private function isLeapYear($year)
    {
        return ($year % 4 === 0 && $year % 100 !== 0) || ($year % 400 === 0);
    }

}
