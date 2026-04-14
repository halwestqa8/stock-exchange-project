<?php

namespace App\Http\Controllers;

use App\Http\Requests\StoreShipmentRequest;
use App\Models\Notification;
use App\Models\Shipment;
use App\Models\User;
use App\Services\PricingService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class ShipmentController extends Controller
{
    protected $pricingService;

    public function __construct(PricingService $pricingService)
    {
        $this->pricingService = $pricingService;
    }
    public function index(Request $request)
    {
        $user = $request->user();
        $query = Shipment::with(['category', 'vehicleType']);

        // Role-based scoping
        if ($user->role === 'customer') {
            $query->where('customer_id', $user->id);
        } elseif ($user->role === 'driver') {
            $query->where('driver_id', $user->id);
        }

        // Server-side filtering by status
        if ($request->filled('status') && $request->status !== 'All') {
            $query->where('status', $request->status);
        }

        // Server-side search
        if ($request->filled('search')) {
            $search = trim((string) $request->search);
            $like = '%' . strtolower($search) . '%';

            $query->where(function ($q) use ($like) {
                $q->whereRaw('LOWER(CAST(id AS TEXT)) LIKE ?', [$like])
                  ->orWhereRaw('LOWER(origin) LIKE ?', [$like])
                  ->orWhereRaw('LOWER(destination) LIKE ?', [$like]);
            });
        }

        return response()->json($query->latest()->paginate(15));
    }

    public function store(StoreShipmentRequest $request)
    {
        return DB::transaction(function () use ($request) {
            $pricingResult = $this->pricingService->calculate(
                $request->category_id,
                $request->vehicle_type_id,
                $request->weight_kg,
                $request->size
            );

            $shipment = Shipment::create([
                'customer_id' => $request->user()->id,
                'origin' => $request->origin,
                'destination' => $request->destination,
                'transit_countries' => $request->transit_countries,
                'weight_kg' => $request->weight_kg,
                'size' => $request->size,
                'category_id' => $request->category_id,
                'vehicle_type_id' => $request->vehicle_type_id,
                'price_breakdown' => $pricingResult['breakdown'],
                'total_price' => $pricingResult['total_price'],
                'estimated_delivery_days' => $pricingResult['estimated_delivery_days'],
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
        });
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
        $drivers = User::where('role', 'driver')
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

        $pricingResult = $this->pricingService->calculate(
            $request->category_id,
            $request->vehicle_type_id,
            $request->weight_kg,
            $request->size
        );

        return response()->json([
            'total_price' => $pricingResult['total_price'],
            'estimated_delivery_days' => $pricingResult['estimated_delivery_days'],
        ]);
    }
}
