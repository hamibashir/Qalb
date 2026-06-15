<?php
// app/helpers.php

use App\Models\Quran\Translator\Translator;

if (!function_exists('translateToLanguage')) {
    function translateToLanguage($input, $language = 'en')
    {
        $translations = [
            'en' => [
                'numbers' => [
                    0 => '0',
                    1 => '1',
                    2 => '2',
                    3 => '3',
                    4 => '4',
                    5 => '5',
                    6 => '6',
                    7 => '7',
                    8 => '8',
                    9 => '9',
                ],
                'texts' => [
                    'verses' => 'Verses',
                    'juz' => 'Juz'
                ],
            ],
            'bn' => [
                'numbers' => [
                    0 => '০',
                    1 => '১',
                    2 => '২',
                    3 => '৩',
                    4 => '৪',
                    5 => '৫',
                    6 => '৬',
                    7 => '৭',
                    8 => '৮',
                    9 => '৯',
                ],
                'texts' => [
                    'verses' => 'আয়াত',
                    'juz' => 'পাড়া'
                ],
            ],
            'sp' => [
                'numbers' => [
                    '0' => '0',
                    '1' => '1',
                    '2' => '2',
                    '3' => '3',
                    '4' => '4',
                    '5' => '5',
                    '6' => '6',
                    '7' => '7',
                    '8' => '8',
                    '9' => '9',
                ],
                'texts' => [
                    'verses' => 'versos',
                    'juz' => 'Juz'
                ],
            ],
            'fr' => [
                'numbers' => [
                    '0' => 'zéro',
                    '1' => 'un',
                    '2' => 'deux',
                    '3' => 'trois',
                    '4' => 'quatre',
                    '5' => 'cinq',
                    '6' => 'six',
                    '7' => 'sept',
                    '8' => 'huit',
                    '9' => 'neuf',
                ],
                'texts' => [
                    'verses' => 'Versets',
                    'juz' => 'Juz'
                ],
            ],
            'ar' => [
                'numbers' => [
                    '0' => '٠',
                    '1' => '١',
                    '2' => '٢',
                    '3' => '٣',
                    '4' => '٤',
                    '5' => '٥',
                    '6' => '٦',
                    '7' => '٧',
                    '8' => '٨',
                    '9' => '٩',
                ],
                'texts' => [
                    'verses' => 'الآيات',
                    'juz' => 'جزء'
                ],
            ],
        ];

        if (isset($translations[$language])) {
            $translationMap = $translations[$language];

            if (is_numeric($input)) {
                // Translate numbers
                $translatedNumber = '';
                $numberString = strval($input);
                foreach (str_split($numberString) as $digit) {
                    $translatedNumber .= $translationMap['numbers'][$digit];
                }
                return $translatedNumber;
            } elseif (is_string($input)) {
                // Translate text strings
                return $translationMap['texts'][$input] ?? $input;
            }
        }

        // If the specified language translation is not available or input type is not supported, return the original input
        return $input;
    }

    if (!function_exists('getTranslatorCode')) {
        function getTranslatorCode($id)
        {
            return Translator::query()
                ->where('id', $id)
                ->select('language_code')
                ->first()
                ->language_code;
        }
    }
}
