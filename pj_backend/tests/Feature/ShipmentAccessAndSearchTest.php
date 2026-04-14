<?php

namespace Tests\Feature;

use App\Models\Category;
use App\Models\PricingConfig;
use App\Models\Shipment;
use App\Models\User;
use App\Models\VehicleType;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class ShipmentAccessAndSearchTest extends TestCase
{
    use RefreshDatabase;

    private function seedCatalog(): array
    {
        PricingConfig::create([
            'base_price' => 15,
            'weight_rate' => 2.5,
        ]);

        $category = Category::create([
            'name_en' => 'General',
            'name_ku' => 'Gashti',
            'surcharge' => 0,
        ]);

        $vehicleType = VehicleType::create([
            'name_en' => 'Car',
            'name_ku' => 'Otomobil',
            'multiplier' => 1.2,
            'delivery_days_offset' => 1,
        ]);

        return [$category, $vehicleType];
    }

    public function test_only_customers_can_create_shipments(): void
    {
        [$category, $vehicleType] = $this->seedCatalog();

        $staff = User::factory()->create([
            'role' => 'staff',
            'is_active' => true,
        ]);

        Sanctum::actingAs($staff);

        $this->postJson('/api/v1/shipments', [
            'origin' => 'Erbil',
            'destination' => 'Baghdad',
            'weight_kg' => 12.5,
            'category_id' => $category->id,
            'vehicle_type_id' => $vehicleType->id,
        ])->assertForbidden();

        $this->assertDatabaseCount('shipments', 0);
    }

    public function test_customer_can_search_shipments_by_uuid_fragment(): void
    {
        [$category, $vehicleType] = $this->seedCatalog();

        $customer = User::factory()->create([
            'role' => 'customer',
            'is_active' => true,
        ]);

        $otherCustomer = User::factory()->create([
            'role' => 'customer',
            'is_active' => true,
        ]);

        $matchingShipment = Shipment::create([
            'customer_id' => $customer->id,
            'origin' => 'Erbil Warehouse',
            'destination' => 'Baghdad Center',
            'weight_kg' => 3.5,
            'category_id' => $category->id,
            'vehicle_type_id' => $vehicleType->id,
            'price_breakdown' => ['base_price' => 15, 'weight_cost' => 8.75],
            'total_price' => 23.75,
            'estimated_delivery_days' => 4,
            'status' => 'pending',
        ]);

        Shipment::create([
            'customer_id' => $otherCustomer->id,
            'origin' => 'Duhok Market',
            'destination' => 'Mosul Gate',
            'weight_kg' => 5,
            'category_id' => $category->id,
            'vehicle_type_id' => $vehicleType->id,
            'price_breakdown' => ['base_price' => 15, 'weight_cost' => 12.5],
            'total_price' => 27.5,
            'estimated_delivery_days' => 4,
            'status' => 'pending',
        ]);

        Sanctum::actingAs($customer);

        $response = $this->getJson('/api/v1/shipments?search=' . strtoupper(substr($matchingShipment->id, 0, 8)));

        $response->assertOk();
        $response->assertJsonCount(1, 'data');
        $response->assertJsonPath('data.0.id', $matchingShipment->id);
    }
}
