<?php

namespace App\Http\Resources\Quran\Donation;

use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class DonationResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'category' => $this->category->name,
            'payment_method' => $this->paymentMethod->name,
            'date' => Carbon::parse($this->transaction->date)->timezone(request()->get('timezone'))->format('d M h:i A'),
            'amount' => floatval($this->transaction->amount)
        ];
    }
}
