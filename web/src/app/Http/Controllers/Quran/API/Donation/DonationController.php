<?php

namespace App\Http\Controllers\Quran\API\Donation;

use App\Http\Controllers\Controller;
use App\Http\Requests\Quran\Donation\DonationRequest;
use App\Http\Resources\Quran\Donation\DonationResourceCollection;
use App\Models\Quran\Donation\Donation;
use Illuminate\Support\Facades\DB;

class DonationController extends Controller
{

    public function index()
    {
        try {
            $donations = Donation::query()
                ->latest('donations.created_at')
                ->with('transaction')
                ->where('email', request()->get('email'))
                ->get();

            $donationList = new DonationResourceCollection($donations);

            return response()->json([
                'status' => true,
                'message' => 'Donation fetched successfully',
                'data' => $donationList
            ]);
        } catch (\Exception $exception) {
            return response()->json([
                'status' => false,
                'message' => $exception->getMessage()
            ]);
        }
    }

    public function store(DonationRequest $request)
    {
        try {
            DB::beginTransaction();

            $donation = Donation::query()->create($request->only('category_id', 'payment_method_id', 'email'));

            $transactionData = $request->only('amount');
            $transactionData['date'] = date('Y-m-d H:i:s');

            $donation->transaction()->create($transactionData);

            DB::commit();

            return response()->json([
                'status' => true,
                'message' => 'Donation placed successfully',
                'data' => []
            ]);
        } catch (\Exception $exception) {
            DB::rollBack();
            return response()->json([
                'status' => false,
                'message' => $exception->getMessage()
            ]);
        }
    }
}
