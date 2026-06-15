<?php

namespace App\Http\Controllers\Quran\Donation;

use App\Http\Controllers\Controller;
use App\Models\Quran\Donation\Donation;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class DonationController extends Controller
{

    public function index()
    {
        try {
            return Donation::query()
                ->latest('donations.created_at')
                ->select('donations.id', 'donations.email', 'donations.category_id','donations.payment_method_id')
                ->join('categories', 'donations.category_id', '=', 'categories.id')
                ->join('payment_methods', 'donations.payment_method_id', '=', 'payment_methods.id')
                ->with([
                    'paymentMethod',
                    'transaction' => function($query) {
                        $query->select(
                            'id',
                            'donation_id',
                            'amount',
                            DB::raw("DATE_FORMAT(date, '%d %b, %h:%i %p') as date")
                        );
                    },
                    'category:id,name'
                ])
                ->when(request()->search, function ($query) {
                    $search = request()->search;
                    return $query->where('donations.email', 'like', '%' . $search . '%')
                        ->orWhere('categories.name', 'like', '%' . $search . '%')
                        ->orWhere('payment_methods.name', 'like', '%' . $search . '%');
                })
                ->paginate(10);

        } catch (\Exception $exception) {
            return response()->json([
                'status' => false,
                'message' => $exception->getMessage()
            ]);
        }
    }


}
