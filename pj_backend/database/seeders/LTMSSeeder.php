<?php

namespace Database\Seeders;

use App\Models\Category;
use App\Models\Faq;
use App\Models\PricingConfig;
use App\Models\User;
use App\Models\VehicleType;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class LTMSSeeder extends Seeder
{
    public function run(): void
    {
        User::updateOrCreate([
            'email' => env('SEED_SUPER_ADMIN_EMAIL', 'admin@ltms.app'),
        ], [
            'name' => 'Super Admin',
            'password' => Hash::make(env('SEED_SUPER_ADMIN_PASSWORD', 'password')),
            'role' => 'super_admin',
            'is_active' => true,
        ]);

        User::updateOrCreate([
            'email' => env('SEED_STAFF_EMAIL', 'staff@ltms.app'),
        ], [
            'name' => 'Staff member',
            'password' => Hash::make(env('SEED_STAFF_PASSWORD', 'password')),
            'role' => 'staff',
            'is_active' => true,
        ]);

        User::updateOrCreate([
            'email' => env('SEED_DRIVER_EMAIL', 'driver@ltms.app'),
        ], [
            'name' => 'John Driver',
            'password' => Hash::make(env('SEED_DRIVER_PASSWORD', 'password')),
            'role' => 'driver',
            'is_active' => true,
        ]);

        PricingConfig::updateOrCreate([
            'id' => 1,
        ], [
            'base_price' => 15.00,
            'weight_rate' => 2.50,
        ]);

        Category::updateOrCreate([
            'name_en' => 'General',
        ], [
            'name_ku' => 'Gashti',
            'surcharge' => 0,
        ]);
        Category::updateOrCreate([
            'name_en' => 'Fragile',
        ], [
            'name_ku' => 'Shkaw',
            'surcharge' => 10.00,
        ]);
        Category::updateOrCreate([
            'name_en' => 'Electronics',
        ], [
            'name_ku' => 'Elektroni',
            'surcharge' => 5.00,
        ]);

        VehicleType::updateOrCreate([
            'name_en' => 'Motorcycle',
        ], [
            'name_ku' => 'Matorsikil',
            'multiplier' => 1.0,
            'delivery_days_offset' => 0,
        ]);
        VehicleType::updateOrCreate([
            'name_en' => 'Car',
        ], [
            'name_ku' => 'Otomobil',
            'multiplier' => 1.2,
            'delivery_days_offset' => 1,
        ]);
        VehicleType::updateOrCreate([
            'name_en' => 'Truck',
        ], [
            'name_ku' => 'Barhalgr',
            'multiplier' => 1.5,
            'delivery_days_offset' => 2,
        ]);

        Faq::updateOrCreate([
            'sort_order' => 1,
        ], [
            'question_en' => 'How do I track my shipment?',
            'question_ku' => 'Chon barekam bedozmawa?',
            'answer_en' => 'Open My Shipments in the app to see the current status.',
            'answer_ku' => 'La appaka My Shipments bikawa bo binini doxi esta.',
            'sort_order' => 1,
        ]);
    }
}
