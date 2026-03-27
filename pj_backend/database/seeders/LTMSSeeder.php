<?php

namespace Database\Seeders;

use App\Models\Category;
use App\Models\VehicleType;
use App\Models\PricingConfig;
use App\Models\User;
use App\Models\Faq;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class LTMSSeeder extends Seeder
{
    public function run(): void
    {
        // 1. Super Admin
        User::create([
            'name' => 'Super Admin',
            'email' => 'admin@ltms.app',
            'password' => Hash::make('password'),
            'role' => 'super_admin',
            'is_active' => true,
        ]);

        // 2. Staff
        User::create([
            'name' => 'Staff member',
            'email' => 'staff@ltms.app',
            'password' => Hash::make('password'),
            'role' => 'staff',
            'is_active' => true,
        ]);

        // 3. Driver
        User::create([
            'name' => 'John Driver',
            'email' => 'driver@ltms.app',
            'password' => Hash::make('password'),
            'role' => 'driver',
            'is_active' => true,
        ]);

        // 4. Default Pricing
        PricingConfig::create([
            'base_price' => 15.00,
            'weight_rate' => 2.50,
        ]);

        // 5. Categories
        Category::create(['name_en' => 'General', 'name_ku' => 'گشتی', 'surcharge' => 0]);
        Category::create(['name_en' => 'Fragile', 'name_ku' => 'شکاو', 'surcharge' => 10.00]);
        Category::create(['name_en' => 'Electronics', 'name_ku' => 'ئەلیکترۆنی', 'surcharge' => 5.00]);

        // 6. Vehicle Types
        VehicleType::create(['name_en' => 'Motorcycle', 'name_ku' => 'ماتۆڕسکیل', 'multiplier' => 1.0, 'delivery_days_offset' => 0]);
        VehicleType::create(['name_en' => 'Car', 'name_ku' => 'ئۆتۆمبێل', 'multiplier' => 1.2, 'delivery_days_offset' => 1]);
        VehicleType::create(['name_en' => 'Truck', 'name_ku' => 'بارهەڵگر', 'multiplier' => 1.5, 'delivery_days_offset' => 2]);

        // 7. FAQs
        Faq::create([
            'question_en' => 'How to track my shipment?',
            'question_ku' => 'چۆن بارەکەم بدۆزمەوە؟',
            'answer_en' => 'Go to My Shipments in the mobile app.',
            'answer_ku' => 'بڕۆ بۆ بەشی بارەکانم لە ئەپڵیکەیشنەکەدا.',
            'sort_order' => 1,
        ]);
    }
}
