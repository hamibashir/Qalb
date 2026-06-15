<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('prayer_times', function (Blueprint $table) {
            $table->id();
            $table->date('date');
            $table->string('city')->nullable();
            $table->string('imsak')->nullable();
            $table->string('sunrise')->nullable();
            $table->string('sunset')->nullable();

            $table->string('fajr_start')->nullable();
            $table->string('fajr_azan')->nullable();
            $table->string('fajr_jamat')->nullable();
            $table->string('fajr_end')->nullable();

            $table->string('zuhr_start')->nullable();
            $table->string('zuhr_azan')->nullable();
            $table->string('zuhr_jamat')->nullable();
            $table->string('zuhr_end')->nullable();

            $table->string('asr_start')->nullable();
            $table->string('asr_azan')->nullable();
            $table->string('asr_jamat')->nullable();
            $table->string('asr_end')->nullable();

            $table->string('maghrib_start')->nullable();
            $table->string('maghrib_azan')->nullable();
            $table->string('maghrib_jamat')->nullable();
            $table->string('maghrib_end')->nullable();

            $table->string('isha_start')->nullable();
            $table->string('isha_azan')->nullable();
            $table->string('isha_jamat')->nullable();
            $table->string('isha_end')->nullable();

            $table->string('sehri_start')->nullable();
            $table->string('sehri_end')->nullable();
            $table->string('iftar_start')->nullable();
            $table->boolean('iftar_notification')->default(false);
            $table->boolean('sehri_notification')->default(false);
            $table->string('second')->nullable();
            $table->string('se_notify')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('prayer_times');
    }
};
