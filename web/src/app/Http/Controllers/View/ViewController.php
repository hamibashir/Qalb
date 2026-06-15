<?php

namespace App\Http\Controllers\View;

use App\Http\Controllers\Controller;
use App\Models\Quran\Chapter\Chapter;
use App\Models\Quran\Reciter\Reciter;
use Illuminate\Contracts\View\Factory;
use Illuminate\Contracts\View\View;
use Illuminate\Foundation\Application;
use Illuminate\Http\Request;

class ViewController extends Controller
{
    /**
     * @return View|Application|Factory|\Illuminate\Contracts\Foundation\Application
     */
    public function userList(): View|Application|Factory|\Illuminate\Contracts\Foundation\Application
    {
        return view('user.index');
    }

    public function roleList(): View|Application|Factory|\Illuminate\Contracts\Foundation\Application
    {
        return view('role.index');
    }

    public function importQuran(): Factory|Application|View|\Illuminate\Contracts\Foundation\Application|\Illuminate\Http\RedirectResponse
    {
        $chapterCount = Chapter::query()->count();
        if ($chapterCount == 114)
            return redirect()->route('dashboard')->with('error', 'Sorry you are already imported Quran in your system.');

        return view('quran_import.index');
    }

    public function haramcodeList(): View|Application|Factory|\Illuminate\Contracts\Foundation\Application
    {
        return view('haramcode.index');
    }

    public function sifatList(): View|Application|Factory|\Illuminate\Contracts\Foundation\Application
    {
        return view('sifat.index');
    }

    public function dhikrList(): View|Application|Factory|\Illuminate\Contracts\Foundation\Application
    {
        return view('dhikr.index');
    }

    public function duaList(): View|Application|Factory|\Illuminate\Contracts\Foundation\Application
    {
        return view('dua.index');
    }

    public function prayerTimeList(): View|Application|Factory|\Illuminate\Contracts\Foundation\Application
    {
        return view('prayer_times.index');
    }

    public function prayerTimeCreate(): View|Application|Factory|\Illuminate\Contracts\Foundation\Application
    {
        return view('prayer_times.create');
    }

    public function prayerTimeEdit($id): Factory|Application|View|\Illuminate\Contracts\Foundation\Application
    {
        return view('prayer_times.edit', compact('id'));
    }

    public function myProfile(): Factory|Application|View|\Illuminate\Contracts\Foundation\Application
    {
        $user = auth()->user()->load('profile');
        return view('profile.index', compact('user'));
    }

    public function setting(): Factory|Application|View|\Illuminate\Contracts\Foundation\Application
    {
        return view('setting.index');
    }

    public function categoryList(): Factory|Application|View|\Illuminate\Contracts\Foundation\Application
    {
        return view('category.index');
    }

    public function donationList(): Factory|Application|View|\Illuminate\Contracts\Foundation\Application
    {
        return view('donation.index');
    }

    public function paymentMethodList()
    {
        return view('payment.index');
    }

    public function prayerTimeImport(): Factory|Application|View|\Illuminate\Contracts\Foundation\Application
    {
        return view('prayer_times.import');
    }

    public function audioReciterList(): Factory|Application|View|\Illuminate\Contracts\Foundation\Application
    {
        return view('reciter.index');
    }


    public function audioSuraList(Reciter $reciter): Factory|Application|View|\Illuminate\Contracts\Foundation\Application
    {
        return view('reciter-audio.index',compact('reciter'));
    }
}
