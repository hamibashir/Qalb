<?php

namespace App\Http\Controllers\Quran\API\PrayerTime;

use App\Http\Controllers\Controller;
use App\Models\Quran\Prayer\PrayerTime;
use Carbon\Carbon;
use Illuminate\Http\Request;
use IslamicNetwork\PrayerTimes\PrayerTimes;

class PrayerTimeController extends Controller
{
    /**
     * Retrieve the columns used for prayer times.
     *
     * @return array
     */
    public function columns()
    {
        return [
            'date',
            'imsak',
            'sunrise',
            'fajr_start',
            'zuhr_start',
            'asr_start',
            'maghrib_start',
            'isha_start',
        ];
    }

    /**
     * Fetch prayer time data based on request type.
     *
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function getPrayerTime(Request $request)
    {
        $request->validate([
            'type' => 'required|in:manual,automatic',
        ]);

        switch ($request->type) {
            case 'manual':
                return $this->getManualPrayerTime($request);
            case 'automatic':
                return $this->getAutomaticPrayerTime($request);
            default:
                return response()->json([
                    'status' => false,
                    'message' => 'Invalid request type',
                    'data' => $this->defaultPrayerTimeResponse(),
                ]);
        }
    }

    /**
     * Fetch prayer time data manually based on the date and city.
     *
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function getManualPrayerTime(Request $request)
    {
        $request->validate([
            'date' => 'required|date:Y-m-d',
            'city' => 'required|string',
        ]);

        try {
            $data = PrayerTime::query()
                ->where('date', $request->get('date'))
                ->where('city', $request->get('city'))
                ->select($this->columns())
                ->first();

            $data['is_jumma'] = date('l', strtotime($request->get('date'))) === 'Friday';
            $this->fillDefaultPrayerTimeValues($data);

            return response()->json([
                'status' => true,
                'message' => 'Manual prayer time data retrieved successfully.',
                'data' => $data,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Data not found.',
                'data' => $this->defaultPrayerTimeResponse(),
            ]);
        }
    }

    /**
     * Fetch automatic prayer times based on location and calculation methods.
     *
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function getAutomaticPrayerTime(Request $request)
    {
        $request->validate([
            'lat' => 'required|numeric',
            'lng' => 'required|numeric',
            'prayer_method' => 'required|in:0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,99',
            'school' => 'required|in:HANAFI,STANDARD',
            'timezone' => 'required|string',
            'date' => 'required|date:Y-m-d',
        ]);

        try {
            $prayerTimes = new PrayerTimes($request->prayer_method, $request->school);
            $times = $prayerTimes->getTimesForToday(
                $request->lat,
                $request->lng,
                $request->timezone
            );

            $data = [
                'date' => Carbon::parse($request->date)->format('Y-m-d'),
                'is_jumma' => date('l', strtotime($request->get('date'))) === 'Friday',
                'imsak' => $times['Imsak'],
                'fajr_start' => $times['Fajr'],
                'sunrise' => $times['Sunrise'],
                'zuhr_start' => $times['Dhuhr'],
                'asr_start' => $times['Asr'],
                'maghrib_start' => $times['Maghrib'],
                'isha_start' => $times['Isha'],
            ];

            return response()->json([
                'status' => true,
                'message' => 'Automatic prayer time data retrieved successfully.',
                'data' => $data,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Failed to fetch prayer times.',
                'data' => $this->defaultPrayerTimeResponse(),
            ]);
        }
    }

    /**
     * Provide default prayer time values.
     *
     * @return array
     */
    private function defaultPrayerTimeResponse(): array
    {
        return [
            'date' => '',
            'imsak' => '0:00',
            'fajr_start' => '0:00',
            'sunrise' => '0:00',
            'zuhr_start' => '0:00',
            'asr_start' => '0:00',
            'maghrib_start' => '0:00',
            'isha_start' => '0:00',
        ];
    }

    /**
     * Fill default values for nullable prayer time fields.
     *
     * @param array $data
     */
    private function fillDefaultPrayerTimeValues($data)
    {
        $fields = ['date', 'imsak', 'sunrise', 'fajr_start', 'zuhr_start', 'asr_start', 'maghrib_start', 'isha_start'];
        foreach ($fields as $field) {
            $data[$field] = $data[$field] ?? '0:00';
        }
        return $this;
    }

    public function getCities()
    {
        $cities = PrayerTime::select('city')->distinct()->orderBy('city', 'ASC')->pluck('city')->toArray();

        return response()->json([
            'status' => true,
            'message' => 'Data fetched successfully',
            'data' => $cities,
        ]);
    }


}
