<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class PricingConfig extends Model
{
    protected $fillable = [
        'base_price',
        'weight_rate',
    ];

    protected $casts = [
        'base_price' => 'float',
        'weight_rate' => 'float',
    ];
}
