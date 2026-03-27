<?php

namespace App\Http\Controllers;

use App\Models\Shipment;
use App\Models\Category;
use App\Models\VehicleType;
use App\Models\PricingConfig;
use App\Models\Notification;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

class ShipmentController extends Controller
{
    public function index(Request $request)
    {
        $user = $request->user();
        $query = Shipment::with(['category', 'vehicleType']);

        if ($user->role === 'customer') {
            $query->where('customer_id', $user->id);
        } elseif ($user->role === 'driver') {
            $query->where('driver_id', $user->id);
        }

        if ($request->filled('status')) {
            $query->where('status', $request->status);
        }

        return response()->json($query->latest()->paginate(15));
    }

    public function store(Request $request)
    {
        $request->validate([
            'origin' => 'required|string',
            'destination' => 'required|string',
            'transit_countries' => 'nullable|array',
            'weight_kg' => 'nullable|numeric|min:0.1',
            'size' => 'nullable|string',
            'category_id' => 'required|exists:categories,id',
            'vehicle_type_id' => 'required|exists:vehicle_types,id',
        ]);

        $category = Category::findOrFail($request->category_id);
        $vehicleType = VehicleType::findOrFail($request->vehicle_type_id);
        $pricing = PricingConfig::first() ?? new PricingConfig(['base_price' => 10, 'weight_rate' => 2]);

        // Pricing Formula: Total Price = (Base Price + (Weight kg × Weight Rate) + Category Surcharge) × Vehicle Multiplier
        $basePrice = $pricing->base_price;
        $weightCost = 0;
        
        if ($request->has('weight_kg') && $request->weight_kg > 0) {
            $weightCost = $request->weight_kg * $pricing->weight_rate;
        } elseif ($request->has('size') && $request->filled('size')) {
            $dims = explode('x', strtolower($request->size));
            if (count($dims) == 3) {
                $volumeCm3 = floatval($dims[0]) * floatval($dims[1]) * floatval($dims[2]);
                $volumetricWeightKg = $volumeCm3 / 5000;
                $weightCost = max($volumetricWeightKg * $pricing->weight_rate, 10);
            } else {
                $weightCost = 10;
            }
        }

        $categorySurcharge = $category->surcharge;
        $totalPrice = ($basePrice + $weightCost + $categorySurcharge) * $vehicleType->multiplier;

        // Estimated Delivery Days = Base Days (e.g., 3) + Vehicle Type Offset
        $estimatedDays = 3 + $vehicleType->delivery_days_offset;

        $shipment = Shipment::create([
            'customer_id' => $request->user()->id,
            'origin' => $request->origin,
            'destination' => $request->destination,
            'transit_countries' => $request->transit_countries,
            'weight_kg' => $request->weight_kg,
            'size' => $request->size,
            'category_id' => $request->category_id,
            'vehicle_type_id' => $request->vehicle_type_id,
            'price_breakdown' => [
                'base_price' => $basePrice,
                'weight_cost' => $weightCost,
                'category_surcharge' => $categorySurcharge,
                'vehicle_multiplier' => $vehicleType->multiplier,
            ],
            'total_price' => $totalPrice,
            'estimated_delivery_days' => $estimatedDays,
            'status' => 'pending',
        ]);

        Notification::create([
            'user_id' => $shipment->customer_id,
            'message_en' => 'Your shipment has been created and is currently pending.',
            'message_ku' => 'بارەکەت دروستکرا و لە ئێستادا چاوەڕوانە.',
            'type' => 'status_update',
            'is_read' => false,
        ]);

        return response()->json($shipment->load(['category', 'vehicleType']), 201);
    }

    public function show($id)
    {
        $shipment = Shipment::with(['category', 'vehicleType', 'customer', 'driver', 'report'])->findOrFail($id);
        return response()->json($shipment);
    }

    public function updateStatus(Request $request, $id)
    {
        $request->validate([
            'status' => 'required|in:pending,in_transit,delivered,reported',
        ]);

        $shipment = Shipment::findOrFail($id);
        
        // Basic state machine enforcement
        $allowedTransitions = [
            'pending' => ['in_transit', 'reported'],
            'in_transit' => ['delivered', 'reported'],
            'delivered' => ['reported'],
            'reported' => [],
        ];

        if (!in_array($request->status, $allowedTransitions[$shipment->status])) {
            return response()->json(['message' => 'Invalid status transition.'], 422);
        }

        $shipment->update(['status' => $request->status]);

        return response()->json($shipment);
    }

    public function assignDriver(Request $request, $id)
    {
        $request->validate([
            'driver_id' => 'required|exists:users,id',
        ]);

        $shipment = Shipment::findOrFail($id);
        
        // Verify the user is a driver
        $driver = \App\Models\User::findOrFail($request->driver_id);
        if ($driver->role !== 'driver') {
            return response()->json(['message' => 'The selected user is not a driver.'], 422);
        }

        $shipment->update(['driver_id' => $request->driver_id]);

        Notification::create([
            'user_id' => $request->driver_id,
            'message_en' => 'A new shipment has been assigned to you: #'.substr($shipment->id, 0, 8),
            'message_ku' => 'بارێکی نوێ پێسپێردراوە: #'.substr($shipment->id, 0, 8),
            'type' => 'assignment',
            'is_read' => false,
            'shipment_id' => $shipment->id,
        ]);

        return response()->json($shipment->load('driver'));
    }
 
    public function drivers()
    {
        $drivers = \App\Models\User::where('role', 'driver')
            ->where('is_active', true)
            ->get(['id', 'name', 'email']);

        return response()->json($drivers);
    }

    public function calculatePreview(Request $request)
    {
        $request->validate([
            'weight_kg' => 'nullable|numeric|min:0.1',
            'size' => 'nullable|string',
            'category_id' => 'required|exists:categories,id',
            'vehicle_type_id' => 'required|exists:vehicle_types,id',
        ]);

        $category = Category::find($request->category_id);
        $vehicleType = VehicleType::find($request->vehicle_type_id);
        $pricing = PricingConfig::first() ?? new PricingConfig(['base_price' => 10, 'weight_rate' => 2]);

        $basePrice = $pricing->base_price;
        $weightCost = 0;
        
        if ($request->has('weight_kg') && $request->weight_kg > 0) {
            $weightCost = $request->weight_kg * $pricing->weight_rate;
        } elseif ($request->has('size') && $request->filled('size')) {
            $dims = explode('x', strtolower($request->size));
            if (count($dims) == 3) {
                $volumeCm3 = floatval($dims[0]) * floatval($dims[1]) * floatval($dims[2]);
                $volumetricWeightKg = $volumeCm3 / 5000;
                $weightCost = max($volumetricWeightKg * $pricing->weight_rate, 10);
            } else {
                $weightCost = 10;
            }
        }

        $categorySurcharge = $category->surcharge;
        $totalPrice = ($basePrice + $weightCost + $categorySurcharge) * $vehicleType->multiplier;

        return response()->json([
            'total_price' => $totalPrice,
            'estimated_delivery_days' => 3 + $vehicleType->delivery_days_offset,
        ]);
    }
}
